package com.refract.prediabetes {
	import com.refract.prediabetes.logger.Logger;
	import com.robot.comm.DispatchManager;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	public class AppSettings 
	{
		public static const DEBUG : Boolean = false;
		public static const INTRO_URL : String = 'd01_intro_part_1' ; 
		
		public static var APP_VIDEO_BASE_URL : String ; 
		public static var LOCALE:String = "en";
		
		public static var RED:int = 0xc45252;
		public static var LIGHT_GREY:int =0xcdcdcd;
		public static var GREY:int = 0x868989;
		public static var DARK_GREY:int = 0x4d4d4d;
		public static var WHITE:int = 0xffffff;
		
		public static var DATA_PATH:String = "data/" ; 
		public static var APP_DATA_PATH : String = "file://";

		public static const BUTTON_HIT_AREA_ALPHA:Number = 0;
		public static const BUTTON_HIT_AREA_EDGE:int = 10;
		public static const BUTTON_HIT_AREA_WIDTH:int = BUTTON_HIT_AREA_EDGE << 1 ;
		
		public static var VIDEO_FILE_EXT:String = ".f4v" ;
		public static var VIDEO_BASE_URL : String = "video/f4v/1024/" ;
		public static var VIDEO_FILE_FORMAT_DESCRIPTOR:String = "";
		
		public static const DEVICE_PC:String = "DEVICE_PC";
		public static const DEVICE_TABLET:String = "DEVICE_TABLET";
		public static var DEVICE : String = "DEVICE_PC";
		
		public static var VIDEO_WIDTH:Number = 0;
		public static var VIDEO_HEIGHT:Number = 0;
		public static var VIDEO_IS_STAGE_WIDTH:Boolean = false;
		public static var VIDEO_LEFT:Number = 0;
		public static var VIDEO_RIGHT:Number = 0;
		public static var VIDEO_TOP:Number = 0;
		public static var VIDEO_BOTTOM:Number = 0;
		
		//public static var RESERVED_HEADER_HEIGHT_TOP:int = 10;
		//public static var RESERVED_HEADER_HEIGHT_BOTTOM:int = 80;
		
		public static var RESERVED_HEADER_HEIGHT_DEFAULT:int = 0;
		public static var RESERVED_FOOTER_HEIGHT_DEFAULT:int = 70;
		public static var RESERVED_HEADER_HEIGHT:int = RESERVED_HEADER_HEIGHT_DEFAULT ; //30 ; //RESERVED_HEADER_HEIGHT_DEFAULT;
		public static var RESERVED_FOOTER_HEIGHT:int = RESERVED_FOOTER_HEIGHT_DEFAULT ; //90 ; //RESERVED_FOOTER_HEIGHT_DEFAULT;
		public static var RESERVED_HEIGHT:int = RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT;
		public static const RESERVED_SIDE_BORDER:int = 30;
		
		public static var FONT_SCALE_FACTOR:Number = 1;
		
		public static var FOOTER_FONT_SIZE:int = 13;
		public static var FOOTER_FONT_SIZE2:int = 14;
		
		public static var FONT_SIZES : Dictionary = __MAKE_DICTIONARY();
		public static function GET_FONT_SCALE(size:int):Number{
			return FONT_SIZES[size]/size;
		}
		
		private static function __MAKE_DICTIONARY():Dictionary{
			var dict:Dictionary = new Dictionary();
			
			dict[12] = 12;
			dict[13] = 13;
			dict[14] = 14;
			dict[15] = 15;
			dict[16] = 16;
			dict[18] = 18;
			dict[20] = 20;
			dict[22] = 22;
			dict[24] = 24;
			dict[30] = 30;
			dict[32] = 32;
			dict[36] = 36;
			dict[48] = 48;
			dict[54] = 54;
			dict[72] = 72;
			dict[100] = 100;
			
			return dict;
		}
		
		public static var RATIO : Number = 1; 
		
		private static var _stage : Stage;
		
		public static var FullScreenInteractiveAllowed : Boolean = false;
		public static const REQUEST_FULL_SCREEN_INTERACTIVE : String = "REQUEST_FULL_SCREEN_INTERACTIVE";
		
		
		public static function get stage():Stage { return _stage; }
		public static function set stage(st:Stage):void{
			
			if(_stage){
				_stage.removeEventListener(Event.RESIZE, onStageResize);
				_stage.removeEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED,onFSInteractiveAccepted);
				_stage.removeEventListener(FullScreenEvent.FULL_SCREEN,onFullScreenChange);
			}
			_stage = st;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			_stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFullScreenChange);
			_stage.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED,onFSInteractiveAccepted);
			onStageResize();
		}
		
		public static var _stageCoverCopy:TextField;
		
		private static const SIXTEEN_NINE_RATIO:Number = 16/9;
		
		private static function onStageResize(evt:Event = null):void{
			var stageRatio:Number = _stage.stageWidth/(_stage.stageHeight-RESERVED_HEIGHT);
			
			if(SIXTEEN_NINE_RATIO > stageRatio){ //stage height greater than width -> fit to width
				VIDEO_HEIGHT = _stage.stageWidth/SIXTEEN_NINE_RATIO;
				VIDEO_WIDTH = _stage.stageWidth;
				VIDEO_IS_STAGE_WIDTH = true;
				VIDEO_LEFT = 0;
				VIDEO_RIGHT = VIDEO_WIDTH;
				VIDEO_TOP = _stage.stageHeight/2 - VIDEO_HEIGHT/2 - RESERVED_HEIGHT/2 ;
				VIDEO_BOTTOM = VIDEO_TOP + VIDEO_HEIGHT;
			}else{ //stage width greater than stage height -> fit to height
				VIDEO_WIDTH = (_stage.stageHeight - RESERVED_HEIGHT)*SIXTEEN_NINE_RATIO;
				VIDEO_HEIGHT = (_stage.stageHeight - RESERVED_HEIGHT);
				VIDEO_IS_STAGE_WIDTH = false;
				VIDEO_LEFT = _stage.stageWidth/2 - VIDEO_WIDTH/2 ;
				VIDEO_RIGHT = VIDEO_LEFT + VIDEO_WIDTH;
				VIDEO_TOP = RESERVED_HEADER_HEIGHT ;
				VIDEO_BOTTOM = VIDEO_TOP + VIDEO_HEIGHT;
			}
			
			
			if(_stageCover && _stage.contains(_stageCover)){
				_stageCover.graphics.clear();
				_stageCover.graphics.beginFill(0x000000,0.85);
				_stageCover.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
				
				if(_stageCoverCopy){
					_stageCoverCopy.x = stage.stageWidth/2 - _stageCoverCopy.width/2;
					_stageCoverCopy.y = AppSettings.VIDEO_TOP + 100;
				}
			}
		}
		
		public static function goToLink(link:String):void{
			navigateToURL(new URLRequest(link),"_blank");
		}
		
		public static function getFlashVar(flashVar:String):String{
			if(_stage){
				return _stage.loaderInfo.parameters[flashVar];
			}
			return "";
		}

		public static function setScreenRatio(isTablet:Boolean = true) : void {
			var dpi:Number = Capabilities.screenDPI;
			var inchesWide:Number = stage.fullScreenWidth/dpi;
			var inchesHigh:Number = stage.fullScreenHeight/dpi;	
			inchesWide *= inchesWide;
			inchesHigh *= inchesHigh;
			var inches:Number = Math.sqrt(inchesWide + inchesHigh);
			if( isTablet ) 
				DEVICE =  DEVICE_TABLET ; 
		
			var serverString:String = unescape(Capabilities.serverString); 
			var reportedDpi:Number = Number(serverString.split("&DP=", 2)[1]);
			
			FONT_SCALE_FACTOR = dpi/72 * 0.6;
			
			RATIO = ( dpi / 72) ; 
			if( RATIO > 1.2) RATIO = RATIO / 2 ;
			
			Logger.general("Device looks like: ", DEVICE, "size is", inches, "with dpi",dpi, "and reported dpi",reportedDpi, "and scale factor",FONT_SCALE_FACTOR);
			if(DEVICE == DEVICE_TABLET){
				RESERVED_FOOTER_HEIGHT = RESERVED_FOOTER_HEIGHT*FONT_SCALE_FACTOR;
				RESERVED_HEADER_HEIGHT = RESERVED_HEADER_HEIGHT*FONT_SCALE_FACTOR;	
			}else{
				RESERVED_FOOTER_HEIGHT = 0;
				RESERVED_HEADER_HEIGHT = 0;
			}
			RESERVED_HEIGHT = RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT;

			if(dpi >= 300){
				var rat300:Number = DEVICE == DEVICE_TABLET ? 2.672972973 : 1.75;
				FONT_SIZES[12] = 12*rat300;
				FONT_SIZES[13] = 13*rat300;
				FONT_SIZES[14] = 14*rat300;
				FONT_SIZES[15] = 15*rat300;
				FONT_SIZES[16] = 16*rat300;
				FONT_SIZES[18] = 18*rat300;
				FONT_SIZES[20] = 20*rat300;
				FONT_SIZES[22] = 22*rat300;
				FONT_SIZES[24] = 24*rat300;
				FONT_SIZES[30] = 30*rat300;
				FONT_SIZES[32] = 32*rat300;
				FONT_SIZES[36] = 36*rat300;
				FONT_SIZES[48] = 48*rat300*.75;
				FONT_SIZES[54] = 54*rat300*.75;
				FONT_SIZES[72] = 72*rat300*.75;
				FONT_SIZES[100] = 100*rat300*.75;
			}else if (dpi >= 200){
				var rat200:Number = DEVICE == DEVICE_TABLET ? 2.277777778 : 1.3;
				FONT_SIZES[12] = 12*rat200;
				FONT_SIZES[13] = 13*rat200;
				FONT_SIZES[14] = 14*rat200;
				FONT_SIZES[15] = 15*rat200;
				FONT_SIZES[16] = 16*rat200;
				FONT_SIZES[18] = 18*rat200;
				FONT_SIZES[20] = 20*rat200;
				FONT_SIZES[22] = 22*rat200;
				FONT_SIZES[24] = 24*rat200;
				FONT_SIZES[30] = 30*rat200;
				FONT_SIZES[32] = 32*rat200;
				FONT_SIZES[36] = 36*rat200;
				FONT_SIZES[48] = 48*rat200*.75;
				FONT_SIZES[54] = 54*rat200*.75;
				FONT_SIZES[72] = 72*rat200*.75;
				FONT_SIZES[100] = 100*rat200*.75;
				
			}else if (dpi >= 100){
				
				FONT_SIZES[12] = 14;
				FONT_SIZES[13] = 14;
				
			}
		}
		
		private static var _stageCover:Sprite;
		
		
		private static function onFullScreenChange(evt:FullScreenEvent):void{
			if(evt.fullScreen == false){
				FullScreenInteractiveAllowed = false;
			}
		}
		
		public static function checkFSStatus():void{
			if(_stage.displayState != StageDisplayState.NORMAL && !FullScreenInteractiveAllowed && DEVICE == DEVICE_PC){
				
				if(!_stageCover){
					_stageCover = new Sprite();
				}
				_stage.addChild(_stageCover);
				_stageCover.addChild(_stageCoverCopy);
				onStageResize();
				_stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenChangeForOverlay);
			}else{
				removeStageCover();
			}
		}
		
		public static function isDisplayObjectVisible(t:DisplayObject):Boolean{
			if(t.stage == null || t.visible == false){
		        return false;
			}
		    var p:DisplayObjectContainer = t.parent;
		    while(p && !(p is Stage)){
		        if(!p.visible){
		           return false;
				}
		        p = p.parent;
		    }
		    return true;
		}
		
		private static function onFSInteractiveAccepted(evt:FullScreenEvent):void{
			FullScreenInteractiveAllowed = true;
			removeStageCover();
		}
		
		
		private static function onFullScreenChangeForOverlay(evt:FullScreenEvent):void{
			if(evt.fullScreen == false && _stageCover && _stage.contains(_stageCover)){
				removeStageCover();
			}
		}
		
		private static function removeStageCover():void{
			
			if(_stageCover){
				_stageCover.graphics.clear();
				_stage.removeChild(_stageCover);
				_stageCover.removeChild(_stageCoverCopy);
				_stageCover = null;
				
			}
			_stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenChangeForOverlay);
			DispatchManager.dispatchEvent(new Event(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED));
		}
		
	}
}

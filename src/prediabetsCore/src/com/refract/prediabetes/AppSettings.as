package com.refract.prediabetes {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;

	public class AppSettings 
	{
		public static const DEBUG : Boolean = true;
		public static const INTRO_URL : String = 'd01_intro_part_1' ; 
		
		public static var APP_VIDEO_BASE_URL : String ; 
		public static var LOCALE:String = "en";
		
		public static var RED:int = 0xc45252;
		public static var LIGHT_GREY:int =0xcdcdcd;
		public static var GREY:int = 0x999999;
		public static var DARK_GREY:int = 0x4d4d4d;
		public static var WHITE:int = 0xffffff;
		public static var BLACK:int = 0x000000;
		
		public static const BULK_LOADER_ID : String  = 'Videos' ; 
		
		public static var DATA_PATH:String = "http://rob.otlabs.net/stuff/prediabetes/" ; //"data/" ;
		//public static var DATA_PATH:String = "data/" ; 
		public static var APP_DATA_PATH : String = "file://";
		public static var BUFFER_DELAY 				  : Number = 0.3 ; 	  

		public static const BUTTON_HIT_AREA_ALPHA:Number = 0;
		public static const BUTTON_HIT_AREA_EDGE:int = 10;
		public static const BUTTON_HIT_AREA_WIDTH:int = BUTTON_HIT_AREA_EDGE << 1 ;
		
		public static var VIDEO_FILE_EXT:String = ".f4v" ;
		public static var VIDEO_BASE_URL : String = "video/f4v/1024/" ;
		public static var VIDEO_FILE_FORMAT_DESCRIPTOR:String = "";
		
		public static const DEVICE_PC:String = "DEVICE_PC";
		public static const DEVICE_TABLET:String = "DEVICE_TABLET";
		public static var DEVICE : String = "DEVICE_PC";
		
		public static var RETINA : Boolean = false ;
		
		public static var VIDEO_WIDTH:Number = 0;
		public static var VIDEO_HEIGHT:Number = 0;
		public static var VIDEO_IS_STAGE_WIDTH:Boolean = false;
		public static var VIDEO_LEFT:Number = 0;
		public static var VIDEO_RIGHT:Number = 0;
		public static var VIDEO_TOP:Number = 0;
		public static var VIDEO_BOTTOM:Number = 0;
		
		//public static var RESERVED_HEADER_HEIGHT_TOP:int = 10;
		//public static var RESERVED_HEADER_HEIGHT_BOTTOM:int = 80;
		
		public static var SHOW_HEADER : Boolean = false ; 
		public static var FOOTER_VIDEONAV_FIXED : Boolean = false ; 
		public static var RESERVED_HEADER_HEIGHT_DEFAULT:int = 34 ; //35;
		public static var RESERVED_FOOTER_HEIGHT_DEFAULT:int = 34 ; //34;
		public static var RESERVED_HEADER_HEIGHT:int = RESERVED_HEADER_HEIGHT_DEFAULT ; //30 ; //RESERVED_HEADER_HEIGHT_DEFAULT;
		public static var RESERVED_FOOTER_HEIGHT:int = RESERVED_FOOTER_HEIGHT_DEFAULT ; //90 ; //RESERVED_FOOTER_HEIGHT_DEFAULT;
		public static var RESERVED_HEIGHT:int = RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT;
		public static var RESERVED_SIDE_BORDER:int = 0;
		
		public static var RESERVED_FOOTER_HEIGH_RETINA : int = 210 ; 
		public static var RESERVED_HEADER_HEIGH_RETINA : int = 202 ; 
		
		public static var RESERVED_FOOTER_HEIGH_NO_RETINA : int = 105 ; 
		public static var RESERVED_HEADER_HEIGH_NO_RETINA : int = 101 ; 
		
		public static var TOP_HEIGHT_BAR				  : int = 38 ; 
		
		public static var FONT_SCALE_FACTOR:Number = 1;
		
		public static var FOOTER_FONT_SIZE:int = 15 ;
		public static var FOOTER_FONT_SIZE_FS:int = 18;
		
		public static var FOOTER_FIX_TABLET_POSITION : int = 0 ;
		public static var HEADER_FIX_COPY_TABLET_POSITION : int = 0 ; 
		public static var FOOTER_FONT_SIZE2:int = 14;
		public static var HEADER_FONT_SIZE : int = 21 ; 
		
		public static var FOOTER_BUTTON_SPACE : int = 22; 
		 
		
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
			dict[19] = 19;
			dict[20] = 20;
			dict[21] = 21;
			dict[22] = 22;
			dict[24] = 24;
			dict[28] = 28;
			dict[30] = 30;
			dict[32] = 32;
			dict[35] = 35;
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
				_stage.removeEventListener(FullScreenEvent.FULL_SCREEN,onFullScreenChange);
			}
			_stage = st;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			_stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFullScreenChange);
			onStageResize();
		}
		
		private static const SIXTEEN_NINE_RATIO:Number = 16/9;
		
		private static function onStageResize(evt:Event = null):void
		{
			var stageW : Number = _stage.stageWidth - AppSettings.RESERVED_SIDE_BORDER * 2 ; 
			var stageRatio:Number = stageW /(_stage.stageHeight-RESERVED_HEIGHT);
			var totHBusy : int ; 
			var diffFree : int ; 
			if(SIXTEEN_NINE_RATIO > stageRatio)
			{
				//**stage height greater than width -> fit to width
				VIDEO_HEIGHT = stageW/SIXTEEN_NINE_RATIO;
				VIDEO_WIDTH = stageW ; 
				VIDEO_IS_STAGE_WIDTH = true;
				VIDEO_LEFT = 0;
				VIDEO_RIGHT = VIDEO_WIDTH;
				totHBusy = VIDEO_HEIGHT + RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT ;
				diffFree = _stage.stageHeight - totHBusy ; 
				VIDEO_TOP = RESERVED_HEADER_HEIGHT + ( diffFree / 2 ) ;
				//_stage.stageHeight/2 - VIDEO_HEIGHT/2 ; //- RESERVED_HEADER_HEIGHT/2 ;
				VIDEO_BOTTOM = VIDEO_TOP + VIDEO_HEIGHT;
			}
			else
			{ 
				//**stage width greater than stage height -> fit to height
				VIDEO_WIDTH = (_stage.stageHeight - RESERVED_HEIGHT)*SIXTEEN_NINE_RATIO - AppSettings.RESERVED_SIDE_BORDER * 2;
				VIDEO_HEIGHT = (_stage.stageHeight - RESERVED_HEIGHT);
				VIDEO_IS_STAGE_WIDTH = false;
				VIDEO_LEFT = stageW/2 - VIDEO_WIDTH/2 ;
				VIDEO_RIGHT = VIDEO_LEFT + VIDEO_WIDTH;
				totHBusy = VIDEO_HEIGHT + RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT ;
				diffFree = _stage.stageHeight - totHBusy ; 
				VIDEO_TOP = RESERVED_HEADER_HEIGHT - diffFree / 2;
				VIDEO_BOTTOM = VIDEO_TOP + VIDEO_HEIGHT;
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
			if( dpi > 200  && dpi < 300)
			{
				RETINA = true ; 
				RESERVED_FOOTER_HEIGHT = RESERVED_FOOTER_HEIGH_RETINA ; 
				RESERVED_HEADER_HEIGHT = RESERVED_HEADER_HEIGH_RETINA ; 
				FOOTER_FIX_TABLET_POSITION = FOOTER_FIX_TABLET_POSITION * 1.7 ; 				
			}
			else
			{
				RETINA = false ; 
				RESERVED_FOOTER_HEIGHT = RESERVED_FOOTER_HEIGH_NO_RETINA ; 
				RESERVED_HEADER_HEIGHT = RESERVED_HEADER_HEIGH_NO_RETINA ; 
				
				TOP_HEIGHT_BAR = TOP_HEIGHT_BAR / 2; 
				HEADER_FIX_COPY_TABLET_POSITION = HEADER_FIX_COPY_TABLET_POSITION / 2; 
			}
			RESERVED_HEIGHT = RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT;
			/*
			//trace("Device looks like: ", DEVICE, "size is", inches, "with dpi",dpi, "and reported dpi",reportedDpi, "and scale factor",FONT_SCALE_FACTOR);
			if(DEVICE == DEVICE_TABLET){
				RESERVED_FOOTER_HEIGHT = RESERVED_FOOTER_HEIGHT*FONT_SCALE_FACTOR;
				RESERVED_HEADER_HEIGHT = RESERVED_HEADER_HEIGHT*FONT_SCALE_FACTOR;	
			}else{
				RESERVED_FOOTER_HEIGHT = 0;
				RESERVED_HEADER_HEIGHT = 0;
			}
			RESERVED_HEIGHT = RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT;
			 * 
			 */

		    if (dpi >= 200)
			{
				trace('>>200')
				var rat200:Number = DEVICE == DEVICE_TABLET ? 2.277777778 : 1.3;
				FONT_SIZES[12] = 12*rat200;
				FONT_SIZES[13] = 13*rat200;
				FONT_SIZES[14] = 14*rat200;
				FONT_SIZES[15] = 15*rat200;
				FONT_SIZES[16] = 16*rat200;
				FONT_SIZES[18] = 18*rat200;
				FONT_SIZES[19] = 38;
				FONT_SIZES[20] = 20*rat200;
				FONT_SIZES[22] = 22*rat200;
				FONT_SIZES[24] = 24*rat200;
				FONT_SIZES[30] = 30*rat200;
				FONT_SIZES[32] = 32*rat200;
				FONT_SIZES[35] = 61 ; 
				FONT_SIZES[36] = 36*rat200;
				FONT_SIZES[48] = 48*rat200*.75;
				FONT_SIZES[54] = 54*rat200*.75;
				FONT_SIZES[72] = 72*rat200*.75;
				FONT_SIZES[100] = 100*rat200*.75;
			}
		}
		
		private static function onFullScreenChange(evt:FullScreenEvent):void
		{
			if( evt.fullScreen )
			{
				RESERVED_HEADER_HEIGHT_DEFAULT = 60 ; //35;
				RESERVED_FOOTER_HEIGHT_DEFAULT = 60 ; //34;

				RESERVED_HEADER_HEIGHT = RESERVED_HEADER_HEIGHT_DEFAULT ; //30 ; //RESERVED_HEADER_HEIGHT_DEFAULT;
				RESERVED_FOOTER_HEIGHT= RESERVED_FOOTER_HEIGHT_DEFAULT ; //90 ; //RESERVED_FOOTER_HEIGHT_DEFAULT;
				RESERVED_HEIGHT = RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT;
				
				FOOTER_BUTTON_SPACE = 22 ; 
		
			}
			else
			{
				RESERVED_HEADER_HEIGHT_DEFAULT = 34 ; //35;
				RESERVED_FOOTER_HEIGHT_DEFAULT = 34 ; //34;
				
				RESERVED_HEADER_HEIGHT = RESERVED_HEADER_HEIGHT_DEFAULT ; //30 ; //RESERVED_HEADER_HEIGHT_DEFAULT;
				RESERVED_FOOTER_HEIGHT= RESERVED_FOOTER_HEIGHT_DEFAULT ; //90 ; //RESERVED_FOOTER_HEIGHT_DEFAULT;
				RESERVED_HEIGHT = RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT;
				
				FOOTER_BUTTON_SPACE = 30 ; 
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
		


		
	}
}

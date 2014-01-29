package com.refract.prediabetes {
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;

	public class AppSettings 
	{
		public static const DEBUG 										: Boolean = true ;
		public static const INTRO_URL									: String = 'd01_intro_part_1' ; 
		public static var APP_VIDEO_BASE_URL 							: String ; 
		public static var LOCALE										: String = "en";
		public static var LOGO_ADDRESS 									: String = 'Logo' ; 
		
		public static const BULK_LOADER_ID 								: String  = 'Videos' ; 
		
		//public static var DATA_PATH									  :String = "http://rob.otlabs.net/stuff/prediabetes/" ; //"data/" ;
		public static var DATA_PATH										: String = "data/" ; 
		public static var APP_DATA_PATH 								: String = "file://";
		public static var BUFFER_DELAY 				  					: Number = 0.3 ; 	  

		public static const BUTTON_HIT_AREA_ALPHA						: Number = 0;
		public static const BUTTON_HIT_AREA_EDGE						: int = 10;
		public static const BUTTON_HIT_AREA_WIDTH						: int = BUTTON_HIT_AREA_EDGE << 1 ;
		
		public static var VIDEO_FILE_EXT								: String = ".f4v" ;
		public static var VIDEO_BASE_URL								: String = "video/f4v/1024/" ;
		public static var VIDEO_FILE_FORMAT_DESCRIPTOR					: String = "";
		
		public static const DEVICE_PC									: String = "DEVICE_PC";
		public static const DEVICE_TABLET								: String = "DEVICE_TABLET";
		public static var DEVICE 										: String = "DEVICE_PC";
		
		public static var RETINA 										: Boolean = false ;
		
		public static var VIDEO_WIDTH									: Number = 0;
		public static var VIDEO_HEIGHT									: Number = 0;
		public static var VIDEO_IS_STAGE_WIDTH							: Boolean = false;
		public static var VIDEO_LEFT									: Number = 0;
		public static var VIDEO_RIGHT									: Number = 0;
		public static var VIDEO_TOP										: Number = 0;
		public static var VIDEO_BOTTOM									: Number = 0;
		
		public static var OVERLAY_GAP 									: int = 26 ; 
		
		public static var OVERLAY_BODY_DIFF_W_NO_FS						: int = 50 ;
		public static var OVERLAY_BODY_DIFF_W_FS						: int = 70 ;
		public static var OVERLAY_BODY_DIFF_H_NO_FS						: int = 120 ;
		public static var OVERLAY_BODY_DIFF_H_FS						: int = 130 ;
		public static var OVERLAY_BODY_DIFF_W							: int = OVERLAY_BODY_DIFF_W_NO_FS ; 
		public static var OVERLAY_BODY_DIFF_H							: int = OVERLAY_BODY_DIFF_H_NO_FS ; 
		//public static var SCROLLBAR_
		public static var SCROLLBAR_GAP_H 								: int = 10 ; 
		public static const SCROLLBAR_BACK_W_NO_FS						: int = 21 ; 
		public static const SCROLLBAR_TRIGGER_W_NO_FS					: int = 12 ; 
		public static const SCROLLBAR_BACK_W_FS							: int = 27 ; 
		public static const SCROLLBAR_TRIGGER_W_FS						: int = 13 ; 
		public static const SCROLLBAR_BACK_W_RETINA						: int = 38 ; 
		public static const SCROLLBAR_BACK_W_NO_RETINA					: int = 19 ; 
		public static const SCROLLBAR_TRIGGER_W_RETINA					: int = 17 ; 
		public static const SCROLLBAR_TRIGGER_W_NO_RETINA				: int = 8 ; 
		public static var SCROLLBAR_BACK_W								: int = SCROLLBAR_BACK_W_NO_FS; 
		public static var SCROLLBAR_TRIGGER_W							: int = SCROLLBAR_TRIGGER_W_NO_FS; 
		
		public static var BACK_TO_VIDEO_GAP 							: int = 10 ;  
		public static var SHOW_HEADER 									: Boolean = false ; 
		public static var FOOTER_VIDEONAV_FIXED 						: Boolean = false ; 
		public static var RESERVED_HEADER_HEIGHT_DEFAULT				: int = 34 ; 
		public static var RESERVED_FOOTER_HEIGHT_DEFAULT				: int = 34 ; 
		public static var RESERVED_HEADER_HEIGHT						: int = RESERVED_HEADER_HEIGHT_DEFAULT ;
		public static var RESERVED_FOOTER_HEIGHT						: int = RESERVED_FOOTER_HEIGHT_DEFAULT ;
		public static var RESERVED_HEIGHT								: int = RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT;
		public static var RESERVED_SIDE_BORDER							: int = 0;

		public static var FONT_SCALE_FACTOR							    : Number = 1 	;
		public static var FOOTER_FONT_SIZE								: int = 15 ;
		public static var FOOTER_FONT_SIZE_FS							: int = 18;
		
		public static var FOOTER_FIX_MENU_TABLET_POSITION 				: int = 0 ;
		public static var HEADER_FIX_COPY_TABLET_POSITION 				: int = 15 ; 
		public static var FOOTER_FONT_SIZE2								: int = 14;
		public static var HEADER_FONT_SIZE 								: int = 21 ; 
		
		public static var FOOTER_BUTTON_SPACE 							: int = 22; 
		
		public static var VIDEO_NAV_SIDE 								: int = 12 ; 
		public static var VIDEO_NAV_HEIGHT 								: int = 26 ;
		public static var VIDEO_NAV_COLOR 								: uint = 0x383838 ;  
		public static var VIDEO_NAV_PROGRESS_BAR_COLOR 					: uint = 0x999999 ;
		public static var VIDEO_NAV_PROGRESS_BAR_HEIGHT 				: int = 12 ; 
		public static var VIDEO_NAV_PROGRESS_BAR_Y_POS					: int = 5 ; 
		public static var VIDEO_NAV_BUTTON_SPACE 						: int = 10 ; 
		public static var VIDEO_NAV_PROGRESS_BAR_HIT_AREA_HEIGHT 		: int = 20 ; 
		public static var PP_FIXER_Y 									: int = 0 ; 
		public static var SND_FIXER_X									: int = 0 ; 
		public static var SND_FIXER_Y									: int = 0 ; 
		
		public static var MOUSE_MOVE_H									: int = -60 ; 
		
		 
		//**Colors
		public static var RED:int = 0xc45252;
		public static var LIGHT_GREY:int =0xcdcdcd;
		public static var GREY:int = 0x999999;
		public static var DARK_GREY:int = 0x4d4d4d;
		public static var WHITE:int = 0xffffff;
		public static var BLACK:int = 0x000000;
		
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
			dict[25] = 25;
			dict[28] = 28;
			dict[30] = 30;
			dict[32] = 32;
			dict[35] = 35;
			dict[36] = 36;
			dict[38] = 38;
			dict[48] = 48;
			dict[54] = 54;
			dict[60] = 60;
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
			
			_stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFullScreenChange );
			_stage.addEventListener(Event.RESIZE, onStageResize );
			onStageResize();
		}
		
		private static const SIXTEEN_NINE_RATIO:Number = 16/9;
		
		private static function onStageResize(evt:Event = null):void
		{
			
			if( DEVICE != DEVICE_TABLET ) 
			{
				SMSettings.onFullScreenChange() ; 
				onFullScreenChange() ; 
			}
			
			
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
			
			DispatchManager.dispatchEvent( new Event( Flags.SET_OVERLAY_SIZE )) ;
		    DispatchManager.dispatchEvent( new Event( Flags.APP_FULLSCREEN )) ;
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

		
		
		private static function onFullScreenChange(evt:FullScreenEvent = null ):void
		{
			if( stage.displayState != StageDisplayState.NORMAL)
			{
				RESERVED_HEADER_HEIGHT_DEFAULT = 80 ; //35;
				RESERVED_FOOTER_HEIGHT_DEFAULT = 60 ; //34;

				RESERVED_HEADER_HEIGHT = RESERVED_HEADER_HEIGHT_DEFAULT ; //30 ; //RESERVED_HEADER_HEIGHT_DEFAULT;
				
				RESERVED_FOOTER_HEIGHT= RESERVED_FOOTER_HEIGHT_DEFAULT ; //90 ; //RESERVED_FOOTER_HEIGHT_DEFAULT;
				RESERVED_HEIGHT = RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT;
				
				FOOTER_BUTTON_SPACE = 22 ; 
				OVERLAY_GAP = 100 ; 
				OVERLAY_BODY_DIFF_W = OVERLAY_BODY_DIFF_W_FS ; 
				OVERLAY_BODY_DIFF_H = OVERLAY_BODY_DIFF_H_FS ; 
				
				SCROLLBAR_BACK_W = SCROLLBAR_BACK_W_FS ;
				SCROLLBAR_TRIGGER_W = SCROLLBAR_TRIGGER_W_FS ;  
				
				MOUSE_MOVE_H = -120 ; 
			}
			else
			{
				RESERVED_HEADER_HEIGHT_DEFAULT = 34 ; //35;
				RESERVED_FOOTER_HEIGHT_DEFAULT = 34 ; //34;
				
				RESERVED_HEADER_HEIGHT = RESERVED_HEADER_HEIGHT_DEFAULT ; //30 ; //RESERVED_HEADER_HEIGHT_DEFAULT;
				RESERVED_FOOTER_HEIGHT= RESERVED_FOOTER_HEIGHT_DEFAULT ; //90 ; //RESERVED_FOOTER_HEIGHT_DEFAULT;
				RESERVED_HEIGHT = RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT;
				FOOTER_BUTTON_SPACE = 30 ; 
				OVERLAY_GAP = 50 ; 
				OVERLAY_BODY_DIFF_W = OVERLAY_BODY_DIFF_W_NO_FS ; 
				OVERLAY_BODY_DIFF_H = OVERLAY_BODY_DIFF_H_NO_FS ; 
				
				SCROLLBAR_BACK_W = SCROLLBAR_BACK_W_NO_FS ;
				SCROLLBAR_TRIGGER_W = SCROLLBAR_TRIGGER_W_NO_FS ;  
				
				MOUSE_MOVE_H = -90 ; 
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

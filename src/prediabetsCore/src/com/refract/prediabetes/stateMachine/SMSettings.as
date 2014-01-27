package com.refract.prediabetes.stateMachine {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	/**
	 * @author robertocascavilla
	 */
	public class SMSettings 
	{
		public static const DEBUG_GET_CLIP_LENGTH 		: Boolean = false ; 
		public static const STATE_TXT_MAX_W               : int = 800 ; 
		
		public static const BUTTON_FADE_DELAY             : Number = 0 ; 
		public static const FADE_OUT_TIME 				  : Number = 0.5 ; 
		public static const SLOW_TIMER_X			  	  : int = 6000 ;  	
		public static const BACK_MAX_TIME 				  : int = 5000 ; 	
		
		
		
		public static const STATE_TXT_COLOR 			  : uint = 0xffffff ; 
		 
		
		public static var STATE_TXT_FONT_SIZE_NO_FS       : int = 28 ;
		public static var STATE_TXT_FONT_SIZE_FS          : int = 35 ;
		
		public static var STATE_TXT_FONT_SIZE 			  : int = STATE_TXT_FONT_SIZE_NO_FS ; 
		//**Choice Skin
		 
		public static var CHOICE_BORDER_COLOR 			  : uint = 0x676767 ; 
		public static var CHOICE_BACK_COLOR 			  : uint = 0x363636 ; 
		
		public static var CHOICE_FONT_SIZE_NO_FS		  : int = 24 ; 
		public static var CHOICE_FONT_SIZE_FS		      : int = 30 ; //24 ; 
		public static var CHOICE_BUTTON_HEIGHT_NO_FS 	  : int = 38 ; 
		public static var CHOICE_BUTTON_HEIGHT_FS 	  	  : int = 50 ; 
		public static var CHOICE_BUTTON_WIDTH_NO_FS 	  : int = 704 ; 
		public static var CHOICE_BUTTON_WIDTH_FS 	  	  : int = 806 ; 
		public static var CHOICE_BUTTON_SPACE_NO_FS 	  : int = 13 ; 
		public static var CHOICE_BUTTON_SPACE_FS 	  	  : int = 16 ; 
		
		
		
		public static var CHOICE_BUTTON_HEIGHT			  : int = CHOICE_BUTTON_HEIGHT_NO_FS ;
		public static var CHOICE_FONT_SIZE       		  : int = CHOICE_FONT_SIZE_NO_FS ; 
		public static var CHOICE_BUTTON_WIDTH			  : int = CHOICE_BUTTON_WIDTH_NO_FS ; 
		public static var CHOICE_BUTTON_SPACE			  : int = CHOICE_BUTTON_SPACE_NO_FS ;
		
		
		
		public static const SHOW_DELAY                    : Number = .2 ; 
		public static const MIN_BUTTON_SIZE               : int = 1 ; 
		
		public static const STATE_SLOW           	      : String = 'd_slow' ;
		public static const STATE_NONE           	      : String = 'd_none' ;
		public static const _Q           				  : String = '_q' ;
		
		//**Colors
		public static const DEEP_RED                      : uint = 0xc45252 ; 
		public static const GREEN_BUTTON                  : uint = 0x829b64 ;
		
		public static const FONT_BUTTON                   : String = 'buttonFont' ;
		public static const FONT_STATETXT                 : String = 'stateTxt' ;
				
		
		public static const BUTTON_SOUND_GOOD             : String = 'BUTTON_SOUND_GOOD' ; 
		public static const BUTTON_SOUND_WRONG            : String = 'BUTTON_SOUND_WRONG' ;
		public static const QUESTIONS_FADE_IN             : String = 'Questions_Fade_Up' ; 
		public static const QUESTIONS_ROLLOVER            : String = 'Questions_Rollover' ; 
		
		//**fix bug with choice smoker ( as video is too short ) 
		public static const D_21_M						  : String = 'd21m_choice_smoker' ; 
		
		public static function init() : void
		{
			//AppSettings.stage.addEventListener( FullScreenEvent.FULL_SCREEN , onFullScreenChange ) ;
		}
		public static function onFullScreenChange ( evt : FullScreenEvent = null ) : void
		{
			
			if( AppSettings.stage.displayState != StageDisplayState.NORMAL)
			{
				CHOICE_FONT_SIZE = CHOICE_FONT_SIZE_FS ; 
				CHOICE_BUTTON_HEIGHT = CHOICE_BUTTON_HEIGHT_FS ; 
				CHOICE_BUTTON_WIDTH = CHOICE_BUTTON_WIDTH_FS ; 
				CHOICE_BUTTON_SPACE = CHOICE_BUTTON_SPACE_FS ; 
				
				STATE_TXT_FONT_SIZE = STATE_TXT_FONT_SIZE_FS ; 
				
			}
			else
			{
				CHOICE_FONT_SIZE = CHOICE_FONT_SIZE_NO_FS ; 
				CHOICE_BUTTON_HEIGHT = CHOICE_BUTTON_HEIGHT_NO_FS ; 
				CHOICE_BUTTON_WIDTH = CHOICE_BUTTON_WIDTH_NO_FS ;
				CHOICE_BUTTON_SPACE = CHOICE_BUTTON_SPACE_NO_FS ;
				
				STATE_TXT_FONT_SIZE = STATE_TXT_FONT_SIZE_NO_FS ; 
			}
			
			//DispatchManager.dispatchEvent( new Event( Flags.APP_FULLSCREEN )) ; 
		}
	}
}

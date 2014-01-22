package com.refract.prediabetes.stateMachine {
	/**
	 * @author robertocascavilla
	 */
	public class SMSettings 
	{
		public static const DEBUG_GET_CLIP_LENGTH 		: Boolean = false ; 
		public static const STATE_TXT_MAX_W               : int = 800 ; 
		
		
		//public static const COUNTER_START_FLASHING        : String = '00:02' ; 
		public static const BUTTON_FADE_DELAY             : Number = 0 ; 
		public static const FADE_OUT_TIME 				  : Number = 0.5 ; 
		public static const SLOW_TIMER_X			  	  : int = 6000 ;  	
		public static const BACK_MAX_TIME 				  : int = 5000 ; 	
		
		public static var CHOICE_BUTTON_HEIGHT		      : int = 60 ; 
		
		public static const STATE_TXT_COLOR 			  : uint = 0xffffff ; 
		public static var STATE_TXT_FONT_SIZE           : int = 28 ; 
		public static var CHOICE_FONT_SIZE 				  : int = 24 ; 
		public static var MESSAGE_BOX_FONT_SIZE			  : int = 35 ;
		
		
		
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
	}
}

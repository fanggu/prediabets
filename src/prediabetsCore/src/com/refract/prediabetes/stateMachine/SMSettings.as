package com.refract.prediabetes.stateMachine {
	/**
	 * @author robertocascavilla
	 */
	public class SMSettings 
	{
		public static const STATE_TXT_MAX_W               : int = 800 ; 
		public static var STATE_TXT_FONT_SIZE           : int = 72 ; 
		
		public static const COUNTER_START_FLASHING        : String = '00:02' ; 
		
		public static const TRIGGER_SLOW_TIME             : int = 3000 ; 
		public static const CPR_TRIGGER_SLOW              : int = 1500 ; 
		public static const CPR_TRIGGER_NOTACTIVE         : int = 6000 ; 
		public static const CPR_TRIGGER_LONG 	          : int = 60000 ; 
		public static const CPR_EASING                    : int = 120 ; 
		public static const CPR_TRIGGER_PUMP              : Number = 600 ; 
		public static const CPR_GAP_MS                    : int = 200 ; 
		public static const CPR_STEP_MS                   : int = 500 ; 
		public static const CPR_GAP_LONG_MS               : int = 120 ; 
		
		public static const TIME_SLOWTIME_DELAY           : int = 3000 ; 
		public static const RIGHT_ANSWER_TIMER            : int = 1000 ; 
		public static const BUTTON_FADE_DELAY             : Number = 1 ; 
		
		public static const ALPHA_RED_FILTER              : Number = .7 ; 
		public static const SHOW_DELAY                    : Number = .2 ; 
		public static const COUNTER_START_DELAY           : int = 8 ;
		
		public static var CUTBLACK_DELAY 				  : Number = 0 ; 
		
		public static const MIN_BUTTON_SIZE               : int = 1 ; 
		
		//**GENERAL COPY, to BE UPDATED ON COPY JSON
		public static const T_PAUSE                       : String = 'PAUSE' ; 
		public static const T_TOO_SLOW                    : String = 'SORRY, TOO SLOW' ;
		public static const T_TRY_AGAIN                   : String = 'SORRY, TRY AGAIN' ; 
		public static const GOOD_CHOICE                   : String = 'GOOD CHOICE' ; 

		// 5 stars
		public static const SCORE_EXCELLENT               : String = 'EXCELLENT' ;
		// 4 stars
		public static const SCORE_VERY_GOOD               : String = 'VERY GOOD' ;
		// 3 stars
		public static const SCORE_OK                      : String = 'OK';
		// 2 stars
		public static const SCORE_NOT_GREAT               : String = 'NOT GREAT';
		// 1 stars
		public static const SCORE_TRY_HARDER              : String = 'TRY HARDER';

		public static const GOOD                          : String = 'GOOD' ; 
		public static const BAD                           : String = 'BAD' ; 
		public static const UGLY                          : String = 'UGLY' ; // useless, but I cannot read "good and bad" without adding ugly at the end...

		public static const YOU                           : String = 'YOU' ; 
		public static const TOO_FAST                      : String = 'SLOWER'; //'TOO FAST' ; 
		public static const TOO_SLOW                      : String = 'FASTER' ; //'TOO SLOW' ; 
		public static const OK                            : String = 'OK' ; 
		public static const PLUS_ACCURACY                 : String = '+ACCURACY' ; 
		public static const TILT                          : String = 'TILT HEAD' ; 
		
		//**general strings
		public static const T_COUNTDOWN                   : String ='00:' ; 
		
		//**Colors
		public static const DEEP_RED                      : uint = 0xc45252 ; 
		public static const GREEN_BUTTON                  : uint = 0x829b64 ;
		
		public static const FONT_BUTTON                   : String = 'buttonFont' ;
		public static const FONT_COUNTDOWN                : String = 'countDown' ;
		public static const FONT_STATETXT                 : String = 'stateTxt' ;
		public static const FONT_REAL_STORIES             : String = 'fontRealStories';
		
		public static var FONT_SIZE_COUNTDOWN 		  : int    = 48;
		
		public static const REAL_STORIES                  : String ='REAL STORIES :';
		public static const OF                            : String ='OF';
		public static const WATCHED                       : String ='WATCHED';
		
		
		public static const CHOICE_IMG_DISTANCE           : int = 300 ; 
		
		public static const BUTTON_SOUND_GOOD             : String = 'BUTTON_SOUND_GOOD' ; 
		public static const BUTTON_SOUND_WRONG            : String = 'BUTTON_SOUND_WRONG' ;
		public static const QUESTIONS_FADE_IN             : String = 'Questions_Fade_Up' ; 
		public static const QUESTIONS_ROLLOVER            : String = 'Questions_Rollover' ; 
	}
}

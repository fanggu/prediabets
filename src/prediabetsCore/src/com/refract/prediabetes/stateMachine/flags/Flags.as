package com.refract.prediabetes.stateMachine.flags {
	/**
	 * @author robertocascavilla
	 */
	public class Flags 
	{
		public static const START_MOVIE							: String = 'startMovie' ; 
		public static const OVERWEIGHT							: String = 'overweight' ; 
		public static const APP_FULLSCREEN						: String = 'appFullScreen' ; 
		//**comm with External UI
		//public static const UPDATE_UI_PROGRESS 					: String = 'updateProgress' ; 
		public static const ACTIVATE_PROGRESS_BAR 				: String = 'activateProgressBar' ; 
		public static const DE_ACTIVATE_PROGRESS_BAR 				: String = 'deActivateProgressBar' ; 		
		public static const ON_FLV_METADATA 					: String = 'onFLVMetaData' ; 
		public static const ON_BACKWARD 						: String = 'onBackward' ;
		public static const ON_REQUEST_RESIZE 					: String = 'onReuqestResize' ;  
		
		public static const FREEZE 								: String = 'freeze' ; 
		public static const UN_FREEZE 							: String = 'unfreeze' ; 
		public static const FREEZE_SOUNDS 						: String = 'FREEZE_SOUNDS' ; 
		public static const UN_FREEZE_SOUNDS 					: String = 'UN_FREEZE_SOUNDS' ;
		public static const FREEZE_BUTTONS 						: String = 'FREEZE_BUTTONS' ;
		public static const UNFREEZE_BUTTONS 					: String = 'UNFREEZE_BUTTONS' ;
		public static const CHOICE_SELECTED 			    	: String = 'choiceSelected' ;
		
		public static const ACTIVE_BACK 						: String = 'activeBack' ; 
		public static const INACTIVE_BACK 						: String = 'inactiveBack' ; 
		
		public static const STATE_MACHINE_START 				: String = 'stateMachineStart' ; 
		public static const STATE_MACHINE_END 					: String = 'stateMachineEnd' ; 
		
		//**
		public static const UPDATE_SIZE_BUTTON 					: String = 'updateSizeButton' ; 
		//public static var UPDATE_STATE 						: String = 'updateState';
		//public static const UNLOCK_AFTER_INTERACTION 				: String = 'unlockAfterInteraction' ; 
		public static const UPDATE_TRANSITION 					: String = 'updateTransition';
		//public static var EXEC_TRANSITION 					: String = 'execTransition'
		public static const UPDATE_VIEW_TRANSITION 				: String = 'updateViewTransition';
		public static const UPDATE_VIEW_INTERACTIONS				: String = 'updateViewInteractions';
		//public static var UPDATE_VIEW_INTERACTIONS_WG			: String = 'updateViewInteractionsWg';
		public static const UPDATE_VIEW_VIDEO 					: String = 'updateViewVideo' ;
		//public static const UPDATE_VIEW_COUNTDOWN_TIMER 			: String = 'updateViewCountdownTimer';
		//public static const UPDATE_VIEW_COUNTDOWN_TIMER_CPR_LONG : String ='updateViewCounterdownTimerCprLong' ; 
		//public static const UPDATE_VIEW_COUNTDOWN_TEXT 			: String = 'updateViewCountdownText' ;
		//public static const CREATE_COUNTDOWN_TIMER 				: String = 'createCountdownTimer' ;
		//public static const UPDATE_VIEW_COUNTDOWN_TIMER_WHITE		: String = 'updateViewCountdownTimerWhite' ; 
		//public static const UPDATE_VIEW_COUNTDOWN_STOP_WHITE 		: String = 'updateViewCountdownStopWhite' ; 
		//public static const UPDATE_VIEW_COUNTDOWN_FORCE_REMOVE 	: String = 'UPDATE_VIEW_COUNTDOWN_FORCE_REMOVE' ;
		//public static const UPDATE_VIEW_BAR_TIMER 				: String = 'updateViewBarTimer';
		//public static const UPDATE_VIEW_BAR_REMOVE 				: String = 'updateViewBarRemove';
		
		public static const UPDATE_MESSAGE_BOX 					: String = 'updateMessageBox' ; 
		public static const UPDATE_VIEW_STATE_TEXT 				: String = 'updateViewStateText';
		
		public static const CLOSE_QUESTIONS 					: String = 'closeQuestions' ; 
		
		public static const UPDATE_PLAY_BUTTON 					: String ='updatePlayButton';
		
		public static const STATE_ACTIVATED 						: String = 'stateActivated' ;
		
		public static const UV_PASS_INIT_OBJECT 					: String = 'uvPassInitObject' ; 
		//public static var DEACTIVATE_BUTTON  					: String = 'deactivateButton' ; 
		public static const FADEOUT	  							: String = 'fadeOut' ;
		public static const SPEED_FADEOUT	  						: String = 'speedFadeOut' ;
		
		//**Sounds
		public static const UPDATE_SOUND 							: String = 'updateSound' ; 
		public static const UPDATE_BUTTON_SOUND 					: String = 'updateButtonSound' ; 
		public static const UPDATE_FX_SOUND 						: String = 'updateFxSound';
		public static const UPDATE_LOOP_SOUND 					: String = 'updateLoopSound' ;
		
		public static const DRAW_VIDEO_STATUS 						: String = 'drawVideoStatus' ;
		
		public static const CLEAR_SOUNDS							: String = 'clearSounds' ; 
		public static const FAST_CLEAR_SOUNDS						: String = 'fastClearSounds' ; 
		 
		public static const SM_ACTIVE								: String = 'SmActive' ;
		public static const SM_NOT_ACTIVE 							: String = 'SmNotActive';
		public static const SM_KILL 								: String = 'smKill' ;
		
		//**STATE MACHINE LISTENER
		public static const INSERT_COIN 							: String = 'insertCoin' ;
		//public static var TRANSITION							: String = 'transition' ; 
		
		public static const VIDEO_OVERLAY_END						: String = 'videoOverlayEnd' ;
		
		public static const ACTIVATE_VIDEO_RUN 						: String = 'activateVideoRun' ;
		public static const DEACTIVATE_VIDEO_RUN 					: String = 'deActivateVideoRun' ;
		
		public static const EXEC_TIMER_SCHEDULER 					: String ='execTimerScheduler';
		
		//**comm with internal UI
		public static const UPDATE_UI 								: String = 'updateUI';
		public static const CREATE_INIT_BUTTON 						: String = 'createInitButton';
		public static const REMOVE_INIT_BUTTON						: String = 'removeInitButton' ; 
		
		public static const CREATE_END_BUTTON						: String = 'createEndButton' ; 
		public static const REMOVE_END_BUTTON						: String = 'removeEndButton' ; 
		
		
		public static const SHOW_FOOTER_PLAY_PAUSE					: String = 'SHOW_FOOTER_PLAY_PAUSE';
		public static const HIDE_FOOTER_PLAY_PAUSE					: String = 'HIDE_FOOTER_PLAY_PAUSE';
		
		//INTERACTION LIST
		public static const CHOICE 									: String = 'choice' ;
		public static const NONE 									: String = 'none' ;
		public static const INIT_BUTTON 							: String = 'initButton' ;
		public static const END_BUTTON 								: String = 'endButton' ;
		public static const BACK_TO_VIDEO_BUTTON 					: String = 'backToVideoButton' ;  
		
		//DEBUG
		public static const UPDATE_DEBUG_PANEL_VIDEO 				: String = 'updateDebugPanelVideo' ;
		public static const UPDATE_DEBUG_PANEL_STATE 				: String = 'updateDebugPanelState' ;
		
		public static const APP_ACTIVATE 							: String = 'APP_ACTIVATE';
		public static const APP_DEACTIVATE 							: String = 'APP_DEACTIVATE';
		
		public static const SET_OVERLAY_SIZE						: String = 'setOverlaySize' ; 
		
		
	}
}

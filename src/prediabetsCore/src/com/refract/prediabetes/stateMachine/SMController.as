package com.refract.prediabetes.stateMachine {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.stateMachine.VO.CoinVO;
	import com.refract.prediabetes.stateMachine.events.BooleanEvent;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.stateMachine.timer.SMTimer;
	import com.refract.prediabetes.video.VideoLoader;
	import com.robot.comm.DispatchManager;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	/**
	 * @author robertocascavilla
	 */
	public class SMController 
	{
		private static var _me : SMController ; 
		protected var _model : SMModel;
		
		private var _videoClickFreeze : Boolean;	
		private var _transitionTimer : SMTimer;
		private var _slowDownTimer : SMTimer;
		
		private var _enterFrameObject : Shape;
		
		private var _activateMessageBox : Boolean ; 
		private var _countDownTimerOn : Boolean ;
		private var _frozen : Boolean;
		private var _wgActivated : Boolean ; 
		private var _wgPrevState : Boolean ; 
		private var _videoFreeze : Boolean;
		
		private var _initObject : Object ;
		
		private var _schedulerMaxTime : int;
		private var _preTrigger : int;
		
		public function SMController()
		{
			_me = this ; 
			init();
		}
		public static function get me() : SMController
		{
			return _me ;
		}
		private function init() : void
		{
			initValues() ;
			
			createEnterFrameLoop();
			createModel();	
			
		}
		
		//***
		public function start(obj:Object) : void
		{ 	
			reset() ;
			createListeners();
			
			SMVars.reset() ;
			DispatchManager.dispatchEvent(new Event ( Flags.UN_FREEZE ) );
		
			_initObject = obj ; 
			_model.init( _initObject.module ) ; 
			
			_model.selectedInteraction= 0 ;
			if( _initObject.selectedState == null)
			{
				_model.selectedState = _model.initState ;  
			}
			else
			{
				_model.selectedState = _initObject.selectedState ; 
			}

			dispatchStartEvents() ; 
			
			if( _initObject.selectedState != null )
			{
				_model.selectedState = _initObject.selectedState ;
				transitionPrevState() ; 
			}
			else
			{
				stateMachineTransition();
			}
			DispatchManager.dispatchEvent( new Event( Flags.UN_FREEZE ) ) ; 

			
		}

		private function dispatchStartEvents() : void
		{
			DispatchManager.dispatchEvent(new ObjectEvent(Flags.STATE_MACHINE_START, _initObject ) ) ;
			DispatchManager.dispatchEvent(new Event(Flags.SHOW_FOOTER_PLAY_PAUSE) ) ;
		}

		
		public function end() : void
		{
			var endObject : Object = new Object() ; 
			
			DispatchManager.dispatchEvent(new Event(Flags.UPDATE_UI) ) ;
			DispatchManager.dispatchEvent(new Event(Flags.HIDE_FOOTER_PLAY_PAUSE) ) ;
			reset() ; 
			
			DispatchManager.dispatchEvent( new ObjectEvent( Flags.STATE_MACHINE_END, endObject ) ) ; 
		}
		
		
		private function reset( evt : Event = null ) : void
		{
			removeTimers() ; 
			//DispatchManager.dispatchEvent( new Event( Flags.FAST_CLEAR_SOUNDS ) ) ; 
			initValues() ; 
			SMVars.reset() ; 
			//removeListeners() ;	
			DispatchManager.dispatchEvent( new Event( Flags.FAST_CLEAR_SOUNDS ) );
			DispatchManager.dispatchEvent( new Event( Flags.DEACTIVATE_VIDEO_RUN ) );
			
		}


		
		private function transitionPrevState() : void
		{
			var prevStateObject : Object = _model.getState( _model.state.prev_state ) ; 
			var interactions : Array = prevStateObject.interactions ; 
			var i : int ; var l : int = interactions.length ; 
			for( i = 0 ; i < l ; i++)
			{
				var interaction : Object = interactions[i] ; 
				
				if( interaction.final_state == _model.selectedState)
				{
					if( interaction.interaction_type !='start_refresh')
					{
						_model.selectedState = _model.state.prev_state ;
						_model.selectedInteraction= i ; 
						stateMachineTransition() ; 
						return ; 
					}
					else
					{
						
						_model.selectedInteraction= 0 ; 
						
						_model.selectedState = _model.state.prev_state ;
						stateMachineTransition() ; 
					}
				}
			}
		}
		
		private function initValues() : void
		{
			_videoFreeze = false ; 
			_activateMessageBox = false ; 
			_wgActivated = false ; 
			_wgPrevState = false ; 
			_countDownTimerOn = false ; 
			
		}
		private function createEnterFrameLoop() : void
		{
			_enterFrameObject = new Shape();
			_enterFrameObject.addEventListener( Event.ENTER_FRAME , loop ) ;
		}
		private function loop( evt : Event ) : void
		{
			DispatchManager.dispatchEvent( new Event( Event.ENTER_FRAME ) ) ; 
		}
		
		public function goNext() : void
		{
			var interaction : Object = _model.interaction ; 
			updateState( interaction.final_state ) ;
		}
		
		private function createModel() : void
		{
			_model = new ClassFactory.SM_MODEL() ; 
		}
		
		private function createListeners() : void
		{	
			DispatchManager.addEventListener(Flags.INSERT_COIN , onInsertCoin);
			//DispatchManager.addEventListener(Flags.UNLOCK_AFTER_INTERACTION , onUnlockAfterInteraction);
			
			DispatchManager.addEventListener(Flags.FREEZE , onFreeze);
			DispatchManager.addEventListener(Flags.UN_FREEZE , onUnFreeze); 
			
			DispatchManager.addEventListener(Flags.NO_STARS , onDie); 
			 
			
			DispatchManager.addEventListener(Flags.SM_RESET , reset); 
			
			DispatchManager.addEventListener(Flags.UPDATE_PLAY_BUTTON, onUpdatePlayButton) ;
			DispatchManager.addEventListener(Flags.SM_KILL, onKill) ;
			
		}
		private function removeListeners() : void
		{	
			DispatchManager.removeEventListener(Flags.INSERT_COIN , onInsertCoin);
			//DispatchManager.removeEventListener(Flags.TRANSITION , onTransition);
			//DispatchManager.removeEventListener(Flags.UNLOCK_AFTER_INTERACTION , onUnlockAfterInteraction);
			
			DispatchManager.removeEventListener(Flags.FREEZE , onFreeze);
			DispatchManager.removeEventListener(Flags.UN_FREEZE , onUnFreeze); 
			
			DispatchManager.removeEventListener(Flags.NO_STARS , onDie);
			
			DispatchManager.removeEventListener(Flags.UPDATE_PLAY_BUTTON, onUpdatePlayButton) ;
			DispatchManager.removeEventListener(Flags.SM_RESET , reset); 
			
			DispatchManager.removeEventListener(Flags.SM_KILL, onKill) ;
			
		}
		
		private function onKill( evt : Event ) : void
		{
			removeTimers() ;
			if( VideoLoader.i.videoAddress != 'intro' ) VideoLoader.i.cancelLoadRequest(VideoLoader.i.videoAddress) ; 
			DispatchManager.dispatchEvent( new Event ( Flags.FAST_CLEAR_SOUNDS ) ) ;  
			DispatchManager.dispatchEvent( new Event( Flags.DEACTIVATE_VIDEO_RUN ) );
			
			DispatchManager.dispatchEvent( new Event( Flags.UPDATE_UI) ) ; 
			DispatchManager.removeEventListener( NetStatusEvent.NET_STATUS,onNetStatus);
			//removeListeners() ; 
		}

		private function onUpdatePlayButton( evt : BooleanEvent ) : void
		{
			if( !evt.value )
			{
				_videoClickFreeze = true ; 
			}
		}
 		private function onFreeze(event : Event ) : void
		{
			if( !_frozen)
			{ 
				if( _transitionTimer ) _transitionTimer.pause() ;
				 
				_enterFrameObject.removeEventListener( Event.ENTER_FRAME , loop ) ;
				
				if( !VideoLoader.i.paused ) 
				{
					_videoFreeze = true ; 
					VideoLoader.i.pauseVideo() ; 
				}
				
				SMVars.me.freezeTime() ; 
				_frozen = true ; 
				
				TweenMax.pauseAll() ;
			}
		}

		private function onUnFreeze(event : Event ) : void 
		{	
			if( _frozen)
			{
				_frozen = false ; 
				//if( _countDownTimer ) _countDownTimer.resume() ; 
				if( _transitionTimer ) _transitionTimer.resume() ; 
				
				_enterFrameObject.addEventListener( Event.ENTER_FRAME , loop ) ;
				
				if( _videoFreeze ) VideoLoader.i.resumeVideo() ; 
				SMVars.me.unFreezeTime() ; 
				
				DispatchManager.dispatchEvent( new Event( Flags.UN_FREEZE_SOUNDS )) ; 
				
				TweenMax.resumeAll() ; 
				
				_videoFreeze = false ; 
				AppSettings.stage.focus = AppSettings.stage ; 
			}
			if( _videoClickFreeze)
			{
				_videoClickFreeze = false ;
				VideoLoader.i.resumeVideo() ; 
			}
		}
		
		private function onDie( evt : Event ) : void
		{ 	
			DispatchManager.dispatchEvent( new Event( Flags.CLEAR_SOUNDS ) ) ; 
			DispatchManager.dispatchEvent( new Event ( Flags.FREEZE_BUTTONS ) ) ; 
		}
		
		private function onInsertCoin( evt : ObjectEvent) : void
		{	
			var coinObj : CoinVO = evt.object as CoinVO; 
			DispatchManager.dispatchEvent( new Event(Flags.CLEAR_SOUNDS )) ;
			switch( coinObj.btName)
			{
				case Flags.NONE : 
				/*
					 if( _model )
					 {
						var interaction : Object = _model.interaction
					 
						var future_address : String = interaction.final_state 
						var l : int = future_address.length ; 
						var l2 : String = future_address.substr( l-2 , l ) ; 
						if( l2 == '_q') 
						{
							_slowDownTimer = new SMTimer( SMSettings.SLOW_DOWN_TIMER_X + interaction.clip_length , 1 ) ; 
							_slowDownTimer.start() ;
							_slowDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onSlowDownComplete );
							_model.interaction.clip_length = SMSettings.SLOW_DOWN_TIMER_X + interaction.clip_length ; 
							_model.interaction.tween = true ;  
						}
						else
						{
							_model.interaction.tween = false ; 
						}
						
						l = address.length ; 
						l2 = address.substr( l-2 , l ) ; 
						if( l2 == '_q')
						{
							
						}
						else 
						{
							 DispatchManager.dispatchEvent( new Event( Flags.DE_ACTIVATE_PROGRESS_BAR ) ) ;
						} 
					 }
					  * 
					  */
					  
					 
					_model.selectedInteraction = 0 ;
					DispatchManager.dispatchEvent(new Event( Flags.DEACTIVATE_VIDEO_RUN ) ) ; 
					
					
					
						
					stateMachineTransition();
				break ;

				default:
					_model.selectedInteraction = int(coinObj.btName);
					var interaction : Object = _model.interaction ; 
					
					removeTimers( ) ; 
						
					_transitionTimer = new SMTimer( SMSettings.RIGHT_ANSWER_TIMER , 1 ) ; 
					_transitionTimer.start() ;
					_transitionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, answerDelayedCompleted );
					
					DispatchManager.dispatchEvent(new Event( Flags.FADEOUT ) ); 
					
					if( coinObj.wrong )
					{
						DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_BUTTON_SOUND , SMSettings.BUTTON_SOUND_WRONG) );
					}
					else
					{		
						DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_BUTTON_SOUND , SMSettings.BUTTON_SOUND_GOOD) ); 
					}
				 	
				break ;
			}
		}

		
		private function answerDelayedCompleted( evt : TimerEvent = null ) : void
		{
			if( _transitionTimer )
			{
				_transitionTimer.stop() ; 
				_transitionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, answerDelayedCompleted );
				_transitionTimer = null ; 
			}
			DispatchManager.dispatchEvent(new Event( Flags.DEACTIVATE_VIDEO_RUN)) ; 
			stateMachineTransition();
		}

		
		private function stateMachineTransition() : void
		{
			removeTimers() ; 
			DispatchManager.dispatchEvent( new Event( Flags.CLEAR_SOUNDS) ) ; 
			var interaction : Object = _model.interaction;
			var videoName : String  = interaction.video_name ; 
			
			activateSlowDownControl() ; 
			
			if( videoName.length > 0)
			{
				DispatchManager.dispatchEvent(new Event(Flags.UPDATE_UI));
				activateTrigger() ; 
				DispatchManager.dispatchEvent( new Event( Flags.DEACTIVATE_VIDEO_RUN ) );
				DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_VIDEO , interaction.video_name));
				
				var prev_state : String = _model.state.prev_state ;
				if( prev_state )
				{
					var i : int = 0 ; 
					var l : int = _model.getState( _model.state.prev_state ).interactions.length ;
					for( i = 0 ; i < l ; i++)
					{
						var prevVideoName : String = _model.getState( _model.state.prev_state ).interactions[i].video_name ;
						VideoLoader.i.cancelLoadRequest( prevVideoName ) ;
					}
				}
				trace('CLIP LENGTH :' , _model.interaction.clip_length ) ; 
				DispatchManager.dispatchEvent( new ObjectEvent ( Flags.ACTIVATE_PROGRESS_BAR , _model.interaction ) ) ; 
			}
			else
			{	 
				createStateMachineTimer() ; 
			}
			
			if( interaction.message_box != null)
			{
				DispatchManager.dispatchEvent(new ObjectEvent(Flags.UPDATE_MESSAGE_BOX, interaction));
			}
			
		}
		
		private function activateSlowDownControl() : void
		{
			var interaction : Object = _model.interaction
			var future_address : String = interaction.final_state 
			var l : int = future_address.length ; 
			var l2 : String = future_address.substr( l-2 , l ) ; 
			if( l2 == '_q') 
			{
				_slowDownTimer = new SMTimer( SMSettings.SLOW_DOWN_TIMER_X + interaction.clip_length , 1 ) ; 
				_slowDownTimer.start() ;
				_slowDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onSlowDownComplete );
				_model.interaction.clip_length = SMSettings.SLOW_DOWN_TIMER_X + interaction.clip_length ; 
				_model.interaction.tween = true ;  
			}
			else
			{
				_model.interaction.tween = false ; 
			}
		}
		
//		private var _tempDelete : Boolean = false ; 
		private function activateTrigger() : void
		{
			var interaction : Object = _model.interaction;
			DispatchManager.removeEventListener( NetStatusEvent.NET_STATUS,onNetStatus);
			_preTrigger = interaction.trigger ;
			var tempTrigger : int = interaction.trigger ;
			
			if( tempTrigger == interaction.clip_length) 
			{
				tempTrigger = -1 ; 
			}
			switch( true )
			{
				case (tempTrigger > 0) : 
					//**launch timer connected with video ( SMVars.me.nsStreamTime ) 
					_schedulerMaxTime = tempTrigger ; 
					DispatchManager.addEventListener( Event.ENTER_FRAME , scheduler) ;
				break ;
					
				case (tempTrigger == 0) : 
					//**launch new state immediately
					updateState( interaction.final_state ) ;
				break ;
					
				case( tempTrigger == -1) :
					//** launch listener for end video
					_schedulerMaxTime = -1 ; 
					DispatchManager.addEventListener( Event.ENTER_FRAME , scheduler) ;
					DispatchManager.addEventListener( NetStatusEvent.NET_STATUS,onNetStatus);
				break;	
			}	
		}
		
		protected function updateState( address : String , cleanUI : Boolean = true) : void
		{	
			trace('XXXXXXX')
			DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ;
			 
			if( address == 'menu')
			{
				return ;
			}

			
			
			if( address == _model.endState)
			{
				end() ; 
				return ; 
			}

			DispatchManager.dispatchEvent( new Event(Flags.CLEAR_SOUNDS  )) ;

			if( cleanUI ) 
				DispatchManager.dispatchEvent(new Event(Flags.UPDATE_UI));
			
			_activateMessageBox = false ; 
			
			_model.selectedState = address ; 
			var stateObject : Object = _model.state;
			
			
			
			
			
			
			
			
			
			
			
			
			 createInteractions( );
			 
			 
			
			
			
			 DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , SMSettings.QUESTIONS_FADE_IN) );			
			 DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_DEBUG_PANEL_STATE, _model.selectedState ));
			
			_wgActivated = false ;
			
			
			
			requestVideos() ; 
			if( stateObject.state_txt.length > 0)
			{
				DispatchManager.dispatchEvent(new ObjectEvent(Flags.UPDATE_VIEW_STATE_TEXT, stateObject));
			}
			
			VideoLoader.i.deactivateClickPause() ; 
			
			
			
			
		}
		
		private function onSlowDownComplete( evt : TimerEvent ) : void
		{
			trace('ON SLOW DOWN COMPLETE> WHAT TO DO')
		}
		private function requestVideos() : void
		{
			var interactions : Array = _model.state.interactions ; 
			var i : int = 0 ; 
			var l : int ;
			l = interactions.length ; 
			var video_name : String;
			for( i = 0 ; i < l ; i ++)
			{
				video_name = interactions[i].video_name ;
				if( video_name.length > 0 && video_name != Flags.WG )
				{
					VideoLoader.i.requestLoad( video_name ) ;
				}
			}
		}

		

		
		private function removeTimer( ) : void
		{
			_countDownTimerOn = false;	
			
			//DispatchManager.dispatchEvent(new Event(Flags.UPDATE_VIEW_BAR_REMOVE ) ) ;
		}
		private function removeTimers() : void
		{
			DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ;
			//DispatchManager.dispatchEvent( new Event( Flags.DE_ACTIVATE_PROGRESS_BAR ) ) ; 
			removeTimer() ; 
			if( _transitionTimer ) 
			{
				_transitionTimer.stop() ; 
				_transitionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleted );
				_transitionTimer = null ;
			}
		}

		

		
		protected function setVideoBack() : void
		{	
			var timerSeek : Number = (_preTrigger-600 ) / 1000 ;
			 
			if( timerSeek < 0) 
				timerSeek = 0 ; 
			
			VideoLoader.i.seek( timerSeek );
		}
		
		//** State Machine Timer ( when no Video is available for timing ) 
		private function createStateMachineTimer() : void
		{	 
			var interaction : Object = _model.interaction;
			_transitionTimer = new SMTimer( interaction.trigger , 1 ) ; 
			
			_transitionTimer.start() ;
			_transitionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleted );
		}
		
		private function timerCompleted(evt : TimerEvent) : void
		{
			_transitionTimer.stop() ;
			_transitionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleted ) ;
			_transitionTimer = null ; 
			updateState( _model.interaction.final_state ) ; 
		}
		
		

		//** video scheduler. timer connected with netStream Time
		protected function scheduler( evt : Event ) : void
		{
			//** launch next event
			if( _schedulerMaxTime >0)
			{
				if( _schedulerMaxTime <= SMVars.me.nsStreamTime)
				{
					DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ; 
					updateState( _model.interaction.final_state ) ; 
				}
			}
			
			//DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_UI_PROGRESS, String(  SMVars.me.nsStreamTime ) ));
		}
		
		//**detect end of video
		protected function onNetStatus(event : NetStatusEvent) : void 
		{
			switch (event.info.code) 
		    { 
		        case "NetStream.Play.Stop": 
					DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ;
					//DispatchManager.dispatchEvent( new Event( Flags.DE_ACTIVATE_PROGRESS_BAR ) ) ; 
		      		DispatchManager.removeEventListener( NetStatusEvent.NET_STATUS,onNetStatus);
					updateState( _model.interaction.final_state) ;
		        break; 
		    } 
		}
		
		private function createInteractions( ) : void
		{
			var stateObject : Object = _model.state;
			DispatchManager.dispatchEvent(new ObjectEvent(Flags.UPDATE_VIEW_INTERACTIONS, stateObject));
		}
		
		public function get model():SMModel
		{
			return _model;
		}		
	}
}

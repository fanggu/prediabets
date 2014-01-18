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
	import flash.display.Sprite;
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
		private var _tooslowTimer : SMTimer;
		private var _tooslowIter : int ; 
		
		private var _enterFrameObject : Shape;
		private var _activateMessageBox : Boolean ; 
		
		private var _frozen : Boolean;
		private var _videoFreeze : Boolean;
		
		private var _schedulerMaxTime : int;
		
		private var _prevTooslowState : String ; 
		private var _prevState : String ; 
		
		private var _totalTooSlowTime : int ; 
		private var _newSlowTime : Number ; 
		
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
			
			if( SMSettings.DEBUG_GET_CLIP_LENGTH )
			{
				
			}
		}
		
		//*DEBUG DURATION
		public function startGetClipLength() : void
		{
			_model.init( ) ;
			var iter : int = 0 ; 
			for( var mc in _model.dictState)
			{
				iter ++ 
				
				var state : Object = _model.dictState[ mc ]  ; 
				
				var interactions : Object = state.interactions ; 
				//_dictStates[address].interactions[iterInteraction] ;
				
				
				for( var i : int = 0 ; i < interactions.length ; i ++ )
				{
					iter ++ ; 
					var interaction : Object = interactions[ i ] ;
					 
					
					var b : Sprite = new Sprite() ; 
					TweenMax.to( b , iter  , { x : 100 , onComplete : launchVideo , onCompleteParams:[ interaction.video_name ]})
				}
				
				
			}
		}
		
		private function launchVideo( nameVideo : String ) : void
		{
				trace('requesting :' , nameVideo)
				VideoLoader.i.update(nameVideo) ;
		}
		 
		 
		 
		 
		 
		//***
		public function start( ) : void
		{ 	
			reset() ;
			createListeners();
			
			SMVars.reset() ;
			DispatchManager.dispatchEvent(new Event ( Flags.UN_FREEZE ) );
		
			_model.init( ) ; 
			
			_model.selectedInteraction= 0 ;
			_model.selectedState = _model.initState ;
			DispatchManager.dispatchEvent( new Event ( Flags.CREATE_INIT_BUTTON ) ) ;
			dispatchStartEvents() ; 
			stateMachineTransition();
			DispatchManager.dispatchEvent( new Event( Flags.UN_FREEZE ) ) ; 
		}

		private function dispatchStartEvents() : void
		{
			DispatchManager.dispatchEvent(new Event(Flags.STATE_MACHINE_START ) ) ;
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
			_tooslowIter = 0 ; 
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
					_model.selectedState = _model.state.prev_state ;
					_model.selectedInteraction= i ; 
					stateMachineTransition() ; 
					return ; 
				}
			}
		}
		
		private function initValues() : void
		{
			_videoFreeze = false ; 
			_activateMessageBox = false ; 
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
			DispatchManager.addEventListener(Flags.FREEZE , onFreeze);
			DispatchManager.addEventListener(Flags.UN_FREEZE , onUnFreeze); 
			DispatchManager.addEventListener(Flags.SM_RESET , reset); 	
			DispatchManager.addEventListener(Flags.UPDATE_PLAY_BUTTON, onUpdatePlayButton) ;
			DispatchManager.addEventListener(Flags.SM_KILL, onKill) ;
			//DispatchManager.addEventListener(Flags.ON_FLV_METADATA , onActivateTooSlowTimer ) ;
			DispatchManager.addEventListener(Flags.ON_BACKWARD , onBackwardState) ;
		}
		private function removeListeners() : void
		{	
			DispatchManager.removeEventListener(Flags.INSERT_COIN , onInsertCoin);			
			DispatchManager.removeEventListener(Flags.FREEZE , onFreeze);
			DispatchManager.removeEventListener(Flags.UN_FREEZE , onUnFreeze); 
			
			DispatchManager.removeEventListener(Flags.UPDATE_PLAY_BUTTON, onUpdatePlayButton) ;
			DispatchManager.removeEventListener(Flags.SM_RESET , reset); 
			DispatchManager.removeEventListener(Flags.SM_KILL, onKill) ;
			//DispatchManager.removeEventListener(Flags.ON_FLV_METADATA , onActivateTooSlowTimer);
			DispatchManager.removeEventListener(Flags.ON_BACKWARD , onBackwardState) ;
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
				if( _tooslowTimer ) _tooslowTimer.pause() ;
				 
				_enterFrameObject.removeEventListener( Event.ENTER_FRAME , loop ) ;
				
				if( !VideoLoader.i.paused ) 
				{
					_videoFreeze = true ; 
					VideoLoader.i.pauseVideo() ; 
				}
				
				SMVars.me.freezeTime() ; 
				_frozen = true ; 
				
				TweenMax.pauseAll( ) ;
			}
		}

		private function onUnFreeze(event : Event ) : void 
		{	
			if( _frozen)
			{
				_frozen = false ; 
				//if( _countDownTimer ) _countDownTimer.resume() ; 
				if( _transitionTimer ) _transitionTimer.resume() ; 
				if( _tooslowTimer ) _tooslowTimer.resume() ; 
				
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
		

		
		private function onInsertCoin( evt : ObjectEvent) : void
		{	
			
			var coinObj : CoinVO = evt.object as CoinVO; 
			DispatchManager.dispatchEvent( new Event(Flags.CLEAR_SOUNDS )) ;
			
			switch( coinObj.btName)
			{
				case Flags.NONE : 					 
					_model.selectedInteraction = 0 ;
					DispatchManager.dispatchEvent(new Event( Flags.DEACTIVATE_VIDEO_RUN ) ) ; 
					stateMachineTransition();
				break ;
				case Flags.INIT_BUTTON : 					 
					updateState(_model.initButtonState ) ; 
					DispatchManager.dispatchEvent( new Event ( Flags.REMOVE_INIT_BUTTON ) ) ; 
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
			trace('onInsertCoin:'  , coinObj.btName)
			trace('onInsertCoin:'  , _model.selectedState)
		}

		
		private function answerDelayedCompleted( evt : TimerEvent = null ) : void
		{
			removeTimers() ; 
			DispatchManager.dispatchEvent(new Event( Flags.DEACTIVATE_VIDEO_RUN)) ; 
			stateMachineTransition();
		}

		
		private function stateMachineTransition() : void
		{
			//trace('STATE MACHINE TRANSITION' , _model.selectedState )
			removeTimers() ; 
			DispatchManager.dispatchEvent( new Event( Flags.CLEAR_SOUNDS) ) ; 
			var interaction : Object = _model.interaction;
			var videoName : String  = interaction.video_name ; 
			
			
			 
			setClipLength() ; 
			
			if( videoName.length > 0)
			{
				DispatchManager.dispatchEvent(new Event(Flags.UPDATE_UI));
				activateTrigger() ; 
				DispatchManager.dispatchEvent( new Event( Flags.DEACTIVATE_VIDEO_RUN ) );
				//DispatchManager.dispatchEvent( new ObjectEvent ( Flags.ACTIVATE_PROGRESS_BAR , _model.interaction ) ) ; 
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
		
		
		
		private function activateTrigger() : void
		{
			var interaction : Object = _model.interaction ;
			DispatchManager.removeEventListener( NetStatusEvent.NET_STATUS,onNetStatus) ;
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
			//trace('UPDATE ADDRESS')
			_newSlowTime = 0 ; 
			DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ;			
			
			if( address == _model.endState)
			{
				end() ; 
				return ; 
			}
			if( address == _model.initButtonState)
			{
				DispatchManager.dispatchEvent( new Event ( Flags.REMOVE_INIT_BUTTON ) ) ; 
			}

			DispatchManager.dispatchEvent( new Event(Flags.CLEAR_SOUNDS  )) ;

			if( cleanUI ) 
				DispatchManager.dispatchEvent(new Event(Flags.UPDATE_UI));

			_activateMessageBox = false ; 
			
			storePrevState() ;  

			_model.selectedState = address ; 
			
			var stateObject : Object = _model.state;

    		controlTooSlowState() ; 
			
			createInteractions( );

			 DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , SMSettings.QUESTIONS_FADE_IN) );			
			 DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_DEBUG_PANEL_STATE, _model.selectedState ));

			requestVideos() ; 
			if( stateObject.state_txt ) if( stateObject.state_txt.length > 0)
			{
				DispatchManager.dispatchEvent(new ObjectEvent(Flags.UPDATE_VIEW_STATE_TEXT, stateObject));
			}
			
			VideoLoader.i.deactivateClickPause() ; 
			
			if( address = _model.initState )
			{
				//DispatchManager.dispatchEvent( new Event ( Flags.CREATE_INIT_BUTTON ) ) ; 
			}
			
		}
		
		//**for backward functionality
		private function storePrevState() : void
		{
			_prevState = _model.selectedState ;
			var i : int = _model.selectedState.indexOf( SMSettings._Q ) ;
			if( i != -1 )
				_prevState = _model.selectedState ; 
		}
		
		
		//**progress bar click. 
		public function progressBarClick( time : Number ) : void
		{
			/*
			var futureState : String = _model.selectedState ; 
			var is_q : Boolean = _model.is_q( futureState ) ; 
			if( is_q || _model.is_pre_q( futureState ) )
			{
				if( is_q ) 
					futureState = _model.state_no_q( futureState ) ; 
				updateState( futureState ) ; 
			}
			else
			{
				VideoLoader.i.seek( time / 1000 ) ; 
			}
			 * 
			 */
			 _newSlowTime = 0 ; 
			 if( !_tooslowTimer )
			 {
				var valueToSeek : Number = time / 1000 ; 
				
				VideoLoader.i.seek( time / 1000 ) ;
			 }
			 else
			 {
				_newSlowTime = time ; //_totalTooSlowTime - time ;
				var slowTimeDiff : Number = _totalTooSlowTime - time ;  
				createTooSlowTimer( slowTimeDiff ) ;  
				
				var valueToSeek : Number = time / 1000 ; 
				
				VideoLoader.i.seek( time / 1000 ) ;
			 }
		}
		
		public function getTooSlowTimerTime() : Number
		{
			if( _tooslowTimer )
			{
				return _tooslowTimer.getTime() + _newSlowTime ;
			}
			else
			{
				return 0;
			}
		}
		
		//**listener for backward funcionality
		private function onBackwardState( evt : Event ) : void
		{
			updateState( _prevState ) ; 
			/*
			var coinObj : CoinVO = evt.object as CoinVO; 
			DispatchManager.dispatchEvent( new Event(Flags.CLEAR_SOUNDS )) ;
			switch( coinObj.btName)
			{
				case Flags.NONE : 					 
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
			
			removeTimers() ; 
			DispatchManager.dispatchEvent(new Event( Flags.DEACTIVATE_VIDEO_RUN)) ; 
			stateMachineTransition();
			 * 
			 */
		}
		//**async call when we get metadata duration from FLV
		private function setClipLength( ) : void //evt : ObjectEvent ) : void
		{
			var clip_length : Number = _model.getVideoLength( _model.interaction.video_name ) ; //Number( evt.object.clip_length ) ;  
			
			activateTooSlowTimer( clip_length  ) ; 
			_model.interaction.clip_length = clip_length ; 
			DispatchManager.dispatchEvent( new ObjectEvent ( Flags.ACTIVATE_PROGRESS_BAR , _model.interaction ) ) ;
		}
		private function activateTooSlowTimer( clip_length : Number ) : void//clip_length : Number ) : void
		{
			var interaction : Object = _model.interaction ; 
			var future_address : String = interaction.final_state ; 
			if( _model.is_q(future_address ) && _model.selectedState != SMSettings.STATE_SLOW ) 
			{
				_prevTooslowState = _model.state.name ;
				createTooSlowTimer( SMSettings.SLOW_TIMER_X + clip_length  ) ; 
				_totalTooSlowTime = SMSettings.SLOW_TIMER_X + clip_length  ; 
				_model.interaction.tween = true ;  
			}
			else
			{
				_model.interaction.tween = false ; 
			}
		}
		private var _testdelete : Number ; 
		private function createTooSlowTimer( totalTime : Number ) : void
		{
			removeTooSlowTimer() ;
			_tooslowTimer = new SMTimer( totalTime , 1) ; 
			_tooslowTimer.start() ;
			_tooslowTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTooSlowTimerComplete );	
		}
		
		
		private function controlTooSlowState() : void
		{
			if( _model.selectedState == SMSettings.STATE_SLOW)
			{
				_prevTooslowState = _model.state_no_q( _prevTooslowState ) ; 
				_model.interaction.final_state = _prevTooslowState ;
				_model.interaction.trigger = -1 ; 
				_model.interaction.clip_length = _model.slowStates[ _tooslowIter][ 1 ] ;  ; 
				_model.interaction.video_name = _model.slowStates[ _tooslowIter][ 0 ] ;  
				_tooslowIter++ ; 
				if( _tooslowIter > _model.slowStates.length-1 )
				{
					_tooslowIter = 0 ; 
				}
			}
			
		}
		private function onTooSlowTimerComplete( evt : TimerEvent ) : void
		{			
			removeTimers() ; 
			updateState( SMSettings.STATE_SLOW ) ; 
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
				if( video_name.length > 0  )
				{
					VideoLoader.i.requestLoad( video_name ) ;
				}
			}
		}

		
		private function removeTimers() : void
		{
			DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ;
			//DispatchManager.dispatchEvent( new Event( Flags.DE_ACTIVATE_PROGRESS_BAR ) ) ; 
			
			if( _transitionTimer ) 
			{
				_transitionTimer.stop() ; 
				_transitionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleted );
				_transitionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, answerDelayedCompleted );
				_transitionTimer = null ;
			}
			removeTooSlowTimer() ; 
		}
		private function removeTooSlowTimer() : void
		{
			if( _tooslowTimer) 
			{
				_tooslowTimer.stop() ; 
				_tooslowTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTooSlowTimerComplete );
				_tooslowTimer = null ;
			}
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

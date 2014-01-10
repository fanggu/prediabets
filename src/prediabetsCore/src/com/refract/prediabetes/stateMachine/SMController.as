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
	import flash.utils.setTimeout;
	/**
	 * @author robertocascavilla
	 */
	public class SMController 
	{
		private static var _me : SMController ; 
		protected var _model : SMModel;
		
		private var _totTimerCount : Number;
		private var _videoClickFreeze : Boolean;
		public function get model():SMModel
		{
			return _model;
		}
		
		//private var _countDownTimer : SMTimer;
		private var _transitionTimer : SMTimer;
		private var _slowTimeTimer : SMTimer;
		private var _delayCounter : SMTimer;
		
		private var _enterFrameObject : Shape;
		
		private var _activateMessageBox : Boolean ; 
		private var _countDownTimerOn : Boolean ;
		private var _frozen : Boolean;
		private var _wgActivated : Boolean ; 
		private var _wgPrevState : Boolean ; 
		private var _videoFreeze : Boolean;
		private var _cprActive : Boolean;
		private var _wrongVideo : Boolean;
		
		private var _initObject : Object ;
		
		
		private var _counterTime : Number;
		private var _initCountDownTimer : Number;
		private var _totCountDownTime : int ;
		private var _schedulerMaxTime : int;
		private var _preTrigger : int;
		
		private var _retainVideo : String;
		private var _death : Boolean;
		
		private var _answerCounter : int ; 
		private var _flashWhite : Boolean = false ; 
		
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
			
			//DispatchManager.dispatchEvent(new Event ( Flags.UNFREEZE_BUTTONS ) );
			DispatchManager.dispatchEvent(new Event ( Flags.UN_FREEZE ) );
		
			_initObject = obj ; 
			_death = false ; 
			_model.init( _initObject.module ) ; 
			
			//_model.selectedState = _initObject.selectedState == null ?  _model.initState : _initObject.selectedState;
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
				setTimeout(delayAddStar, 100 ) ; 
			}
			else
			{
				stateMachineTransition();
				SMScore.reset() ; 
			}
			DispatchManager.dispatchEvent( new Event( Flags.UN_FREEZE ) ) ; 

			
		}
		private function delayAddStar() : void
		{
			SMScore.me.addStarOnSceneSelect( );
		}
		
	
		private function dispatchStartEvents() : void
		{
			DispatchManager.dispatchEvent(new ObjectEvent(Flags.STATE_MACHINE_START, _initObject ) ) ;
			DispatchManager.dispatchEvent(new Event(Flags.SHOW_FOOTER_PLAY_PAUSE) ) ;
		}
		private function goState( address : String ) : void
		{
			_model.selectedState = address ;
			transitionPrevState() ;
		}
		
		public function end() : void
		{
			var endObject : Object = new Object() ; 
			//endObject.correctAnswers = 57 ;
			//endObject.totalQuestions = _model.totQuestions ; 
			endObject.cprAccuracy = SMVars.me.qp_accuracy ; 
			//endObject.speedAnswers = SMScore.me.averageSpeed ; 
			
			DispatchManager.dispatchEvent(new Event(Flags.UPDATE_UI) ) ;
			DispatchManager.dispatchEvent(new Event(Flags.HIDE_FOOTER_PLAY_PAUSE) ) ;
			reset() ; 
			

			DispatchManager.dispatchEvent( new ObjectEvent( Flags.STATE_MACHINE_END, endObject ) ) ; 
		}
		
		public function questionSelected( id : int ) : void
		{ 
			if( VideoLoader.i ) VideoLoader.i.resetURL() ;
			createListeners();
			var nextStoryState : String = model.sceneSelect[ id ];
			
			//DispatchManager.dispatchEvent(new ObjectEvent(Flags.STATE_MACHINE_START, _initObject ) ) ;
			DispatchManager.dispatchEvent( new Event( Flags.UN_FREEZE ) ) ; 
			
			DispatchManager.dispatchEvent( new Event( Flags.SM_ACTIVE ) ) ; 
			_model.selectedState = nextStoryState ; 
			_model.selectedInteraction = 0 ; 
			stateMachineTransition() ; 
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
		private function goResuscitate() : void
		{
			/*
			var scoreObj : Object = new Object() ; 
			scoreObj.totChoices = 0 ; 
			scoreObj.totCorrectChoices = 0 ; 
			scoreObj.addStar = 2 ; 
			scoreObj.valueTotal = 0 ; 
			scoreObj.avgSpeed = 0 ; 
			DispatchManager.dispatchEvent( new ObjectEvent( Flags.UPDATE_SCORE, scoreObj )) ;
			 * 
			 */
			DispatchManager.dispatchEvent( new Event( Flags.DEACTIVATE_VIDEO_RUN ) );
			DispatchManager.dispatchEvent( new Event ( Flags.UNFREEZE_BUTTONS ) ) ; 
			//SMScore.me.updateResuscitation();
			VideoLoader.i.pauseVideo();
			
			
			reset() ;
			onKill( null ) ; 
			//start( _initObject ) ; 
			//transitionPrevState() ; 
			setTimeout( lateStart , 100 );
		}
		
		private function lateStart() : void
		{
			_initObject.selectedState = _model.selectedState ; 
			start( _initObject ) ;
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
			
			_answerCounter = 0 ; 
		}
		private function createEnterFrameLoop() : void
		{
			_enterFrameObject = new Shape();
			_enterFrameObject.addEventListener( Event.ENTER_FRAME , loop ) ;
		}
		private function loop( evt : Event ) : void
		{
			DispatchManager.dispatchEvent( new Event( Event.ENTER_FRAME ) ) ; 
			if( _countDownTimerOn )
			{
				updateCountDownTimer() ; 
			}
		}
		
		private function createModel() : void
		{
			_model = new ClassFactory.SM_MODEL() ; 
		}
		
		private function createListeners() : void
		{	
			DispatchManager.addEventListener(Flags.INSERT_COIN , onInsertCoin);
			//DispatchManager.addEventListener(Flags.TRANSITION , onTransition);
			DispatchManager.addEventListener(Flags.UNLOCK_AFTER_INTERACTION , onUnlockAfterInteraction);
			
			//DispatchManager.addEventListener(Flags.DEACTIVATE_BUTTON , onDeActivateButton);
			
			DispatchManager.addEventListener(Flags.FREEZE , onFreeze);
			DispatchManager.addEventListener(Flags.UN_FREEZE , onUnFreeze); 
			
			DispatchManager.addEventListener(Flags.NO_STARS , onDie); 
			
			DispatchManager.addEventListener(Flags.CPR_SLOW_TIME , callCPRSlowTime); 
			DispatchManager.addEventListener(Flags.DEACTIVATE_BUTTON , onDeactivateButton); 
			
			DispatchManager.addEventListener(Flags.SM_RESET , reset); 
			
			DispatchManager.addEventListener(Flags.UPDATE_PLAY_BUTTON, onUpdatePlayButton) ;
			DispatchManager.addEventListener(Flags.SM_KILL, onKill) ;
			
		}
		private function removeListeners() : void
		{	
			DispatchManager.removeEventListener(Flags.INSERT_COIN , onInsertCoin);
			//DispatchManager.removeEventListener(Flags.TRANSITION , onTransition);
			DispatchManager.removeEventListener(Flags.UNLOCK_AFTER_INTERACTION , onUnlockAfterInteraction);
			
			DispatchManager.removeEventListener(Flags.FREEZE , onFreeze);
			DispatchManager.removeEventListener(Flags.UN_FREEZE , onUnFreeze); 
			
			DispatchManager.removeEventListener(Flags.NO_STARS , onDie);
			DispatchManager.removeEventListener(Flags.CPR_SLOW_TIME , callCPRSlowTime);
			DispatchManager.removeEventListener(Flags.DEACTIVATE_BUTTON , onDeactivateButton); 
			
			DispatchManager.removeEventListener(Flags.UPDATE_PLAY_BUTTON, onUpdatePlayButton) ;
			DispatchManager.removeEventListener(Flags.SM_RESET , reset); 
			
			DispatchManager.removeEventListener(Flags.SM_KILL, onKill) ;
			
		}
		
		private function onKill( evt : Event ) : void
		{
			removeTimers() ;
			//trace("kill video address :" , VideoLoader.i.videoAddress)
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
				if( _slowTimeTimer ) _slowTimeTimer.pause() ; 
				if( _delayCounter ) _delayCounter.pause() ; 
				 
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
				if( _slowTimeTimer ) _slowTimeTimer.resume() ; 
				if( _delayCounter ) _delayCounter.resume() ; 
				
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
			_death = true ; 
			
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
				
					_model.selectedInteraction = 0 ;
					DispatchManager.dispatchEvent(new Event( Flags.DEACTIVATE_VIDEO_RUN ) ) ; 
					stateMachineTransition();
					
				break ;
				
				case Flags.CPR  :
					removeTimers() ; 
					
					
					DispatchManager.dispatchEvent( new Event( Flags.DEACTIVATE_VIDEO_RUN ) );
					DispatchManager.dispatchEvent( new Event( Flags.SPEED_FADEOUT ) );
					DispatchManager.dispatchEvent( new Event(Flags.FAST_CLEAR_SOUNDS )) ; 
					DispatchManager.dispatchEvent(new Event(Flags.UPDATE_VIEW_COUNTDOWN_STOP_WHITE));
					
				
				break ;
				
				default:
					 _model.selectedInteraction = int(coinObj.btName);
					 if(  _model.selectedModule != 6) 
					 {
						//SMScore.me.addTotSpeed( _counterTime );
					 	
						if( SMVars.me.tempTotChoice > 1 )
					 	{
							SMScore.me.insertCoin( coinObj) ;
						}
						else
						{
							SMScore.me.pSendScore() ;
						}
					 }
					 var interaction : Object = _model.interaction ; 
					 if( interaction.video_name == Flags.WG )
					 {
						DispatchManager.dispatchEvent( new Event(Flags.CLEAR_SOUNDS )) ;
						_answerCounter = 0 ; 
						removeTimers( ) ; 
						callWG() ;
						DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_BUTTON_SOUND , SMSettings.BUTTON_SOUND_WRONG) ); 
						DispatchManager.dispatchEvent(new Event(Flags.UPDATE_VIEW_COUNTDOWN_STOP_WHITE));
					 }
					 else
					 {
						if( coinObj.wrong )
						{
							_answerCounter = 0 ; 
							removeTimers( ) ; 
							
							_wrongVideo = true ; 
							_retainVideo = VideoLoader.i.videoAddress ; 
							
							//VideoLoader.i.stopVideo() ; 
							//VideoLoader.i.cancelLoadRequest( _retainVideo ) ;
							//VideoLoader.i.pauseVideo() ;
							_model.selectedInteraction = int(coinObj.btName);	
							
							DispatchManager.dispatchEvent(new Event( Flags.DEACTIVATE_VIDEO_RUN) );
							
							DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_VIDEO, interaction.video_name));
							DispatchManager.dispatchEvent(new Event( Flags.FADEOUT) ); 
							
							
							activateTrigger();

							DispatchManager.dispatchEvent( new Event(Flags.CLEAR_SOUNDS )) ; 
							DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_BUTTON_SOUND , SMSettings.BUTTON_SOUND_WRONG) );
							
							if( interaction.message_box != null)
							{
								DispatchManager.dispatchEvent(new ObjectEvent(Flags.UPDATE_MESSAGE_BOX, interaction));
							} 
						}
						else
						{
							_wrongVideo = false ; 
							_retainVideo = null ; 
							removeTimers( ) ; 
							_answerCounter ++;
							SMScore.me.addTotSpeed( _counterTime );
							if( !coinObj.oneShot )
							{
								_transitionTimer = new SMTimer( SMSettings.RIGHT_ANSWER_TIMER , 1 ) ; 
								_transitionTimer.start() ;
								_transitionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, rightAnswerCompleted );
							}
							else
							{
								rightAnswerCompleted( ) ; 
							}
							DispatchManager.dispatchEvent(new Event( Flags.FADEOUT) ); 
							if( SMVars.me.tempTotChoice > 1)
							{
								var successString : String = SMSettings.SCORE_OK ; 
								/*
								if (_answerCounter == 1)
								{
									successString = SMSettings.SCORE_TRY_HARDER;
								}
								else if (_answerCounter == 2)
								{
									successString = SMSettings.SCORE_NOT_GREAT;
								}
								else if (_answerCounter == 3)
								{
									successString = SMSettings.SCORE_OK;
								}
								else if (_answerCounter == 4)
								{
									successString = SMSettings.SCORE_VERY_GOOD;
								}
								else if (_answerCounter >= 5)
								{
									successString = SMSettings.SCORE_EXCELLENT;
								}
								 * 
								 */
								 if (_answerCounter == 1)
								{
									successString = SMSettings.OK;
								}
								else if (_answerCounter == 2)
								{
									successString = SMSettings.GOOD;
								}
								else if (_answerCounter == 3)
								{
									successString = SMSettings.SCORE_EXCELLENT ;
								}
								_answerCounter = 0 ; 
								DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_VIEW_COUNTDOWN_TEXT , successString ) ) ;
							}
							DispatchManager.dispatchEvent( new Event(Flags.CLEAR_SOUNDS )) ; 
							DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_BUTTON_SOUND , SMSettings.BUTTON_SOUND_GOOD) ); 
							DispatchManager.dispatchEvent(new Event(Flags.UPDATE_VIEW_COUNTDOWN_STOP_WHITE));
						}
				 	}
				break ;
			}
		}
		
		private function onDeactivateButton( evt : StateEvent ) : void
		{
			var btName : String = evt.stringParam ; 
			
			var stateObject : Object = _model.state ;
			var interaction : Object = _model.getInteraction( _model.selectedState, int(btName) ) ; 
			interaction.deactivate = true ; 
			_model.setState( stateObject , _model.selectedState ) ; 
		}
		
		
		
		private function rightAnswerCompleted( evt : TimerEvent = null ) : void
		{
			if( _transitionTimer )
			{
				_transitionTimer.stop() ; 
				_transitionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, rightAnswerCompleted );
				_transitionTimer = null ; 
			}
			DispatchManager.dispatchEvent(new Event( Flags.DEACTIVATE_VIDEO_RUN)) ; 
			stateMachineTransition();
		}
		private function onUnlockAfterInteraction( evt : StateEvent = null ) : void
		{
			_model.selectedInteraction = int(evt.stringParam); 
			//removeChoiceTimer() ; 
			removeTimers() ;
			updateState( _model.interaction.final_state ) ;
		}
		
		private function stateMachineTransition() : void
		{
			
			removeTimers() ; 
			DispatchManager.dispatchEvent( new Event( Flags.CLEAR_SOUNDS) ) ; 
			var interaction : Object = _model.interaction;
			var videoName : String  = interaction.video_name ; 
			//Logger.log(Logger.STATE_MACHINE,videoName);
			if( videoName == Flags.WG) 
			{ 
				_wgActivated = true ; 
				callSlowTime(  ) ; 
				return ; 
			}
			

			//if( interaction.message_box != null )
				//_activateMessageBox = true ; 
			
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
//		private var _tempDelete : Boolean = false ; 
		private function activateTrigger() : void
		{
			var interaction : Object = _model.interaction;
			DispatchManager.removeEventListener( NetStatusEvent.NET_STATUS,onNetStatus);
			if( !_wrongVideo ) 
			{
				_preTrigger = interaction.trigger ; 
			}
			else
			{
				//_preTrigger = interaction.trigger ;
			}
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
		{	if( address == 'dont_know')
				trace('YEAH')
			DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ;
			if( address == 'menu')
			{
				 
				return ;
			}
			if( address != _model.selectedState )
			{
				_wrongVideo = false ;
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

			var prevFinalState : String = _model.selectedState ; 
			var interaction : Object = _model.getInteraction( _model.selectedState , _model.selectedInteraction ) ; 
			
			var interactionCheckCPR : Object = _model.getInteraction( _model.selectedState , 0 ) ; 
			if( interactionCheckCPR)
			{
				if
				( 
					interactionCheckCPR.interaction_type == Flags.CPR
					|| interactionCheckCPR.interaction_type == Flags.CPR_LINEAR
					|| interactionCheckCPR.interaction_type == Flags.CPR_LONG
					|| interactionCheckCPR.interaction_type == Flags.ONESHOT
				)
				{
					if( !SMVars.me.accelerometerAble ) 
						SMVars.me.QP_PRE_RUN = true ; 
				}
			
			}
			
			
			_model.selectedState = address 
			/*; 
			if( _model.sceneSelect.indexOf(address) != -1)	
			{
				//DispatchManager.dispatchEvent( new StateEvent( Flags.STATE_ACTIVATED , address ) ) ;	
				_model.stateActivate( address ) ; 
			}
			 * 
			 */
			
	
			var stateObject : Object = _model.state;
			if( _model.greyStates.indexOf(_model.selectedState) != -1)
			{
				stateObject.state_txt_grey = true ; 
			}
			
				
			
			
			if( stateObject.timer )
				if( int(stateObject.timer) > 0 )
					if( _model.selectedModule != 6)
						createTimer( stateObject.timer);	
					
			 createInteractions( );
			 DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , SMSettings.QUESTIONS_FADE_IN) );			
			 DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_DEBUG_PANEL_STATE, _model.selectedState ));

			var progress : int = _model.progress ;
			if( progress > 0)
				DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_UI_PROGRESS, String(  progress) ));
			
			_wgActivated = false ; 
			
			requestVideos() ; 
			if( stateObject.state_txt.length > 0)
			{
				DispatchManager.dispatchEvent(new ObjectEvent(Flags.UPDATE_VIEW_STATE_TEXT, stateObject));
			}
			
			VideoLoader.i.deactivateClickPause() ; 
			
			SMScore.me.updateState(stateObject);
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
			
			/*
			//trace('_model.state.prevState ' , _model.state.prev_state)		
			if( _model.getState( _model.state.prev_state ))
			{
				var prevInteractions : Array = _model.getState( _model.state.prev_state ).interactions ;
				i = 0 ; 
				l = interactions.length ; 
				for( i = 0 ; i < l ; i ++)
				{
					video_name  = interactions[i].video_name ;
					if( video_name.length > 0 && video_name != Flags.WG )
					{
						//trace('cancel video name ' , video_name)
						VideoLoader.i.cancelLoadRequest( video_name ) ;
					}
				}
			}
			 * 
			 */
		}
		
		private function createTimer( totTimerCount : int) : void
		{
			/*
			_flashWhite = false ;
			_initCountDownTimer = SMVars.me.getSMTimer() ; 
			_totCountDownTime = totTimerCount*1000;
			_totTimerCount = totTimerCount ;
			
			createCountDownTimer() ; 
			
			_delayCounter= new SMTimer( (SMSettings.SHOW_DELAY*SMSettings.COUNTER_START_DELAY )*1000 , 1 ) ; 
			_delayCounter.start() ;
			_delayCounter.addEventListener(TimerEvent.TIMER_COMPLETE, createTimerDelay );
			 * 
			 */
		}
		
		private function createTimerDelay( evt : TimerEvent) : void
		{	
			if( _delayCounter )
			{
				_delayCounter.stop() ; 
				_delayCounter.removeEventListener(TimerEvent.TIMER_COMPLETE, createTimerDelay );
				_delayCounter = null ; 
				_initCountDownTimer = SMVars.me.getSMTimer() ;
				DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_BAR_TIMER, String( _totTimerCount) ) ) ;
				
				_countDownTimerOn = true ;
				
				DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_LOOP_SOUND , SMSettings.TIMER_LOOP) );
			}
			
		}
		
		private function removeTimer( ) : void
		{
			_countDownTimerOn = false;	
			
			DispatchManager.dispatchEvent(new Event(Flags.UPDATE_VIEW_BAR_REMOVE ) ) ;
		}
		private function removeTimers() : void
		{
			DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ;
			removeTimer() ; 
			if( _slowTimeTimer)
			{
				_slowTimeTimer.stop() ;
				_slowTimeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleted ) ;
				_slowTimeTimer = null ; 
				DispatchManager.dispatchEvent(new Event(Flags.UPDATE_REMOVE_RED_FILTER )) ;
			}
			if( _transitionTimer ) 
			{
				_transitionTimer.stop() ; 
				_transitionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleted );
				_transitionTimer = null ;
			}
			if( _delayCounter ) 
			{
				_delayCounter.stop() ; 
				_delayCounter.removeEventListener(TimerEvent.TIMER_COMPLETE, createTimerDelay );
				_delayCounter = null ;
			}
		}
		private function createCountDownTimer( evt : Event = null) : void
		{
			_counterTime = 0 ; 
			var valueReverse : Number = _totCountDownTime ;
			var value : String = createCountDownString( valueReverse) ;
			DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_COUNTDOWN_TIMER, value));
			
	
		}
		private function updateCountDownTimer( evt : Event = null) : void
		{
			_counterTime = SMVars.me.getSMTimer() - _initCountDownTimer ; 
		
			var valueReverse : Number = _totCountDownTime - _counterTime  ;
			var value : String = createCountDownString(valueReverse) ; 
			if( valueReverse <= 0)
			{
				countDownComplete();
			}
			else
			{
				DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_COUNTDOWN_TIMER, value));
			}
			
			if( valueReverse <= 2000 && !_flashWhite)
			{
				_flashWhite = true ; 
				DispatchManager.dispatchEvent(new Event(Flags.UPDATE_VIEW_COUNTDOWN_TIMER_WHITE));
			}
			//else
				//DispatchManager.dispatchEvent(new Event(Flags.UPDATE_VIEW_COUNTDOWN_STOP_WHITE));
				
			
		}
		private function createCountDownString( valueReverse : Number ) : String
		{
			var firstValue : Number = Math.floor(valueReverse/1000) ;
			var firstValueString : String= String( firstValue ); 
			if( firstValue <10) 
			{
				firstValueString = '0' + firstValue ;
			}
			var secondValue : Number = valueReverse%1000 ; 
			var secondValueString : String = String( secondValue ).substr(0,2) ;
			if( secondValueString.length < 2)
			{
				secondValueString =  secondValueString + '0' ; 
			}
			var value : String = firstValueString + ":" + secondValueString ;
			return value ; 
		}
		
		private function countDownComplete() : void
		{
			removeTimer() ;
			callSlowTime( ) ; 
		}
		
		private function callCPRSlowTime( evt : Event) : void
		{
			_cprActive = true ; 
			callSlowTime() ; 
		}
		private function callSlowTime( ) : void
		{
			_answerCounter = 0 ; 
			DispatchManager.dispatchEvent( new Event( Flags.CLEAR_SOUNDS));
			DispatchManager.dispatchEvent(new Event(Flags.UPDATE_RED_FILTER )) ;
			
			DispatchManager.dispatchEvent(new Event(Flags.UPDATE_VIEW_COUNTDOWN_STOP_WHITE));
			
			_slowTimeTimer = new SMTimer( SMSettings.TIME_SLOWTIME_DELAY , 1 ) ; 
			_slowTimeTimer.start() ;
			_slowTimeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, slowTimerCompleted );
			
			if( SMVars.me.tooSlowCounter == 0)
			{
				var voiceOverAddress : String = SMSettings.WTS_VOICE_OVER ; 
				var rn : int = Math.random()*12 + 1 ; 
				voiceOverAddress = voiceOverAddress + String(rn);
				DispatchManager.dispatchEvent( new StateEvent(Flags.UPDATE_SOUND , voiceOverAddress )) ; 
			}
			
			SMVars.me.tooSlowCounter++ ;
			
			
			SMScore.me.addTotSpeed( _counterTime );
			
			SMScore.me.updateSlowTime() ; 
			//setTimeout( testOnDie, 2);
			DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_COUNTDOWN_TEXT , SMSettings.T_TOO_SLOW));
			
			//trace(' slow time. W interaction : ' , interaction.)
			var interactionCheckCPR : Object = _model.getInteraction( _model.selectedState , 0 ) ; 
			switch( interactionCheckCPR.interaction_type )
			{
				case Flags.ONESHOT :
					SMVars.me.accelerometerAble = false ;
				break ;
				case Flags.CPR_LINEAR :
					SMVars.me.accelerometerAble = false ;
				break ;
				case Flags.CPR_LONG :
					SMVars.me.accelerometerAble = false ;
				break ; 
				default :
				
			}
			/*
			if( interactionCheckCPR)
			{
				Logger.log(Logger.STATE_MACHINE," SLOW TIME interactionCheckCPR.interaction_type :" , interactionCheckCPR.interaction_type );
				if
				(
				 	interactionCheckCPR.interaction_type == Flags.ONESHOT
				)
				{
					SMVars.me.accelerometerAble = false ; 
				}
				
				
//				if
//				( 
//					interactionCheckCPR.interaction_type == Flags.CPR
//					|| interactionCheckCPR.interaction_type == Flags.CPR_LINEAR
//					|| interactionCheckCPR.interaction_type == Flags.CPR_LONG
//					|| interactionCheckCPR.interaction_type == Flags.ONESHOT
//				)
//				{
//					trace('setting qp pre run TRUE ' , SMVars.me.accelerometerAble)
//					if( !SMVars.me.accelerometerAble ) 
//						SMVars.me.QP_PRE_RUN = true ; 
//				}
			
			}
			 * 
			 */
			
		}
		private function testOnDie() : void
		{
			DispatchManager.dispatchEvent( new Event( Flags.NO_STARS ) ) ; 
		}
		private function callWG( ) : void
		{
			removeTimer( ) ; 
			DispatchManager.dispatchEvent(new Event(Flags.UPDATE_RED_FILTER )) ;
			
			DispatchManager.dispatchEvent(new Event(Flags.UPDATE_VIEW_COUNTDOWN_STOP_WHITE));
			
			_slowTimeTimer = new SMTimer( SMSettings.TIME_SLOWTIME_DELAY , 1 ) ; 
			_slowTimeTimer.start() ;
			_slowTimeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, slowTimerCompleted );
			
			if(SMVars.me.tryAgainCounter == 0 )
			{
				var voiceOverAddress : String = SMSettings.WG_VOICE_OVER; 
				var rn : int = Math.random()*12 + 1 ; 
				voiceOverAddress = voiceOverAddress + String(rn);
				DispatchManager.dispatchEvent( new StateEvent(Flags.UPDATE_SOUND , voiceOverAddress )) ; 
			}
			SMVars.me.tryAgainCounter++ ;
			
			DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_COUNTDOWN_TEXT, SMSettings.T_TRY_AGAIN));
		}
		
		
		
		private function callRetainVideo( ) : void
		{
			DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_VIDEO, _retainVideo));
			VideoLoader.i.pauseVideo() ;
			setVideoBack() ;
		}
		private function slowTimerCompleted( evt : TimerEvent = null ) : void
		{
			
			
			if(_slowTimeTimer)
			{
				_slowTimeTimer.stop() ;
				_slowTimeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleted ) ;
				_slowTimeTimer = null ; 
			}
			if( !_death)
			{
				DispatchManager.dispatchEvent(new Event(Flags.UPDATE_REMOVE_RED_FILTER )) ;
				
				var stateObject : Object = _model.state ; 
				createTimer( stateObject.timer ) ; 
				
				if( !_cprActive )
				{	
					if( !SMVars.me.QP_PRE_RUN)
					{
					
						if( _wrongVideo)
						{
							//VideoLoader.i.pauseVideo() ;
							
							//setTimeout(setVideoBack, 50) ;
							DispatchManager.dispatchEvent( new Event(Flags.UPDATE_CUT_BLACK_LONG ) )  ; 
							
							//VideoLoader.i.stopVideo() ; 
							//DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_VIDEO, _retainVideo));
							//setVideoBack() ;
							//callRetainVideo() ; 
							setTimeout(callRetainVideo , 270 ) ; 
							//setTimeout(setVideoBack , 280 ) ; 
						}
						else
						{
							setTimeout(setVideoBack, 250) ;
							DispatchManager.dispatchEvent( new Event(Flags.UPDATE_CUT_BLACK) )  ; 
						}
						
					}
					else
					{
						updateState( _model.selectedState , true ) ; 
						_cprActive = false ; 
					}
				}
				else
				{
					updateState( _model.selectedState , true ) ; 
					_cprActive = false ; 
				}
			}
			else
			{
				//SMScore.me.addStarAfterDie();
				DispatchManager.dispatchEvent( new Event( Flags.UPDATE_UI ) ) ; 
				DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_VIDEO, _model.deathVideo));

				DispatchManager.dispatchEvent( new Event ( Flags.FAST_CLEAR_SOUNDS ) ) ;  
				DispatchManager.dispatchEvent( new Event( Flags.DEACTIVATE_VIDEO_RUN ) );
			
				DispatchManager.addEventListener( NetStatusEvent.NET_STATUS,onNetStatus);
				
				var interaction : Object = new Object() ;
				interaction.interaction_meta ='' ;
				interaction.message_box = _model.death_message_box ;
				if( interaction.message_box != null)
				{
					DispatchManager.dispatchEvent(new ObjectEvent(Flags.UPDATE_MESSAGE_BOX, interaction));
				}
				//SMScore.reset() ;
				
				
			}
		}

		
		protected function setVideoBack() : void
		{
			_wrongVideo = false ; 
			
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
			
			
			/*
			//** create message box, if there is one
			if( _activateMessageBox)
			{
				if( _model.getMBoxTriggerEvent() <= SMVars.me.nsStreamTime)
				{
					_activateMessageBox = false ; 
					_timerRemoveMessageBox = SMVars.me.nsStreamTime + _model.interaction.mbox_duration ;
					var messageBox : String = _model.interaction.message_box ; 
					var loadVarsIndexOf : int = _model.interaction.interaction_meta.indexOf('load_vars') ; 
					if( loadVarsIndexOf >= 0)
					{
						var pattern:RegExp = /-?[A-Z]+/g;
						var arr : Array = _model.interaction.interaction_meta.match(pattern);
						var i : int = 0 ; 
						var l : int = arr.length ; 
						var tempRegExp : RegExp ; 
						var tempString : String ; 
						
						for( i = 0 ; i < l ; i++)
						{
							tempString = '{' + arr[i] + '}' ; 
							tempRegExp =  new RegExp(tempString);
							
							switch( arr[i])
							{
								case 'XX' : 
									messageBox = messageBox.replace( tempRegExp , String( SMVars.me.qp_counter )) ; 
								break ;
								case 'YY' :
									messageBox = messageBox.replace( tempRegExp , String( SMVars.me.qp_timer )) ;
								break ; 
								case 'ZZ' : 
									messageBox = messageBox.replace( tempRegExp , String( SMVars.me.latest_accuracy )) ;
								break ;
								case 'DATE' :
									messageBox ='' ; 
								break ;
							}
						}
						
						DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_MESSAGE, messageBox));
					}
				}
			}
			else
			{
				_timerRemoveMessageBox = -1 ; 
			}
			if( _timerRemoveMessageBox > 0)
			{
				if( _timerRemoveMessageBox < SMVars.me.nsStreamTime)
				{
					DispatchManager.dispatchEvent(new Event(Flags.REMOVE_VIEW_MESSAGE ));
				}
			}
			 * 
			 */
		}
		
		//**detect end of video
		protected function onNetStatus(event : NetStatusEvent) : void 
		{
			switch (event.info.code) 
		    { 
		        case "NetStream.Play.Stop": 
					if( !_death)
					{
						//Logger.log(Logger.STATE_MACHINE,'END VIDEO ?');
						DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ;
		      			DispatchManager.removeEventListener( NetStatusEvent.NET_STATUS,onNetStatus);
						updateState( _model.interaction.final_state) ;
						
					}
					else
					{
						_death = false ; 
						
						DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ;
						goResuscitate() ; 
						
					}
		        break; 
		    } 
		}
		
		private function createInteractions( ) : void
		{
			var stateObject : Object = _model.state;
			DispatchManager.dispatchEvent(new ObjectEvent(Flags.UPDATE_VIEW_INTERACTIONS, stateObject));
		}		
	}
}

package com.refract.prediabetes.stateMachine {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.nav.events.FooterEvent;
	import com.refract.prediabetes.stateMachine.VO.CoinVO;
	import com.refract.prediabetes.stateMachine.VO.HistoryVO;
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
		private var _prevStateAddress : String ; 
		
		private var _totalTooSlowTime : int ; 
		private var _newSlowTime : Number ; 
		
		private var _bulkLoader : BulkLoader ;
		private var _url : String;
		
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
			setBulkLoader() ; 
			initValues() ;

			createEnterFrameLoop();
			createModel();
			
		}

		//*START
		public function start( ) : void
		{ 	
			createListeners();	
			SMVars.reset() ;

			
			
			dispatchStartEvents() ; 
			stateMachineTransition();
			
			DispatchManager.dispatchEvent( new Event( Flags.UN_FREEZE ) ) ; 
			
			//**manual load of the first videos, ( #on json load_init_request: ) 
			for( var i : int = 0 ; i < _model.arrLoadInitRequest.length ; i ++ )
			{
				var videoName : String = _model.arrLoadInitRequest[ i ] ; 
				VideoLoader.i.requestLoad( videoName ); 
			}
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
			DispatchManager.dispatchEvent( new ObjectEvent( Flags.STATE_MACHINE_END, endObject ) ) ; 
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
			_model.init( ) ; 
			_model.selectedInteraction= 0 ;		
			_model.selectedState = _model.startState ; 
		}
		
		private function createListeners() : void
		{	
			DispatchManager.addEventListener(Flags.INSERT_COIN , onInsertCoin);
			DispatchManager.addEventListener(Flags.FREEZE , onFreeze);
			DispatchManager.addEventListener(Flags.UN_FREEZE , onUnFreeze); 
			DispatchManager.addEventListener(Flags.UPDATE_PLAY_BUTTON, onUpdatePlayButton) ;
			DispatchManager.addEventListener(Flags.ON_BACKWARD , onBackwardState) ;
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
				if( _transitionTimer ) 
					_transitionTimer.pause() ;
				if( _tooslowTimer ) 
					_tooslowTimer.pause() ; 
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
				if( _transitionTimer ) 
					_transitionTimer.resume() ; 
				if( _tooslowTimer ) 
					_tooslowTimer.resume() ; 
				_enterFrameObject.addEventListener( Event.ENTER_FRAME , loop ) ;
				if( _videoFreeze ) 
					VideoLoader.i.resumeVideo() ; 
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
		
		//**Activate State Machine.
		private function onInsertCoin( evt : ObjectEvent) : void
		{	
			VideoLoader.i.pauseVideo() ; 
			var coinObj : CoinVO = evt.object as CoinVO; 
			DispatchManager.dispatchEvent( new Event(Flags.CLEAR_SOUNDS ) ) ;
			switch( coinObj.btName )
			{
				case Flags.NONE : 					 
					_model.selectedInteraction = 0 ;
					DispatchManager.dispatchEvent(new Event( Flags.DEACTIVATE_VIDEO_RUN ) ) ; 
					stateMachineTransition();
				break ;
				case Flags.INIT_BUTTON : 					 
					updateState(_model.initButtonStateAddress ) ; 
					DispatchManager.dispatchEvent( new Event ( Flags.REMOVE_INIT_BUTTON ) ) ; 
				break ;
				case Flags.BACK_TO_VIDEO_BUTTON : 					 
					//**do nothing
				break ;

				case Flags.OVERWEIGHT : 					 
					DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.FOOTER_CLICKED ,{value:'overweight'}));
				break ;
				
				
				default:
					_model.selectedInteraction = int(coinObj.btName);
					var interaction : Object = _model.interaction ; 
					
					requestVideos( _model.getState( interaction.final_state  ) ) ;
					requestVideos( _model.getState( _model.getState( interaction.final_state  ).interactions[0].final_state ) ) ;
					
					removeTimers( ) ; 
					
					_transitionTimer = new SMTimer( coinObj.timeChoiceFadeOut , 1 ) ; 
					_transitionTimer.start() ;
					_transitionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, answerDelayedCompleted );
					
					DispatchManager.dispatchEvent(new Event( Flags.FADEOUT ) ); 
					DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_BUTTON_SOUND , SMSettings.BUTTON_SOUND_GOOD) );
				 	//answerDelayedCompleted() ; 
				break ;
			}

			 var historyVO : HistoryVO = new HistoryVO( coinObj.btName , _model.selectedState ) ;
			 if( coinObj.btName != Flags.INIT_BUTTON )
			 {
				_model.storeHistory( historyVO ) ;
			 }
		}
		
		private function answerDelayedCompleted( evt : TimerEvent = null ) : void
		{
			removeTimers() ; 
			DispatchManager.dispatchEvent(new Event( Flags.DEACTIVATE_VIDEO_RUN)) ; 
			stateMachineTransition();
		}

		
		private function stateMachineTransition() : void
		{
			removeTimers() ; 
			DispatchManager.dispatchEvent( new Event( Flags.CLEAR_SOUNDS) ) ; 
			var interaction : Object = _model.interaction;
			var videoName : String  = interaction.video_name ; 
			 
			if( _model.is_pre_q( _model.selectedState ) )
			{
				var loaded : Boolean = VideoLoader.i.isLoaded( videoName ) ; 
				if( loaded )
				{	
					VideoLoader.i.setLoadedTrue() ; 
 					stateMachineTransitionExec(  ) ; 
					VideoLoader.i.deactivateClickPause() ; 
				}
				else
				{
					SMVars.me.nsStreamTime = 0 ; 
					SMVars.me.nsStreamTimeAbs = 0 ; 
					VideoLoader.i.questionShowLoader() ; 
					var url : String = VideoLoader.i.getCompleteUrl( videoName ) ; 
					_bulkLoader.add( url , {id:url , priority : 1000, type : "video" , pausedAtStart : true }) ; 
 					_bulkLoader.loadNow( url ) ; 
					_bulkLoader.get( url).addEventListener(BulkLoader.PROGRESS , onAllProgress) ;
					_bulkLoader.get( url).addEventListener(BulkLoader.COMPLETE , onAllLoaded) ;
					_bulkLoader.start() ; 
					 _url = url ; 
				}
			}
			else
			{
				stateMachineTransitionExec( ) ; 
			}
		}
		
		private function clenBulkLoader() : void
		{
			if( _url && _bulkLoader.get(_url ) )
			{
				_bulkLoader.get( _url).removeEventListener(BulkLoader.PROGRESS , onAllProgress) ;
				_bulkLoader.get( _url).removeEventListener(BulkLoader.COMPLETE , onAllLoaded) ;
			}
		}
		
		public function onVideoStart() : void
		{
			checkAddress() ; 
			setClipLength() ;
		}
	
		private function stateMachineTransitionExec(  ) : void
		{
			clenBulkLoader() ; 
			var interaction : Object = _model.interaction;
			var videoName : String  = interaction.video_name ; 
			if( videoName.length > 0)
			{
				//setClipLength() ; 
				DispatchManager.dispatchEvent(new Event(Flags.UPDATE_UI));
				activateTrigger() ; 
				
				DispatchManager.dispatchEvent( new Event( Flags.DEACTIVATE_VIDEO_RUN ) );
				DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_VIDEO , interaction.video_name)) ;				
				if( _prevStateAddress && _model.selectedState != SMSettings.STATE_SLOW )
				{
					cancelVideos( _prevStateAddress ) ; 
					cancelVideos( _model.selectedState ) ; 
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
		
		private function requestVideos( state : Object ) : void
		{
			var interactions : Array = state.interactions ; 
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
		private function cancelVideos( address : String ) : void
		{
			var i : int = 0 ; 
			var prevState : Object = _model.getState( address ) ; 
			var l : int = prevState.interactions.length ;
			for( i = 0 ; i < l ; i++)
			{
				var prevVideoName : String = prevState.interactions[i].video_name ;
				VideoLoader.i.cancelLoadRequest( prevVideoName ) ;
			}
		}
		private function onAllLoaded(event : Event) : void 
		{
			_bulkLoader.removeEventListener(BulkLoader.PROGRESS, onAllProgress);
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onAllLoaded);
			
			
			stateMachineTransition();
		}

		private function onAllProgress(event : BulkProgressEvent) : void 
		{
			//trace('--loading ' , event.bytesLoaded )
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
		public function goStartState( ) : void
		{
			updateState( _model.startState ) ; 
		}
		private function checkAddress(  ) : void
		{
			var address : String = _model.selectedState ;
			switch( address )
			{				
				case _model.initButtonStateAddress : 
					DispatchManager.dispatchEvent( new Event ( Flags.REMOVE_INIT_BUTTON ) ) ;
				break ;
				
				case _model.startState : 
					_model.resetHistory() ; 
					DispatchManager.dispatchEvent( new ObjectEvent ( Flags.CREATE_INIT_BUTTON , _model.initButtonState) ) ;
				break ;
			}
		}
		protected function updateState( address : String , cleanUI : Boolean = true) : void
		{	
			clenBulkLoader() ; 
			cleanMemory() ; 
			
			_newSlowTime = 0 ; 
			_activateMessageBox = false ; 
			DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ;			
			DispatchManager.dispatchEvent( new Event(Flags.CLEAR_SOUNDS  )) ;
			
			if( address == _model.endState)
			{
				end() ; 
				return ; 
			}

			storePrevState() ;  
			_model.selectedState = address ;  
    		controlTooSlowState() ; 
			createInteractions( );

			 DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , SMSettings.QUESTIONS_FADE_IN) );			
			 if( AppSettings.DEBUG ) DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_DEBUG_PANEL_STATE, _model.selectedState ));

			requestVideos( _model.state ) ; 
			if( _model.state.state_txt ) if( _model.state.state_txt.length > 0)
			{
				DispatchManager.dispatchEvent(new ObjectEvent(Flags.UPDATE_VIEW_STATE_TEXT, _model.state) ) ;
			}
			
			VideoLoader.i.deactivateClickPause() ; 
		}

		
		//**for backward functionality
		private function storePrevState() : void
		{
			_prevStateAddress = _model.selectedState ;
			var i : int = _model.selectedState.indexOf( SMSettings._Q ) ;
			if( i != -1 )
				_prevStateAddress = _model.selectedState ; 
		}
		
		
		//**progress bar click. 
		public function progressBarClick( time : Number ) : void
		{
			 _newSlowTime = 0 ; 
			 if( !_tooslowTimer )
			 {
				VideoLoader.i.seek( time / 1000 ) ;
			 }
			 else
			 {
				_newSlowTime = time ; //_totalTooSlowTime - time ;
				var slowTimeDiff : Number = _totalTooSlowTime - time ;  
				createTooSlowTimer( slowTimeDiff ) ;  	
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
			DispatchManager.dispatchEvent( new Event( Flags.DEACTIVATE_VIDEO_RUN ) );
			switch( true )
			{
				case SMVars.me.nsStreamTime > SMSettings.BACK_MAX_TIME  && !_tooslowTimer :
					VideoLoader.i.seek( 0 ) ; 
				break  ;
				
				case _tooslowTimer && SMController.me.getTooSlowTimerTime() > SMSettings.BACK_MAX_TIME :
					updateState( _prevStateAddress ) ;
				break  ;
				
				default :
					backExec()  ;		
			}
		}
		
		private function backExec() : void
		{
			var iter : int  = 2 ; 
			if( _model.selectedState == SMSettings.STATE_SLOW ) iter = 1 ; 
			var historyVO : HistoryVO = _model.getHistory( iter ) ; 
			updateState( historyVO.state ) ; 
			if( historyVO.btName != 'none')
			{
				var coinObj : CoinVO = new CoinVO() ;
				coinObj.btName = historyVO.btName ; 
				coinObj.timeChoiceFadeOut = 0 ; 
				DispatchManager.dispatchEvent( new ObjectEvent( Flags.INSERT_COIN , coinObj ) )  ; 
			}
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
		
		//**clean memory ( !important especially for ipad2 ) 
		private function cleanMemory() : void
		{
			var historyVO : HistoryVO = _model.getHistoryPrev() ; 
			if( historyVO)
			{
				var state : Object = _model.getState( historyVO.state ) ; 
				var interactions : Array = state.interactions ; 
				for( var i : int = 0 ; i < interactions.length ; i ++ )
				{
					var videoName : String = interactions[i].video_name ; 
					VideoLoader.i.removeItem( videoName ) ; 
				}
			}
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
		
		
		private function setBulkLoader():void{
			_bulkLoader = BulkLoader.getLoader(AppSettings.BULK_LOADER_ID);
			if(_bulkLoader == null){
				_bulkLoader = new BulkLoader(AppSettings.BULK_LOADER_ID , 3 ) ;
			}
		}
		
		//*DEBUG DURATION
		public function startGetClipLength() : void
		{
			_model.init( ) ;
			var iter : int = 0 ; 
			for( var mc : * in _model.dictState)
			{
				iter ++ ;				
				var state : Object = _model.dictState[ mc ]  ; 
				var interactions : Object = state.interactions ; 
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
				VideoLoader.i.update(nameVideo) ;
		}
		 
		 
		 
		public function get model():SMModel
		{
			return _model;
		}		
	}
}

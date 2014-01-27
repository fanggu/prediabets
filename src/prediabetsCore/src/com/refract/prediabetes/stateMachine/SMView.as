package com.refract.prediabetes.stateMachine 
{
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.stateMachine.VO.CoinVO;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.stateMachine.view.BorderView;
	import com.refract.prediabetes.stateMachine.view.DebugView;
	import com.refract.prediabetes.stateMachine.view.StateTxtView;
	import com.refract.prediabetes.stateMachine.view.UIView;
	import com.refract.prediabetes.stateMachine.view.buttons.ButtonChoice;
	import com.refract.prediabetes.stateMachine.view.messageBox.MessageBoxView;
	import com.refract.prediabetes.video.VideoLoader;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Box;

	import flash.display.Sprite;
	import flash.events.Event;


	/**
	 * @author robertocascavilla
	 */
	public class SMView extends Sprite 
	{
		private var _borderView : Sprite ;
		
		private var _videoView : VideoLoader;
		private var _videoOverlayView : Sprite;
		private var _uiView : UIView;
		private var _debugView : DebugView;
		private var _overlayView : Sprite;
		private var _lockButtonsView : Sprite;
		private var _lockButtonsQ : Sprite;
		
		private var _stateTxtView : StateTxtView;
		private var _messageBoxContView : Sprite;
		private var _closeButton : Sprite;
		private var _initButton : ButtonChoice ; 
		
		public function SMView()
		{
			addEventListener(Event.ADDED_TO_STAGE , init );
			createInitialListener() ;
		}

		
		protected function init( evt : Event = null ) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE , init );
			
			createStuff() ; 
			
			addChild( _borderView );
			addChild( _videoView );
			addChild( _videoOverlayView );
			addChild( _uiView );
			addChild( _messageBoxContView );
			
			if( AppSettings.DEBUG ) addChild( _debugView );
			addChild( _lockButtonsView );
			addChild( _overlayView );
		}
	
		private function createStuff() : void
		{
			_borderView = new BorderView() ; 
			_videoView = new ClassFactory.VIDEO_LOADER();
			_videoOverlayView = new Sprite();
			_uiView = new UIView() ;
			_messageBoxContView = new Sprite() ; 
			if( AppSettings.DEBUG ) _debugView = new DebugView() ; 
			_lockButtonsView = new Sprite() ;
			_overlayView = new Sprite() ; 
			 
			createLockButtonsQ();
		}
		
		private function onStart( event : Event ) : void
		{
			createListeners() ; 
		}
		
		private function createInitialListener() : void
		{
			DispatchManager.addEventListener(Flags.STATE_MACHINE_START, onStart );
			DispatchManager.addEventListener(Flags.CREATE_INIT_BUTTON, onAddInitButton);
			DispatchManager.addEventListener(Flags.REMOVE_INIT_BUTTON, onRemoveInitButton);
		}
		
		protected function createListeners() : void
		{
			DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onEnd);
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_INTERACTIONS, onUpdateInteractions);
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_VIDEO, onUpdateVideo);
			//DispatchManager.addEventListener(Flags.UPDATE_VIEW_STATE_TEXT , onUpdateStateText);
			DispatchManager.addEventListener(Flags.UPDATE_MESSAGE_BOX, onUpdateMessageBox);
			DispatchManager.addEventListener(Flags.UPDATE_UI, onUpdateUI);
			
			//**PAUSE
			DispatchManager.addEventListener(Flags.FREEZE, onFreeze );
			DispatchManager.addEventListener(Flags.UN_FREEZE, onUnFreeze);
			DispatchManager.addEventListener(Flags.FREEZE_BUTTONS, onFreeze );
			DispatchManager.addEventListener(Flags.UNFREEZE_BUTTONS, onUnFreeze);
			AppSettings.stage.addEventListener(Event.RESIZE, onResize );
			DispatchManager.addEventListener(Flags.FADEOUT, onFadeOut );
			DispatchManager.addEventListener(Flags.SPEED_FADEOUT, onSpeedFadeOut );	
		
			//**DEBUG PANEL UPDATE
			if( AppSettings.DEBUG ) DispatchManager.addEventListener(Flags.UPDATE_DEBUG_PANEL_STATE, onUpdateDebugPanelState);
			if( AppSettings.DEBUG ) DispatchManager.addEventListener(Flags.UPDATE_DEBUG_PANEL_VIDEO, onUpdateDebugPanelVideo);
		}
		
		private function removeListeners() : void
		{
			DispatchManager.removeEventListener(Flags.STATE_MACHINE_END , onEnd);
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_INTERACTIONS, onUpdateInteractions);
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_VIDEO, onUpdateVideo);
			//DispatchManager.removeEventListener(Flags.UPDATE_VIEW_STATE_TEXT, onUpdateStateText);
			DispatchManager.removeEventListener(Flags.UPDATE_UI, onUpdateUI);
			DispatchManager.removeEventListener(Flags.CREATE_INIT_BUTTON, onAddInitButton);
			DispatchManager.removeEventListener(Flags.REMOVE_INIT_BUTTON, onRemoveInitButton);
			DispatchManager.removeEventListener(Flags.FREEZE, onFreeze );
			DispatchManager.removeEventListener(Flags.UN_FREEZE, onUnFreeze);	
			DispatchManager.removeEventListener(Flags.FREEZE_BUTTONS, onFreeze );
			DispatchManager.removeEventListener(Flags.UNFREEZE_BUTTONS, onUnFreeze);
			AppSettings.stage.removeEventListener(Event.RESIZE, onResize );
			DispatchManager.removeEventListener(Flags.FADEOUT, onFadeOut );
			DispatchManager.removeEventListener(Flags.SPEED_FADEOUT, onSpeedFadeOut );
			
			//**DEBUG PANEL UPDATE
			DispatchManager.removeEventListener(Flags.UPDATE_DEBUG_PANEL_STATE, onUpdateDebugPanelState);
			DispatchManager.removeEventListener(Flags.UPDATE_DEBUG_PANEL_VIDEO, onUpdateDebugPanelVideo);
		}
		
		private function onEnd(event : Event) : void 
		{
			removeListeners() ; 
		}
		
		
		//**[FREEZE AND UNFREEZE]
		private function onUnFreeze(event : Event) : void 
		{
			if(_lockButtonsQ.parent )  _lockButtonsView.removeChild( _lockButtonsQ ) ;
		}

		private function onFreeze(event : Event) : void 
		{	
			_lockButtonsView.addChild( _lockButtonsQ ) ;
			onResize() ; 
		}
		//**/[FREEZE AND UNFREEZE]

		private function createInteraction( interaction : Object) : void
		{
			switch( interaction.interaction_type)
			{
				case Flags.CHOICE :
					_uiView.createChoice( interaction , _stateTxtView.height );	
					SMVars.me.tempTotChoice++;
				break ; 
				
				case Flags.NONE :
					var btObj : CoinVO = new CoinVO() ; 
					btObj.btName = Flags.NONE; 
					DispatchManager.dispatchEvent(new ObjectEvent(Flags.INSERT_COIN, btObj)); 
					
				break;
				
					
				default :
				//
				break;
			}	
		}

		
		//**LISTENERS ACTIONS
		private function onUpdateInteractions( evt : ObjectEvent ) : void
		{
			var stateObject :Object = evt.object ; 
			var len : int = stateObject.interactions.length ;
			
			SMVars.me.tempTotChoice = 0 ; 
			
			createChoiceTitle( stateObject ) ; 
			
			var i : int ; 
			for( i = 0 ; i < len ; i++)
			{
				var interaction : Object = stateObject.interactions[i] ;
				interaction.iter = i ; 
				interaction.stateName = stateObject.name ; 
				createInteraction( interaction );
			}
			
			_uiView.posButtons() ; 
			onResize() ; 
			_uiView.animateIn() ; 
		}
		
		private function createChoiceTitle( stateObject : Object ) : void
		{		
			if( _stateTxtView )
			{
				if( _stateTxtView.parent)
					_stateTxtView.parent.removeChild( _stateTxtView );
				 _stateTxtView = null ; 
			}
			_stateTxtView  = new StateTxtView( stateObject ) ; 
			_uiView.addChild( _stateTxtView ) ; 
			_uiView.stateTxtHeight = _stateTxtView.height ;
			
			_stateTxtView.x = - _stateTxtView.width / 2 ;  
		}
		


		private function onUpdateUI( evt : Event ) : void
		{
			_uiView.cleanUI() ;		
			if( _stateTxtView )
			{
				if( _stateTxtView.parent)
					_stateTxtView.parent.removeChild( _stateTxtView );
				 _stateTxtView = null ; 
			}
			
			var i : int ;
			var l : int = _messageBoxContView.numChildren ; 
			for( i = 0 ; i < l ; i++)
			{
				var child : MessageBoxView = _messageBoxContView.getChildAt( 0 )  as MessageBoxView ;
				if( child) 
					if( child.parent )
					{
						child.dispose() ; 
					}
			}
		}
		
		private function createInitButton( interaction : Object) : void
		{
			_initButton = new ButtonChoice("buttonFont", { fontSize:26  }, SMSettings.MIN_BUTTON_SIZE, 70  , true , true);
			addChild( _initButton ) ; 
			_initButton.id = Flags.INIT_BUTTON ; 
			_initButton.visible = false ; 
			_initButton.setButton( interaction ) ; 
		}
		private function onAddInitButton( evt : ObjectEvent ) : void
		{
			if( !_initButton ) createInitButton( evt.object )
			_initButton.visible = true ; 
			_initButton.alpha = 0 ; 
			TweenMax.to( _initButton , .5 , { alpha : 1 , delay : 2 } ) ; 
		}
		private function onRemoveInitButton( evt : Event = null ) : void
		{ 
			if( _initButton )
			{
				_initButton.dispose() ; 
				if( _initButton.parent ) 
					_initButton.parent.removeChild( _initButton ) ; 
				_initButton= null; 
			}
			
		}
	
		private function onUpdateVideo( evt : StateEvent) : void
		{
			VideoLoader.i.activateClickPause() ; 
			var videoName : String = evt.stringParam;
			_videoView.update( videoName);	 
		}
		private function onUpdateStateText( evt : ObjectEvent) : void
		{
			var stateObjectText : Object = evt.object ;
			//_uiView.createStateText( stateObject );	
			
			if( _stateTxtView )
			{
				if( _stateTxtView.parent)
					_stateTxtView.parent.removeChild( _stateTxtView );
				 _stateTxtView = null ; 
			}
			_stateTxtView  = new StateTxtView( stateObjectText, SMSettings.STATE_TXT_FONT_SIZE  ) ; 
			_uiView.addChild( _stateTxtView ) ; 
		}
		
		private function onUpdateMessageBox( evt : ObjectEvent ) : void
		{
			var interaction : Object = evt.object  ; 
			
			var i : int ; 
			var l : int = interaction.message_box.length ; 
			for( i = 0 ; i < l ; i++ )
			{
				var msgBox : MessageBoxView = new MessageBoxView( interaction.message_box[i] , interaction.interaction_meta ) ;
				_messageBoxContView.addChild( msgBox ) ;	
			}
		}


		//** [UTILITIES]
		
		

		
		//**lock buttons
		private function createLockButtonsQ() : void 
		{	
			_lockButtonsQ = new Box( 1,1,0xff0099);
			_lockButtonsQ.alpha = 0 ; 	
			
			
		}

		
		private function resizeSquare( square : Sprite )  : void
		{
			if( square.parent )
			{
				square.width = AppSettings.VIDEO_WIDTH ; 
				square.height = AppSettings.VIDEO_HEIGHT ; 
				square.x = AppSettings.VIDEO_LEFT ;
				square.y = AppSettings.VIDEO_TOP ;
			}
		}

		//** /[UTILITIES]
		
		//**DEBUG
		private function onUpdateDebugPanelState( evt : StateEvent ) : void
		{
			_debugView.updateState('STATE :'+ evt.stringParam);
		}
		private function onUpdateDebugPanelVideo( evt : StateEvent ) : void
		{
			_debugView.updateVideoName('VIDEO PLAYING IS : '+ evt.stringParam);
		}
		
		
		private function onFadeOut( evt : Event = null ) : void
		{
			if( _stateTxtView ) fadeOut( _stateTxtView ) ; 
		}
		private function onSpeedFadeOut( evt : Event = null ) : void
		{
			if( _stateTxtView ) speedFadeOut( _stateTxtView ) ; 
		}
		
		private function fadeOut( obj : * ) : void
		{
			TweenMax.to( obj , SMSettings.FADE_OUT_TIME , {alpha : 0 , delay :SMSettings.BUTTON_FADE_DELAY , onComplete:makeInvisible , onCompleteParams:[obj], canBePaused:true} ) ; 
		}
		private function makeInvisible( obj : *) : void
		{
			obj.visible = false ; 
		}
		private function speedFadeOut( obj : * ) : void
		{
			TweenMax.to( obj , .3 , {alpha : 0 , delay :0 , canBePaused:true} ) ; 
		}
		
		
		//**RESIZE
		private function onResize( evt : Event = null ) : void
		{			
			_uiView.x = AppSettings.stage.stageWidth / 2 ; //- _uiView.width / 2 ; 
			_uiView.y = AppSettings.stage.stageHeight / 2 - _uiView.height / 2; 	
			
			
			resizeSquare( _lockButtonsQ );
			if(_closeButton )
			{
				_closeButton.visible = true ; 
				_closeButton.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH - _closeButton.width *2*(AppSettings.RATIO/2) ;
				_closeButton.y = AppSettings.VIDEO_TOP + _closeButton.height ; //*4*(AppSettings.RATIO/2) ; 
			}
		}
	}
}

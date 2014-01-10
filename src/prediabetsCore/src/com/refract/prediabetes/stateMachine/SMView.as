package com.refract.prediabetes.stateMachine 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.refract.prediabetes.AppSections;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.stateMachine.VO.CoinVO;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.events.OverlayEvent;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.stateMachine.view.DebugView;
	import com.refract.prediabetes.stateMachine.view.StateTxtView;
	import com.refract.prediabetes.stateMachine.view.UIView;
	import com.refract.prediabetes.stateMachine.view.messageBox.MessageBoxView;
	import com.refract.prediabetes.video.VideoLoader;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Box;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;


	/**
	 * @author robertocascavilla
	 */
	public class SMView extends Sprite {
//		private var _videoView : VideoView;
		private var _videoView : VideoLoader;
		private var _videoOverlayView : Sprite;
		private var _uiView : UIView;
		private var _debugView : DebugView;
		private var _overlayView : Sprite;
		private var _balloonView : Sprite ;
		private var _lockButtonsView : Sprite;
		private var _lockButtonsQ : Sprite;
		private var _redFilter : MovieClip;
		private var _blackCut : Box;
		
		private var _countDownCont : Sprite ; 
		
		private var _initObject : Object ;
		private var _countDownTimerTxt : TextField;
		private var _bar : Box;
		private var _initTime : Number;
		private var _totTime : int;
		private var _endWidthBar : Number;
		
		private var _stateTxtView : StateTxtView;
		private var _messageBoxContView : Sprite;
		private var _cpr : Boolean;
		private var _closeButton : Sprite;
		//private var _flashWhite : Boolean ; 
		
		public function SMView()
		{
			addEventListener(Event.ADDED_TO_STAGE , init );
			createInitialListener() ;
		}

		
		protected function init( evt : Event = null ) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE , init );
			
			createStuff() ; 
			
			addChild( _videoView );
			addChild( _videoOverlayView );
			addChild( _uiView );
			addChild( _messageBoxContView );
			
			addChild( _countDownCont ) ;
			addChild( _debugView );
			addChild( _lockButtonsView );
			addChild( _overlayView );
			addChild( _balloonView );
			
			
			
		}
		
		
		
		private function createStuff() : void
		{
			_videoView = new ClassFactory.VIDEO_LOADER();
			_videoOverlayView = new Sprite();
			_uiView = new UIView() ;
			_messageBoxContView = new Sprite() ; 
			_debugView = new DebugView() ; 
			_lockButtonsView = new Sprite() ;
			_overlayView = new Sprite() ; 
			_balloonView = new Sprite ; 
			_countDownCont = new Sprite() ; 
			
			
			createRedFilter() ; 	
			//createPauseButton() ; 
			createLockButtonsQ();
			createBlackCut() ; 
		}
		
		private function onStart( event : ObjectEvent ) : void
		{
			_initObject = event.object ; 
			_uiView.setCountDownContainer( _initObject.footerBar) ; 
			
			createListeners() ; 
		}
		
		private function createInitialListener() : void
		{
			DispatchManager.addEventListener(Flags.STATE_MACHINE_START, onStart );
		}
		
		protected function createListeners() : void
		{
			
			DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onEnd);
			//**create interactions
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_INTERACTIONS, onUpdateInteractions);
			//DispatchManager.addEventListener(Flags.UPDATE_VIEW_INTERACTIONS_WG, onUpdateInteractionsWg);
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_VIDEO, onUpdateVideo);
			
			//**state text
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_STATE_TEXT , onUpdateStateText);
			//**message box
			//DispatchManager.addEventListener(Flags.UPDATE_VIEW_MESSAGE, onUpdateMessage);
			//DispatchManager.addEventListener(Flags.REMOVE_VIEW_MESSAGE, onRemoveMessage);
			DispatchManager.addEventListener(Flags.UPDATE_MESSAGE_BOX, onUpdateMessageBox);
			//**clean UI
			DispatchManager.addEventListener(Flags.UPDATE_UI, onUpdateUI);
			
			
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_COUNTDOWN_TIMER, onUpdateCountdownTimer);
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_COUNTDOWN_TIMER_CPR_LONG, onUpdateCountdownTimerCprLong);
			
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_COUNTDOWN_TEXT, onUpdateCountdownText);
			
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_COUNTDOWN_TIMER_WHITE, onUpdateCountdownTimerWhite);
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_COUNTDOWN_STOP_WHITE, onUpdateCountdownStopWhite);
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_COUNTDOWN_FORCE_REMOVE, onUpdateCountdownForceRemove ) ;
			
			
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_BAR_TIMER, onUpdateBarTimer);
			DispatchManager.addEventListener(Flags.UPDATE_VIEW_BAR_REMOVE, onUpdateBarRemove);
			
			DispatchManager.addEventListener(Flags.UPDATE_RED_FILTER , onUpdateRedFilter);
			DispatchManager.addEventListener(Flags.UPDATE_REMOVE_RED_FILTER , onUpdateRemoveRedFilter);
			
			DispatchManager.addEventListener(Flags.UPDATE_CUT_BLACK, onUpdateCutBlack);
			DispatchManager.addEventListener(Flags.UPDATE_CUT_BLACK_LONG, onUpdateCutBlackLong);
			DispatchManager.addEventListener(Flags.UPDATE_CUT_BLACK_SUPER_LONG, onUpdateCutBlackSuperLong);
			DispatchManager.addEventListener(Flags.REMOVE_CUT_BLACK_SUPER_LONG, onRemoveCutBlackSuperLong);
			
			DispatchManager.addEventListener(Flags.ADD_LS6_CLOSE_BUTTON, onAddLS6CloseButton);
			//DispatchManager.addEventListener(Flags.REMOVE_LS6_CLOSE_BUTTON, onRemoveLS6CloseButton);
			
			
			
			//**PAUSE
			DispatchManager.addEventListener(Flags.FREEZE, onFreeze );
			DispatchManager.addEventListener(Flags.UN_FREEZE, onUnFreeze);
			DispatchManager.addEventListener(Flags.FREEZE_BUTTONS, onFreeze );
			DispatchManager.addEventListener(Flags.UNFREEZE_BUTTONS, onUnFreeze);
			
			AppSettings.stage.addEventListener(Event.RESIZE, onResize );
			
			DispatchManager.addEventListener(Flags.FADEOUT, onFadeOut );
			DispatchManager.addEventListener(Flags.SPEED_FADEOUT, onSpeedFadeOut );
			
			DispatchManager.addEventListener(OverlayEvent.DRAW_BALLOON, onDrawBalloon );
			//DispatchManager.addEventListener( Flags.DRAW_VIDEO_STATUS ,onDrawVideoStatus  ) ; 
			
			//DispatchManager.addEventListener(Flags.TEXT_FEEDBACK, onTextFeedback );
			//**DEBUG PANEL UPDATE
			DispatchManager.addEventListener(Flags.UPDATE_DEBUG_PANEL_STATE, onUpdateDebugPanelState);
			DispatchManager.addEventListener(Flags.UPDATE_DEBUG_PANEL_VIDEO, onUpdateDebugPanelVideo);
		}
		
		private function removeListeners() : void
		{
			
			DispatchManager.removeEventListener(Flags.STATE_MACHINE_END , onEnd);
			//**create interactions
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_INTERACTIONS, onUpdateInteractions);
			//DispatchManager.removeEventListener(Flags.UPDATE_VIEW_INTERACTIONS_WG, onUpdateInteractionsWg);
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_VIDEO, onUpdateVideo);
			
			//**state text
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_STATE_TEXT, onUpdateStateText);
			//**message box
			//DispatchManager.removeEventListener(Flags.UPDATE_VIEW_MESSAGE, onUpdateMessage);
			//DispatchManager.addEventListener(Flags.REMOVE_VIEW_MESSAGE, onRemoveMessage);
			//**clean UI
			DispatchManager.removeEventListener(Flags.UPDATE_UI, onUpdateUI);
			
			
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_COUNTDOWN_TIMER, onUpdateCountdownTimer);
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_COUNTDOWN_TEXT, onUpdateCountdownText);
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_COUNTDOWN_TIMER_WHITE, onUpdateCountdownTimerWhite);
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_COUNTDOWN_STOP_WHITE, onUpdateCountdownStopWhite);
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_COUNTDOWN_FORCE_REMOVE, onUpdateCountdownStopWhite);
			
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_BAR_TIMER, onUpdateBarTimer);
			DispatchManager.removeEventListener(Flags.UPDATE_VIEW_BAR_REMOVE, onUpdateBarRemove);
			
			DispatchManager.removeEventListener(Flags.UPDATE_RED_FILTER , onUpdateRedFilter);
			DispatchManager.removeEventListener(Flags.UPDATE_REMOVE_RED_FILTER , onUpdateRemoveRedFilter);
			
			DispatchManager.removeEventListener(Flags.UPDATE_CUT_BLACK, onUpdateCutBlack);
			DispatchManager.removeEventListener(Flags.UPDATE_CUT_BLACK_LONG, onUpdateCutBlackLong );
			DispatchManager.removeEventListener(Flags.UPDATE_CUT_BLACK_SUPER_LONG, onUpdateCutBlackSuperLong);
			DispatchManager.removeEventListener(Flags.REMOVE_CUT_BLACK_SUPER_LONG, onRemoveCutBlackSuperLong);
			
			DispatchManager.removeEventListener(Flags.ADD_LS6_CLOSE_BUTTON, onAddLS6CloseButton);
			//DispatchManager.removeEventListener(Flags.REMOVE_LS6_CLOSE_BUTTON, onRemoveLS6CloseButton);
			
			//**PAUSE
			DispatchManager.removeEventListener(Flags.FREEZE, onFreeze );
			DispatchManager.removeEventListener(Flags.UN_FREEZE, onUnFreeze);
			
			DispatchManager.removeEventListener(Flags.FREEZE_BUTTONS, onFreeze );
			DispatchManager.removeEventListener(Flags.UNFREEZE_BUTTONS, onUnFreeze);
			
			AppSettings.stage.removeEventListener(Event.RESIZE, onResize );
			
			DispatchManager.removeEventListener(Flags.FADEOUT, onFadeOut );
			
			DispatchManager.removeEventListener(Flags.SPEED_FADEOUT, onSpeedFadeOut );
			
			DispatchManager.removeEventListener(OverlayEvent.DRAW_BALLOON, onDrawBalloon );
			//DispatchManager.removeEventListener( Flags.DRAW_VIDEO_STATUS ,onDrawVideoStatus  ) ; 
			//DispatchManager.removeEventListener(Flags.TEXT_FEEDBACK, onTextFeedback );
			
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
			//trace('lock button called :' , event.type)
			_lockButtonsView.addChild( _lockButtonsQ ) ;
			onResize() ; 
		}
		//**/[FREEZE AND UNFREEZE]

		
		private function onAddLS6CloseButton( evt : Event ) : void
		{
			_closeButton = new Sprite() ; 
			var closeButtonBtm : Bitmap = AssetManager.getEmbeddedAsset("LS6CloseButton") ;
			_closeButton.addChild( closeButtonBtm ) ; 
			_uiView.addChild( _closeButton ) ; 
			//onResize() ; 
			
			_closeButton.visible = false ; 
			_closeButton.addEventListener(MouseEvent.MOUSE_DOWN, onCloseButton) ;
			if( AppSettings.RATIO > 1.2)
			{
				_closeButton.scaleX = _closeButton.scaleY = AppSettings.RATIO ; 
			}
			onResize() ; 
		}

		private function onCloseButton(event : MouseEvent) : void 
		{
			DispatchManager.dispatchEvent( new Event( Flags.CLOSE_QUESTIONS ) ) ; 
		}
		private function onRemoveLS6CloseButton( evt : Event ) : void
		{
			
		}
		
		
		private function onDrawBalloon( evt : OverlayEvent) : void
		{
			var txtBalloon : Sprite = evt.object ; 
			_uiView.addChild( txtBalloon ) ;  
		}

		
		private function createInteraction( interaction : Object) : void
		{
			switch( interaction.interaction_type)
			{
				case Flags.CHOICE :
					_uiView.createChoice( interaction );	
					SMVars.me.tempTotChoice++;
				break ; 
				case Flags.CHOICE_IMG :
					_uiView.createChoice( interaction );	
					SMVars.me.tempTotChoice++;
				break ;
				case Flags.CHOICE_TARGET :
					_uiView.createChoice( interaction );	
					SMVars.me.tempTotChoice++;
				break ;
				
				case Flags.NONE :
					var btObj : CoinVO = new CoinVO() ; 
					btObj.btName = Flags.NONE; 
					DispatchManager.dispatchEvent(new ObjectEvent(Flags.INSERT_COIN, btObj)); 
					
				break;
				
				case Flags.SLIDE_Y:
					_uiView.createSlide(interaction) ; 
				break;
				
				case Flags.SLIDE_X:
					_uiView.createSlide(interaction) ; 
				break;
				
				case Flags.CPR_STANDARD:
					_uiView.createQPInteraction( interaction ) ; 
				break;
				case Flags.CPR_LINEAR:
					_uiView.createQPInteraction( interaction ) ; 
				break;
				case Flags.CPR_LONG:
					_uiView.createQPInteraction( interaction ) ; 
				break;
				case Flags.ONESHOT:
					_uiView.createQPInteraction( interaction ) ; 
				break;
								
				default :
				//
				break;
			}	
		}

		
		//**LISTENERS ACTIONS

		private function onUpdateCutBlack(event : Event) : void 
		{	
			_videoOverlayView.addChild( _blackCut ) ; 
			TweenMax.killTweensOf( _blackCut  ) ; 
			_blackCut.alpha = 0 ;
			_blackCut.visible = true ; 
			TweenMax.to( _blackCut , .3 , { alpha:1 , onComplete:reverse ,canBePaused:true}); 
			
			onResize() ; 
		}
		
		private function onUpdateCutBlackLong(event : Event) : void 
		{	
			_videoOverlayView.addChild( _blackCut ) ; 
			
			TweenMax.killTweensOf( _blackCut  ) ; 
			
			_blackCut.alpha = 0 ;
			_blackCut.visible = true ; 
			TweenMax.to( _blackCut , .2 , { alpha:1 , onComplete:removeBlackCut ,canBePaused:true}); 
			
			onResize() ; 
		}
		private function removeBlackCut( ) : void
		{
			TweenMax.killTweensOf( _blackCut  ) ; 
			TweenMax.to( _blackCut , .3 , { alpha:0 , delay : .3 , onComplete:devastate ,canBePaused:true}); 
			onResize() ; 
		}
		
		private function onUpdateCutBlackSuperLong( event : Event ) : void
		{
			_videoOverlayView.addChild( _blackCut ) ;
			TweenMax.killTweensOf( _blackCut  ) ; 
			_videoOverlayView.addChild( _blackCut ) ; 
			_blackCut.alpha = 0 ;
			_blackCut.visible = true ; 
			TweenMax.to( _blackCut , .2 , { alpha:1 }) ; //, onComplete:removeBlackCut ,canBePaused:true}); 
		}
		private function onRemoveCutBlackSuperLong( event : Event ) : void
		{
			TweenMax.killTweensOf( _blackCut  ) ; 
			TweenMax.to( _blackCut , .3 , { alpha:0 , delay : 0 , onComplete:devastate ,canBePaused:true}); 
			onResize() ; 
		}
		
		private function onUpdateInteractions( evt : ObjectEvent ) : void
		{
			var stateObject :Object = evt.object ; 
			var len : int = stateObject.interactions.length ;
			
			SMVars.me.maxButtonSize = 0 ; 
			var nrChoiceImg : int = 0 ; 
			var i : int ; 
			SMVars.me.tempTotChoice = 0 ; 
			for( i = 0 ; i < len ; i++)
			{
				var interaction : Object = stateObject.interactions[i] ;
				interaction.iter = i ; 
				interaction.stateName = stateObject.name ; 
				createInteraction( interaction );
				if( interaction.interaction_type == Flags.CHOICE_IMG)
				{
					nrChoiceImg++ ; 
				}
			}
			if( nrChoiceImg == 2)
			{
				if( SMVars.me.maxButtonSize < 290)
				{
					SMVars.me.maxButtonSize = 290 ; 
				}
			}
			DispatchManager.dispatchEvent( new Event( Flags.UPDATE_SIZE_BUTTON ) ) ; 
		}
		private function onUpdateCountdownTimerCprLong( evt : StateEvent ) : void
		{
			_cpr = true ;
			onUpdateCountdown( evt.stringParam , 0 ) ; 
		}
		private function onUpdateCountdownTimer( evt : StateEvent ) : void
		{
			_cpr = false ;
			onUpdateCountdown( evt.stringParam , SMSettings.SHOW_DELAY * 3 ) ; 
		}
		private function onUpdateCountdownText( evt : StateEvent ) : void
		{
			_cpr = false ;
			 if(_countDownTimerTxt ) TweenMax.to( _countDownTimerTxt , 0 , { tint:0xffffff , canBePaused:true  } );
			 onUpdateCountdown( evt.stringParam , 0 , true) ; 
			 
		}
		private function onUpdateCountdown( value : String , mdelay : Number , text : Boolean = false ) : void
		{
			if( !_countDownTimerTxt )
			{
				createCountDownTimerTxt() ;				
				_countDownCont.addChild( _countDownTimerTxt ) ; 
				_countDownCont.alpha = 0 ;
				text = true ; 
			}
			
			_countDownCont.visible = true ; 
			TweenMax.to( _countDownCont , .25 , { alpha:1 , delay : mdelay , canBePaused:true } );			
			_countDownTimerTxt.text = value ;
			
			if(  text )
			{
				TweenMax.to( _countDownTimerTxt , .7 , { tint:SMSettings.DEEP_RED , delay : mdelay , ease : Sine.easeOut , canBePaused:true } );
				text = false ;
				TweenMax.to( _countDownCont , .25 , { alpha:0 , delay : mdelay + 2 , canBePaused:true } ); 
			}
			
			onResize() ; 
		}
		
		private function onUpdateCountdownTimerWhite( evt : Event ) : void
		{
			TweenMax.to( _countDownCont , .5 , { tint:0xffffff , repeat:-1, yoyo:true , canBePaused:true} );
		}
		private function onUpdateCountdownStopWhite( evt : Event = null  ) : void
		{	 
			TweenMax.killTweensOf( _countDownCont ) ;
			TweenMax.to( _countDownCont, 0 , { tint:null , canBePaused:true} );
		}
		private function onUpdateCountdownForceRemove( evt : Event = null  ) : void
		{	 
			removeCountDownTimerTxt() ; 
		}
		private function onUpdateBarTimer( evt : StateEvent ) : void
		{
			var barH : Number = 8 * AppSettings.RATIO ; 
			if( ! _bar) _bar = new Box( 1 , barH , SMSettings.DEEP_RED); 
			 
			_initTime = SMVars.me.getSMTimer() ;
			_totTime = int( evt.stringParam ) * 1000 ;
			_countDownCont.addChild( _bar ) ;  
			
			_bar.x = 0 ; 
			_bar.y = 0 ; 
			
			_bar.width = 0 ; 
			_endWidthBar = AppSettings.VIDEO_WIDTH ; 
			DispatchManager.addEventListener( Event.ENTER_FRAME , barRun) ; 
		}
		private function onUpdateBarRemove( evt : Event ) : void
		{
			DispatchManager.removeEventListener( Event.ENTER_FRAME , barRun) ; 
			
			if( _bar ) 
				if( _bar.parent ) 
					_countDownCont.removeChild( _bar ) ; 
		}
		
		private function barRun( evt : Event ) : void
		{
			var diffTime : Number = SMVars.me.getSMTimer() - _initTime ; 
			var percTime : Number = (diffTime * 100) / _totTime ; 
			_bar.width = ( percTime * _endWidthBar ) / 100 ;
			if( diffTime >= _totTime)
			{
				DispatchManager.removeEventListener( Event.ENTER_FRAME , barRun) ; 
			}
		}
		
		private function onUpdateUI( evt : Event ) : void
		{
			_uiView.cleanUI() ;	
			
			
			if( _redFilter.parent ) _videoOverlayView.removeChild( _redFilter );
			removeCountDownTimerTxt() ; 
				
				
			if( _stateTxtView )
			{
				if( _stateTxtView.parent)
					_stateTxtView.parent.removeChild( _stateTxtView );
				 _stateTxtView = null ; 
			}
			
			onUpdateCountdownStopWhite() ;
			
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
					removeChild( _stateTxtView );
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


		private function onUpdateRedFilter(event : Event) : void 
		{
			_videoOverlayView.addChild( _redFilter ) ;  
			_redFilter.visible = true ; 
			_redFilter.alpha = 1 ; 
			_redFilter.gotoAndPlay(0);
			//_redFilter.alpha = 0 ; 
			//TweenMax.to( _redFilter , .25 , { alpha:SMSettings.ALPHA_RED_FILTER , canBePaused:true } ) ; 
			onResize();
		}
		private function onUpdateRemoveRedFilter( event : Event ): void
		{
			//if( _redFilter.parent ) _videoOverlayView.removeChild( _redFilter) ; 
			TweenMax.to( _redFilter , .3 , { alpha : 0 , onComplete: removeRedFilter , canBePaused:true} ) ;
		}
		
		
		
		
		
		private function removeRedFilter( ) : void
		{
			if( _redFilter.parent ) _videoOverlayView.removeChild( _redFilter) ;
		}
		
		
		//** [UTILITIES]
		
		private function createCountDownTimerTxt() : void 
		{ 		
			var style:Object = 
			{ 
				fontSize:SMSettings.FONT_SIZE_COUNTDOWN
				, align:TextFormatAlign.CENTER 
				, autoSize : TextFieldAutoSize.CENTER 
				, multiline: false
				, wordWrap : false
				//, width : 300
			} ; 


			var txtField : TextField = TextManager.makeText( SMSettings.FONT_COUNTDOWN , null , style) ;
			txtField.text = "00:00" ; 
			
			_countDownTimerTxt = txtField ;//createText( "00:00" ,  , 48 ) ;
			_countDownTimerTxt.textColor = 0xffffff ;   
		}
		
		private function removeCountDownTimerTxt() : void
		{
			if( _countDownTimerTxt ) 
			{
				if( _countDownTimerTxt.parent)
				{
					_countDownTimerTxt.parent.removeChild( _countDownTimerTxt ) ; 
					_countDownTimerTxt = null ; 
				}
			}
		}
		
		//**red filter
		private function createRedFilter() : void
		{
			//_redFilter = new Box( 1,1,0xff0000);
			
			
			//_redFilter = AssetManagerEmbeds.g
			_redFilter = AssetManager.getEmbeddedAsset("RedFilter") ;
			/*
			_redFilter = new Sprite() ; 
			var fillType:String = GradientType.RADIAL;
     		var colors:Array = [SMSettings.DEEP_RED , SMSettings.DEEP_RED];
     		var alphas:Array = [.2, 1];
     		var ratios:Array = [155, 255];
     		var matr:Matrix = new Matrix();
     		matr.createGradientBox(1000, 1000, 0, 0, 0);
     		var spreadMethod:String = SpreadMethod.PAD;
     		_redFilter.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);       
     		_redFilter.graphics.drawRect(0,0,1000,1000);
			
			_redFilter.mouseEnabled = false ; 
			_redFilter.mouseChildren = false ; 
			 * 
			 */
		}
		
		//**lock buttons
		private function createLockButtonsQ() : void 
		{	
			_lockButtonsQ = new Box( 1,1,0xff0099);
			_lockButtonsQ.alpha = 0 ; 	
			
			
		}
		//**black cut
		private function createBlackCut() : void
		{
			_blackCut = new Box( 1,1,0x000000 ); 
			_blackCut.mouseChildren = false ;
			_blackCut.mouseEnabled = false ; 
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
		private function resizeSquareFilter() : void
		{
			/*
			var fillType:String = GradientType.RADIAL;
     		var colors:Array = [SMSettings.DEEP_RED, 0xffffff];
     		var alphas:Array = [1, 0];
     		var ratios:Array = [0, 255];
     		var matr:Matrix = new Matrix();
     		matr.createGradientBox(AppSettings.VIDEO_WIDTH , AppSettings.VIDEO_HEIGHT , 0, 0, 0);
     		var spreadMethod:String = SpreadMethod.PAD;
     		_redFilter.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);       
     		_redFilter.graphics.drawRect(0,0,AppSettings.VIDEO_WIDTH ,AppSettings.VIDEO_HEIGHT );
     		 * 
     		 */
			 _redFilter.width = AppSettings.VIDEO_WIDTH  + 1; //* 1.5; 
				_redFilter.height = AppSettings.VIDEO_HEIGHT ;//* 1.5; 
				_redFilter.x = AppSettings.VIDEO_LEFT + _redFilter.width/2 ;//+10;
				_redFilter.y = AppSettings.VIDEO_TOP + _redFilter.height/2  ;//+ 25  ;
		}
		
		//**cut black transitions
		private function reverse( ) : void
		{
			TweenMax.to( _blackCut , .5 , { alpha:0 , delay : SMSettings.CUTBLACK_DELAY , onComplete:devastate , canBePaused:true });
		}
		private function devastate( ) : void
		{
			_blackCut.parent.removeChild( _blackCut) ; 
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
			if( _countDownCont ) fadeOut( _countDownCont  );
			if( _redFilter ) fadeOut( _redFilter  );
			if( _stateTxtView ) fadeOut( _stateTxtView ) ; 
		}
		private function onSpeedFadeOut( evt : Event = null ) : void
		{
			
			if( _countDownCont ) 
			{
				TweenMax.killTweensOf( _countDownCont ) ;
				speedFadeOut( _countDownCont  );
			}
			if( _redFilter ) speedFadeOut( _redFilter  );
			if( _stateTxtView ) speedFadeOut( _stateTxtView ) ; 
		}
		
		private function fadeOut( obj : * ) : void
		{
			TweenMax.to( obj , .3 , {alpha : 0 , delay :SMSettings.BUTTON_FADE_DELAY , onComplete:makeInvisible , onCompleteParams:[obj], canBePaused:true} ) ; 
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
			resizeSquareFilter(  );
			resizeSquare( _lockButtonsQ );
			resizeSquare( _blackCut );
			
			onResizeCountDown() ; 
			
			if( _bar )
			{
				_bar.y = -_bar.height;
			}
			
			if(_closeButton )
			{
				_closeButton.visible = true ; 
				_closeButton.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH - _closeButton.width *2*(AppSettings.RATIO/2) ;
				_closeButton.y = AppSettings.VIDEO_TOP + _closeButton.height ; //*4*(AppSettings.RATIO/2) ; 
			}

			_endWidthBar = AppSettings.VIDEO_WIDTH ; 
		}
		private function onResizeCountDown() : void
		{
			if( _cpr )
			{
				if( _countDownTimerTxt)
				{
					_countDownTimerTxt.x =  10 ; 
					_countDownTimerTxt.y =  -AppSettings.VIDEO_HEIGHT + _countDownTimerTxt.height*2 ; //-_countDownTimerTxt.width/2 //- 500;	
				}
			}
			else
			{
				if( _countDownTimerTxt)
				{
					_countDownTimerTxt.y = -_countDownTimerTxt.height - 2*(AppSettings.RATIO/2) ;
					_countDownTimerTxt.x = AppSettings.VIDEO_WIDTH/2 -_countDownTimerTxt.width/2 ;	
				}
			}
			
			if( _countDownCont )
			{
				_countDownCont.x = AppSettings.VIDEO_LEFT ; 
				_countDownCont.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT ;//;- 80 ;
			}
		}
		
	}
}

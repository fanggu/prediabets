package com.refract.prediabetes.nav {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.nav.events.FooterEvent;
	import com.refract.prediabetes.nav.footer.BackwardButton;
	import com.refract.prediabetes.nav.footer.FullScreenButton;
	import com.refract.prediabetes.nav.footer.PlayPauseButton;
	import com.refract.prediabetes.nav.footer.SoundButton;
	import com.refract.prediabetes.sections.utils.PrediabetesButton;
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.stateMachine.view.buttons.ButtonChoice;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Box;
	import com.robot.utils.Utils;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;


	public class Footer extends Sprite 
	{
		//Flags
		private const PLAY_PAUSE:String = "PLAY_PAUSE";
		private const BACKWARD_BUTTON:String = "BACKWARD_BUTTON";
		private const SOUND:String = "SOUND";
		private const FULL_SCREEN:String = "FULL_SCREEN";
		private const START_AGAIN:String = "startAgain";
		private const FIND_OUT_MORE:String = "findOutMore";
		private const SHARE:String = "share";
		private const LEGAL:String = "legal";
		
		private var _footerButtons : Dictionary ; 
		//**special buttons
		private var _backToVideo:ButtonChoice; 
		private var _playPauseButton : PlayPauseButton ;
		private var _backwardButton : BackwardButton ;  
		
		private var _progressBar : Sprite;
		private var _footerBackCont : Sprite ;
		private var _footerBackBottom : Box;
		private var _footerBackTop : Box;
		
		private var _footerBottom : Sprite;
		private var _footerBottomRight : Sprite ; 
		
		protected var _footerTopCenter:Sprite;
		private var _footerTopRight : Sprite;
		private var _footerTopLeft : Sprite;
		
		private var _footerTopBackground : Sprite ; 
		
		private var _nav : Nav ;
		private var _clip_length : Number;
		private var _tween : Boolean ;
		private var _tweenID : TweenMax;	
		private var _progressBarBox : Sprite;
		private var _progressBarBoxHitArea : Sprite;
		private var _progressBarAbsWidth : Number ; 
		private var _iterShowNav : int ; 
		private var _barHidden : Boolean ;
		private var _endFooterTopLeft_y : int;
		private var _overlay : Boolean;

		public function Footer( nav : Nav ) 
		{
			_nav = nav ; 
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void
		{
			_iterShowNav = 0 ; 
			_barHidden = false ; 
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			createFooterButtonsArray() ; 
			createFooterBackgrounds() ; 
			createFooterContainers() ; 
			createBottomFooter() ; 
			createTopRightFooter() ; 
			createTopLeftFooter() ; 
			createTopCenterFooter() ; 
			createProgressBar() ; 
			if( AppSettings.DEVICE != AppSettings.DEVICE_TABLET)
				createBottomRightFooter() ;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_buttonSpace : 0;

			stage.addEventListener(Event.RESIZE,onResize  );
			DispatchManager.addEventListener(FooterEvent.HIGHLIGHT_BUTTON, highlightFooterButton);
			DispatchManager.addEventListener(Flags.SHOW_FOOTER_PLAY_PAUSE, togglePauseShown);
			DispatchManager.addEventListener(Flags.HIDE_FOOTER_PLAY_PAUSE, togglePauseShown);
			DispatchManager.addEventListener(Flags.ACTIVATE_PROGRESS_BAR , activateProgressBar);
			DispatchManager.addEventListener(Flags.DE_ACTIVATE_PROGRESS_BAR , deActivateProgressBar);
			DispatchManager.addEventListener(Flags.ON_REQUEST_RESIZE , onRequestResize);
			
			
			DispatchManager.addEventListener(Flags.FREEZE , onFreeze);
			DispatchManager.addEventListener(Flags.UN_FREEZE , onUnFreeze); 
			
			if( AppSettings.DEVICE != AppSettings.DEVICE_TABLET)
			{
				DispatchManager.addEventListener(Event.ENTER_FRAME , onRun);
				AppSettings.stage.addEventListener(MouseEvent.MOUSE_MOVE ,  onMouseMove ) ; 
				stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFSChange);
			}
			
			onResize();
		}
		private function onRun( evt : Event ) : void
		{
			_iterShowNav ++ ; 
			if( _iterShowNav > 180 && !_barHidden )
			{ 
				var arrObjs : Array = AppSettings.stage.getObjectsUnderPoint( new Point( AppSettings.stage.mouseX , AppSettings.stage.mouseY ) ) ; 
				for( var i : int = 0 ; i < arrObjs.length ; i ++ )
				{
					if( arrObjs[ i ].name == 'topBack')
					{
						_iterShowNav = 0 ; 
						return ; 
					}
				}
				hideNavBar()  ; 
			}
		}
		
		private function onMouseMove( evt : MouseEvent ) : void
		{
			if( mouseY  > AppSettings.MOUSE_MOVE_H )
			{
				_iterShowNav = 0 ;
				if( _barHidden && !_overlay )
					showNavBar() ; 
			}
			
		}
		
		public function addOverlay() : void
		{
			_overlay = true ; 
			hideNavBar() ; 
		}
		public function removeOverlay() : void
		{
			_overlay = false ; 
			showNavBar() ; 
		}
		private function showNavBar() : void
		{
			_barHidden = false ; 
			TweenMax.killTweensOf( _footerTopLeft ) ; 
			if( AppSettings.DEVICE != AppSettings.DEVICE_TABLET )
			{
				TweenMax.to( _footerTopLeft , .5 , { y : _endFooterTopLeft_y , alpha : 1 , scaleY : 1 , ease : Quint.easeOut } ) ;
			}
			else
			{
				_footerTopLeft.mouseEnabled = true ;
				_footerTopLeft.mouseChildren = true ;
				TweenMax.to( _footerTopLeft , 1 , { alpha : 1 , alpha : 0 , ease : Quint.easeOut } ) ;
			}
			
		}
		private function hideNavBar( ) : void
		{
			_barHidden = true ;
			TweenMax.killTweensOf( _footerTopLeft ) ; 
			if( AppSettings.DEVICE != AppSettings.DEVICE_TABLET )
			{
				TweenMax.to( _footerTopLeft , 1 , { y : 5 , scaleY : 0 , alpha : 0 , ease : Quint.easeOut } ) ;	
			}
			else
			{
				_footerTopLeft.mouseEnabled = false ;
				_footerTopLeft.mouseChildren = false ;
				TweenMax.to( _footerTopLeft , 1 , { alpha : 0 , alpha : 0 , ease : Quint.easeOut } ) ;
			}
			
		}
		
		
		private function onFreeze( evt : Event ) : void
		{
			if( _tweenID ) _tweenID.pause() ; 
		}
		private function onUnFreeze( evt : Event ) : void
		{
			if( _tweenID ) _tweenID.resume() ; 
		}
		
		private function createFooterButtonsArray() : void
		{
			_footerButtons = new Dictionary( true ) ; 
			var footerButtonsList : Array = [ START_AGAIN , FIND_OUT_MORE , SHARE , LEGAL ] ;  
			var i : int = 0 ; 
			var l : int = footerButtonsList.length ; 
			for( i = 0 ; i < l ; i++ )
			{
				createButton( footerButtonsList[ i ] ) ; 
			}
		}
		
		private function onFSChange( evt : FullScreenEvent ) : void
		{
			createFooterBackgrounds() ; 
			if( evt.fullScreen )
			{
				onFS() ; 
			}
			else
			{
				onNoFS() ; 
			}
		}
		private function onFS() : void
		{
			for(var s:String in _footerButtons)
			{
				var button : PrediabetesButton  = _footerButtons[s] ; 
				var copy : TextField = button.textfield ; 
				
				var style:Object = {};
				style.fontSize = AppSettings.FOOTER_FONT_SIZE_FS ;
				style.align = "left";
				TextManager.styleText( button.id, copy , style) ; 
			}
			positionButtons() ; 
			
		}
		private function onNoFS() : void
		{
			for(var s:String in _footerButtons)
			{
				var button : PrediabetesButton  = _footerButtons[s] ; 
				var copy : TextField = button.textfield ; 
				
				var style:Object = {};
				style.fontSize = AppSettings.FOOTER_FONT_SIZE  ;
				style.align = "left";
				TextManager.styleText( button.id, copy , style) ; 	
			}
			positionButtons(); 
		}
		private function createButton( valueName : String ) : void
		{
			var style:Object = {};
			style.fontSize = AppSettings.FOOTER_FONT_SIZE;
			style.align = "left";
			
			var button : PrediabetesButton = new PrediabetesButton( valueName , style );
			button.x = 0 ; 
			button.y = 0 ; 
			button.id = valueName ; 
			_footerButtons[ valueName ] = button ;
			button.addEventListener(MouseEvent.CLICK, footerButtonClick);
		}
		
		private function createProgressBar() : void
		{
			
		}
		private function createFooterBackgrounds() : void
		{
			if(_footerBackCont && _footerBackCont.parent )
			{
				Utils.cleanContainer( _footerBackCont ) ; 
			}
			var posContainerAdder : int = 0 ; 
			var footerHeight : Number = AppSettings.RESERVED_FOOTER_HEIGHT ; 
			
			_footerBackTop = new Box( stage.stageWidth , footerHeight  , 0xffffff) ;
			_footerBackTop.alpha = 0 ; 
			if( AppSettings.FOOTER_VIDEONAV_FIXED )
			{
				footerHeight = footerHeight / 2;
				posContainerAdder = footerHeight ;
				_footerBackTop.height = footerHeight ; 
				_footerBackTop.alpha = 1 ; 
			}
			_footerBackBottom = new Box( stage.stageWidth , footerHeight  , 0xffffff ) ;
			
			_footerBackBottom.y = 0 + posContainerAdder  ;
			_footerBackTop.y = -footerHeight + posContainerAdder ;
			_footerBackCont = new Sprite() ; 
			_footerBackCont.addChild( _footerBackBottom ) ; 
			_footerBackCont.addChild( _footerBackTop ) ; 
			addChildAt( _footerBackCont , 0 ) ; 
		}
		
		private function createFooterContainers() : void
		{
			_footerBottom = new Sprite() ; 
			_footerBottomRight = new Sprite() ; 
			_footerTopRight = new Sprite() ;
			_footerTopLeft = new Sprite() ;  
			_footerTopCenter= new Sprite() ; 
			
			addChild( _footerBottom ) ; 
			addChild( _footerBottomRight ) ; 
			addChild( _footerTopRight ) ; 
			addChild( _footerTopLeft ) ; 
			addChild( _footerTopCenter ) ; 
		}
		
		private function createBottomFooter() : void
		{
			var style:Object = {};
			style.fontSize = AppSettings.FOOTER_FONT_SIZE;
			style.align = "left";
			
			var lastButton : PrediabetesButton ;
			var button: PrediabetesButton ;  

			lastButton = _footerButtons[START_AGAIN ] ; 
			_footerBottom.addChild( lastButton ) ; 
			 	
			button = _footerButtons[FIND_OUT_MORE ] ;
			//button.x = lastButton.x + lastButton.width + _buttonSpace;
			_footerBottom.addChild(button );
			lastButton = button;
			
			button = _footerButtons[ SHARE ] ;
			//button.x = lastButton.x + lastButton.width + _buttonSpace;
			_footerBottom.addChild(button );
			lastButton = button;
			
			button = _footerButtons[ LEGAL ] ;
			//button.x = lastButton.x + lastButton.width + _buttonSpace;
			_footerBottom.addChild(button );
			lastButton = button;
			
			positionButtons() ; 
		}
		private function positionButtons() : void
		{
			var i : int = 0 ; 
			var l : int = _footerBottom.numChildren ; 
			var prevButton : PrediabetesButton ; 
			for( i = 0 ; i < l ; i ++ )
			{
				if( i > 0 )
				{
					 prevButton = _footerBottom.getChildAt( i - 1 ) as PrediabetesButton ;
					var button : PrediabetesButton = _footerBottom.getChildAt( i ) as PrediabetesButton ; 
					button.x = prevButton.x  + prevButton.width + AppSettings.FOOTER_BUTTON_SPACE ;
					//button.y = ( (-i) * _buttonSpace )  //+ prevButton.width ; 
				}
			}
			
			DispatchManager.dispatchEvent( new Event( Flags.ON_REQUEST_RESIZE )) ;
		}
		
		private function createBottomRightFooter() : void
		{
			var fsb:FullScreenButton = new FullScreenButton();
			_footerBottomRight.addChild(fsb);
			fsb.x = 0 ; 
			fsb.y = 0 ; 
			fsb.id = FULL_SCREEN;
		}
		private function createTopLeftFooter() : void
		{
			_footerTopBackground = new Sprite() ; 
			_footerTopBackground.name= 'topBack' ; 
			_footerTopLeft.addChild( _footerTopBackground );
			
			if( AppSettings.FOOTER_VIDEONAV_FIXED )
			{
				_footerTopBackground.visible = true ; 
				_footerTopBackground.alpha = 0 ; 
				_footerTopBackground.y = _footerBackTop.height/2 - AppSettings.VIDEO_NAV_HEIGHT / 2 ; 
			}
			else
			{
				_footerTopBackground.y = -AppSettings.VIDEO_NAV_SIDE - AppSettings.VIDEO_NAV_HEIGHT ;
			}
			
			
			_backwardButton = new ClassFactory.BACKWARD_BUTTON();
			_footerTopLeft.addChild( _backwardButton );
			_backwardButton.id = BACKWARD_BUTTON;
			_backwardButton.visible = true;
			_backwardButton.x =  _backwardButton.width ; 
			
			_backwardButton.y =  _footerTopBackground.y + AppSettings.VIDEO_NAV_PROGRESS_BAR_Y_POS ; 
			
			_playPauseButton = new ClassFactory.PLAY_PAUSE_BUTTON();
			_footerTopLeft.addChild( _playPauseButton );
			_playPauseButton.id = PLAY_PAUSE;
			_playPauseButton.visible = true;
			_playPauseButton.x = _backwardButton.x + _backwardButton.width + AppSettings.VIDEO_NAV_BUTTON_SPACE  ; 
			_playPauseButton.y =  _footerTopBackground.y + AppSettings.VIDEO_NAV_PROGRESS_BAR_Y_POS - 2 + AppSettings.PP_FIXER_Y; 
			
			
			var snd:SoundButton = new ClassFactory.SOUND_BUTTON();
			_footerTopLeft.addChild(snd);
			snd.x = _playPauseButton.x + _playPauseButton.width + AppSettings.VIDEO_NAV_BUTTON_SPACE + AppSettings.SND_FIXER_X ; 
			snd.y =  _footerTopBackground.y + AppSettings.VIDEO_NAV_PROGRESS_BAR_Y_POS + AppSettings.SND_FIXER_Y ; 
			snd.id = SOUND;
			
			
			_progressBar = new Sprite();
			_footerTopLeft.addChild(_progressBar);
			_progressBar.y = _footerTopBackground.y + AppSettings.VIDEO_NAV_HEIGHT / 2 - AppSettings.VIDEO_NAV_PROGRESS_BAR_HEIGHT / 2;   

			var fix_x : int = snd.x + snd.width + AppSettings.VIDEO_NAV_BUTTON_SPACE  ;
			_progressBarBox = new Sprite() ;  
			_progressBarBoxHitArea = new Sprite();
			_progressBarBoxHitArea.alpha = 0 ; 
			
			_progressBarBoxHitArea.addEventListener( MouseEvent.MOUSE_DOWN , onProgressBarClick ) ;
			_progressBarBoxHitArea.buttonMode = true ; 
			_progressBarBoxHitArea.mouseEnabled = true ; 
			
			_progressBar.addChild( _progressBarBox ) ;  
			_progressBar.addChild( _progressBarBoxHitArea ) ;
			
			_progressBarBox.x = fix_x ;
			_progressBarBox.y = 0 ;
			
			_progressBarBoxHitArea.x = fix_x ;
			_progressBarBoxHitArea.y = 0 ;
		}
		private function createTopRightFooter() : void
		{
		}
		
		protected function createTopCenterFooter():void
		{
			var style:Object = {};
			style.fontSize = 13;
			style.align = "left";
			 
			 /*
			_backToVideo = new PrediabetesButton("footer_back_to_video",style);
			_footerTopCenter.addChild(_backToVideo);
			_backToVideo.graphics.beginFill(0x000000,1);
			_backToVideo.graphics.drawRect(0,0,_backToVideo.width,_backToVideo.height);
			_backToVideo.addEventListener(MouseEvent.CLICK, onBackToVideo);
			_backToVideo.visible = false ; 
			_backToVideo.y = -40 ; 
			 * 
			 */
			
			_backToVideo = new ButtonChoice( SMSettings.FONT_BUTTON, { fontSize:26  }, SMSettings.MIN_BUTTON_SIZE, 70  , false , false);
			parent.addChild( _backToVideo ) ; 
			var interaction : Object = SMController.me.model.closeButtonState ; 
			interaction.iter = Flags.BACK_TO_VIDEO_BUTTON ; 
			_backToVideo.id = Flags.BACK_TO_VIDEO_BUTTON ;
			_backToVideo.visible = false ; 
			_backToVideo.setButton( interaction ) ; 
			 
			_backToVideo.addEventListener(MouseEvent.CLICK, onBackToVideo);
			onBackToVideoResize() ; 
		}

		public function showBackToVideo() : void
		{
			_backToVideo.visible = true ; 
		}
		public function hideBackToVideo() : void
		{
			_backToVideo.visible = false ; 
		}
		
		protected function togglePauseShown(evt:Event):void
		{
			switch(evt.type)
			{
				case(Flags.SHOW_FOOTER_PLAY_PAUSE):
					_playPauseButton.visible = true ; 
				break;
				default:
					_playPauseButton.visible = true ; 
			}
		}
		
		protected function highlightFooterButton(evt:FooterEvent):void
		{
			var id:String = evt.info.buttonID;
			for(var s:String in _footerButtons){
				TweenMax.to(_footerButtons[s],0.5,{tint:null});
			}
			if(_footerButtons[id]){
				TweenMax.to(_footerButtons[id],0.5,{tint:AppSettings.WHITE});
			}
		}

		
		public function hideAllBtns(_footerFadeOutTime:Number = 2):void
		{
			
		}
		
		public function showAllBtns(_footerFadeInTime:Number = 0.5):void
		{
		
		}

		
		
		//CLICKS 
		private function activateProgressBar( evt : ObjectEvent ) : void
		{		
			
			_tween = evt.object.tween ; 
			_clip_length = evt.object.clip_length ; 
			 if( _tween )
			{
				_clip_length = _clip_length + SMSettings.SLOW_TIMER_X - 200 ;
			}
			DispatchManager.addEventListener( Event.ENTER_FRAME , onProgressBar) ;
		}
		private function deActivateProgressBar( evt : Event ) : void
		{
			DispatchManager.removeEventListener( Event.ENTER_FRAME , onProgressBar) ;
		}
		private function onProgressBar( evt : Event ) : void
		{
			var perc : Number ; 
			if( _tween )
			{
				 perc = ( SMController.me.getTooSlowTimerTime()   ) / _clip_length ; 
				 if( perc > 1 )
				{
					DispatchManager.removeEventListener( Event.ENTER_FRAME , onProgressBar) ;
					perc = 1 ; 
				}
				_progressBarBox.scaleX = perc  ;  
				_progressBarBoxHitArea.scaleX = perc ; 
			}
			else
			{
				perc = ( SMVars.me.nsStreamTimeAbs  ) / _clip_length ; 
				if( perc > 1 )
				{
					DispatchManager.removeEventListener( Event.ENTER_FRAME , onProgressBar) ;
					perc = 1 ; 
				}
				_progressBarBox.scaleX = perc  ; 
				_progressBarBoxHitArea.scaleX = perc ; 
			}
		}
		
		private function onProgressBarClick( evt : MouseEvent ) : void
		{ 
			var mouse_x_clean : Number = _footerTopLeft.mouseX - _progressBarBox.x ; //tot_pos_x ; 
			var perc_mouse_x : Number = ( mouse_x_clean * 100 ) / _progressBarAbsWidth ; 
			  
			 var time : Number = ( perc_mouse_x / 100 ) * _clip_length ; 
			 SMController.me.progressBarClick( time ) ; 
		}
		
		
		private function onBackToVideo(evt:Event):void
		{	
			_nav.onBackToVideo( ) ; 
		}
		
		protected function footerButtonClick(evt:MouseEvent):void{
			var thisGuy:String = (evt.currentTarget as PrediabetesButton).id;
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.FOOTER_CLICKED ,{value:thisGuy}));
		}

		
		public function destroy():void
		{
			removeChildren();
			stage.removeEventListener(Event.RESIZE, onResize);
		}
		
		private function onDrawProgressBar() : void
		{
			var g:Graphics ;			
			_progressBarAbsWidth = _footerTopBackground.width - _progressBarBox.x - AppSettings.VIDEO_NAV_SIDE / 2 ;//- 50 ;
			
			g = _progressBarBox.graphics;
			g.clear();
			g.beginFill( AppSettings.VIDEO_NAV_PROGRESS_BAR_COLOR , 1 ) ;
			g.drawRect
			(
				0
				, 0
				, _progressBarAbsWidth
				, AppSettings.VIDEO_NAV_PROGRESS_BAR_HEIGHT
			);
			
			g = _progressBarBoxHitArea.graphics;
			g.clear();
			g.beginFill( 0xff0099 , 1 ) ;
			var h : int = AppSettings.VIDEO_NAV_PROGRESS_BAR_HEIGHT + AppSettings.VIDEO_NAV_PROGRESS_BAR_HIT_AREA_HEIGHT ; 
			g.drawRect
			(
				0
				, AppSettings.VIDEO_NAV_PROGRESS_BAR_HEIGHT/2- h/2
				, _progressBarAbsWidth
				, h
			);
			
		}
		private function onDrawFooterTopBackground() : void
		{
			var g : Graphics ; 
			g = _footerTopBackground.graphics;
			g.clear();
			g.beginFill( AppSettings.VIDEO_NAV_COLOR , 1 ) ;
			g.drawRect
			( 0, 0
			  , AppSettings.VIDEO_WIDTH - AppSettings.VIDEO_NAV_SIDE * 2
			  , AppSettings.VIDEO_NAV_HEIGHT
			);
			_footerTopBackground.x = AppSettings.VIDEO_NAV_SIDE ; 
		}
		private function onRequestResize( evt : Event ) : void
		{
			onResize() ; 
		}
		
		private function onBackToVideoResize() : void
		{
			_backToVideo.y = 
				AppSettings.VIDEO_TOP 
				+ AppSettings.VIDEO_HEIGHT 
				- AppSettings.OVERLAY_GAP / 2 
				- SMSettings.CHOICE_BUTTON_HEIGHT 
				- AppSettings.BACK_TO_VIDEO_GAP ;
			
			_backToVideo.x = 
				AppSettings.VIDEO_LEFT 
				+ AppSettings.VIDEO_WIDTH / 2  
				- SMSettings.CHOICE_BUTTON_WIDTH / 2 ;
		}
		protected function onResize(evt:Event = null) : void 
		{
			_backToVideo.onFullScreen() ; 
			var center_x : Number = stage.stageWidth / 2 ; 
			var sw : Number = stage.stageWidth ; 
			_footerBackBottom.width = sw ; 
			_footerBackTop.width = sw ; 
			_footerBackCont.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2 - center_x ;
			
			_footerBottom.x = center_x - _footerBottom.width / 2; 
			_footerBottom.y = _footerBackBottom.y + _footerBackBottom.height / 2 - _footerBottom.height / 2 + AppSettings.FOOTER_FIX_MENU_TABLET_POSITION;  
			//_footerBackBottom.height/2 + _footerBackBottom.height - _footerBottom.height / 2 ; //( _footer_bottom_back.height * 3 ) / 3 ;  
			
			_footerTopRight.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH - _footerTopRight.width - 15 ;
			_footerTopRight.y = -_footerTopRight.height / 2 ;  
			
			_footerBottomRight.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH - _footerTopRight.width - 30 ; 
			_footerBottomRight.y = _footerBackBottom.y + _footerBackBottom.height / 2 - 7.5 ; 
			
			_footerTopLeft.x = AppSettings.VIDEO_LEFT ; 
			if( !AppSettings.FOOTER_VIDEONAV_FIXED )
			{
				_endFooterTopLeft_y = 0 ; 
				_footerTopLeft.y = _endFooterTopLeft_y ; 
				onDrawFooterTopBackground() ; 
				 
			}
			else
			{
				_endFooterTopLeft_y = -_footerBackTop.y ; ; 
				_footerTopLeft.y = _endFooterTopLeft_y ; 
				onDrawFooterTopBackground() ; 
			}
				
			
			_footerTopCenter.x = center_x ; 
			_footerTopCenter.y = _footerBackTop.height/2 ;  
			
			onDrawProgressBar() ; 
			
			if(AppSettings.VIDEO_IS_STAGE_WIDTH)
			{
				this.y = AppSettings.VIDEO_BOTTOM;//stage.stageHeight/2 + AppSettings.VIDEO_HEIGHT/2;
			
			}
			else
			{
				this.y = stage.stageHeight - AppSettings.RESERVED_FOOTER_HEIGHT;
			}
			onBackToVideoResize() ; 
		}

	}
}

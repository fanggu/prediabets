package com.refract.prediabetes.nav {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.nav.events.FooterEvent;
	import com.refract.prediabetes.nav.footer.FullScreenButton;
	import com.refract.prediabetes.nav.footer.PlayPauseButton;
	import com.refract.prediabetes.nav.footer.SoundButton;
	import com.refract.prediabetes.sections.utils.LSButton;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Box;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;


	public class Footer extends Sprite {
		
		//Flags
		private const PLAY_PAUSE:String = "PLAY_PAUSE";
		private const SOUND:String = "SOUND";
		private const FULL_SCREEN:String = "FULL_SCREEN";
		private const START_AGAIN:String = "startAgain";
		private const FIND_OUT_MORE:String = "findOutMore";
		private const SHARE:String = "share";
		private const LEGAL:String = "legal";
		
		private var _footerButtons : Dictionary ; 
		//special buttons
		private var _backToVideo:LSButton; 
		private var _playPauseButton : PlayPauseButton ; 
		
		private var _buttonSpace:int = 12;
		
		private var _progressBar : Sprite;
		private var _footerBackCont : Sprite ;
		private var _footerBackBottom : Box;
		private var _footerBackTop : Box;
		private var _footerBackMiddle : Box ; 
		
		
		private var _footerBottom : Sprite;
		protected var _footerTopCenter:Sprite;
		private var _footerTopRight : Sprite;
		private var _footerBottomRight : Sprite ; 
		
		private var _nav : Nav ;
		private var _clip_length : Number;
		
		
		private var _tween : Boolean ;
		private var _footerTopLeft : Sprite;
		private var _tweenID : TweenMax;
		
		private var _progressBarBack : Sprite;
		private var _progressBarBox : Sprite;

		public function Footer( nav : Nav ) 
		{
			_nav = nav ; 
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void
		{
			createFooterButtonsArray() ; 
			createFooterBackgrounds() ; 
			createFooterContainers() ; 
			createBottomFooter() ;
			createBottomRightFooter() ; 
			createTopRightFooter() ; 
			createTopLeftFooter() ; 
			createTopCenterFooter() ; 
			createProgressBar() ; 
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_buttonSpace : 0;

			stage.addEventListener(Event.RESIZE,onResize);
			DispatchManager.addEventListener(FooterEvent.HIGHLIGHT_BUTTON, highlightFooterButton);
			DispatchManager.addEventListener(Flags.SHOW_FOOTER_PLAY_PAUSE, togglePauseShown);
			DispatchManager.addEventListener(Flags.HIDE_FOOTER_PLAY_PAUSE, togglePauseShown);
			DispatchManager.addEventListener(Flags.ACTIVATE_PROGRESS_BAR , activateProgressBar);
			DispatchManager.addEventListener(Flags.DE_ACTIVATE_PROGRESS_BAR , deActivateProgressBar);
			
			DispatchManager.addEventListener(Flags.FREEZE , onFreeze);
			DispatchManager.addEventListener(Flags.UN_FREEZE , onUnFreeze); 
			
			onResize();
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
		
		private function createButton( valueName : String ) : void
		{
			var style:Object = {};
			style.fontSize = AppSettings.FOOTER_FONT_SIZE;
			style.align = "left";
			
			var button : LSButton = new LSButton( valueName , style );
			//_footerBottom.addChild(button);
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
			_footerBackBottom = new Box( stage.stageWidth , AppSettings.RESERVED_FOOTER_HEIGHT / 2 - 2 , 0xff0099) ;
			_footerBackMiddle = new Box( stage.stageWidth , 2 , 0x000000 ) ;
			_footerBackTop = new Box( stage.stageWidth , AppSettings.RESERVED_FOOTER_HEIGHT / 2 - 2 , 0xff9966) ;
			_footerBackTop.y = AppSettings.RESERVED_FOOTER_HEIGHT / 2  ;
			_footerBackMiddle.y = AppSettings.RESERVED_FOOTER_HEIGHT / 2 - 2 ; 
			_footerBackCont = new Sprite() ; 
			_footerBackCont.addChild( _footerBackBottom ) ; 
			_footerBackCont.addChild( _footerBackMiddle ) ; 
			_footerBackCont.addChild( _footerBackTop ) ; 
			addChild( _footerBackCont ) ; 
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
			
			var lastButton : LSButton ;
			var button: LSButton ;  

			lastButton = _footerButtons[START_AGAIN ] ; 
			_footerBottom.addChild( lastButton ) ; 
			 	
			button = _footerButtons[FIND_OUT_MORE ] ;
			button.x = lastButton.x + lastButton.width + _buttonSpace;
			_footerBottom.addChild(button );
			lastButton = button;
			
			button = _footerButtons[ SHARE ] ;
			button.x = lastButton.x + lastButton.width + _buttonSpace;
			_footerBottom.addChild(button );
			lastButton = button;
			
			button = _footerButtons[ LEGAL ] ;
			button.x = lastButton.x + lastButton.width + _buttonSpace;
			_footerBottom.addChild(button );
			lastButton = button;
			
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
			_playPauseButton = new PlayPauseButton();
			_footerTopLeft.addChild( _playPauseButton );
			_playPauseButton.id = PLAY_PAUSE;
			_playPauseButton.visible = true;
			
			
			var snd:SoundButton = new SoundButton();
			_footerTopLeft.addChild(snd);
			snd.x = _playPauseButton.width + 20  ; 
			snd.y = snd.height / 2 ; 
			snd.id = SOUND;
			
			
			_progressBar = new Sprite();
			_footerTopLeft.addChild(_progressBar);
			_progressBar.y = -_progressBar.height /2 ; 
			 
			
			var fix_x : int = snd.x + snd.width + 20 ;
			_progressBarBack    = new Sprite() ;  
			_progressBarBox = new Sprite() ;  

			_progressBar.addChild( _progressBarBack ) ; 
			_progressBar.addChild( _progressBarBox ) ;  
			_progressBarBox.x = fix_x ;
			_progressBarBack.x = fix_x - 4 ;
			_progressBarBox.y = 2 ;
			 
			_progressBar.y = 10 ;
			//_progressBar.x = - _progressBar.width / 2 ; 
		}
		private function createTopRightFooter() : void
		{
			
			
			
			
			
			
				
			
			
		}
		
		protected function createTopCenterFooter():void
		{
			var style:Object = {};
			style.fontSize = 13;
			style.align = "left";
			 
			_backToVideo = new LSButton("footer_back_to_video",style);
			_footerTopCenter.addChild(_backToVideo);
			_backToVideo.graphics.beginFill(0x000000,1);
			_backToVideo.graphics.drawRect(0,0,_backToVideo.width,_backToVideo.height);
			_backToVideo.addEventListener(MouseEvent.CLICK, onBackToVideo);
			_backToVideo.visible = false ; 
			_backToVideo.y = -40 ; 
			
			
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
			switch(evt.type){
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
			_clip_length = Number( evt.object.clip_length ) 
			if( _tween )
				_clip_length = _clip_length + SMSettings.SLOW_TIMER_X ;
			 
			addEventListener( Event.ENTER_FRAME , onProgressBar) ;
		}
		private function deActivateProgressBar( evt : Event ) : void
		{
			removeEventListener( Event.ENTER_FRAME , onProgressBar) ;
		}
		private function onProgressBar( evt : Event ) : void
		{
			var perc : Number ; 
			if( _tween )
			{
				removeEventListener( Event.ENTER_FRAME , onProgressBar) ;
				_progressBarBox.scaleX = 0 ; 
				_tweenID = new TweenMax( _progressBarBox , _clip_length / 1000 , { scaleX : 1 , ease : Linear.easeNone } ) ; 
			}
			else
			{
				perc = (SMVars.me.nsStreamTimeAbs  ) / _clip_length ; 
				if( perc > 1 ) perc = 1 ; 
				
				_progressBarBox.scaleX = perc  ; 
			}
			
		}
		private function onBackToVideo(evt:Event):void
		{	
			_nav.onBackToVideo( ) ; 
		}
		
		protected function footerButtonClick(evt:MouseEvent):void{
			var thisGuy:String = (evt.currentTarget as LSButton).id;
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.FOOTER_CLICKED ,{value:thisGuy}));
		}

		
		public function destroy():void
		{
			removeChildren();
			stage.removeEventListener(Event.RESIZE, onResize);
		}
		
		private function onDrawProgressBar() : void
		{
			var g:Graphics = _progressBarBack.graphics;
			g.clear();
			g.beginFill( 0xff0000 , 1 ) ;
			g.drawRect
			(
				0
				, 0
				, AppSettings.VIDEO_WIDTH - _progressBarBack.x + 8 - 50
				, 10
			);
			
			var g:Graphics = _progressBarBox.graphics;
			g.clear();
			g.beginFill( 0xfff000 , 1 ) ;
			g.drawRect
			(
				0
				, 0
				, AppSettings.VIDEO_WIDTH - _progressBarBack.x - 50
				, 6
			);
		}
		
		protected function onResize(evt:Event = null) : void 
		{
			var center_x : Number = stage.stageWidth / 2 ; 
			var sw : Number = stage.stageWidth ; 
			_footerBackBottom.width = sw ; 
			_footerBackTop.width = sw ; 
			_footerBackMiddle.width = sw ; 
			_footerBackCont.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2 - center_x ;
			
			_footerBottom.x = center_x - _footerBottom.width / 2; 
			_footerBottom.y = _footerBackBottom.height/2 + _footerBackBottom.height - _footerBottom.height / 2 ; //( _footer_bottom_back.height * 3 ) / 3 ;  
			
			_footerTopRight.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH - _footerTopRight.width - 15 ;
			_footerTopRight.y = -_footerTopRight.height / 2 ;  
			
			_footerBottomRight.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH - _footerTopRight.width - 15 ;
			_footerBottomRight.y = _footerBackBottom.height/2 + _footerBackBottom.height ; //- _footerBottomRight.height / 2 ;  
			
			_footerTopLeft.x = AppSettings.VIDEO_LEFT + 20  ; //+ AppSettings.VIDEO_WIDTH - _footerTopRight.width - 15 ;
			//_footerTopLeft.y = -_footerTopLeft.height / 2 ;  
			
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
		}
		
	}
}

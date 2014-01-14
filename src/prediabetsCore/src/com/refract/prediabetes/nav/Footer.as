package com.refract.prediabetes.nav {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.nav.events.FooterEvent;
	import com.refract.prediabetes.nav.footer.FullScreenButton;
	import com.refract.prediabetes.nav.footer.PlayPauseButton;
	import com.refract.prediabetes.nav.footer.SoundButton;
	import com.refract.prediabetes.sections.utils.LSButton;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Box;

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
		
		private var _nav : Nav ;
		private var _clip_length : Number;
		private var _progressBarBox : Box;
		
		private var _tween : Boolean ; 

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
			createTopRightFooter() ; 
			createTopCenterFooter() ; 
			createProgressBar() ; 
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_buttonSpace = AppSettings.PLATFORM == AppSettings.PLATFORM_PC ? _buttonSpace : 0;//AppSettings.FONT_SCALE_FACTOR*_buttonSpace;
			//_buttonY = AppSettings.FONT_SCALE_FACTOR*_buttonY;

			stage.addEventListener(Event.RESIZE,onResize);
			DispatchManager.addEventListener(FooterEvent.HIGHLIGHT_BUTTON, highlightFooterButton);
			DispatchManager.addEventListener(Flags.SHOW_FOOTER_PLAY_PAUSE, togglePauseShown);
			DispatchManager.addEventListener(Flags.HIDE_FOOTER_PLAY_PAUSE, togglePauseShown);
			DispatchManager.addEventListener(Flags.ACTIVATE_PROGRESS_BAR , activateProgressBar);
			DispatchManager.addEventListener(Flags.DE_ACTIVATE_PROGRESS_BAR , deActivateProgressBar);
			
			onResize();
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
			_footerBackTop = new Box( stage.stageWidth , AppSettings.RESERVED_FOOTER_HEIGHT / 2 - 2 , 0xfff000) ;
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
			_footerTopRight = new Sprite() ; 
			_footerTopCenter= new Sprite() ; 
			
			addChild( _footerBottom ) ; 
			addChild( _footerTopRight ) ; 
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
		private function createTopRightFooter() : void
		{
			var style:Object = {};
			style.fontSize = 13;
			style.align = "left";
			
			var lastButton : * ;
			 
			_backToVideo = new LSButton("footer_back_to_video",style);
			addChild(_backToVideo);
			_backToVideo.graphics.beginFill(0x000000,1);
			_backToVideo.graphics.drawRect(0,0,_backToVideo.width,_backToVideo.height);
			_backToVideo.addEventListener(MouseEvent.CLICK, onBackToVideo);
			_backToVideo.visible = false ; 
			
			
			var snd:SoundButton = new SoundButton();
			_footerTopRight.addChild(snd);
			snd.x = 0 + _buttonSpace;
			snd.y = 12 + 6;
			snd.id = SOUND;
			
			lastButton = snd;
				
			var fsb:FullScreenButton = new FullScreenButton();
			_footerTopRight.addChild(fsb);
			fsb.x = lastButton.x + lastButton.width + _buttonSpace;
			fsb.y = 12 + 4;
			fsb.id = FULL_SCREEN;
			
		}
		
		protected function createTopCenterFooter():void
		{
			_playPauseButton = new PlayPauseButton();
			_footerTopCenter.addChild( _playPauseButton );
			_playPauseButton.x = -_playPauseButton.width/2;
			_playPauseButton.y = 0 ; //12 + 2;
			_playPauseButton.id = PLAY_PAUSE;
			
			_playPauseButton.visible = false;
			
			_progressBar = new Sprite();
			_footerTopCenter.addChild(_progressBar);
			_progressBar.y = -_progressBar.height /2 ; 
			
			var progressBarBackground : Box = new Box( 506 , 12 , 0x00ff00) ; 
			_progressBarBox  = new Box( 500 , 10 , 0xfff000 ) ; 
			
			//_bar = createSquare( 0xc45252  , 1 , 8) ; 
			
			_progressBar.addChild( progressBarBackground ) ;
			_progressBar.addChild( _progressBarBox ) ;  
			_progressBarBox.x = 3 ;
			_progressBarBox.y = 1 ; 
			
			_progressBar.x = - _progressBar.width / 2 ; 
		}
		
		
		
		private function createSquare( color : uint , w : int , h : int  , alpha : Number = 1 , corner_w : Number = 1 , corner_h : Number = 1) : Sprite
		{
			/*
			var spr:Sprite = new Sprite();
			spr.graphics.lineStyle( 0 , color ) ;
			spr.graphics.beginFill( color );
			spr.graphics.drawRect( 0, 0, w, h );
			spr.graphics.endFill( );
			spr.alpha = alpha ; 
			spr.x = -spr.width/2 ;
			spr.y = -spr.height/2;
			return spr ; 
			 * 
			 */
			
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(color);
			spr.graphics.drawRoundRect(0 , 0 , w , h , corner_w , corner_h );
			spr.graphics.endFill( );
			spr.alpha =  alpha ; 
			spr.x = -spr.width/2 ;
			spr.y = -spr.height/2;
			return spr ; 
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
					_playPauseButton.visible = false ; 
					
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

		
		
		
		/*
		 * 
		 * CLICKS
		 * 
		 */
		 
		private function activateProgressBar( evt : ObjectEvent ) : void
		{		
			_tween = evt.object.tween ; 
			_clip_length = Number( evt.object.clip_length ) ;
			 
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
				TweenMax.to( _progressBarBox , _clip_length / 1000 ,{ scaleX : 1 , ease : Linear.easeNone } ) ; 
				trace('yes? ' , _clip_length )
			}
			else
			{
				perc = (SMVars.me.nsStreamTime * 100 ) / _clip_length ; 
				_progressBarBox.scaleX = perc / 100 ; 
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
		/*
		public function get progressBar():Sprite 
		{ 
			return _progressBar; 
		}
		 * 
		 */
		
		public function destroy():void
		{
			removeChildren();
			stage.removeEventListener(Event.RESIZE, onResize);
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
			
			
			_footerTopCenter.x = center_x ; 
			_footerTopCenter.y = _footerTopCenter.height /2 ;  
			
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

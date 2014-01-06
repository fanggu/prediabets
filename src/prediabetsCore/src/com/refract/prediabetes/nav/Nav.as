package com.refract.prediabetes.nav {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppController;
	import com.refract.prediabetes.AppSections;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.nav.events.FooterEvent;
	import com.refract.prediabetes.sections.intro.Intro;
	import com.refract.prediabetes.sections.utils.LSButton;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;

	
	public class Nav extends Sprite 
	{	
		public static const NO_MORE_OVERLAYS : String = "NO_MORE_OVERLAYS";
		
		protected var _header:Header;
		protected var _footer : Footer;
		protected var _overlayShown:Boolean = false;

		protected var _overlayLayer:Sprite;
		protected var _currentOverlay:Sprite;
		protected var _prevOverlay : Sprite;
		private var _blackGraphics : Sprite ; 
		
		protected var _backToVideo:LSButton;
		
		protected var _fadeInTime:Number = 0.5;
		protected var _fadeOutTime:Number = 2;
		protected var _fadeDelay:Number = 5;
		protected var fadeTime:Number = 0.5;
		
		
		public function Nav() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		protected function init(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_blackGraphics = new Sprite() ; 
			addChild( _blackGraphics ) ; 
			_blackGraphics.alpha = .5 ; 
			
			_overlayLayer = new Sprite();
			addChild(_overlayLayer);

			var style:Object = {};
			style.fontSize = 13;
			style.align = "left";
			
			_backToVideo = new LSButton("footer_back_to_video",style);
			addChild(_backToVideo);
			_backToVideo.graphics.beginFill(0x000000,1);
			_backToVideo.graphics.drawRect(0,0,_backToVideo.width,_backToVideo.height);
			removeChild(_backToVideo);
			_backToVideo.addEventListener(MouseEvent.CLICK, onBackToVideo);

			_header = new ClassFactory.HEADER();
			addChild(_header);
			_header.alpha = 0 ; 
			_header.addEventListener(FooterEvent.FOOTER_CLICKED, onNavClicked);
			
			_footer = new ClassFactory.FOOTER();
			addChild(_footer);
			DispatchManager.addEventListener(FooterEvent.FOOTER_CLICKED, onNavClicked);
			
			
			DispatchManager.addEventListener(Flags.STATE_MACHINE_START, onSMStart);
			DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onSMEnd);
			
			DispatchManager.addEventListener(AppSettings.REQUEST_FULL_SCREEN_INTERACTIVE, onFSIRequest);
			
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}
		
		
		
		protected function onSMStart(evt:Event):void{
			startShowHandler();
		}
		
		protected function onSMEnd(evt:Event):void{
			stopShowHandler();
		}

		
		protected function startShowHandler():void{
			_footer.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverForAutoHide);
			_header.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverForAutoHide);
			TweenMax.killTweensOf(this);
			TweenMax.to(this,_fadeOutTime,{delay:_fadeDelay,onStart:hideAllBtns});
		}
		
		protected function stopShowHandler():void{
			onMouseOverForAutoHide();
			_footer.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutForAutoHide);
			_header.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutForAutoHide);
		}
		
		protected function onMouseOverForAutoHide(evt:MouseEvent = null):void{
			_footer.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverForAutoHide);
			_header.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverForAutoHide);
			_footer.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutForAutoHide);
			_header.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutForAutoHide);
			_footer.showAllBtns(_fadeInTime);
			_header.showAllBtns(_fadeInTime);
		}
		
		protected function onMouseOutForAutoHide(evt:MouseEvent = null):void{
			_footer.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutForAutoHide);
			_header.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutForAutoHide);
		//	footer.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverForAutoHide);
			startShowHandler();
		}
		
		protected function hideAllBtns():void{
			_footer.hideAllBtns(_fadeOutTime);
			_header.hideAllBtns(_fadeOutTime);
		}
		
		public function addSection(name:String,suppressAnim:Boolean = false):void{
			switch("SECTION:"+name){
				
				case(AppSections.LEGAL):
					addOverlay(ClassFactory.LEGAL);
					break;
				
				case(AppSections.FEEDBACK):
					addOverlay(ClassFactory.FEEDBACK);
					break;
				
				case(AppSections.SHARE):
					addOverlay(ClassFactory.SHARE);
					break;
				case(AppSections.BOOK_A_COURSE):
					addOverlay(ClassFactory.BOOK_A_COURSE);
					break;
			}
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.HIGHLIGHT_BUTTON,{buttonID:"SECTION:"+name}));
		}
		
		
		
		
		
		public function addOverlay(overlay:Class ):void
		{
			DispatchManager.dispatchEvent(new Event(Flags.FREEZE));
			if(_currentOverlay)
			{
				_prevOverlay = _currentOverlay ; 
				removeCurrentOverlay(null,true);
			}
			
			DispatchManager.dispatchEvent(new Event(Intro.INTRO_VIDEO_PAUSE));
			
			_overlayShown = true;
			_currentOverlay = new overlay();
			
			_overlayLayer.addChild(_currentOverlay);
			_currentOverlay.alpha = 0;

			TweenMax.to(_backToVideo,fadeTime,{autoAlpha:1});
			TweenMax.to(_currentOverlay,fadeTime,{autoAlpha:1});

			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.ADD_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_backToVideo}));
			onResize();
		}

		public function removeCurrentOverlay(evt:Event = null,hasNextOverlay:Boolean = false):void{
			if(_currentOverlay)
			{
				_blackGraphics.graphics.clear();
				
				TweenMax.to(_currentOverlay,fadeTime,{autoAlpha:0,onComplete:overlayRemoved,onCompleteParams:[_currentOverlay]});
				TweenMax.to(_backToVideo,fadeTime,{autoAlpha:0});
				//TweenMax.to(_coverBt,fadeTime,{autoAlpha:0});
				if(!hasNextOverlay){
					_currentOverlay = null;
					_overlayShown = false;
					
					DispatchManager.dispatchEvent(new Event(Flags.UN_FREEZE));
					DispatchManager.dispatchEvent(new Event(Intro.INTRO_VIDEO_UNPAUSE));
					DispatchManager.dispatchEvent(new Event(NO_MORE_OVERLAYS));
					DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.HIGHLIGHT_BUTTON,{buttonID:null}));
				}
			}
			
		}
		
		protected function overlayRemoved(overlay:DisplayObject):void
		{
			overlay["destroy"]();
			_overlayLayer.removeChild(overlay);
		}

		public function requestFSInteractive() : void
		{
			
		}
		
		protected function onFSIRequest(evt:MouseEvent):void{
			stage.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED,onFSInteractiveAccepted);
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		protected function onFSInteractiveAccepted(evt:FullScreenEvent):void{
			//AppSettings.FullScreenInteractiveAllowed = true;
			
		}
		
		protected function onNavClicked(evt : FooterEvent) : void 
		{
			var obj:Object = evt.info;
			switch(obj.value){
				case(Header.LS_LOGO):
					AppController.i.setSWFAddress(AppSections.INTRO);
					removeCurrentOverlay();
					break;
		
				case(AppSections.LEGAL):
					AppController.i.setSWFAddress(AppSections.LEGAL);
					break;
			
				case(AppSections.BOOK_A_COURSE):
					AppController.i.setSWFAddress(AppSections.BOOK_A_COURSE);
					break;
				case(AppSections.FEEDBACK):
					AppController.i.setSWFAddress(AppSections.FEEDBACK);
					break;
				
				case(AppSections.SHARE):
					AppController.i.setSWFAddress(AppSections.SHARE);
					break;
				
				default:
			}
		}
		
		protected function onUpdatePlayButton( evt : Event ) : void
		{
			DispatchManager.dispatchEvent(new Event(Flags.SHOW_FOOTER_PLAY_PAUSE) ) ;
		}
		protected function onResize(evt:Event = null):void
		{
			if(_overlayShown)
			{
				_blackGraphics.graphics.clear();
				_blackGraphics.graphics.beginFill(0x0,1);
				_blackGraphics.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			}
		}
		protected function onBackToVideo(evt:Event):void
		{	
			removeCurrentOverlay();
		}
		
		
		public function get footer():Footer
		{ 
			return _footer; 
		}
		public function get overlayShown():Boolean 
		{
			return _overlayShown;
		}
	}
}

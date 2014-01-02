package com.refract.prediabets.components.nav {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSections;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.ClassFactory;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.components.events.FooterEvent;
	import com.refract.prediabets.components.intro.Intro;
	import com.refract.prediabets.components.sceneselector.SceneSelectorQuestions;
	import com.refract.prediabets.components.shared.LSButton;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.refract.prediabets.user.UserModel;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;

	/**
	 * @author kanish
	 */
	public class Nav extends Sprite {
		
		public static const CLOSE_OVERLAY:String = "CLOSE_OVERLAY";
		
		public static const SHOW_SCENE_SELECTOR:String = "SHOW_SCENE_SELECTOR";
		public static const SHOW_ABOUT : String = "SHOW_ABOUT";
		public static const NO_MORE_OVERLAYS : String = "NO_MORE_OVERLAYS";
		
		protected var _header:Header;
		protected var _footer : Footer;
		
		public function get footer():Footer{ return _footer; }
		
		
		
		protected var _overlayShown:Boolean = false;
		public function get overlayShown():Boolean {return _overlayShown;}
		
		protected var _overlayLayer:Sprite;
		protected var _blackOverlay:Sprite;
		protected var _blackGraphics:Graphics;
		protected var _bkgs:Vector.<Bitmap>;
		
		protected var _currentOverlay:Sprite;
		protected var _prevOverlay : Sprite;
		
		protected var _backToVideo:LSButton;
		//protected var _coverBt : LSButton ;
		
		
		public function Nav() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		protected var _closeButton:LSButton;
		
		protected function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			_overlayLayer = new Sprite();
			addChild(_overlayLayer);
			
			
			_blackOverlay = new Sprite();
			_blackGraphics = _blackOverlay.graphics;
			_blackOverlay.visible = false;
	
			_bkgs = new Vector.<Bitmap>();
			
	 		var bkg:Bitmap;
			for(var i:int = 0; i < 9; ++i){
				if( AssetManager.hasEmbeddedAsset("BKG_0"+i)){
					bkg = AssetManager.getEmbeddedAsset("BKG_0"+i) as Bitmap;
					bkg.smoothing = true;
					_blackOverlay.addChild(bkg);
					bkg.alpha = 0.3;
				//	bkg.visible = false;
					_bkgs.push(bkg);
				}
				
			}
			
			var style:Object = {};
			style.fontSize = 13;
			style.align = "left";
			
			_backToVideo = new LSButton("footer_back_to_video",style);
			addChild(_backToVideo);
		//	_backToVideo.visible = false;
			_backToVideo.graphics.beginFill(0x000000,1);
			_backToVideo.graphics.drawRect(0,0,_backToVideo.width,_backToVideo.height);
			removeChild(_backToVideo);
			_backToVideo.addEventListener(MouseEvent.CLICK, onBackToVideo);
			
			/*_coverBt = new LSButton("buttonFont",style);	
			addChild(_coverBt);
			_coverBt.text = '';
			_coverBt.useHandCursor = false ;
			_coverBt.graphics.beginFill(0x000000 , 1 ) ;
			_coverBt.graphics.drawRect(0,0,_backToVideo.width,_backToVideo.height);
			removeChild(_coverBt);
			//_coverBt.addEventListener(MouseEvent.CLICK, onBackToVideo);
			*/
			_blackOverlay.addEventListener(MouseEvent.CLICK, fakeListener,true);
			_blackOverlay.addEventListener(MouseEvent.MOUSE_OVER, fakeListener,true);
			_blackOverlay.addEventListener(MouseEvent.MOUSE_OUT, fakeListener,true);
			_overlayLayer.addChild(_blackOverlay);
			
			
			
			_closeButton = new LSButton("overlay_close",{fontSize:36},190,70,true,false);
		//	_overlayLayer.addChild(_closeButton);
			_closeButton.addEventListener(MouseEvent.CLICK, onClose);
			_closeButton.visible = false;
			
			
		
		
			_header = new ClassFactory.HEADER();
			addChild(_header);
			_header.addEventListener(FooterEvent.FOOTER_CLICKED, onNavClicked);
			
			_footer = new ClassFactory.FOOTER();
			addChild(_footer);
			DispatchManager.addEventListener(FooterEvent.FOOTER_CLICKED, onNavClicked);
			
			
			DispatchManager.addEventListener(Flags.STATE_MACHINE_START, onSMStart);
			DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onSMEnd);
			
			DispatchManager.addEventListener(CLOSE_OVERLAY, removeCurrentOverlay);
			
			DispatchManager.addEventListener(AppSettings.REQUEST_FULL_SCREEN_INTERACTIVE, onFSIRequest);
			
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}
		
		protected var _fadeInTime:Number = 0.5;
		protected var _fadeOutTime:Number = 2;
		protected var _fadeDelay:Number = 5;
		
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
		//	TweenMax.killTweensOf(_leftSide);
		//	TweenMax.to(_leftSide,_footerFadeOutTime,{autoAlpha:0,delay:_footerFadeDelay,onStart:hideAllBtns});
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
		
		protected function onFSIRequest(evt:MouseEvent):void{
			stage.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED,onFSInteractiveAccepted);
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		
		protected function onFSInteractiveAccepted(evt:FullScreenEvent):void{
			//AppSettings.FullScreenInteractiveAllowed = true;
			
		}
		
		/*
		 * TODO: 
		 * 		EMERGENCY_INFO
		 * 		CONTACT_US Backend
		 * 
		 */
		protected function onNavClicked(evt : FooterEvent) : void 
		{
			var obj:Object = evt.info;
			switch(obj.value){
				case(Header.LS_LOGO):
					AppController.i.setSWFAddress(AppSections.INTRO);
					removeCurrentOverlay();
				
					break;
				case(Footer.MENU):
					
					break;
				case(AppSections.SCENE_SELECTOR):
					//DispatchManager.dispatchEvent(new Event( Flags.SM_RESET)) ;
					if( AppController.i.nextStory != 4)
					{
						addOverlay(ClassFactory.SCENE_SELECTOR);
						DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.HIGHLIGHT_BUTTON,{buttonID:AppSections.SCENE_SELECTOR}));
					}
					else
					{
						
						addOverlay(ClassFactory.SCENE_SELECTOR_QUESTIONS);
						//DispatchManager.dispatchEvent(new Event( Flags.SM_RESET)) ;
					}
					
					break;
				case(AppSections.SCENE_SELECTOR_QUESTIONS):
					DispatchManager.dispatchEvent(new Event( Flags.SM_RESET)) ;
					addOverlay(ClassFactory.SCENE_SELECTOR_QUESTIONS);
					//
					break;
				case(AppSections.ABOUT):
					AppController.i.setSWFAddress(AppSections.ABOUT);
					break;
				case(AppSections.CREDITS):
					AppController.i.setSWFAddress(AppSections.CREDITS);
					break;
				case(AppSections.LEGAL):
					AppController.i.setSWFAddress(AppSections.LEGAL);
					break;
				case(AppSections.MEDICAL_QUESTIONS):
					AppController.i.setSWFAddress(AppSections.MEDICAL_QUESTIONS);
					break;
				case(AppSections.BOOK_A_COURSE):
					AppController.i.setSWFAddress(AppSections.BOOK_A_COURSE);
					
					//AppSettings.goToLink(AppSettings.COURSE_URL);
					break;
				case(AppSections.FEEDBACK):
					AppController.i.setSWFAddress(AppSections.FEEDBACK);
					break;
				case(AppSections.GET_THE_APP):
					AppController.i.setSWFAddress(AppSections.GET_THE_APP);
					break;
				case(AppSections.SHARE):
					AppController.i.setSWFAddress(AppSections.SHARE);
					break;
				case(AppSections.EMERGENCY_INFO):
					AppController.i.setSWFAddress(AppSections.EMERGENCY_INFO);
					break;
				case(AppSections.PROFILE):
					AppController.i.setSWFAddress(AppSections.PROFILE);
					break;
				case(AppSections.LOGIN):
					AppController.i.setSWFAddress(AppSections.LOGIN);
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
			if(_overlayShown){
				_blackGraphics.clear();
				_blackGraphics.beginFill(0x0,1);
				_blackGraphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				
				for(var i:int = 0; i < _bkgs.length; ++i){
					_bkgs[i].width = AppSettings.VIDEO_WIDTH;
					_bkgs[i].height = AppSettings.VIDEO_HEIGHT;
					_bkgs[i].x = AppSettings.VIDEO_LEFT;
					_bkgs[i].y = AppSettings.VIDEO_TOP;
				}
				
				_closeButton.x = this.width/2 - _closeButton.width/2;
				_closeButton.y = AppSettings.VIDEO_BOTTOM - _closeButton.height - 5;
			}
		}
		
		protected function onClose(evt:MouseEvent):void{
			DispatchManager.dispatchEvent(new Event(Nav.CLOSE_OVERLAY));
		}
		

		protected var fadeTime:Number = 0.5;
		
		public function addSection(name:String,suppressAnim:Boolean = false):void{
			switch("SECTION:"+name){
				case(AppSections.ABOUT):
					addOverlay(ClassFactory.ABOUT);
					break;
				case(AppSections.CREDITS):
					addOverlay(ClassFactory.CREDITS);
					break;
				case(AppSections.LEGAL):
					addOverlay(ClassFactory.LEGAL);
					break;
				case(AppSections.MEDICAL_QUESTIONS):
					addOverlay(ClassFactory.MEDICAL_QUESTIONS);
					break;
				case(AppSections.FEEDBACK):
					addOverlay(ClassFactory.FEEDBACK);
					break;
				case(AppSections.GET_THE_APP):
					addOverlay(ClassFactory.GET_THE_APP);
					break;
				case(AppSections.SHARE):
					addOverlay(ClassFactory.SHARE);
					break;
				case(AppSections.BOOK_A_COURSE):
					addOverlay(ClassFactory.BOOK_A_COURSE);
					break;
				case(AppSections.EMERGENCY_INFO):
					addOverlay(ClassFactory.EMERGENCY_INFO);
					break;
				case(AppSections.PROFILE):
					addOverlay(ClassFactory.PROFILE);
					break;
				case(AppSections.RESULTS):
					
					addOverlay(ClassFactory.RESULTS,suppressAnim);
					break;
			}
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.HIGHLIGHT_BUTTON,{buttonID:"SECTION:"+name}));
		}
		
		
		protected function onBackToVideo(evt:Event):void{	
			removeCurrentOverlay();
			if( _prevOverlay is SceneSelectorQuestions && AppController.i.nextStory == 4)
			{
				_prevOverlay = null ; 
				addOverlay(ClassFactory.SCENE_SELECTOR_QUESTIONS);
			}
			
		}
		
		
		public function addOverlay(overlay:Class,supressAnim:Boolean = false):void
		{
			DispatchManager.dispatchEvent(new Event(Flags.FREEZE));
			if(_currentOverlay)
			{
				_prevOverlay = _currentOverlay ; 
				removeCurrentOverlay(null,true);
			}
			
			DispatchManager.dispatchEvent(new Event(Intro.INTRO_VIDEO_PAUSE));
			
			_overlayShown = true;
			if(overlay == ClassFactory.RESULTS){
				_currentOverlay = new overlay(supressAnim);
			}else{
				_currentOverlay = new overlay();
			}
			
			
			
			_overlayLayer.addChildAt(_currentOverlay,1);
			_currentOverlay.alpha = 0;
			//_blackOverlay.alpha = 0;
			if(_blackOverlay.visible == false){
				var magicNumber:int = Math.round(Math.random()*(_bkgs.length-1));
				for(var i:int = 0; i < _bkgs.length; ++i){
					if(i == magicNumber){
						_bkgs[i].visible = true;
					}else{
						_bkgs[i].visible = false;
					}
				}
			}
			TweenMax.to(_backToVideo,fadeTime,{autoAlpha:1});
			TweenMax.to(_currentOverlay,fadeTime,{autoAlpha:1});
			TweenMax.to(_blackOverlay,fadeTime,{autoAlpha:1});
			if(_currentOverlay.hasOwnProperty("useClose") && _currentOverlay["useClose"] == true){
				_closeButton.visible = true;
				_closeButton.alpha = 0;
				TweenMax.to(_closeButton,fadeTime,{autoAlpha:1});
			}else{
				_closeButton.visible = false;
			}

			switch( overlay )
			{
				case ClassFactory.RESULTS:
				break;
				case ClassFactory.SCENE_SELECTOR_QUESTIONS :
					//DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.ADD_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_coverBt}));
				break ;
				default :
					DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.ADD_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_backToVideo}));
			}
			onResize();
		}
		protected function fakeListener(evt:Event):void{
			evt.stopImmediatePropagation();
		}
		
		public function removeCurrentOverlay(evt:Event = null,hasNextOverlay:Boolean = false):void{
			if(_currentOverlay)
			{
				TweenMax.to(_currentOverlay,fadeTime,{autoAlpha:0,onComplete:overlayRemoved,onCompleteParams:[_currentOverlay]});
				TweenMax.to(_backToVideo,fadeTime,{autoAlpha:0});
				//TweenMax.to(_coverBt,fadeTime,{autoAlpha:0});
				if(!hasNextOverlay){
					_currentOverlay = null;
					_overlayShown = false;
					TweenMax.to(_blackOverlay,fadeTime,{autoAlpha:0});
					TweenMax.to(_closeButton,fadeTime,{autoAlpha:0,onComplete:DispatchManager.dispatchEvent,onCompleteParams:[new FooterEvent(FooterEvent.REMOVE_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_backToVideo})]});
					//TweenMax.to(_closeButton,fadeTime,{autoAlpha:0,onComplete:DispatchManager.dispatchEvent,onCompleteParams:[new FooterEvent(FooterEvent.REMOVE_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_coverBt})]});
			//		DispatchManager.dispatchEvent();
			
					DispatchManager.dispatchEvent(new Event(Flags.UN_FREEZE));
					DispatchManager.dispatchEvent(new Event(Intro.INTRO_VIDEO_UNPAUSE));
					DispatchManager.dispatchEvent(new Event(NO_MORE_OVERLAYS));
					DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.HIGHLIGHT_BUTTON,{buttonID:null}));
				}
			}
			
		}
		
		protected function overlayRemoved(overlay:DisplayObject):void{
			overlay["destroy"]();
			_overlayLayer.removeChild(overlay);
		//	_blackGraphics.clear();
		//	_closeButton.visible = false;
			_blackOverlay.removeEventListener(MouseEvent.CLICK, fakeListener);
		}

		public function requestFSInteractive() : void {
			
		}
	}
}

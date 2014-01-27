package com.refract.prediabetes.nav {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppController;
	import com.refract.prediabetes.AppSections;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.nav.events.FooterEvent;
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
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
		protected var _fadeInTime:Number = 0.5;
		protected var _fadeOutTime:Number = 2;
		protected var _fadeDelay:Number = 5;
		protected var fadeTime : Number = 0.5;
		private var _overlayBackground : Sprite;
		
		
		public function Nav() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		protected function init(evt:Event):void
		{
			trace("::nav init::")
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_blackGraphics = new Sprite() ; 
			addChild( _blackGraphics ) ; 
			_blackGraphics.alpha = 0 ; 
			
			_overlayBackground = new Sprite() ; 
			addChild( _overlayBackground ) ; 
			
			_overlayLayer = new Sprite();
			addChild(_overlayLayer);

			var style:Object = {};
			style.fontSize = 13;
			style.align = "left";

			_header = new ClassFactory.HEADER();
			addChild(_header);
			if( !AppSettings.SHOW_HEADER )
			{
				_header.addEventListener(FooterEvent.FOOTER_CLICKED, onNavClicked);
				_header.visible = false ; 
			}
			
			_footer = new ClassFactory.FOOTER( this );
			addChild(_footer);
			DispatchManager.addEventListener(FooterEvent.FOOTER_CLICKED, onNavClicked);
			
			DispatchManager.addEventListener(Flags.STATE_MACHINE_START, onSMStart);
			DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onSMEnd);
			DispatchManager.addEventListener(Flags.UN_FREEZE, onUnFreeze);
			
			stage.addEventListener(Event.RESIZE,onResize);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFSChange);
			onResize();
		}
		
		private function onFSChange( evt : FullScreenEvent ) : void
		{
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
			AppSettings.SHOW_HEADER = true ; 
			_header.addEventListener(FooterEvent.FOOTER_CLICKED, onNavClicked);
			_header.visible = true ; 
		}
		private function onNoFS() : void
		{
			AppSettings.SHOW_HEADER = false ; 
			_header.removeEventListener(FooterEvent.FOOTER_CLICKED, onNavClicked);
			_header.visible = false ; 
		}

		private function onUnFreeze(event : Event) : void 
		{
			removeCurrentOverlay(  ) ; 
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
		
		public function addSection( name:String ):void
		{
			switch("SECTION:"+name)
			{	
				case(AppSections.LEGAL):
					addOverlay(ClassFactory.LEGAL);
					break;
				case(AppSections.SHARE):
					addOverlay(ClassFactory.SHARE);
					break;
				case(AppSections.FIND_OUT_MORE):
					addOverlay(ClassFactory.FIND_OUT_MORE);
					break;
				case(AppSections.OVERWEIGHT):
					addOverlay(ClassFactory.OVERWEIGHT);
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
			_footer.addOverlay() ; 
			_overlayShown = true;
			_currentOverlay = new overlay();
			_overlayLayer.addChild(_currentOverlay);
			_currentOverlay.alpha = 0;
			_footer.showBackToVideo() ; 
			TweenMax.to(_currentOverlay,fadeTime,{autoAlpha:1});
			onResize();
		}

		public function removeCurrentOverlay(evt:Event = null,hasNextOverlay:Boolean = false):void{
			if(_currentOverlay)
			{
				_footer.removeOverlay() ; 
				_blackGraphics.graphics.clear();
				_overlayBackground.graphics.clear();
				TweenMax.to(_currentOverlay,fadeTime,{autoAlpha:0,onComplete:overlayRemoved,onCompleteParams:[_currentOverlay]});
				_footer.hideBackToVideo() ; 	
				if(!hasNextOverlay){
					_currentOverlay = null;
					_overlayShown = false;
					DispatchManager.dispatchEvent(new Event(Flags.UN_FREEZE)) ;
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

		
		protected function onNavClicked(evt : FooterEvent) : void 
		{
			var obj:Object = evt.info;
			switch(obj.value)
			{
				case('legal'):
					AppController.i.setSWFAddress(AppSections.LEGAL);
					break;
			
				case('findOutMore'):
					AppController.i.setSWFAddress(AppSections.FIND_OUT_MORE);
					break;
				case(AppSections.START_AGAIN ):
					onBackToVideo( ) ; 
					//AppController.i.setSWFAddress(AppSections.INTRO);
					//DispatchManager.dispatchEvent(new Event(Flags.START_MOVIE));
					SMController.me.goStartState() ; 
					break;
				case('share'):
					AppController.i.setSWFAddress(AppSections.SHARE);
					break;
				case('overweight'):
					AppController.i.setSWFAddress(AppSections.OVERWEIGHT);
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
				_blackGraphics.graphics.beginFill(0xff0099,1);
				_blackGraphics.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				
				_overlayBackground.graphics.clear();
				_overlayBackground.graphics.lineStyle(2 , SMSettings.CHOICE_BORDER_COLOR ) ;
				_overlayBackground.graphics.beginFill( SMSettings.CHOICE_BACK_COLOR , .95 );
				_overlayBackground.graphics.drawRect
					(
						0
						, 0
						, AppSettings.VIDEO_WIDTH - AppSettings.OVERLAY_GAP 
						, AppSettings.VIDEO_HEIGHT - AppSettings.OVERLAY_GAP  
					);
				
				_overlayBackground.x = AppSettings.VIDEO_LEFT + AppSettings.OVERLAY_GAP / 2 ; 
				_overlayBackground.y = AppSettings.VIDEO_TOP + AppSettings.OVERLAY_GAP / 2; 
			}
		}
		public function onBackToVideo( ):void
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

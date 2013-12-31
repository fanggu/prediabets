package com.refract.prediabets.components.intro {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.events.FooterEvent;
	import com.refract.prediabets.components.events.MenuEvent;
	import com.refract.prediabets.components.nav.Footer;
	import com.refract.prediabets.stateMachine.events.StateEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.refract.prediabets.video.VideoLoader;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	/**
	 * @author kanish
	 */
	public class Intro extends Sprite {
		
		
		public static const INTRO_VIDEO_PAUSE:String = "INTRO_VIDEO_PAUSE";
		public static const INTRO_VIDEO_UNPAUSE : String = "INTRO_VIDEO_UNPAUSE";
		public static const INTRO_ENDED:String = "INTRO_ENDED";
		
	
		protected var _timer:Timer;
		
		protected var _copyStyle:Object = {fontSize:72,align:"center"};
		
		protected var _menu:Sprite;
		
		protected var _introQuote:TextField;
		protected var _introTween:TweenMax;
		
		protected var _cover:Sprite;
		
		public function Intro() {
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
		
			
			setVideo();
			addIntroNav();
		//	addGetApp();
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}

		protected function setVideo():void{
			
			DispatchManager.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			//if(VideoLoader.i.url == "intro"){
		
			//	VideoLoader.i.seek(0);
		//		VideoLoader.i.resumeVideo();
		//	}else{
		
				if( VideoLoader.i) VideoLoader.i.update("intro");	
			//}
			
			_introQuote = TextManager.makeText("intro_menu_pull_quote",this,_copyStyle);
			_introQuote.visible = false;
			_introQuote.alpha = 0;
			_introTween = TweenMax.to(_introQuote,0.5,{delay:35,autoAlpha:1,onComplete:tweenComplete});
			addEventListener(Event.ENTER_FRAME,onEF);
			
			if( VideoLoader.i ) VideoLoader.i.activateClickPause();
			DispatchManager.addEventListener(INTRO_VIDEO_PAUSE, onVideoClick);
			DispatchManager.addEventListener(INTRO_VIDEO_UNPAUSE, onVideoClick);
			
		}
		
		
		private function onEF(evt:Event):void
		{
			if( VideoLoader.i)
			{
				if(VideoLoader.i.paused && !_introTween.paused){
					_introTween.pause();
				}else if(!VideoLoader.i.paused && _introTween.paused){
					_introTween.resume();
				}
			}
		}
		
		protected function tweenComplete():void{
			removeEventListener(Event.ENTER_FRAME,onEF);
			TweenMax.to(_introQuote,0.5,{delay:3,autoAlpha:0,onComplete:removeQuote});
		}
		
		protected function removeQuote():void{
			removeChild(_introQuote);
		}
		
		protected function addIntroNav():void{
			_menu = new Sprite();
			addChild(_menu);
			_menu.graphics.beginFill(AppSettings.WHITE,0.2);
			_menu.graphics.drawCircle(AppSettings.RESERVED_FOOTER_HEIGHT, AppSettings.RESERVED_FOOTER_HEIGHT, AppSettings.RESERVED_FOOTER_HEIGHT);
			var tf:TextField = TextManager.makeText("footer_menu",_menu,{fontSize : 13, align : "left"});
			var format:TextFormat = tf.getTextFormat();
			format.color = AppSettings.WHITE;
			tf.setTextFormat(format);
			tf.x = AppSettings.RESERVED_FOOTER_HEIGHT - tf.width/2;
			tf.y = AppSettings.RESERVED_FOOTER_HEIGHT/2 - tf.height/2;
			_menu.addEventListener(MouseEvent.CLICK, onShowMenu);
			_menu.addEventListener(MouseEvent.MOUSE_OVER, onMenuBtnOverOut);
			_menu.addEventListener(MouseEvent.MOUSE_OUT, onMenuBtnOverOut);
			_menu.buttonMode = true;
			_menu.useHandCursor = true;
			_menu.mouseEnabled = true;
			_menu.mouseChildren = false;
		//	_menu.graphics.moveTo(0,40);
		//	_menu.graphics.curveTo(0,0,40,0);
		//	_menu.graphics.curveTo(80,0,80,40);
		
		//	_menuButton = new LSButton("footer_menu",{fontSize:13});
		//	_menuButton.addEventListener(MouseEvent.CLICK, onShowMenu);
		//	DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.ADD_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_menuButton}));
		//	DispatchManager.addEventListener(IntroEvent.INTRO_ENDED,onIntroEnded);
		}
		
		protected function onMenuBtnOverOut(evt:MouseEvent):void{
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):	
					DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralRollover") );
					_menu.graphics.clear();
					_menu.graphics.lineStyle(1,AppSettings.WHITE,0.3);
					_menu.graphics.beginFill(AppSettings.WHITE,0.2);
					_menu.graphics.drawCircle(AppSettings.RESERVED_FOOTER_HEIGHT, AppSettings.RESERVED_FOOTER_HEIGHT, AppSettings.RESERVED_FOOTER_HEIGHT);
					break;
				default:
					_menu.graphics.clear();
					_menu.graphics.beginFill(AppSettings.WHITE,0.1);
					_menu.graphics.drawCircle(AppSettings.RESERVED_FOOTER_HEIGHT, AppSettings.RESERVED_FOOTER_HEIGHT, AppSettings.RESERVED_FOOTER_HEIGHT);
					
			}
		}
		
		protected function onShowMenu(evt:MouseEvent):void{
			DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralClick") );	
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.FOOTER_CLICKED,{value:Footer.MENU}));
		}
		
		/*
		 *  LISTENERS
		 */
		 
		
		protected function onNetStatus(event:NetStatusEvent):void{
			switch (event.info.code) 
		    { 
				case "NetStream.Play.Stop":
		        case "NetStream.Buffer.Empty": 
					endIntro();
				//	VideoLoader.i.seek(0);
		            break; 
		    } 
		}
		
		
		protected function endIntro():void{
			DispatchManager.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			onIntroEnded(new MenuEvent(MenuEvent.MENU_SELECTED,2));
			addCover();
		}
		
		protected function addCover():void{
			_cover = new Sprite();
			addChild(_cover);
			_cover.graphics.clear();
			_cover.graphics.beginFill(0xff0000,0);
			_cover.graphics.drawRect(0,0,10,10);
			_cover.addEventListener(MouseEvent.CLICK, onCoverClick);
			_introQuote = TextManager.makeText("intro_menu_click",this,_copyStyle);
			_introQuote.alpha = 0;
			_introQuote.visible = false;
			onResize();
		}
		
		protected function onCoverClick(evt:MouseEvent):void{
			AppController.i.nav.hideMenu();
			TweenMax.to(_menu,0.5,{autoAlpha:0});
			TweenMax.to(_introQuote,0.5,{autoAlpha:1,delay:1});
			TweenMax.to(_introQuote,0.5,{autoAlpha:0,delay:5.5,onComplete:AppController.i.nav.showMenu});
			TweenMax.to(_menu,0.5,{autoAlpha:1,delay:5.5});
		}
		
		protected function onVideoClick(evt:Event):void{
			switch(evt.type){
				case(INTRO_VIDEO_PAUSE):
					VideoLoader.i.pauseVideo();
				break;
				case(INTRO_VIDEO_UNPAUSE):
					VideoLoader.i.resumeVideo();
				break;
			}
			
		}
		
		protected function onIntroEnded(evt : MenuEvent = null) : void {
		//	DispatchManager.dispatchEvent(evt);
			DispatchManager.dispatchEvent(new Event(INTRO_ENDED));
	//		DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.REMOVE_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_menuButton}));
		}
		
		protected function onResize(evt : Event = null) : void {
			if(_menu){
				_menu.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2 - AppSettings.RESERVED_FOOTER_HEIGHT;
				_menu.y = AppSettings.VIDEO_BOTTOM - AppSettings.RESERVED_FOOTER_HEIGHT;
			}
			
			if(_introQuote){
				if(_cover){
						_introQuote.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2 - _introQuote.width/2; //value is not 33%, it's 
						_introQuote.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - _introQuote.height/2;
				}else{	
					_introQuote.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH*0.3078125 - _introQuote.width/2; //value is not 33%, it's 
					_introQuote.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT*0.275;// - _introQuote.height/2;
				}
			}
			
			if(_cover){
				_cover.x = AppSettings.VIDEO_LEFT;
				_cover.y = AppSettings.VIDEO_TOP;
				_cover.width = AppSettings.VIDEO_WIDTH;
				_cover.height = AppSettings.VIDEO_HEIGHT;
			}
		}
		
		public function destroy() : void {
		    DispatchManager.removeEventListener( NetStatusEvent.NET_STATUS,onNetStatus);
			stage.removeEventListener(Event.RESIZE,onResize);
			DispatchManager.removeEventListener(INTRO_VIDEO_PAUSE, onVideoClick);
			DispatchManager.removeEventListener(INTRO_VIDEO_UNPAUSE, onVideoClick);
			
			removeEventListener(Event.ENTER_FRAME,onEF);
			
			//VideoLoader.i.stopVideo();
			VideoLoader.i.pauseVideo();
			//VideoLoader.i.seekAndPause(0);
			
			if(_timer){
				_timer.stop();
				_timer = null;
			}
			if(_menu){
				_menu.graphics.clear();
				removeChild(_menu);
				_menu.removeEventListener(MouseEvent.CLICK, onShowMenu);
				_menu = null;
			}
			if(_cover){
				removeChild(_cover);
				_cover.removeEventListener(MouseEvent.CLICK, onCoverClick);
				_cover = null;
			}
			TweenMax.killTweensOf(_introQuote);
			_introQuote = null;
			_introTween = null;
		//	if(_menuButton){
		//		DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.REMOVE_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_menuButton}));
		//		_menuButton.removeEventListener(MouseEvent.CLICK, onShowMenu);
		//		_menuButton.destroy();
		//		_menuButton = null;
		//	}
			
			removeChildren();
		}
	}
}

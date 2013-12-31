package com.refract.air.shared.components.nav {
	import com.refract.air.shared.components.nav.filmsmenu.FilmsMenu;
	import com.refract.air.shared.components.nav.footer.MobileFooter;
	import com.refract.air.shared.components.nav.sidemenu.SideMenu;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSections;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.components.events.FooterEvent;
	import com.refract.prediabets.components.events.MenuEvent;
	import com.refract.prediabets.components.nav.Footer;
	import com.refract.prediabets.components.nav.Header;
	import com.refract.prediabets.components.nav.Nav;
	import com.refract.prediabets.components.shared.LSButton;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author kanish
	 */
	public class MobileNav extends Nav {
		
		protected var _sideMenu:SideMenu;
		protected var _filmsMenu:FilmsMenu;
		
		public function MobileNav() {
			super();
		}
		
		override protected function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		//	graphics.beginFill(0xff0000,1);
		//	graphics.drawRect(0,0,20,20);
		
			AppSettings.FOOTER_FONT_SIZE = 20;
			AppSettings.FOOTER_FONT_SIZE2 = 20;
		
			var style:Object = {};
			style.fontSize = AppSettings.FOOTER_FONT_SIZE;
			style.align = "left";
			
			_backToVideo = new LSButton("footer_back_to_video",style);
			addChild(_backToVideo);
		//	_backToVideo.visible = false;
			_backToVideo.graphics.beginFill(0x000000,1);
			_backToVideo.graphics.drawRect(0,0,_backToVideo.width,_backToVideo.height);
			removeChild(_backToVideo);
			_backToVideo.addEventListener(MouseEvent.CLICK, onBackToVideo);
			
			_overlayLayer = new Sprite();
			addChild(_overlayLayer);
			
			
			_blackOverlay = new Sprite();
			_blackGraphics = _blackOverlay.graphics;
			_blackOverlay.visible = false;
			_blackOverlay.addEventListener(MouseEvent.CLICK, fakeListener,true);
			_blackOverlay.addEventListener(MouseEvent.MOUSE_OVER, fakeListener,true);
			_blackOverlay.addEventListener(MouseEvent.MOUSE_OUT, fakeListener,true);
			_overlayLayer.addChild(_blackOverlay);
		
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
			
			_closeButton = new LSButton("overlay_close",{fontSize:36},190,70,true,false);
		//	_overlayLayer.addChild(_closeButton);
			_closeButton.addEventListener(MouseEvent.CLICK, onClose);
			_closeButton.visible = false;
		
			addSideMenu();
			addFilmsMenu();
			addBaseButtons();
			
			addEvents();
		}
		
		protected function addBaseButtons():void{
			
			_footer = new MobileFooter();
			addChild(_footer);
			swapChildren(_footer, _sideMenu);
			DispatchManager.addEventListener(FooterEvent.FOOTER_CLICKED, onNavClicked);
			
		}
		
		protected function addSideMenu():void{
			_sideMenu = new SideMenu();
			addChild(_sideMenu);
		}
		
		protected function addFilmsMenu():void{
			_filmsMenu = new FilmsMenu();
			addChildAt(_filmsMenu,numChildren-1);
		}
		
		private function addEvents():void{
			_sideMenu.addEventListener(MenuEvent.MENU_HIDE, onMenuHidden);
			_filmsMenu.addEventListener(MenuEvent.MENU_HIDE, onMenuHidden);
			_sideMenu.addEventListener(MenuEvent.MENU_SHOW, onMenuShown);
			_filmsMenu.addEventListener(MenuEvent.MENU_SHOW, onMenuShown);
		}
		
		private function onMenuHidden(evt:Event):void{
			if(!_sideMenu.shown && !_filmsMenu.shown){
				DispatchManager.dispatchEvent(evt);
			}
		}
		
		private function onMenuShown(evt:Event):void{
			if(_sideMenu.shown || _filmsMenu.shown){
				DispatchManager.dispatchEvent(evt);
			}
		}
		
		override public function showMenu():void{
		//	_sideMenu.show();
			_filmsMenu.show();
			(_footer as MobileFooter).hideCenter();
		}
		
		override public function hideMenu():void{
		//	_sideMenu.hide();
			_filmsMenu.hide();
			(_footer as MobileFooter).showCenter();
		}
		
		override protected function onNavClicked(evt : FooterEvent) : void{
			var obj:Object = evt.info;
			switch(obj.value){
				case(Header.LS_LOGO):
					AppController.i.setSWFAddress(AppSections.INTRO);
					_sideMenu.shown ? _sideMenu.hide() : true;
					_filmsMenu.shown ? hideMenu() : true;
					removeCurrentOverlay();
				//	_menu.shown ? _menu.hide() : _menu.show();
				//	_header.setProgressBar((Math.round(Math.random()*3))*33.3/100);
					break;
				case(Footer.MENU):
				//	_menu.shown ? _menu.hide() : _menu.show();
					_sideMenu.shown ? _sideMenu.hide() : _sideMenu.show();
					break;
				case(MobileFooter.FILMS):
					_filmsMenu.shown ? hideMenu() : showMenu();
					break;
				default:
					super.onNavClicked(evt);
			}
		}
	}
}

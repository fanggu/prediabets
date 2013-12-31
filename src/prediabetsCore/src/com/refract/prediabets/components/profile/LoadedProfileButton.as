package com.refract.prediabets.components.profile {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.events.MenuEvent;
	import com.refract.prediabets.components.nav.header.HeaderProgressBar;
	import com.refract.prediabets.logger.Logger;
	import com.refract.prediabets.user.UserModel;
	import com.robot.comm.DispatchManager;

	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;

	/**
	 * @author kanish
	 */
	public class LoadedProfileButton extends ProfileButton {
		public function LoadedProfileButton(id : int) {
			super(id);
		}
		
		override protected function buildBottom():void{
			super.buildBottom();
			
			if(state != LOCKED){
				if(!UserModel.getModuleStats(id).isDownloaded){
					if(UserModel.getModuleStats(id).isDownloading){
						listenForDownload();
					}else{	
						_startNow.text = TextManager.getDataListForId("intro_menu_download")["intro_menu_download"]["copy_"+AppSettings.LOCALE];
						DispatchManager.addEventListener(MenuEvent.MENU_LOAD_MODULE,downloadRequested);
					}
				}else{
				}
			}
		}
		
		override protected function onClick(evt:MouseEvent):void{
			if(!UserModel.getModuleStats(id).isDownloaded){
			//	listenForDownload();
				DispatchManager.dispatchEvent(new MenuEvent(MenuEvent.MENU_LOAD_MODULE,id));
			}else{
				super.onClick(evt);
			}
		}
		
		
		protected var _progress:HeaderProgressBar;
		
		protected var timeoutID:int;
		
		
		protected function downloadRequested(evt:MenuEvent = null):void{
			if(int(evt.menuItem) == id){
				listenForDownload();
			}
		}
		
		public function listenForDownload() : void {
			_startNow.buttonMode = false;
			_startNow.mouseEnabled = false;
			DispatchManager.addEventListener(MenuEvent.MENU_LOAD_ERROR, onLoadError);
			TweenMax.to(_startNow,0.5,{autoAlpha:0});
			_progress = new HeaderProgressBar();
			_bottom.addChild(_progress);
			_progress.width = _startNow.width;
			_progress.scaleY = _progress.scaleX;
			_progress.x = _startNow.x;
			_progress.y = _startNow.y + _startNow.height/2 - _progress.height/2;
			_progress.alpha = 0;
			TweenMax.to(_progress,0.5,{autoAlpha:1});
			//timeoutID = setTimeout(checkDownloadSize,LoadedMenuButton.POLL_TIME);
			
		}
		
		protected function onLoadError(evt:MenuEvent):void{
			if(id == evt.menuItem){
				clearTimeout(timeoutID);
				TweenMax.to(_startNow,0.5,{autoAlpha:1});
				TweenMax.to(_progress,0.5,{autoAlpha:0, onComplete:removeProgress});	
			}
		}
		
		protected function checkDownloadSize():void{
			var perc:Number = UserModel.getModuleStats(id).downloadPercent;
			Logger.log(Logger.FILE_LOADING,perc);
			if(perc < 1){
				_progress.setBar(perc);
				//timeoutID = setTimeout(checkDownloadSize,LoadedMenuButton.POLL_TIME);
			}else{
				_startNow.text = TextManager.getDataListForId("intro_menu_start_now")["intro_menu_start_now"]["copy_"+AppSettings.LOCALE];
				
				TweenMax.to(_startNow,0.5,{autoAlpha:1});
				TweenMax.to(_progress,0.5,{autoAlpha:0, onComplete:removeProgress});
				
			}
		}
		
		protected function removeProgress():void{
			if(_progress){		
				_bottom.removeChild(_progress);
				_progress.destroy();
				_progress = null;
			}
			DispatchManager.removeEventListener(MenuEvent.MENU_LOAD_ERROR, onLoadError);
			_startNow.buttonMode = true;
			_startNow.mouseEnabled = true;
		}
		
		override public function destroy():void{
			
			clearTimeout(timeoutID);
			removeProgress();
			DispatchManager.removeEventListener(MenuEvent.MENU_LOAD_MODULE,downloadRequested);
			super.destroy();
		}
	}
}

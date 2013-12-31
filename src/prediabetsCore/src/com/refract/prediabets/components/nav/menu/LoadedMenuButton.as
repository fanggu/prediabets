package com.refract.prediabets.components.nav.menu {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.events.MenuEvent;
	import com.refract.prediabets.components.nav.Menu;
	import com.refract.prediabets.components.nav.header.HeaderProgressBar;
	import com.refract.prediabets.components.shared.LSButton;
	import com.refract.prediabets.logger.Logger;
	import com.refract.prediabets.stateMachine.events.StateEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.refract.prediabets.user.UserModel;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * @author kanish
	 */
	

	/**
	 * @author kanish
	 */
	public class LoadedMenuButton extends MenuButton {
		
		public static const POLL_TIME:int = 1000;
		
		public static var BKG_ALPHA:Number = 0.4;
		
		public override function get bkgHeight():Number {return _bkgBmp.height;}
		public override function get type():String{return _type;}
		
		protected var _bkgBmp:Bitmap;
		
		public override function get enabled():Boolean {return _isEnabled;}
		
		
		public function LoadedMenuButton(type : String, menu : Menu) {
			super(type, menu);
		}
		
		protected override function addBKG():void{			
			_bkgBmp = AssetManager.getEmbeddedAsset("IntroFilm"+_type+"Bkg") as Bitmap;
			
			
			addChild(_bkgBmp);
			_bkgBmp.smoothing = true;
			_bkgBmp.alpha = BKG_ALPHA;
		}
		
		protected override function addLabels():void{
			
			
			nameStyle = {fontSize:24};
			labelStyle = { fontSize:16, antiAlias:"normal" };
			
			_label = new Sprite();
			addChild(_label);
			var tf:TextField,lastTF:TextField;
			tf = TextManager.makeText("intro_menu_label"+_type,_label,labelStyle);	
			tf.x += 1;
			lastTF = tf;
			
			tf = TextManager.makeText("intro_menu_unlocked"+_type,_label,nameStyle);
			tf.y = lastTF.textHeight - (tf.height - tf.textHeight);
				
			if(UserModel.getModuleStats(_pos+1).isDownloaded){
				if(UserModel.getModuleStats(_pos+1).isComplete){
					_start = new LSButton("intro_menu_replay",nameStyle,257,70,true,false);
				}else if(AppController.i.nextStory == _pos+1){
					_start = new LSButton("intro_menu_resume",nameStyle,257,70,true,false);
				}else{
					_start = new LSButton("intro_menu_start_now",nameStyle,257,70,true,false);
				}
			}else{
				_start = new LSButton("intro_menu_download",nameStyle,257,70,true,false);
			}
			_start.minBkgWidthGap = 0;
			_start.buttonAlpha = 0.15;
			_label.addChild(_start);
			TweenMax.to(_start.body,0,{tint:0xffffff});
				
			_start.y = tf.y + tf.height;//_start.height + 9;
			_label.y = _bkgBmp.height - 10 - _label.height;
				
				
			
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
			
			DispatchManager.addEventListener(MenuEvent.MENU_LOAD_MODULE,downloadRequested);
			
			TweenMax.to(_bkgBmp, 0, {alpha: BKG_ALPHA});
			
		}
		
		public override function lockNow():void{ }
		
		public override function unlockNow():void{ }
		
		public override function unlock():void{ }

		public override function onMouseOverOut(evt : MouseEvent) : void {
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
					DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndMenuRollover") );	
					TweenMax.to(_bkgBmp, 0.5, {alpha :1,canBePaused:false});
					if(_start) _start.startDancingArrow();
					break;
				default:
					TweenMax.to(_bkgBmp, 0.5, {alpha: BKG_ALPHA,canBePaused:false});
					if(_start) _start.stopDancingArrow();
					
			}
		}
		
		
		protected override function onResize(evt:Event = null):void{
			
			
			_bkgBmp.scaleX = _bkgBmp.scaleY = (AppSettings.VIDEO_WIDTH+4)/(1280);
			_label.x = 28;
			
			
			
			graphics.clear();
			graphics.beginFill(0x0,1);
			graphics.drawRect(0,0,_bkgBmp.width+1,_bkgBmp.height);
		//	graphics.drawRect(0,0,_bkg.width,_bkg.height);
			
			if(_start){
			//	_label.removeChild(_start);
				_start.minW = _bkgBmp.width - 63;
				_start.y = _start.height + 10;
			//	_start.y = _label.height + 10;
			//	_label.addChild(_start);
			}
			
			_label.y = _bkgBmp.height - 10 - _label.height;
			
			this.x = (_bkgBmp.width*_pos);
			this.y = _menu.shown ? -bkgHeight : 0;
			
		}

		public override function destroy() : void {
			stage.removeEventListener(Event.RESIZE,onResize);
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
			DispatchManager.removeEventListener(MenuEvent.MENU_LOAD_MODULE,listenForDownload);
			clearTimeout(timeoutID);
			removeProgress();
			
		}

		public override function resetVideo() : void {
			onMouseOverOut(new MouseEvent(MouseEvent.MOUSE_OUT));
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
			if(UserModel.getModuleStats(_pos+1).isDownloaded){
				if(UserModel.getModuleStats(_pos+1).isComplete){
					_start.text = TextManager.getDataListForId("intro_menu_replay")["intro_menu_replay"]["copy_"+AppSettings.LOCALE];
				}else if(AppController.i.nextStory == _pos+1){
					_start.text = TextManager.getDataListForId("intro_menu_resume")["intro_menu_resume"]["copy_"+AppSettings.LOCALE];
				}else{
					_start.text = TextManager.getDataListForId("intro_menu_start_now")["intro_menu_start_now"]["copy_"+AppSettings.LOCALE];
				}
			}else{
				_start.text = TextManager.getDataListForId("intro_menu_download")["intro_menu_download"]["copy_"+AppSettings.LOCALE];
			}
		}
		
		protected var timeoutID:int;
		
		protected function downloadRequested(evt:MenuEvent = null):void{
			if(int(evt.menuItem) == int(this.type)){
				if(this.buttonMode == true){
					listenForDownload();
				}
			}
		}
		
		public override function listenForDownload() : void {
			
			this.buttonMode = false;
			this.mouseEnabled = false;
			DispatchManager.addEventListener(MenuEvent.MENU_LOAD_ERROR, onLoadError);
			TweenMax.to(_start,0.5,{autoAlpha:0});
			_progress = new HeaderProgressBar();
			_label.addChild(_progress);
			_progress.width = _start.width;
			_progress.scaleY = _progress.scaleX;
			_progress.x = _start.x;
			_progress.y = _start.y + _start.height/2 - _progress.height/2;
			_progress.alpha = 0;
			TweenMax.to(_progress,0.5,{autoAlpha:1});
			timeoutID = setTimeout(checkDownloadSize,POLL_TIME);
		}
		
		protected function onLoadError(evt:MenuEvent):void{
			if(int(this.type) == evt.menuItem){
				clearTimeout(timeoutID);
				TweenMax.to(_start,0.5,{autoAlpha:1});
				TweenMax.to(_progress,0.5,{autoAlpha:0, onComplete:removeProgress});	
			}
		}
		
		protected override function checkDownloadSize():void{
			var perc:Number = UserModel.getModuleStats(int(this.type)).downloadPercent;
			Logger.log(Logger.FILE_LOADING,"% of LS"+type+" loaded: "+perc);
			if(perc != 1){
			//	Logger.log(Logger.FILE_LOADING,perc);
				_progress.setBar(perc);
				timeoutID = setTimeout(checkDownloadSize,POLL_TIME);
			}else{
				_start.text = TextManager.getDataListForId("intro_menu_start_now")["intro_menu_start_now"]["copy_"+AppSettings.LOCALE];
				
				TweenMax.to(_start,0.5,{autoAlpha:1});
				TweenMax.to(_progress,0.5,{autoAlpha:0, onComplete:removeProgress});
				
			}
		}
		
		protected function removeProgress():void{
			if(_progress){		
				_label.removeChild(_progress);
				_progress.destroy();
				_progress = null;
			}
			DispatchManager.removeEventListener(MenuEvent.MENU_LOAD_ERROR, onLoadError);
			this.buttonMode = true;
			this.mouseEnabled = true;
		}

		public override function resetState() : void {
		//	onResize();
			if(enabled){
				_start.y = _start.height + 9;
				_label.y = _bkgBmp.height - 10 - _label.height;
			}
		}

	}
}

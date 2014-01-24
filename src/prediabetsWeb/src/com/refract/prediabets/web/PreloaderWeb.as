package com.refract.prediabets.web {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;

	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabets.web.preloader.PreloaderAssets;
	import com.refract.prediabets.web.preloader.PreloaderSplash;

	import org.osmf.logging.Logger;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;

	[SWF(width='1280', height='800', backgroundColor='#000000', frameRate='25')]

	public class PreloaderWeb extends Sprite {
		private var _assets : PreloaderAssets;
		private var _bulkLoader : BulkLoader;
		private var _preContainer : PreloaderSplash;
		private var _bkg : Bitmap;
		private var _footerContainer : Sprite;
		private static const VIDEO_EXTENTION : String = ".flv";
		private var _min : Shape;
		private var _mainSWF : String = "MainWeb.swf";
		private var _dataURL : String = "../data/";
		private var _videoList : Array = ["intro", "LS1_p98_p104", "LS1_p127_p135", "LS2_p29_p29", "LS2_p30_p31", "LS2_p32_p33", "LS2_p33_p34", "LS2_p35_p36", "LS2_p58_p59", "LS2_p60_p61", "LS2_p61_p62", "LS2_p65_p65", "LS2_p65_p66"];
		private var _videoSize : int = 22267581;

		private var _skipLoadSize:Boolean = false;

		public function PreloaderWeb() {
			_assets = new PreloaderAssets();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(evt : Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.align = "TL";
			stage.scaleMode = "noScale";

			AppSettings.stage = stage;
			_assets.stage = stage;

			var mainSWF : String = AppSettings.getFlashVar("mainSwf");
			if (mainSWF && mainSWF != "") {
				_mainSWF = mainSWF;
			}
			var dataURL : String = AppSettings.getFlashVar("dataURL");
			if (dataURL && dataURL != "") {
				_dataURL = dataURL;
			}

			addBackground();

			_preContainer = new PreloaderSplash(_assets);
			_preContainer.addEventListener(PreloaderSplash.CONTINUE, onUserReady);
			_preContainer.addEventListener(PreloaderSplash.GO_TERMS, onTermsClick);
			_footerContainer = new Sprite();
			_preContainer.alpha = 0;
			addChild(_preContainer);
			addChild(_footerContainer);

			_min = new Shape();
		//	addChild(_min);

			addFooter();
			addEvents();
			if(_skipLoadSize){
				getContent();
			}else{
				loadMainContent();
			}
		}

		private function addBackground() : void {
			_bkg = new _assets.BKG();
			addChildAt(_bkg, 0);
			_bkg.alpha = 0.3;
			_bkg.smoothing = true;
		}

		private function addFooter() : void {
		//	var tf : TextField;
		//	tf = _assets.createText("preloader_emergency", _footerContainer);
		//	tf.alpha = 0.7;
		//	tf.getTextFormat().bold = true;
		//	_assets.setButtonProps(_footerContainer);
		}

		private function loadMainContent() : void {
			BackendResponder.initialize(onBackendInit,getContent);
		}
		
		private function onBackendInit():void{
			BackendResponder.getStoresLinks(onStoresLinks,onStoresError);
			BackendResponder.videoListData(_videoList.join(","),videoSizeLoadComplete,getContent);
		}
		
		private function onStoresLinks(evt:Event,loader:URLLoader):void{
			var data:Object = JSON.parse(loader.data as String);
			if(data.success){
				AppSettings.ITUNES_LINK = data.data.store.apple && data.data.store.apple.enabled ? data.data.store.apple.url : AppSettings.ITUNES_LINK;
				AppSettings.ITUNES_TAB_LINK = data.data.store.apple_tab && data.data.store.apple_tab.enabled ? data.data.store.apple_tab.url : AppSettings.ITUNES_TAB_LINK;
				AppSettings.PLAY_LINK = data.data.store.google && data.data.store.google.enabled ? data.data.store.google.url : AppSettings.PLAY_LINK;
				AppSettings.PLAY_TAB_LINK = data.data.store.google_tab && data.data.store.google_tab.enabled ? data.data.store.google_tab.url : AppSettings.PLAY_TAB_LINK;
			}else{
				onStoresError(evt);
			}
		}
		
		private function onStoresError(evt:Event):void{
			AppSettings.ITUNES_LINK = "";
			AppSettings.PLAY_LINK = "";
		}

		private function videoSizeLoadComplete(evt : Event,loader:URLLoader):void{
			_videoSize = int(JSON.parse(loader.data as String).data.meta.tot_size);
			getContent();
		}

		private function getContent() : void {
			_bulkLoader = new BulkLoader("Videos");
			_bulkLoader.addEventListener(BulkLoader.COMPLETE, onComplete);
			_bulkLoader.addEventListener(BulkLoader.PROGRESS, onProgress);

			
			_bulkLoader.add(_mainSWF, {id:"mainSWF", type:"movieclip", priority:1});
			
			
			var url : String;
			for (var i : int = 0; i < _videoList.length; ++i) {
				url = _dataURL + "video/flv/" + _videoList[i] + VIDEO_EXTENTION;
				_bulkLoader.add(url, {id:url, type:"video", pausedAtStart:true, priority:0});
			}
			//hello
			_bulkLoader.start();
		}

		/*
		 * 
		 * EVENTS
		 * 
		 */
		private function addEvents() : void {
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		private function onProgress(evt : BulkProgressEvent) : void {
			var totalMain : int = _bulkLoader.get("mainSWF")._bytesTotal;

			if ( totalMain != 0) {
				var perc : int = Math.floor(_bulkLoader.bytesLoaded * 100 / (_videoSize + totalMain));
				perc = perc > 99 ? 99 : perc;
				_preContainer.setLoaderText(perc < 10 ? "0" + String(perc) : String(perc));
			} else {
				_preContainer.setLoaderText("0");
			}
		}

		private function onComplete(evt : BulkProgressEvent) : void {
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onComplete);
			_bulkLoader.removeEventListener(BulkLoader.PROGRESS, onProgress);

			// Logger.log(Logger.PRELOADER,"onProgress:",_bulkLoader.bytesLoaded,_bulkLoader.bytesTotal)

			_preContainer.setLoaderText("100");
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);

			_preContainer.replaceLoader();
			_preContainer.alpha = 1;
			onResize();
		}

		public function onEnterFrame(e : Event) : void {
			_preContainer.loaderRotation += 16;
			if (_preContainer.alpha < 1) {
				_preContainer.alpha += 1 / 15;
			}

		}

		private function onResize(event : Event = null) : void {
			if(_bkg){
				_bkg.width = _assets.VIDEO_WIDTH;
				_bkg.height = _assets.VIDEO_HEIGHT;
				_bkg.x = _assets.VIDEO_LEFT;
				_bkg.y = _assets.VIDEO_TOP;
			}
			if(_preContainer){
				_preContainer.x = _assets.VIDEO_LEFT + _assets.VIDEO_WIDTH / 2;
				_preContainer.y = 0;
			}
			if(_assets && _footerContainer){
				_assets.exactCenterStage(_footerContainer);
			} 
			if (_footerContainer){
				_footerContainer.x += 50;
				_footerContainer.y = _bkg.y + _bkg.height + 10;
			}
			if(_min && contains(_min)){
				_min.graphics.clear();
				_min.graphics.lineStyle(1, 0xff0000, 1);
				_min.graphics.drawRect(stage.stageWidth / 2 - 1024 / 2, stage.stageHeight / 2 - 656 / 2, 1024, 656);
				_min.graphics.moveTo(stage.stageWidth / 2, 0);
				_min.graphics.lineTo(stage.stageWidth / 2, stage.stageHeight);
				_min.graphics.moveTo(0, stage.stageHeight / 2);
				_min.graphics.lineTo(stage.stageWidth, stage.stageHeight / 2);
			}
		}

		private function onUserReady(evt : Event) : void {
			_preContainer.removeEventListener(PreloaderSplash.CONTINUE, onUserReady);
			destroy();
			var mainSWF : DisplayObject = _bulkLoader.getContent("mainSWF");
			if (mainSWF) {
				addChild(mainSWF);
				addChild(_min);
			} else {
				Logger.log(Logger.PRELOADER,"SOMETHING WENT WRONG ", _bulkLoader.isFinished);
			}
		}
		
		private function onTermsClick(evt:Event):void{
			BackendResponder.goExternalPage("terms");
		}

		private function destroy() : void {
			if(!contains(_min)){
				stage.removeEventListener(Event.RESIZE, onResize);
			}
			_preContainer.destroy();
			_assets.destroy();

			_footerContainer.removeChildren();
			removeChildren();

			_mainSWF = null;
			_videoList = null;
			_assets = null;
			_preContainer = null;
			_bkg = null;
			_footerContainer = null;
		}
	}
}

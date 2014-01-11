package com.refract.prediabetes.video {
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	import br.com.stimuli.loading.loadingtypes.VideoItem;

	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.logger.Logger;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.events.BooleanEvent;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.video.events.LSVideoEvent;
	import com.robot.comm.DispatchManager;

	import org.bytearray.video.SimpleStageVideo;
	import org.bytearray.video.events.SimpleStageVideoEvent;

	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;


	public class VideoLoader extends Sprite /* implements IVideoLoader */ {
		
		public static const BulkLoaderID:String = "Videos";
		
		
		public static const VIDEO_WIDTH:int = 800;
		public static const VIDEO_HEIGHT:int = 450;
		
		private static var _i : VideoLoader;
		private var _lastPos : Number;
		public static function get i():VideoLoader{ return _i; }
		public static function set i(vl:VideoLoader):void{ _i = vl;} 
		
		public static var VIDEO_BASE_URL:String = "video/flv/1024/";
		public static var VIDEO_FILE_FORMAT_DESCRIPTOR:String = "";
		public static function get VIDEO_FILE_EXT():String { return _VIDEO_FILE_EXT;}
		public static function set VIDEO_FILE_EXT(s:String):void{ _VIDEO_FILE_EXT = s; AppSettings.VIDEO_FILE_EXT = _VIDEO_FILE_EXT;}
		private static var _VIDEO_FILE_EXT:String = ".flv";
		
		public static function set defaultLoadingOrder(newOrder:Array):void{ _defaultLoadingOrder = newOrder; }
		public static function get defaultLoadingOrder():Array{ return _defaultLoadingOrder; }
		
		protected static var _defaultLoadingOrder:Array = [ LSVideoEvent.STREAM_VIDEO_ONLY ];
		
		protected var _loadingOrder:Array;
		public function set loadingOrder(newOrder:Array):void{ _loadingOrder = newOrder; }
		public function get loadingOrder():Array{ return _loadingOrder; }
		
//		private var _loader:Loader;
		public function get url():String {return _url;}
		protected var _url:String;
		protected var _currentStep:int = 0;
		
		protected var _loader:Sprite;
		
		protected var _standardVideo : Boolean;
		protected var _netConnection : NetConnection;
		protected var _netStream : NetStream;
		protected var _backupNetStream : NetStream;
		
		protected var _hardwareDecoding : Boolean;
		protected var _hardwareCompositing : Boolean;
		protected var _fullGPU : Boolean;
		public var paused : Boolean  = true;
		
		
		protected var _videoClickListener:Sprite;
		
		/*
		 * Begin the rewrite 
		 */
		protected var _simpleVid:SimpleStageVideo;
		protected var _simpleVidAvailable:Boolean;
		protected var _failedToPlay:Boolean;
		
		protected var _bulkLoader:BulkLoader;
		
		public var videoAddress : String;
		private var _deActivate : Boolean ; 
		
		protected var _blackOn : Boolean ; 
		public function VideoLoader(){
			super();
			_i = this;
			setBulkLoader();
			
			
			addEventListener(Event.ADDED_TO_STAGE, preInit );
			loadingOrder = VideoLoader.defaultLoadingOrder;
		}
		
		
		
		public function stopVideo() : void{
			if(_netStream) _netStream.close();
		}
		
		
		public function pauseVideo()  : void
		{
			if( _netStream) _netStream.pause() ; 
			paused = true ; 
		}
		public function playVideo()  : void
		{
			paused = false ; 
			//DispatchManager.dispatchEvent( new Event( Flags.FREEZE_SOUNDS )) ; 
			if( _netStream) _netStream.resume() ; 
		}
		public function resumeVideo()  : void
		{
			paused = false ; 
			//DispatchManager.dispatchEvent( new Event( Flags.UN_FREEZE_SOUNDS )) ; 
			if( _netStream){
				 _netStream.resume() ; 
			}
			//_simpleVid.reattachStageVideo();
		}
		public function rePlayVideo( url : String) : void
		{
			paused = false ; 
			if( _netStream) _netStream.play(AppSettings.DATA_PATH+VIDEO_BASE_URL+_url + VIDEO_FILE_FORMAT_DESCRIPTOR + VIDEO_FILE_EXT);
		}
		public function seek( time : Number ) : void
		{
			if( _netStream ) 
			{
				_lastPos = time - 0.5 ;
				_netStream.seek( time ) ; 
				_netStream.resume() ; 
				paused = false ;
			}
		}
		
		public function seekAndPause( time : Number ) : void
		{
			if( _netStream ) 
			{
				_netStream.seek( time ) ; 
				paused = false ; 
				//_netStream.resume() ; 
			}
		}
		
		
		/*
		public function loadVideo(url:String):void{
			_url = url;
			_currentStep = 0;
			attemptLoadVideo();
			
		}
		
		protected function attemptLoadVideo():void{
			switch(loadingOrder[_currentStep]){
				case(LSVideoEvent.CHECK_STORAGE):
				break;
				case(LSVideoEvent.DOWNLOAD_AND_STORE_VIDEO):
				break;
				case(LSVideoEvent.STREAM_VIDEO_AND_STORE):
				break;
				case(LSVideoEvent.LOAD_FROM_STORAGE):
				break;
				default://LSVideoEvent.STREAM_VIDEO_ONLY
					streamVideo(_url,onStreamReady);
				
			}
		}

		public function checkStorageforVideo(filename : String) : void {
			//if video is in storage
			dispatchEvent(new LSVideoEvent(LSVideoEvent.VIDEO_READY,filename));
			//else
		}

		public function loadVideoFromStorage(filename : String, callback : Function) : void {
		}

		public function preloadAndStoreVideo(filename : String, callback : Function) : void {
		}

		public function streamVideo(filename : String, callback : Function) : void {
			
		}
	
		protected function onStreamReady():void{
			
		}

		public function streamAndStoreVideo(filename : String, callback : Function) : void {
		}
		*/
		/*
		 * 
		 * INIT Stuff
		 * 
		 */
		 
		protected function preInit( evt : Event ) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, preInit);
			
			
			DispatchManager.addEventListener(Flags.DEACTIVATE_VIDEO_RUN, deActivateVideoRun );
			DispatchManager.addEventListener(Flags.ACTIVATE_VIDEO_RUN, onActivateVideoRun );
			//DispatchManager.addEventListener(Flags.UPDATE_WRONG , onUpdateWrong) ;
			
			_simpleVidAvailable = false;
			
			
			_simpleVid = new SimpleStageVideo(AppSettings.VIDEO_WIDTH,AppSettings.VIDEO_HEIGHT);
			_simpleVid.addEventListener(Event.INIT, onInit);
			_simpleVid.addEventListener(SimpleStageVideoEvent.STATUS, onSimpleStageVideoStatus);
			
			_netConnection= new NetConnection();
	        _netConnection.connect(null);
			
			_backupNetStream = new NetStream(_netConnection);
			_backupNetStream.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
	        _backupNetStream.client = {};
			
			_netStream = _backupNetStream;
			
			_simpleVid.attachNetStream(_netStream);
			
			addChild(_simpleVid);
			
			_loader = new Sprite();
			addChild(_loader);
			var bmp:Bitmap = AssetManager.getEmbeddedAsset("PoliteLoader") as Bitmap;
			_loader.addChild(bmp);
			_loader.visible = false;
			bmp.blendMode = "screen";
			bmp.smoothing = true;
			bmp.scaleX = bmp.scaleY = 0.77;
			bmp.x = -bmp.width/2;
			bmp.y = -bmp.height/2;
			
			_videoClickListener = new Sprite();
			addChild(_videoClickListener);
			drawVideoClickListener();
			
			
			
		//	this.addEventListener(Event.ENTER_FRAME, ef);
			
			//stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onStageVideoState);
		}
		
		public function setBlackOn() : void
		{
			
		}
		private function ef(evt:Event):void{
			if(!paused){
			//	Logger.log(Logger.VIDEO,stage.stageVideos[0].videoWidth,stage.stageVideos[0].videoHeight);
				
			}
		}

		protected function drawVideoClickListener():void{
			var g:Graphics = _videoClickListener.graphics;
			g.clear();
			g.beginFill(0xff0000,0);
			g.drawRect(AppSettings.VIDEO_LEFT,AppSettings.VIDEO_TOP,AppSettings.VIDEO_WIDTH,AppSettings.VIDEO_HEIGHT);
		}
		
		public function activateClickPause():void
		{
			AppSettings.stage.focus = AppSettings.stage ; 
			_videoClickListener.addEventListener(MouseEvent.CLICK,onVideoClick);
			_videoClickListener.buttonMode = true;
			_videoClickListener.useHandCursor = true;
			_videoClickListener.mouseEnabled = true; 
		}
		
		public function deactivateClickPause():void
		{
			_videoClickListener.removeEventListener(MouseEvent.CLICK,onVideoClick);
			_videoClickListener.buttonMode = false;
			_videoClickListener.useHandCursor = false;
			_videoClickListener.mouseEnabled = false; 
		}
		
		public function onSpaceBarClicked(  ) : void
		{
			if( _videoClickListener.buttonMode )
			{
				_videoClickListener.dispatchEvent( new MouseEvent( MouseEvent.CLICK ) ) ;
			} 
			else
			{
				if(paused)
				{
					 DispatchManager.dispatchEvent( new Event( Flags.UN_FREEZE ) ) ;
				}
				else
				{
					 DispatchManager.dispatchEvent( new Event( Flags.FREEZE ) ) ;
				}
			}	
		}
		private function onVideoClick(evt:Event):void
		{
			switch(evt.type){
				case(MouseEvent.CLICK):
					if(paused){
						DispatchManager.dispatchEvent( new BooleanEvent( Flags.DRAW_VIDEO_STATUS ,true ) ) ;
						DispatchManager.dispatchEvent( new BooleanEvent( Flags.UPDATE_PLAY_BUTTON , true)) ;
						resumeVideo();
						
					}else{
						DispatchManager.dispatchEvent( new BooleanEvent( Flags.DRAW_VIDEO_STATUS ,false ) ) ;
						DispatchManager.dispatchEvent( new BooleanEvent( Flags.UPDATE_PLAY_BUTTON , false)) ;
						pauseVideo();
						
					}
				break;
			}
			
		}

		protected function onInit(evt:Event):void{
			_simpleVid.removeEventListener(Event.INIT, onInit);
			
			
			stage.addEventListener(Event.RESIZE,onResize);
			
			_simpleVidAvailable = true;
			if(_url && _failedToPlay == true){
				createVideo(_url);
			}
		}
		
		protected function onResize(evt:Event = null):void{
			//_simpleVid.resize( stage.stageWidth , stage.stageHeight - AppSettings.RESERVED_FOOTER_HEIGHT) //-AppSettings.RESERVED_HEIGHT ) ;
			_simpleVid.resize( stage.stageWidth , stage.stageHeight -AppSettings.RESERVED_HEIGHT ) ;
			if(_videoClickListener)
			{
				drawVideoClickListener();
			}
			if(_loader)
			{
				_loader.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;
				_loader.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2;
			}
		}
	
		protected function onSimpleStageVideoStatus(evt:SimpleStageVideoEvent):void{
			_simpleVid.removeEventListener(SimpleStageVideoEvent.STATUS, onSimpleStageVideoStatus);
			_hardwareDecoding = evt.hardwareDecoding;
			_hardwareCompositing = evt.hardwareCompositing;
			_fullGPU = evt.fullGPU;
			Logger.log(Logger.VIDEO,"StageVideoAvailable:",_simpleVid.available);
			Logger.log(Logger.VIDEO,"Hardware Decoding:",_hardwareDecoding);
			Logger.log(Logger.VIDEO,"Hardware Compositing:",_hardwareCompositing);
			Logger.log(Logger.VIDEO,"Full GPU",_fullGPU);
		}
		
		
		/*
		 * 
		 * Once the video is loaded
		 * 
		 */
		private function onActivateVideoRun( evt : Event =null ) : void
		{
			_deActivate = false ; 
			DispatchManager.addEventListener(Event.ENTER_FRAME , run ) ; 
		}
		private function deActivateVideoRun( evt : Event = null) : void
		{
			_deActivate = true ; 
			DispatchManager.removeEventListener(Event.ENTER_FRAME , run ) ; 
			SMVars.me.nsStreamTime = 0 ; 
		}
		protected function run( evt : Event ) : void
		{
			if( !_deActivate)
			{
				if( _netStream)
				SMVars.me.nsStreamTime = _netStream.time * 1000 ;
			}
			else
				SMVars.me.nsStreamTime =0 ; 
		}
		public function resetURL( ) : void
		{
			_url = null ; 
		}
		public function update( nameVideo : String ) : void
		{
			if(_netStream)
			{
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, videoStatus);
				_netStream.pause();
				_netStream.seek(0);
			} 
			createVideo( nameVideo );
			videoAddress = nameVideo ; 
		}	
		
		public function resetVideo() : void
		{
			if( _simpleVid ) _simpleVid.attachNetStream( null ) ; 
		}
		protected function createVideo( nameVideo : String) : void
		{		
			showLoader() ; 
	  		_url = nameVideo;
			if(_simpleVidAvailable){
				_failedToPlay = false;
				var url : String ; 
				DispatchManager.dispatchEvent( new StateEvent( Flags.UPDATE_DEBUG_PANEL_VIDEO , nameVideo)) ; 
				/*
				 
			 	var localPath:String = "video/flv/";
				var videoBaseUrl : String = MainIOS.STORAGE_DIR.nativePath + "/" + localPath ;
			 	
			 	
			 	 * 
			 	 */
			 
				if( _url == AppSettings.INTRO_URL && AppSettings.DEVICE == AppSettings.DEVICE_TABLET)
				{
					var ext : String = "flv" ;
					var videoFileFormatDescriptor : String = "_800"+ext;
					var videoFileExt: String = "."+ext ;
					url = AppSettings.APP_DATA_PATH + AppSettings.APP_VIDEO_BASE_URL +_url+videoFileFormatDescriptor+videoFileExt;
				}
				else
				{
					url = AppSettings.DATA_PATH+VIDEO_BASE_URL+_url+VIDEO_FILE_FORMAT_DESCRIPTOR+VIDEO_FILE_EXT;
				}
				
				
				var items:Array = _bulkLoader.items;
				var totalItems:int = items.length;
				var videoItem:VideoItem;
				for(var i:int = 0; i < totalItems; ++i)
				{
					if(items[i].url.url == url )
					{
						videoItem = items[i] as VideoItem;
					}
				} 
				
				if(videoItem){
					videoItem.pausedAtStart = false;
				}
				
				if( videoItem != null )
				{
					_netStream = videoItem.stream ;
				}
				else
				{
					_netStream = _backupNetStream ; 
				}
				
				
				if(videoItem && !_netStream)
				{
    				_bulkLoader.loadNow(url);
    				_netStream = videoItem.stream;
				}
				if( _netStream ) 
				{
					_netStream.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
					_netStream.bufferTime = 4;
					_simpleVid.attachNetStream(_netStream);
	
					if( videoItem != null)
					{
						_netStream.resume() ; 
					}
					else
					{
						_netStream.play(url);
					}
				}

				
				onResize();
				paused = false ;
				
			}else{
				_failedToPlay = true;
				addChild(_simpleVid);
			}
		}
		
		protected function showLoader():void
		{
			TweenMax.killTweensOf(_loader);
			
			_loader.visible = true ; 
			TweenMax.to( _loader , .5 , { alpha : 1  } ) ; 
			//TweenMax.to(_loader, 0.3, {autoAlpha:1});
			TweenMax.to(_loader, 1 , {rotation:360, ease:Linear.easeNone,repeat:-1});
			
			//_loader.visible = true ; 
			//_loader.alpha = 1 ; 
		}
		
		protected function hideLoader():void
		{
			TweenMax.killTweensOf(_loader);
			TweenMax.to(_loader, 0.3, {alpha:0});
			//_loader.visible = false ; 
			//TweenMax.to( _loader , .5 , { alpha : 0} )
		}
		
		protected function videoStatus( event : NetStatusEvent ) : void
		{
			//trace('event.info.code :' , event.info.code)
			//Logger.log(Logger.VIDEO,"NET STATUS:",event.info.code);
			switch (event.info.code) 
		    { 
				case "NetStream.Play.Start" :
				//	hideLoader();
				//hideLoader();
					showLoader() ;
					//onActivateVideoRun() ;
				break ;
				case "NetStream.Unpause.Notify" :
					hideLoader();
					onActivateVideoRun() ;
				break ;
				case "NetStream.Pause.Notify" :
					deActivateVideoRun() ;
				break ;
				case "NetStream.Buffer.Flush" :
					hideLoader();
					//deActivateVideoRun();
				break ;
				case "NetStream.Play.Stop" :
					deActivateVideoRun();
				break ;
			
		        case "NetStream.Buffer.Full": 
		            onActivateVideoRun() ; 
					hideLoader();
				
					
		            break; 
		        case "NetStream.Buffer.Empty": 
				
					if(!_deActivate)
					{
						showLoader();
					}
		            //deActivateVideoRun();
		            break; 
				case "NetStream.Play.StreamNotFound":
					Logger.log(Logger.VIDEO,"Stream Not Found: ", AppSettings.DATA_PATH+VIDEO_BASE_URL+_url+VIDEO_FILE_FORMAT_DESCRIPTOR+VIDEO_FILE_EXT);
					break;
				case "NetStream.Seek.InvalidTime":
					seek( _lastPos );
					break;
		    } 
			DispatchManager.dispatchEvent(event);
		}
		
		private function setBulkLoader():void{
			_bulkLoader = BulkLoader.getLoader(BulkLoaderID);
			if(_bulkLoader == null){
				_bulkLoader = new BulkLoader(BulkLoaderID,3);
			}
		}
		
		public function requestLoad(name:String):void
		{
			if(!_bulkLoader){
				setBulkLoader();
			}
			var url:String = AppSettings.DATA_PATH+VIDEO_BASE_URL+name+VIDEO_FILE_FORMAT_DESCRIPTOR+VIDEO_FILE_EXT;
			if((_bulkLoader.getProgressForItems([url])) != null && _bulkLoader.getProgressForItems([url]).itemsTotal == 0)
			{
				_bulkLoader.add(url,{id:url,type:"video",pausedAtStart:true});
				_bulkLoader.start();
			}else{
				//Logger.log(Logger.VIDEO,"video: ",url,"is already in the loader");
			}
		}
		
		public function cancelLoadRequest(name:String):void
		{
			if(_bulkLoader){
				var url:String = AppSettings.DATA_PATH+VIDEO_BASE_URL+name+VIDEO_FILE_FORMAT_DESCRIPTOR+VIDEO_FILE_EXT;
				var item:LoadingItem = _bulkLoader.get(url);
				if(item != null && item._isLoading)
				{
					item.stop();
					item.destroy();
					_bulkLoader.remove( url ) ; 
				}
			}
		}

		public function reattachStageVideo() : void {
			_simpleVid.reattachStageVideo();
		//	_simpleVid.toggle(true);
		}
	}
}

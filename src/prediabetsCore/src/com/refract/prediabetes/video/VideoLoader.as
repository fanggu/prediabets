package com.refract.prediabetes.video 
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	import br.com.stimuli.loading.loadingtypes.VideoItem;

	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.events.BooleanEvent;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.utils.Buffer;
	import com.robot.comm.DispatchManager;

	import org.bytearray.video.SimpleStageVideo;
	import org.bytearray.video.events.SimpleStageVideoEvent;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class VideoLoader extends Sprite 
	{	
		public static const VIDEO_WIDTH:int = 1024;
		public static const VIDEO_HEIGHT:int = 576;
		private static var _i : VideoLoader;
		
		private var _lastPos : Number;
		protected var _metaActive : Boolean ; 
		private var _iterMetaFixBug : int ;

		protected var _url:String;
		protected var _currentStep:int = 0;
		protected var _buffer:Buffer;
		protected var _standardVideo : Boolean;
		protected var _netConnection : NetConnection;
		protected var _netStream : NetStream;
		protected var _backupNetStream : NetStream;
		protected var _hardwareDecoding : Boolean;
		protected var _hardwareCompositing : Boolean;
		protected var _fullGPU : Boolean;
		protected var _videoClickListener:Sprite;
		protected var _simpleVid:SimpleStageVideo;
		protected var _simpleVidAvailable:Boolean;
		protected var _failedToPlay:Boolean;
		protected var _bulkLoader:BulkLoader;
		private var _deActivate : Boolean ;
		protected var _blackOn : Boolean ;
		
		public var paused : Boolean  = true;
		public var videoAddress : String;
		protected var _nameVideo : String;
		private var _showBuffer : Boolean;
		 
		public function VideoLoader()
		{
			super();
			
			_i = this;
			_showBuffer = true  ; 
			
			setBulkLoader();
			addEventListener(Event.ADDED_TO_STAGE, preInit );
		}
		
		
		
		
		public function stopVideo() : void
		{
			if(_netStream) 
				_netStream.close();
		}
		
		
		public function pauseVideo()  : void
		{
			if( _netStream) 
				_netStream.pause() ; 
				
			paused = true ; 
		}
		public function playVideo()  : void
		{
			paused = false ; 
			if( _netStream) 
				_netStream.resume() ; 
		}
		public function resumeVideo()  : void
		{
			paused = false ; 
			if( _netStream)
				 _netStream.resume() ; 
		}
		public function rePlayVideo( ) : void
		{
			paused = false ; 
			if( _netStream) 
				_netStream.play( getCompleteUrl( _url ) );
			
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
			}
		}
		protected function preInit( evt : Event ) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, preInit);
			
			DispatchManager.addEventListener(Flags.DEACTIVATE_VIDEO_RUN, deActivateVideoRun );
			DispatchManager.addEventListener(Flags.ACTIVATE_VIDEO_RUN, onActivateVideoRun );
			
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
			
			var netClient:Object = new Object();
			_netStream.client = netClient;
			if( SMSettings.DEBUG_GET_CLIP_LENGTH)
				netClient.onMetaData = metaHandler ;
			 
			
			_simpleVid.attachNetStream(_netStream);
			addChild(_simpleVid);
			
			_buffer = new Buffer();
			addChild(_buffer);
			/*
			var bmp:Bitmap = AssetManager.getEmbeddedAsset("PoliteLoader") as Bitmap;
			_buffer.addChild(bmp);
			bmp.blendMode = "screen";
			bmp.smoothing = true;
			bmp.scaleX = bmp.scaleY = 0.77;
			bmp.x = -bmp.width/2;
			bmp.y = -bmp.height/2;
			 * 
			 */
			
			_videoClickListener = new Sprite();
			addChild(_videoClickListener);
			drawVideoClickListener();
			
			
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
				_videoClickListener.dispatchEvent( new MouseEvent( MouseEvent.CLICK ) ) ;
			else
			{
				if(paused)
					 DispatchManager.dispatchEvent( new Event( Flags.UN_FREEZE ) ) ;
				else
					 DispatchManager.dispatchEvent( new Event( Flags.FREEZE ) ) ;
			}	
		}
		private function onVideoClick(evt:Event):void
		{
			switch(evt.type)
			{
				case(MouseEvent.CLICK):
					if(paused)
					{
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

		protected function onInit(evt:Event):void
		{
			_simpleVid.removeEventListener(Event.INIT, onInit);
			stage.addEventListener(Event.RESIZE,onResize);
			_simpleVidAvailable = true;
			if(_url && _failedToPlay == true)
			{
				createVideo(_url);
			}
			
		}
		
		protected function onResize(evt:Event = null):void
		{
			_simpleVid.resize( stage.stageWidth , stage.stageHeight -AppSettings.RESERVED_HEIGHT ) ;
			if(_videoClickListener)
			{
				drawVideoClickListener();
			}
			if(_buffer)
			{
				_buffer.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;
				_buffer.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2;
			}
		}
	
		protected function onSimpleStageVideoStatus(evt:SimpleStageVideoEvent):void{
			_simpleVid.removeEventListener(SimpleStageVideoEvent.STATUS, onSimpleStageVideoStatus);
			_hardwareDecoding = evt.hardwareDecoding;
			_hardwareCompositing = evt.hardwareCompositing;
			_fullGPU = evt.fullGPU;
			/*
			trace( "StageVideoAvailable:",_simpleVid.available ) ;
			trace( "Hardware Decoding:",_hardwareDecoding);
			trace( "Hardware Compositing:",_hardwareCompositing);
			trace( "Full GPU",_fullGPU);
			 * 
			 */
		}
		

		private function onActivateVideoRun( evt : Event =null ) : void
		{
			_deActivate = false ; 
			DispatchManager.addEventListener(Event.ENTER_FRAME , run ) ; 
			hideBuffer() ; 
			
			SMController.me.onVideoStart() ; 
		}
	
		private function deActivateVideoRun( evt : Event = null) : void
		{
			_deActivate = true ; 
			DispatchManager.removeEventListener(Event.ENTER_FRAME , run ) ; 
			SMVars.me.nsStreamTime = 0 ; 
			
			hideLoader() ; 
		}
		protected function run( evt : Event ) : void
		{
			if( !_deActivate)
			{
				if( _netStream)
				SMVars.me.nsStreamTime = _netStream.time * 1000 ;
				SMVars.me.nsStreamTimeAbs = SMVars.me.nsStreamTime ; 
			}
			else
				SMVars.me.nsStreamTime =0 ; 
				
			var percent:Number = Math.round( _netStream.bufferLength / _netStream.bufferTime * 100);
			if( percent > 95 && _showBuffer )
			{
				hideBuffer() ; 
			}
			if( percent < 5 && !_showBuffer )
			{ 
				var clip_length : Number = SMController.me.model.getVideoLength( _nameVideo ) - 200 ; 
				if( SMVars.me.nsStreamTime <= ( clip_length ) ) 
				{
					showBuffer() ;	
				}
				 
			}
				
		}
		private function showBuffer() : void
		{
			if( !_showBuffer )
			{
				_buffer.off = false; 
				_showBuffer = true ; 
				TweenMax.killTweensOf( _buffer ) ;
				TweenMax.to( _buffer , .5 , { alpha : 1 , delay : AppSettings.BUFFER_DELAY } ) ; 
			}
		}
		protected function hideBuffer() : void
		{
			if( _showBuffer )
			{
				_showBuffer = false ; 
				TweenMax.killTweensOf( _buffer ) ;
				TweenMax.to( _buffer , .5 , { alpha : 0 , onComplete : invisibleBuffer } ) ; 
			}
		}
		private function invisibleBuffer() : void
		{
			_buffer.off = true; 
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
			if( _simpleVid ) 
				_simpleVid.attachNetStream( null ) ; 
		}
		protected function createVideo( nameVideo : String) : void
		{		
			
			SMVars.me.nsStreamTimeAbs = 0 ; 
			showBuffer() ; 
			
			_metaActive = true ;  
			_iterMetaFixBug = 0 ; 
			
	  		_url = nameVideo;
			_nameVideo = nameVideo ; 
			if(_simpleVidAvailable)
			{
				_failedToPlay = false;
				var url : String ; 
				url = getCompleteUrl( _url ) ;
				if( _url == AppSettings.INTRO_URL && AppSettings.DEVICE == AppSettings.DEVICE_TABLET)
				{
					var ext : String = "flv" ;
					var videoFileFormatDescriptor : String = "";
					var videoFileExt: String = "."+ext ;
					url = AppSettings.APP_DATA_PATH + AppSettings.APP_VIDEO_BASE_URL +_url+videoFileFormatDescriptor+videoFileExt;
				}
				else
				{
					url = getCompleteUrl( _url ) ; 
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
				
				if( videoItem )
				{
					 _metaActive = false ; 
					 /*DEBUG DURATION
					 var obj : Object = {} ; obj.clip_length = Number( videoItem.metaData['duration'] ) * 1000  ;
					 DispatchManager.dispatchEvent(new ObjectEvent( Flags.ON_FLV_METADATA , obj  ) ) ; 
					 trace( '"'+_nameVideo+'"' + ' : ' + obj.clip_length + ' , ')
					  * 
					  */
				}
				
				if(videoItem)
				{
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
				
				_netStream.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
				_netStream.bufferTime = 4;
				_simpleVid.attachNetStream(_netStream);
				
				if( videoItem != null)
				{
					if( nameVideo == SMSettings.D_21_M )
					{
						_netStream.play( url ) ; 
					}
					else
					{
						if( _netStream.time > 0.1)
						{
							_netStream.seek( 0 ) ;
							_netStream.play(url);
						}
						else
						{
							_netStream.resume() ;
						}
					}
				}
				else
				{
					_netStream.play(url);
				}
				
				onResize();
				paused = false ;
			}
			else
			{
				_failedToPlay = true;
				addChild(_simpleVid);
			}
			
			if( AppSettings.DEBUG ) DispatchManager.dispatchEvent( new StateEvent( Flags.UPDATE_DEBUG_PANEL_VIDEO , nameVideo)) ;
		}
		
		//* DEBUG DURATION
		private function metaHandler( meta : Object ) : void
		{ 
			if( _metaActive )
			{
				var obj : Object= {} ; obj.clip_length = Number( meta.duration ) * 1000 ;
				_iterMetaFixBug++ ;
				if( _iterMetaFixBug > 1 )
				{
					DispatchManager.dispatchEvent(new ObjectEvent( Flags.ON_FLV_METADATA , obj ) ) ;
					trace( '"'+_nameVideo+'"' + ' : ' + obj.clip_length + ' , ')
				} 
			}
	        
		}
		 
		public function questionShowLoader() : void
		{
			showBuffer() ;  
		}

		
		public function hideLoader():void
		{
			 hideBuffer() ; 
		}
		
		protected function videoStatus( event : NetStatusEvent ) : void
		{
			switch (event.info.code) 
		    { 
				case "NetStream.Play.Start" :
					//showLoader() ;
					showBuffer() ; 
				break ;
				case "NetStream.Unpause.Notify" :
					//hideLoader();
					onActivateVideoRun() ;
				break ;
				case "NetStream.Pause.Notify" :
					deActivateVideoRun() ;
				break ;
				case "NetStream.Buffer.Flush" :
					//hideLoader();
				break ;
				case "NetStream.Play.Stop" :
					deActivateVideoRun();
				break ;
			
		        case "NetStream.Buffer.Full": 
		            onActivateVideoRun() ; 
					//hideLoader();
		            break; 
		        case "NetStream.Buffer.Empty": 

		            break; 
				case "NetStream.Play.StreamNotFound":
					
					break;
				case "NetStream.Seek.InvalidTime":
					seek( _lastPos );
					break;
		    } 
			DispatchManager.dispatchEvent(event);
		}
		
		public function isLoaded( videoName : String ) : Boolean
		{
			var completeUrl : String = getCompleteUrl( videoName ) ; 
			if( _bulkLoader.hasItem( completeUrl ) )
				return true ;
			else
				return false ; 
		}
		public function getCompleteUrl( videoName : String ) : String
		{
			var url : String = 
						AppSettings.DATA_PATH
						+AppSettings.VIDEO_BASE_URL
						+ videoName
						+AppSettings.VIDEO_FILE_FORMAT_DESCRIPTOR
						+AppSettings.VIDEO_FILE_EXT;
						
			return url ; 
		}
		
		protected function setBulkLoader():void{
			_bulkLoader = BulkLoader.getLoader(AppSettings.BULK_LOADER_ID);
			if(_bulkLoader == null){
				_bulkLoader = new BulkLoader( AppSettings.BULK_LOADER_ID , 3 ) ;
			}
		}
		
		public function requestLoad(name:String):void
		{
			if(!_bulkLoader){
				setBulkLoader();
			}
			var url:String = getCompleteUrl( name ) ; 
			if((_bulkLoader.getProgressForItems([url])) != null && _bulkLoader.getProgressForItems([url]).itemsTotal == 0)
			{
				_bulkLoader.add(url,{id:url,type:"video",pausedAtStart:true});
				_bulkLoader.start();
				
			}
		}
		
		public function cancelLoadRequest(name:String):void
		{
			
			if(_bulkLoader)
			{
				var url:String =getCompleteUrl( name ) ; 
				if( name == _url)
				{
					return ; 
				}
				var item:LoadingItem = _bulkLoader.get(url);
				if(item != null && item._isLoading && !item._isLoaded)
				{
					item.stop();
					item.destroy();
					_bulkLoader.remove( url ) ; 
				}
				if( item ) 
				{
					if( !item._isLoaded  ) 
					{
						_bulkLoader.remove( url ) ; 
					}
				}
			}
		}
		public function removeItem( name : String ) : void
		{
			if(_bulkLoader)
			{
				var url:String =getCompleteUrl( name ) ; 
				if( name == _url)
					return ; 
				
				var item:LoadingItem = _bulkLoader.get(url);
				if( item )  _bulkLoader.remove( url ) ; 
			}
		}
		

		public function reattachStageVideo() : void {
			_simpleVid.reattachStageVideo();
		//	_simpleVid.toggle(true);
		
		}
		
		
		public static function get i():VideoLoader{ return _i; }
		public static function set i(vl:VideoLoader):void{ _i = vl;} 
		public function get url():String {return _url;}
		//public static function set defaultLoadingOrder(newOrder:Array):void{ _defaultLoadingOrder = newOrder; }
		//public static function get defaultLoadingOrder():Array{ return _defaultLoadingOrder; }
		//public function set loadingOrder(newOrder:Array):void{ _loadingOrder = newOrder; }
		//public function get loadingOrder():Array{ return _loadingOrder; }
		private function onAllProgress( event : BulkProgressEvent ) : void
		{
			
		}
		
		//**to be extended in iOS
		public function setLoadedTrue() : void{}
		public function get nameVideo() : String
		{
			return _nameVideo ; 
		}
		
	}
}

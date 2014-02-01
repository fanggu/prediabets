package com.refract.air.shared.prediabetes.video 
{
	import flash.utils.setTimeout;
	import br.com.stimuli.loading.loadingtypes.VideoItem;

	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.video.VideoLoader;
	import com.robot.comm.DispatchManager;

	import flash.events.NetStatusEvent;


	public class IOSVideoLoader extends VideoLoader {
		
		private var _wasLoaded : Boolean ; 
		private var _delayedUrl : String ; 
		public function IOSVideoLoader() 
		{
			_wasLoaded = false ; 
			
			super();
		}
		
	
		/*
		override protected function createVideo( nameVideo : String) : void
		{	
	  		_url = nameVideo;
			if(_simpleVidAvailable)
			{	
				var url:String = 
					AppSettings.DATA_PATH 
					+ AppSettings.VIDEO_BASE_URL 
					+ _url+AppSettings.VIDEO_FILE_FORMAT_DESCRIPTOR 
					+ AppSettings.VIDEO_FILE_EXT;
				if( !_simpleVid )
				{
					_simpleVid = new SimpleStageVideo(AppSettings.VIDEO_WIDTH,AppSettings.VIDEO_HEIGHT);
					_simpleVid.addEventListener(Event.INIT, onInit);
					_simpleVid.addEventListener(SimpleStageVideoEvent.STATUS, onSimpleStageVideoStatus);
				}
				
				if( !_netConnection)
				{
					_netConnection= new NetConnection();
		        	_netConnection.connect(null);
				}
				
				if( !_backupNetStream)
				{
					_backupNetStream = new NetStream(_netConnection);
					_backupNetStream.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
			        _backupNetStream.client = {};
				}
				else
				{
					if( !_backupNetStream.hasEventListener(NetStatusEvent.NET_STATUS  ) )
					{
						_backupNetStream = new NetStream(_netConnection);
						_backupNetStream.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
			        	_backupNetStream.client = {};
					}
					//_backupNetStream = new NetStream(_netConnection);
					//_backupNetStream.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
			        //_backupNetStream.client = {};
				}
				_netStream = _backupNetStream;
				
				//_simpleVid.attachNetStream(_netStream);
				
				if( !_simpleVid.parent ) 
				{
					addChild(_simpleVid);
				}
					
				
						
				_netStream.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
				_netStream.bufferTime = 4;
				
				_simpleVid.attachNetStream(_netStream);
				_netStream.play(url);
				
				onResize();
				paused = false ;
			}
		}
		
		 * 
		 */
		 
		override protected function createVideo( nameVideo : String) : void
		{		
			SMVars.me.nsStreamTimeAbs = 0 ; 

	  		_url = nameVideo;
			_nameVideo = nameVideo ; 
			if(_simpleVidAvailable)
			{
				_failedToPlay = false;
				var url : String ; 
				url = getCompleteUrl( _url ) ;
				if( _url == AppSettings.INTRO_URL )
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
				
				
				if(videoItem)
				{
					trace('-1-')
					videoItem.pausedAtStart = false;
				}
				
				
				if( videoItem != null )
				{
					trace('-2-')
					_netStream = videoItem.stream ;
				}
				else
				{
					trace('-3-')
					_netStream = _backupNetStream ; 
				}
				if(videoItem && !_netStream)
				{
					trace('-4-')
    				_bulkLoader.loadNow(url);
    				_netStream = videoItem.stream;
				}
				
				_netStream.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
				_netStream.bufferTime = 10 ;
				_simpleVid.attachNetStream(_netStream);
				
				/*
				if( videoItem != null)
				{
					_netStream.seek( 0 ) ; 
					_netStream.resume() ;
				}
				else
					_netStream.play(url);
					 * 
					 */
				
				if( _wasLoaded )
				{
					trace('-5-')	
					_wasLoaded = false ;
					//_netStream.play(url);
					_netStream.resume() ;
					/*
					if( _netStream.time > 0.1)
					{
						_netStream.seek( 0 ) ;
						_netStream.play(url);
					}
					else
					{
						_netStream.resume() ;
					}
					 * 
					 */
				}
				 else
				 {
					trace('-6-')
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
			DispatchManager.dispatchEvent( new StateEvent( Flags.UPDATE_DEBUG_PANEL_VIDEO , nameVideo)) ;
			
			if( _url == AppSettings.INTRO_URL)
			{
				trace("yes?")
				//_netStream.pause() ; 
				_delayedUrl = url ; 
				setTimeout( delayedPlay , 1000 ) ; 
			}
		}
		
		private function delayedPlay() : void
		{
			_netStream.seek( 0 ) ;  
		}
		override public function update( nameVideo : String ) : void
		{
			if(_netStream)
			{
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, videoStatus);
				_netStream.close() ;
				_netStream.close() ;
				_netStream = null ; 
				//var urlTemp:String = getCompleteUrl( nameVideo ) ; 
				//_bulkLoader.remove( urlTemp ) ; 
			} 
			super.update( nameVideo ) ; 
		}	
		
		override public function setLoadedTrue( ) : void
		{
			_wasLoaded = true ; 
		}

	}
}

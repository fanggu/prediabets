package com.refract.air.shared.prediabetes.video 
{
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.video.VideoLoader;
	import com.robot.comm.DispatchManager;

	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.utils.setTimeout;


	public class IOSVideoLoader extends VideoLoader {
		
		private var _wasLoaded : Boolean ; 
		private var _delayedUrl : String ; 
		public function IOSVideoLoader() 
		{
			_wasLoaded = false ; 
			addEventListener(Event.ADDED_TO_STAGE, preInit );
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
				
				_netStream = _backupNetStream ;
				
				_netStream.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
				_netStream.bufferTime = 10 ;
				_simpleVid.attachNetStream(_netStream);
				
				_netStream.play(url);
				
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
		
		
		override public function requestLoad(name:String):void
		{
		}
		
		override public function cancelLoadRequest(name:String):void
		{
		}

	}
}

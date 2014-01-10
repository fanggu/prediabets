package com.refract.air.shared.prediabetes.video 
{
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.video.VideoLoader;

	import org.bytearray.video.SimpleStageVideo;
	import org.bytearray.video.events.SimpleStageVideoEvent;

	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;


	public class IOSVideoLoader extends VideoLoader {
		
		public function IOSVideoLoader() {
		//	VIDEO_BASE_URL = "video/flv/";
		//	VIDEO_FILE_EXT = '.flv' ; 
			super();
		}
		
	
		  
		override protected function createVideo( nameVideo : String) : void
		{	
	  		_url = nameVideo;
			if(_simpleVidAvailable)
			{	
				var url:String = AppSettings.DATA_PATH+VIDEO_BASE_URL+_url+VIDEO_FILE_FORMAT_DESCRIPTOR+VIDEO_FILE_EXT;
				trace('url :' , url )
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
				trace('play url :: ' , url )
				_netStream.play(url);
				
				onResize();
				paused = false ;
			}
		}
		
		
		
		
		override protected function showLoader():void
		{
		//	TweenMax.killTweensOf(_loader);
			
		//	_loader.visible = true ; 
		//	TweenMax.to( _loader , .5 , { alpha : 1 , delay : .5 } ) ; 
		//	TweenMax.to(_loader, 1 , {rotation:360, ease:Linear.easeNone,repeat:-1}); 
		}
		
		override protected function hideLoader():void
		{
		//	TweenMax.killTweensOf(_loader);
		//	TweenMax.to(_loader, 0.3, {alpha:0});
			//_loader.visible = false ; 
			//TweenMax.to( _loader , .5 , { alpha : 0} )
		}
		
		
		override public function update( nameVideo : String ) : void
		{
			if(_netStream)
			{
				_netStream.removeEventListener(NetStatusEvent.NET_STATUS, videoStatus);
				_netStream.close() ;
				_netStream.close() ;
				_netStream = null ; 
				var urlTemp:String = AppSettings.DATA_PATH+VIDEO_BASE_URL+nameVideo+VIDEO_FILE_FORMAT_DESCRIPTOR+VIDEO_FILE_EXT;
				_bulkLoader.remove( urlTemp ) ; 
				
			} 
			super.update( nameVideo ) ; 
		}	
		override public function requestLoad( name : String ) : void
		{
			//do nothing
		}
		override public function cancelLoadRequest( name : String ) : void
		{
			//do nothing
		}
	}
}

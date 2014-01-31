package {
	import com.flashdynamix.utils.SWFProfiler;
	import com.refract.prediabetes.AppController;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.FontManager;
	import com.refract.prediabetes.assets.TextManager;
	//import com.refract.prediabetes.tracking.Tracking;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	[SWF( backgroundColor='#000000', frameRate='60')]
	public class PrediabetesCore extends Sprite 
	{	
		public function PrediabetesCore() 
		{
			new FontManager();
			addEventListener( Event.ADDED_TO_STAGE , init ) ; 
			
		}
		private function donothing( evt : Event ) : void
		{
			
		}
		private function test( evt : Event ) : void
		{
			
			/*
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			try
			{
			    loader.load(new URLRequest("http://healthmentoronline.com:8086/action/getAttachment/:1"));
			}
			catch (error:Error)
			{
			    trace("Error loading URL: " + error.message);
			}
			 * 
			 */
			//Security.allowDomain("*") ;
			var loader:URLLoader = new URLLoader();
			/*
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			 * 
			 */
			
			//Create the HTTP request object 
		     
		    //var request:URLRequest = new URLRequest( "http://healthmentoronline.com:8086/timespent/start" );
			//var request:URLRequest = new URLRequest( "http://healthmentoronline.com:8086/timespent/end/3" );
			//var request:URLRequest = new URLRequest( "http://healthmentoronline.com:8086/action/getAttachment/1" );
			//var request:URLRequest = new URLRequest( "http://healthmentoronline.com:8086/action/closeAttachment/1" );
			//var request:URLRequest = new URLRequest( "http://healthmentoronline.com:8086/interactive" );
			var request:URLRequest = new URLRequest( "http://healthmentoronline.com:8086/location" );
			
				
			
		   request.method = URLRequestMethod.POST;
		   request.requestHeaders = new Array
		   (
		   		new URLRequestHeader("userId", "65C68682-5052-52DD-14FB-B07465E37319")
				,new URLRequestHeader("trackId", "1")
			);
		    //Add the URL variables 
		    var variables:URLVariables = new URLVariables();   
			variables.param = '{"latitude":"33.8404","longitude":"170.7399","ipaddress":"192.168.1.1"}';
			//variables.param = '{"episodeId":"d11s","choice":"what?","nextEpisodeId":"d21", "currentStep" : "13"}';  
			//variables.param = {} ;     
		    request.data = variables; 
			
			
			
	
			
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loader.load( request ) ; 
		}

		private function httpResponseHandler(event : HTTPStatusEvent) : void 
		{
			var urlRequestHeader : URLRequestHeader ; 
			for( var i : int = 0 ; i < event.responseHeaders.length ; i ++ )
			{
				urlRequestHeader = event.responseHeaders[i] ; 
				if( urlRequestHeader.name == 'Trackheader')
				{
					trace('value :' , urlRequestHeader.value)
				}
			}
		}
		
		private function loaderCompleteHandler(e:Event):void
		{
		    // and here's your response (in your case the JSON)
		    trace('---' , e.target.data);
		}
		
		private function httpStatusHandler(e:HTTPStatusEvent):void
		{
			trace("*****")
			//if( e.responseHeaders ) trace('e ', e.responseHeaders ) 
		    trace("httpStatusHandler:" + e.status);
		
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
		    trace("securityErrorHandler:" + e.text);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{
		    trace("ioErrorHandler: " + e.text);
		}



		private function init(  evt : Event ) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			//trace(' User Id :' , Tracking.USER_ID )
			//trace(' Track Id :' , Tracking.TRACK_ID )
			SWFProfiler.init(stage, this);
			AppSettings.stage = stage ; 
			
			
			stage.align = StageAlign.TOP_LEFT; 
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//SoundMixer.soundTransform = new SoundTransform(0);
	
			var bytes : ByteArray = AssetManager.getEmbeddedAsset("CopyJSON") as ByteArray;
			TextManager.parseData(bytes.readUTFBytes(bytes.length));
			
			//AppSettings.RETINA = false ; 
			startApp() ; 
		}

		private function startApp():void{
			 var appController : AppController = new ClassFactory.APP_CONTROLLER( this );
			 appController.init( ) ; 
		}
	}
}

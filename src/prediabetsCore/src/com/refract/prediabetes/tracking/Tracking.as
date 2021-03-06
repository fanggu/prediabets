package com.refract.prediabetes.tracking {
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	/**
	 * @author otlabs
	 */
	public class Tracking 
	{
		protected var _loader : URLLoader ; 
		public function Tracking()
		{
				
		}
		protected function trackRequest( obj : Object ) : void
		{
			_loader = new URLLoader();
			var address : String = TrackingSettings.BASE_ADDRESS + obj.address ; 
			var request:URLRequest = new URLRequest( TrackingSettings.BASE_ADDRESS + obj.address );	
		    request.method = obj.method ; 
			request.requestHeaders = new Array
			(
			   	new URLRequestHeader("userId", TrackingSettings.USER_ID)
				,new URLRequestHeader("trackId", TrackingSettings.TRACK_ID)
			);  
		    request.data = obj.variables; 
			
			_loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			_loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			_loader.load( request ) ; 
			
		}
		protected function httpResponseHandler(event : HTTPStatusEvent) : void { dispose() ; }
		protected function loaderCompleteHandler(e:Event):void { dispose() ; }
		protected function httpStatusHandler(e:HTTPStatusEvent):void{ dispose() ; }
		protected function securityErrorHandler(e:SecurityErrorEvent):void{ dispose() ; }
		protected function ioErrorHandler(e:IOErrorEvent):void{ dispose() ; }
		
		protected function dispose() : void
		{
			if( _loader )
			{
				_loader.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
				_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				_loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseHandler);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_loader = null ; 
			}
			 
		}
	}
}

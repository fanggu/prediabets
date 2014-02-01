package com.refract.prediabetes.tracking {
	import com.refract.prediabetes.AppSettings;

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
		public function Tracking()
		{
				
		}
		protected function trackRequest( obj : Object ) : void
		{
			var loader:URLLoader = new URLLoader();
			var address : String = TrackingSettings.BASE_ADDRESS + obj.address ; 
			var request:URLRequest = new URLRequest( TrackingSettings.BASE_ADDRESS + obj.address );	
		    request.method = obj.method ; 
			request.requestHeaders = new Array
			(
			   	new URLRequestHeader("userId", TrackingSettings.USER_ID)
				,new URLRequestHeader("trackId", TrackingSettings.TRACK_ID)
			);  
		    request.data = obj.variables; 
			
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loader.load( request ) ; 
			
		}
		protected function httpResponseHandler(event : HTTPStatusEvent) : void {}
		protected function loaderCompleteHandler(e:Event):void{}
		protected function httpStatusHandler(e:HTTPStatusEvent):void{}
		protected function securityErrorHandler(e:SecurityErrorEvent):void{}
		protected function ioErrorHandler(e:IOErrorEvent):void{}
	}
}

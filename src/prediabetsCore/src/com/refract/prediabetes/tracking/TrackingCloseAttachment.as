package com.refract.prediabetes.tracking {
	import com.refract.prediabetes.tracking.VO.TrackingRequestVO;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @author otlabs
	 */
	public class TrackingCloseAttachment extends Tracking {
		public function TrackingCloseAttachment() 
		{
			super();
		}
		public function track( id : int ) : void
		{
			var objTrackRequest : TrackingRequestVO = new TrackingRequestVO() ; 
			objTrackRequest.address = TrackingSettings.ATTACHMENT_CLOSE_ADDRESS + id; 
			var variables:URLVariables = new URLVariables();
			variables.param = {} ; 
			objTrackRequest.variables = variables ; 
			objTrackRequest.method = URLRequestMethod.POST ; 
			trackRequest( objTrackRequest ) ; 
		}
		
		
		override protected function trackRequest( obj : Object ) : void
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
		
		
		/*
		override protected function trackRequest( obj : Object ) : void
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
		 * 
		 */
		override protected function loaderCompleteHandler(e:Event):void
		{ 	 
			
		}
		
		override protected function httpStatusHandler(e:HTTPStatusEvent):void
		{
		   // trace("Close::httpStatusHandler:" + e.status);
			
		}
	}
}
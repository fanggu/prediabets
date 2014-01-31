package com.refract.prediabetes.tracking {
	import com.refract.prediabetes.tracking.VO.TrackingRequestVO;
	import com.robot.comm.DispatchManager;

	import flash.events.Event;
	import flash.events.GeolocationEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.sensors.Geolocation;
	
	/**
	 * @author otlabs
	 */
	public class Tracking 
	{
		public static const HEADER_REGISTERED : String = 'headerRegistered' ; 
		public static const HEADER_NOT_REGISTERED : String = 'headerNotRegistered' ; 
		
		public static const LOCATION : String = 'location' ;
		public static const START : String = 'start' ;  
		
		public static const BASE_ADDRESS : String = 'http://healthmentoronline.com:8086/' ; 
		
		public static const LOCATION_ADDRESS : String = 'location' ; 
		public static const START_ADDRESS : String = 'timespent/start' ; 
		
 		public static var USER_ID : String = '65C68682-5052-52DD-14FB-B07465E37313' ; 
		public static var TRACK_ID : String ='13'; 
		public static var IP_ADDRESS : String = '000' ; 
		
		private static var _geo : Geolocation ; 
		
		public static function track( obj : Object) : void
		{
			switch( obj.type )
			{
				case LOCATION : 
					trackLocation() ; 
				break ; 
				case START : 
					trackStart( obj ) ;
				break ; 
			}
			
		}
		
		private static function trackStart( obj : Object ) : void
		{
			var objTrackRequest : TrackingRequestVO = new TrackingRequestVO() ; 
			objTrackRequest.address = START_ADDRESS ; 
			var variables:URLVariables = new URLVariables();
			variables.param = {} ; 
			objTrackRequest.variables = variables ; 
			objTrackRequest.method = URLRequestMethod.POST ; 
			objTrackRequest.callBack = obj.callBack ; 
			
			trackRequest( objTrackRequest ) ; 
		}
		
		private static function trackLocation() : void
		{
			_geo = new Geolocation(); 
			if (Geolocation.isSupported)
			{ 
				_geo.addEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
			}
		}
		

		private static function geoUpdateHandler(event : GeolocationEvent) : void 
		{
			_geo.removeEventListener( GeolocationEvent.UPDATE, geoUpdateHandler) ; 
			_geo = null ; 

			var objTrackRequest : TrackingRequestVO = new TrackingRequestVO() ; 
			objTrackRequest.address = LOCATION_ADDRESS ; 
			var variables:URLVariables = new URLVariables();
			variables.param = '{"latitude":"' + event.latitude + '","longitude":"' + event.longitude + '","ipaddress":"' + IP_ADDRESS + '"}';
			objTrackRequest.variables = variables ; 
			objTrackRequest.method = URLRequestMethod.POST ; 
			
			trackRequest( objTrackRequest ) ; 
		}
		
		
		private static function trackRequest( obj : Object ) : void
		{
			var loader:URLLoader = new URLLoader();
			var address : String = BASE_ADDRESS + obj.address ; 
			var request:URLRequest = new URLRequest( BASE_ADDRESS + obj.address );	
		    request.method = obj.method ; 
			if( !obj.callBack)
			{
				request.requestHeaders = new Array
				(
				   	new URLRequestHeader("userId", USER_ID)
					,new URLRequestHeader("trackId", TRACK_ID)
				);    
			}
			else
			{
				request.requestHeaders = new Array
				(
				   	new URLRequestHeader("userId", '')
					,new URLRequestHeader("trackId", '')
				);  
			}
		    request.data = obj.variables; 
			
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			if( obj.callBack)
				loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, httpResponseHandler);
				
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			loader.load( request ) ; 
			
		}
		
		private static function httpResponseHandler(event : HTTPStatusEvent) : void 
		{
			trace('::httpResponseHandler::')
			var urlRequestHeader : URLRequestHeader ; 
			for( var i : int = 0 ; i < event.responseHeaders.length ; i ++ )
			{
				urlRequestHeader = event.responseHeaders[i] ; 
				if( urlRequestHeader.name == 'Trackheader')
				{
					var headerObj : Object = JSON.parse(urlRequestHeader.value) ; 
					Tracking.TRACK_ID = headerObj.trackId ;
					Tracking.USER_ID = headerObj.userId ;   
					
					trace('--header registered ')
					DispatchManager.dispatchEvent( new Event( Tracking.HEADER_REGISTERED ) ) ; 
					return ; 
				}
			}
			trace('HERE???')
			DispatchManager.dispatchEvent( new Event( Tracking.HEADER_NOT_REGISTERED ) ) ; 
		}

		
		private static function loaderCompleteHandler(e:Event):void
		{
		    // and here's your response (in your case the JSON)
		    //trace('---' , e.target.data);
		}
		
		private static function httpStatusHandler(e:HTTPStatusEvent):void
		{
			trace("+++++") 
		    trace("httpStatusHandler:" + e.status);
		
		}
		
		private static function securityErrorHandler(e:SecurityErrorEvent):void
		{
		    //trace("securityErrorHandler:" + e.text);
		}
		
		private static function ioErrorHandler(e:IOErrorEvent):void
		{
		    //trace("ioErrorHandler: " + e.text);
		}
		
	}
}

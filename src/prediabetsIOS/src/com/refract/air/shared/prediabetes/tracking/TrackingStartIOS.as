package com.refract.air.shared.prediabetes.tracking {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.tracking.Tracking;
	import com.refract.prediabetes.tracking.TrackingSettings;
	import com.refract.prediabetes.tracking.VO.TrackingRequestVO;
	import com.robot.comm.DispatchManager;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @author otlabs
	 */
	public class TrackingStartIOS extends Tracking
	{
		
		
		public function TrackingStartIOS() 
		{
			
		}
		public function track() : void
		{
			var objTrackRequest : TrackingRequestVO = new TrackingRequestVO() ; 
			objTrackRequest.address = TrackingSettings.START_ADDRESS ; 
			var variables:URLVariables = new URLVariables();
			variables.param = {} ; 
			objTrackRequest.variables = variables ; 
			objTrackRequest.method = URLRequestMethod.POST ; 
			trackRequest( objTrackRequest ) ; 
		}
		
		
		override protected function httpResponseHandler(event : HTTPStatusEvent) : void 
		{
			var urlRequestHeader : URLRequestHeader ; 
			for( var i : int = 0 ; i < event.responseHeaders.length ; i ++ )
			{
				urlRequestHeader = event.responseHeaders[i] ; 
				if( urlRequestHeader.name == 'Trackheader')
				{
					var headerObj : Object = JSON.parse(urlRequestHeader.value) ; 
					TrackingSettings.TRACK_ID = headerObj.trackId ;
					TrackingSettings.USER_ID = headerObj.userId ;   
					AppSettings.TRACKING = true ; 
					return ; 
				}
			}
		}

		
		override protected function loaderCompleteHandler(e:Event):void
		{
			var headerObj : Object = JSON.parse(e.target.data) ; 
			TrackingSettings.TIMESPENT_ID = headerObj.id ; 
		    DispatchManager.dispatchEvent( new Event( TrackingSettings.HEADER_REGISTERED ) ) ;
		}
		
		override protected function httpStatusHandler(e:HTTPStatusEvent):void
		{
		    //trace("httpStatusHandler:" + e.status);
			//trace('e responseURL' , e.responseURL)
		}
		
		override protected function securityErrorHandler(e:SecurityErrorEvent):void
		{
			DispatchManager.dispatchEvent( new Event( TrackingSettings.HEADER_REGISTERED ) ) ;
		    //trace("securityErrorHandler:" + e.text);
		}
		
		override protected function ioErrorHandler(e:IOErrorEvent):void
		{
			DispatchManager.dispatchEvent( new Event( TrackingSettings.HEADER_REGISTERED ) ) ;
		    //trace("ioErrorHandler: " + e.text);
		}
		
	}
}

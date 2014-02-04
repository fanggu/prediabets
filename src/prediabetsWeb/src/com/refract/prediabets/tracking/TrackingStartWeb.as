package com.refract.prediabets.tracking {
	import com.refract.prediabetes.tracking.Tracking;
	import com.refract.prediabetes.tracking.TrackingSettings;
	import com.refract.prediabetes.tracking.VO.TrackingRequestVO;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @author otlabs
	 */
	public class TrackingStartWeb extends Tracking {
		public function TrackingStartWeb() 
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
		override protected function loaderCompleteHandler(e:Event):void
		{
			var headerObj : Object = JSON.parse(e.target.data) ;
			//trace('complete TrackingSettings.TIMESPENT_ID: ' ,TrackingSettings.TIMESPENT_ID)
			//trace('complete headerObj.id: ' , headerObj.trackId)
			//TrackingSettings.TIMESPENT_ID = headerObj.id ;
		}
		override protected function httpStatusHandler(e:HTTPStatusEvent):void
		{
		    //trace("httpStatusHandler:" + e.status);
			//trace('>>>>e responseURL' , e.responseURL)
		}
	}
}

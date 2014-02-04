package com.refract.prediabetes.tracking {
	import com.refract.prediabetes.tracking.VO.TrackingRequestVO;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * @author otlabs
	 */
	public class TrackingEnd extends Tracking
	{
		public function TrackingEnd() 
		{
			
		}
		public function track() : void
		{
			var objTrackRequest : TrackingRequestVO = new TrackingRequestVO() ; 
			objTrackRequest.address = TrackingSettings.END_ADDRESS + TrackingSettings.TIMESPENT_ID ; 
			var variables:URLVariables = new URLVariables();
			variables.param = {} ; 
			objTrackRequest.variables = variables ; 
			objTrackRequest.method = URLRequestMethod.POST ; 
			trackRequest( objTrackRequest ) ; 
		}
		
		override protected function loaderCompleteHandler(e:Event):void
		{ 	 
			
		}
		
		override protected function httpStatusHandler(e:HTTPStatusEvent):void
		{
		    //trace("end::httpStatusHandler:" + e.status);
		}
		
		override protected function securityErrorHandler(e:SecurityErrorEvent):void
		{
		   //trace("securityErrorHandler:" + e.text);
		}
		
		override protected function ioErrorHandler(e:IOErrorEvent):void
		{
		    //trace("ioErrorHandler: " + e.text);
		}
	}
}

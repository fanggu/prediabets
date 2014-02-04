package com.refract.prediabetes.tracking {
	import com.refract.prediabetes.tracking.VO.TrackingRequestVO;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @author otlabs
	 */
	public class TrackingGetAttachment extends Tracking {
		public function TrackingGetAttachment() 
		{
			super();
		}
		public function track( id : int ) : void
		{
			var objTrackRequest : TrackingRequestVO = new TrackingRequestVO() ; 
			objTrackRequest.address = TrackingSettings.ATTACHMENT_GET_ADDRESS + id ; 
			var variables:URLVariables = new URLVariables();
			variables.param = {} ; 
			objTrackRequest.variables = variables ; 
			objTrackRequest.method = URLRequestMethod.POST ; 
			trackRequest( objTrackRequest ) ; 
		}
		override protected function loaderCompleteHandler(e:Event):void
		{ 	 
			var headerObj : Object = JSON.parse(e.target.data) ;
			TrackingSettings.ATTACHMENT_ID = headerObj.id ; 
		}
		
		override protected function httpStatusHandler(e:HTTPStatusEvent):void
		{
		    //trace("getAttachment:httpStatusHandler:" + e.status);
		}
	}
}

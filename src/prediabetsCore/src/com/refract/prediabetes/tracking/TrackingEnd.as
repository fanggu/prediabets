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
		private var _callBack : Object ; 
		public function TrackingEnd() 
		{
			
		}
		public function track( callBack : Object) : void
		{
			_callBack = callBack ; 
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
			_callBack.callBack() ; 
			//trace("COMPLETE END :" , e.target)
			//trace("COMPLETE END data:" , e.target.data)
		}
		
		override protected function httpStatusHandler(e:HTTPStatusEvent):void
		{
		    //trace("end::httpStatusHandler:" + e.status);
		}
		
		override protected function securityErrorHandler(e:SecurityErrorEvent):void
		{
			_callBack.scope[ _callBack.callBack ]() ; 
		   //trace("securityErrorHandler:" + e.text);
		}
		
		override protected function ioErrorHandler(e:IOErrorEvent):void
		{
			_callBack.scope[ _callBack.callBack ]() ; 
		    //trace("ioErrorHandler: " + e.text);
		}
	}
}

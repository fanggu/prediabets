package com.refract.prediabetes.tracking {
	import com.refract.prediabetes.tracking.VO.TrackingRequestVO;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @author otlabs
	 */
	public class TrackingInteractive extends Tracking {
		public function TrackingInteractive() {
			super();
		}
		public function track( episodeId : String , choice : String , nextEpisodeId : String , step : String ) : void
		{
			var objTrackRequest : TrackingRequestVO = new TrackingRequestVO() ; 
			objTrackRequest.address = TrackingSettings.INTERACTIVE_ADDRESS ;  
			var variables:URLVariables = new URLVariables(); 
			variables.param = '{"episodeId":"' + episodeId + '","choice":"' + choice + '","nextEpisodeId":"' + nextEpisodeId + '", "currentStep" : "' + step + '"}';  
			objTrackRequest.variables = variables ; 
			objTrackRequest.method = URLRequestMethod.POST ; 
			trackRequest( objTrackRequest ) ; 
		}
		override protected function loaderCompleteHandler(e:Event):void
		{ 	 
			
		}
		
		override protected function httpStatusHandler(e:HTTPStatusEvent):void
		{
		    //trace("tracking:interaction:httpStatusHandler:" + e.status);
		}
	}
}

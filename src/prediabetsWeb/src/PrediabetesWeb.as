package {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.tracking.TrackingSettings;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;

	[SWF(width='800', height='500', backgroundColor='#000000', frameRate='60')]

	/**
	 * @author robertocascavilla
	 */
	public class PrediabetesWeb extends Sprite 
	{
		
		public function PrediabetesWeb() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE , init );
		}
		
		private function init(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			Security.loadPolicyFile("http://healthmentoronline.com:8086/crossdomain.xml");
			Security.allowDomain( '*' ) ; 
			Security.allowInsecureDomain( '*' ) ; 
			setTrackingValues() ; 
			setAppSettings( ) ; 
			
			var mainCore : PrediabetesCore = new PrediabetesCore(); 
			addChild ( mainCore ) ;
		}
		private function setAppSettings() : void
		{
			AppSettings.TYPE_APP = 'prediabetes.co.nz' ; 
		}
		private function setTrackingValues() : void
		{
			trace('---SET TRACKING VALUES')
			var parameters : Object = LoaderInfo(this.root.loaderInfo).parameters ;
			trace('parameters ' , parameters.uid)
			for( var mc in parameters)
			{
				trace('mc ' , mc)
			}
			if( parameters.uid )
			{
				var paramUserId:Object = parameters.uid;
				var paramTrackId:Object = parameters.tid;
				var paramTimespentId : Object = parameters.timespentId ; 
				
				TrackingSettings.USER_ID = paramUserId.toString() ; 
				TrackingSettings.TRACK_ID = paramTrackId.toString() ;
				TrackingSettings.TIMESPENT_ID = paramTimespentId.toString() ; 
				
				trace('--TrackingSettings.USER_ID :' , TrackingSettings.USER_ID)
				trace('--TrackingSettings.TRACK_ID :' , TrackingSettings.TRACK_ID)
				trace('--TrackingSettings.TIMESPENT_ID :' , TrackingSettings.TIMESPENT_ID)
				//var trackingStartWeb : TrackingStartWeb = new TrackingStartWeb() ; 
				//trackingStartWeb.track() ; 
			}
			 
		}
		
		
	}
}

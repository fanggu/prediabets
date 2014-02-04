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
			var parameters : Object = LoaderInfo(this.root.loaderInfo).parameters ;
			if( parameters.uid )
			{
				var paramUserId:Object = parameters.uid;
				var paramTrackId:Object = parameters.tid;
				var paramTimespentId : Object = parameters.timespentId ; 
				
				TrackingSettings.USER_ID = paramUserId.toString() ; 
				TrackingSettings.TRACK_ID = paramTrackId.toString() ;
				TrackingSettings.TIMESPENT_ID = paramTimespentId.toString() ; 
			} 
		}
	}
}

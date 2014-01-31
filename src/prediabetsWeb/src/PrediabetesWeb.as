package {
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;

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
		
		private function init(evt:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			setTrackingValues() ; 
			
			var mainCore : PrediabetesCore = new PrediabetesCore(); 
			addChild ( mainCore ) ;
		}
		private function setTrackingValues() : void
		{
			var parameters : Object = LoaderInfo(this.root.loaderInfo).parameters ;
			if( parameters.userId )
			{
				var paramUserId:Object = parameters.userId;
				var paramTrackId:Object = parameters.trackId;
				//Tracking.USER_ID = paramUserId.toString() ; 
				//Tracking.TRACK_ID = paramTrackId.toString() ; 
			}
			
		}
		
		
	}
}

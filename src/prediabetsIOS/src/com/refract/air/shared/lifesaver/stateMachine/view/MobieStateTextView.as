package com.refract.air.shared.lifesaver.stateMachine.view {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.logger.Logger;
	import com.refract.prediabets.stateMachine.view.StateTxtView;

	import flash.events.Event;

	/**
	 * @author robertocascavilla
	 */
	public class MobieStateTextView extends StateTxtView {
		public function MobieStateTextView(stateObjectText : Object, fontSize : int) 
		{
			super(stateObjectText, fontSize);
		}
		
		override protected function onResize(event : Event = null ) : void 
		{
			x = ( perc_x * AppSettings.VIDEO_WIDTH) / 100 - width/2 + AppSettings.VIDEO_LEFT;
			y = ( perc_y * AppSettings.VIDEO_HEIGHT ) / 100  + AppSettings.VIDEO_TOP;
			
			Logger.log(Logger.STATE_MACHINE,'STATE TXT ON RESIZE NUM LINES :' , txt.numLines );
			if( txt.numLines > 1)
			{
				y = y - height /2 ;	
			}
			
			
			//if( AppSettings.RATIO > 1.2){
//			if( AppSettings.DEVICE == AppSettings.DEVICE_TABLET || AppSettings.DEVICE == AppSettings.DEVICE_MOBILE)
//			{
//				if( AppSettings.RATIO > 1.2)
//				{
//					y = y - height /2 ; 
//				}
//			}
		}
		
	}
}

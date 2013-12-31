package com.refract.air.shared.components.emergencyinfo {
	import com.refract.prediabets.AppSettings;
	/**
	 * @author kanish
	 */
	public class MobileEmergencyInfoChoking extends TabletEmergencyInfoChoking {
		public function MobileEmergencyInfoChoking() {
			super();
		}
		
		override protected function setDimensions():void{
			_scrollerWidth = AppSettings.VIDEO_WIDTH*.95;//BODY_WIDTH*AppSettings.FONT_SCALE_FACTOR;
			_scrollerHeight =  AppSettings.VIDEO_HEIGHT*.75; //BODY_HEIGHT*AppSettings.FONT_SCALE_FACTOR/2;
			_imgScale = AppSettings.GET_FONT_SCALE(_bodyStyle.fontSize)*.55;
		}
	}
}

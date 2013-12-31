package com.refract.air.shared.components.intro {
	import com.refract.prediabets.components.intro.Intro;

	/**
	 * @author kanish
	 */
	public class MobileIntro extends Intro {
		public function MobileIntro() {
			super();
			_copyStyle.fontSize = 24;
		}
		
		override protected function addIntroNav():void{
		//	super.addIntroNav();
		}
		
		override protected function setVideo():void{
			super.setVideo();
	//		if( VideoLoader.i ) VideoLoader.i.deactivateClickPause();
			
		}
	}
}

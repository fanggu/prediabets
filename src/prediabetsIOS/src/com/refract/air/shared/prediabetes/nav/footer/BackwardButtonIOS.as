package com.refract.air.shared.prediabetes.nav.footer {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.nav.footer.BackwardButton;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author otlabs
	 */
	public class BackwardButtonIOS extends BackwardButton {
		public function BackwardButtonIOS() {
			super();
		}
		
		override protected function init( evt : Event ) : void
		{
			super.init( evt ) ; 
		}
		override protected function createStates() : void
		{
			backwardButton = new Sprite( ) ; 
			var bkg : Loader = new Loader();
			bkg.load(new URLRequest("img/backward_retina.png"));
			backwardButton.addChild(bkg);
			addChild( backwardButton ) ; 
		}
		
	}
}

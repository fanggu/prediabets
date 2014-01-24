package com.refract.air.shared.prediabetes.nav.footer {
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.nav.footer.SoundButton;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;

	/**
	 * @author otlabs
	 */
	public class SoundButtonIOS extends SoundButton {
		public function SoundButtonIOS() {
			super();
		}
		override protected function createStates() : void
		{
			audioOn = new Sprite( ) ; 
			var l : Loader = new Loader();
			l.load(new URLRequest("img/audio/audio_on_retina.png"));
			audioOn.addChild(l);
			addChild( audioOn ) ; 
			
			audioOff = new Sprite( ) ; 
			var l2 = new Loader();
			l2.load(new URLRequest("img/audio/audio_off_retina.png"));
			audioOff.addChild(l2);
			addChild( audioOff ) ; 
		}
	}
}

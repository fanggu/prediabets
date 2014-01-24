package com.refract.air.shared.prediabetes.nav.footer {
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.nav.footer.PlayPauseButton;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;

	/**
	 * @author otlabs
	 */
	public class PlayPauseButtonIOS extends PlayPauseButton {
		public function PlayPauseButtonIOS() {
			super();
		}
		override protected function createState() : void
		{
			playBtn = new Sprite( ) ; 
			var l1 : Loader = new Loader();
			l1.load(new URLRequest("img/play_retina.png"));
			playBtn.addChild( l1 );
			addChild( playBtn ) ; 
			
			//pauseBtn = AssetManager.getEmbeddedAsset("Pause");
			
			pauseBtn = new Sprite( ) ; 
			var l2 : Loader = new Loader();
			l2.load(new URLRequest("img/pause_retina.png"));
			pauseBtn.addChild( l2 );
			addChild( pauseBtn ) ;
			 
			
		}
	}
}

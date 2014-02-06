package com.refract.air.shared.prediabetes.nav.footer {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.nav.footer.SoundButton;
	import com.refract.prediabetes.stateMachine.SMSettings;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	/**
	 * @author otlabs
	 */
	public class SoundButtonIOS extends SoundButton {
		public function SoundButtonIOS() {
			super();
		}
		override protected function init( evt : Event = null ) : void
		{
			_fixHitArea_w = 50 ; 
			_fixHitArea_h = 50 ; 
			super.init( evt )  ; 
		}
		override protected function createStates() : void
		{
			audioOn = new Sprite( ) ; 
			var l : Loader = new Loader();
			l.load(new URLRequest("img/audio/audio_on_retina.png"));
			audioOn.addChild(l);
			addChild( audioOn ) ; 
			
			audioOff = new Sprite( ) ; 
			var l2 : Loader= new Loader();
			l2.load(new URLRequest("img/audio/audio_off_retina.png"));
			audioOff.addChild(l2);
			addChild( audioOff ) ; 
			
			w = 44 ; 
			h = 40 ; 
		}
		override protected function onMouseOverOut(evt : MouseEvent) : void 
		{
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
					//DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralRollover") );
					TweenMax.to(this,0.5,{tint: SMSettings.CHOICE_BACK_COLOR  } ) ;
				break;
				default:
					TweenMax.to(this,0.5,{tint:null});
			}	
		}
	}
}

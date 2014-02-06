package com.refract.air.shared.prediabetes.nav.footer {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.nav.footer.BackwardButton;
	import com.refract.prediabetes.stateMachine.SMSettings;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
			//if( AppSettings.RETINA)
			//{
				_fixHitArea_w = 50 ; 
				_fixHitArea_h = 50 ; 
			//}
			super.init( evt ) ; 
		}
		override protected function createStates() : void
		{
			backwardButton = new Sprite( ) ; 
			var bkg : Loader = new Loader();
			bkg.load(new URLRequest("img/backward_retina.png"));
			backwardButton.addChild(bkg);
			addChild( backwardButton ) ; 
			
			w = 40 ; 
			h = 36 ; 
		}
		override protected function onMouseOverOut(evt : MouseEvent) : void 
		{
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
					//DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralRollover") );
					TweenMax.to(this,0.5,{tint:SMSettings.CHOICE_BACK_COLOR } ) ;
				break;
				default:
					TweenMax.to(this,0.3,{tint:null});
			}	
		}
		
	}
}

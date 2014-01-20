package com.refract.prediabetes.nav.footer {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class BackwardButton extends Sprite 
	{		
		public var id : String;
		private var backwardButton : Bitmap;
		
		public function BackwardButton() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void
		{
			drawBack() ; 
			createStates() ;
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOverOut);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOverOut);
			addEventListener(MouseEvent.CLICK, onClick);
			
			DispatchManager.addEventListener( Flags.ACTIVE_BACK , onBackActive);
			DispatchManager.addEventListener(Flags.INACTIVE_BACK , onBackInactive);
			
			mouseChildren = false;
			mouseEnabled = true;
			useHandCursor = true;
			buttonMode = true;
			
			this.scaleX = this.scaleY = AppSettings.FONT_SCALE_FACTOR;
		}
		private function drawBack() : void
		{
			graphics.beginFill(0xff0000,0);
			graphics.drawRect(0,0,25,25);
			graphics.endFill();
		}
		private function createStates() : void
		{
			backwardButton = AssetManager.getEmbeddedAsset("BackwardButton");
			addChild( backwardButton ) ; 
		}

		private function onMouseOverOut(evt : MouseEvent) : void 
		{
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
					//DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralRollover") );
					//TweenMax.to(this,0.5,{tint:0xffffff});
				break;
				default:
					//TweenMax.to(this,0.5,{tint:null});
			}	
		}
		
		private function onClick(evt:Event):void
		{
			DispatchManager.dispatchEvent( new Event( Flags.ON_BACKWARD ) ) ; 
		}
		
		private function onBackActive( evt : Event ) : void
		{
			alpha = 1 ; 
			mouseEnabled = true ; 
		}
		private function onBackInactive( evt : Event  ) : void
		{
			alpha = .4 ; 
			mouseEnabled = false ; 
		}
	}
}

package com.refract.prediabetes.nav.footer {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;


	public class SoundButton extends Sprite 
	{
		public var id : String;
		protected var audioOn : *;
		protected var audioOff : *;
		protected var _fixHitArea_w : int;
		protected var _fixHitArea_h : int;
		
		protected var w : int ; 
		protected var h : int ; 
		
		public function SoundButton() 
		{
			_fixHitArea_w = 10 ; 
			_fixHitArea_h = 10 ; 
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			createStates() ;
			drawStates();
			drawBack() ; 
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOverOut);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOverOut);
			addEventListener(MouseEvent.CLICK, onClick);
			
			mouseChildren = false;
			mouseEnabled = true;
			useHandCursor = true;
			buttonMode = true;
			
			this.scaleX = this.scaleY = AppSettings.FONT_SCALE_FACTOR;
		}
		private function drawBack() : void
		{
			graphics.beginFill(0xff0000 , 0 ) ;
			graphics.drawRect( -_fixHitArea_w / 2 , -_fixHitArea_h / 2 , w + _fixHitArea_w , h + _fixHitArea_h );
			graphics.endFill();
		}
		protected function createStates() : void
		{
			audioOn = AssetManager.getEmbeddedAsset("AudioOn");
			audioOff = AssetManager.getEmbeddedAsset("AudioOff");
			addChild( audioOn ) ; 
			addChild( audioOff ) ; 
			w = audioOn.width ; 
			h = audioOn.height ; 
		}
		private function drawStates() : void
		{
			audioOn.visible = false ; 
			audioOff.visible = false ; 
			if(SoundMixer.soundTransform.volume != 0)
			{
				audioOn.visible = true ; 
			}
			else
			{
				audioOff.visible = true ; 
			}
		}

		protected function onMouseOverOut(evt : MouseEvent) : void 
		{
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
					//DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralRollover") );
					TweenMax.to(this,0.5,{tint:0xffffff});
				break;
				default:
					TweenMax.to(this,0.5,{tint:null});
			}	
		}
		
		private function onClick(evt:Event):void
		{
			DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralClick") );	
			if(SoundMixer.soundTransform.volume != 0)
			{
				SoundMixer.soundTransform = new SoundTransform(0);
				drawStates()
			}
			else
			{
				SoundMixer.soundTransform = new SoundTransform(1);
				drawStates()
			}
		}
	}
}

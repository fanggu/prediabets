package com.refract.prediabets.components.nav.footer {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.stateMachine.events.StateEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.CapsStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	/**
	 * @author kanish
	 */
	public class SoundButton extends Sprite {
		
		private var colour:uint = AppSettings.GREY;
		
		public var id:String;
		
		public function SoundButton() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void{
			drawState();
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOverOut);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOverOut);
			addEventListener(MouseEvent.CLICK, onClick);
			mouseChildren = false;
			mouseEnabled = true;
			useHandCursor = true;
			buttonMode = true;
			
			this.scaleX = this.scaleY = AppSettings.FONT_SCALE_FACTOR;
		}

		private function onMouseOverOut(evt : MouseEvent) : void {
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
					DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralRollover") );
					TweenMax.to(this,0.5,{tint:0xffffff});
				break;
				default:
					TweenMax.to(this,0.5,{tint:null});
			}	
		}
		
		private function onClick(evt:Event):void{
			DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralClick") );	
			if(SoundMixer.soundTransform.volume != 0){
				SoundMixer.soundTransform = new SoundTransform(0);
				drawState();
			}else{
				SoundMixer.soundTransform = new SoundTransform(1);
				drawState();
			}
		}
		
		private function drawBase():void{
			
			this.scaleX = this.scaleY = 1;
			
			graphics.beginFill(0xff0000,0);
			graphics.drawRect(0,0,15,10);
			graphics.endFill();
			graphics.beginFill(colour,1);
			graphics.drawRect(0, 2, 4, 4);
			graphics.beginFill(colour,1);
			graphics.moveTo(6,8);
			graphics.lineTo(6,0);
			graphics.lineTo(1,4);
			graphics.lineTo(6,8);
			graphics.endFill();
			
			this.graphics.beginFill(0xff0000,AppSettings.BUTTON_HIT_AREA_ALPHA);
			if(AppSettings.PLATFORM == AppSettings.PLATFORM_PC){
				this.graphics.drawRect(0,0,width,height);
			}else{
				this.graphics.drawRect(-AppSettings.BUTTON_HIT_AREA_EDGE,-AppSettings.BUTTON_HIT_AREA_EDGE,width+AppSettings.BUTTON_HIT_AREA_WIDTH,height+AppSettings.BUTTON_HIT_AREA_WIDTH);
			}
			
			this.scaleX = this.scaleY = AppSettings.FONT_SCALE_FACTOR;
		}
		
		public function drawState():void{
			graphics.clear();
			drawBase();
			if(SoundMixer.soundTransform.volume != 0){
				graphics.lineStyle(1,colour,1,false,null,CapsStyle.ROUND);
				graphics.moveTo(8,2);
				graphics.curveTo(10,4,8,6);
				graphics.moveTo(10,0);
				graphics.curveTo( 14, 4,10,8);
			}
			
		}
	}
}

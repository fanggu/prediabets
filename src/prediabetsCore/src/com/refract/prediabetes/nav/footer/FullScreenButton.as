package com.refract.prediabetes.nav.footer {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;

	public class FullScreenButton extends Sprite {
		
		private var colour:uint = AppSettings.GREY;
		
		public var id:String;
		
		public function FullScreenButton() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void{
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOverOut);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOverOut);
			addEventListener(MouseEvent.CLICK, onClick);
			mouseChildren = false;
			mouseEnabled = true;
			useHandCursor = true;
			buttonMode = true;
			drawState();
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFSChange);
			
			this.scaleX = this.scaleY = AppSettings.FONT_SCALE_FACTOR;
		}

		private function onFSChange(event : FullScreenEvent) : void {
			drawState();
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
			if(stage.displayState != StageDisplayState.NORMAL){
				stage.displayState = StageDisplayState.NORMAL;
			//	drawState();
			}else{
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			//	drawState();
			}
		}
		
		private function drawOuter():void{
			graphics.beginFill(0xff0000,0);
			graphics.drawRect(0,0,14,10);
			graphics.endFill();
			graphics.lineStyle(1,colour);
			graphics.drawRoundRect(0, 0, 14, 10, 2);
			
		}
		
		public function drawState():void{
			this.scaleX = this.scaleY = 1;
			graphics.clear();
			drawOuter();
			var isFullScreen:Boolean = !(stage.displayState == StageDisplayState.NORMAL);
			if(isFullScreen){
				graphics.lineStyle(2,colour);
				graphics.moveTo(5,3);
				graphics.lineTo(9,7);
				graphics.moveTo(5,7);
				graphics.lineTo(9,3);
			}else{
				graphics.beginFill(colour,1);
				graphics.moveTo(12,8);
				graphics.lineTo(12,5);
				graphics.lineTo(9,8);
				graphics.lineTo(12,8);
				graphics.endFill();
				
			}
			this.graphics.lineStyle(0,0,0);
			this.graphics.beginFill(0xff0000,AppSettings.BUTTON_HIT_AREA_ALPHA);
			if(AppSettings.DEVICE == AppSettings.DEVICE_PC){
				this.graphics.drawRect(0,0,width,height);
			}else{
				this.graphics.drawRect(-AppSettings.BUTTON_HIT_AREA_EDGE,-AppSettings.BUTTON_HIT_AREA_EDGE,width+AppSettings.BUTTON_HIT_AREA_WIDTH,height+AppSettings.BUTTON_HIT_AREA_WIDTH);
			}
			
			this.scaleX = this.scaleY = AppSettings.FONT_SCALE_FACTOR;
		}
		
	}
}

package com.refract.prediabetes.nav.footer {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;

	public class FullScreenButton extends Sprite {
		
		private var colour:uint = AppSettings.GREY;
		
		public var id : String;
		private var _mc : MovieClip ;
		
		public function FullScreenButton() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			addEventListener(MouseEvent.MOUSE_OVER, onMouseOverOut);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOverOut);
			addEventListener(MouseEvent.CLICK, onClick);
			mouseChildren = false;
			mouseEnabled = true;
			useHandCursor = true;
			buttonMode = true;
			
			_mc  = AssetManager.getEmbeddedAsset('FullScreen') ;
			addChild( _mc ) ; 
			drawState();
			stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFSChange);
			
			this.scaleX = this.scaleY = AppSettings.FONT_SCALE_FACTOR;
		}

		private function onFSChange(event : FullScreenEvent) : void 
		{
			drawState();
		}

		private function onMouseOverOut(evt : MouseEvent) : void {
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
					DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralRollover") );	
					TweenMax.to(this,0.5,{tint:SMSettings.CHOICE_BACK_COLOR});
				break;
				default:
					TweenMax.to(this,0.5,{tint:null});
			}	
		}
		
		private function onClick(evt:Event):void{
			DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralClick") );	
			if(stage.displayState != StageDisplayState.NORMAL)
			{
				stage.displayState = StageDisplayState.NORMAL;
			}
			else
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
			//	drawState();
			}
		}
		
		
		public function drawState():void
		{
			var isFullScreen:Boolean = !(stage.displayState == StageDisplayState.NORMAL);
			if(isFullScreen)
			{
				_mc.gotoAndStop( 2 ) ; 	
			}else
			{
				_mc.gotoAndStop( 1 ) ; 	
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

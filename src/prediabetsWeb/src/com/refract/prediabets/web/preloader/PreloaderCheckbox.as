package com.refract.prediabets.web.preloader {
	import com.refract.prediabetes.AppSettings;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author kanish
	 */
	public class PreloaderCheckbox extends Sprite {
		
		private var _centre:Shape;
		
		private var _enabled:Boolean = false;
		public function get enabled():Boolean {return _enabled;}
		
		public function PreloaderCheckbox() {
			super();
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			draw();
			
			setCentre();
					
			this.mouseEnabled = true;
			this.buttonMode = true;
			this.mouseChildren = false;
			this.useHandCursor = true;
			
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouse);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouse);
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function draw():void{
			var dimensions:int = 11;
			var thickness:int = 2;
			var littleDimensions:int = dimensions - thickness*2 - 3;
			//reset and create mouse actionable layer;
			graphics.clear();
			graphics.beginFill(0xff,0);
			graphics.drawRect(0,0,dimensions,dimensions);
			graphics.endFill();
			
			graphics.lineStyle(thickness,AppSettings.WHITE,1,true,"normal","none","miter");
			graphics.drawRect(0,0,dimensions,dimensions);
			
			_centre = new Shape();
			_centre.graphics.beginFill(AppSettings.WHITE,1);
			_centre.graphics.drawRect(0,0,littleDimensions,littleDimensions);
			
			addChild(_centre);
			
			_centre.x = _centre.y = dimensions/2 - _centre.width/2;	
			
		}
		
		private function onMouse(evt:MouseEvent):void{
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
					_centre.alpha = 0.5;
					break;
				case(MouseEvent.MOUSE_OUT):
					setCentre();
					break;
			}
		}
		
		private function setCentre():void{
			_centre.alpha = enabled ? 1 : 0;	
		}
		
		public function onClick(evt:MouseEvent):void{
			_enabled = !_enabled;
			setCentre();
		}

		public function destroy() : void {
			graphics.clear();
			_centre.graphics.clear();
			
			
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouse);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouse);
			this.removeEventListener(MouseEvent.CLICK,onClick);
			
			removeChildren();
		}
	}
}

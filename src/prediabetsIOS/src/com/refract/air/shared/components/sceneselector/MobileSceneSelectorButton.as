package com.refract.air.shared.components.sceneselector {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.components.sceneselector.SceneSelectorButton;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author kanish
	 */
	public class MobileSceneSelectorButton extends SceneSelectorButton {
		public function MobileSceneSelectorButton(id : int, enabled : Boolean = false, gridHeight : int = 4) {
			super(id, enabled, gridHeight);
		}
		
		override protected function init(evt:Event):void{
			super.init(evt);
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
			
			_blocker.alpha = 0;
			_blocker.visible = false;
			
		}
		
		override protected function onResize(evt:Event = null):void{
		
		//	var w:Number = (AppSettings.VIDEO_WIDTH)/4 -1 ;
		//	var h:Number = (AppSettings.VIDEO_HEIGHT- 3)/_gridHeight -1 + 4;
			
		//	graphics.clear();
		//	graphics.beginFill(0xffffff*Math.random(),0.5);
		//	graphics.drawRect(0, 0, w, h);
			
			
			_image.height = AppSettings.VIDEO_HEIGHT ;
			_image.scaleX = _image.scaleY;
			
			_blocker.graphics.clear();
			_blocker.graphics.beginFill(0x0,1);
			_blocker.graphics.drawRect(0, 0, _image.width, _image.height);
			
			_blocker.alpha = _blockerAlpha;
			
			x = _id*_image.width;// _xx*(width+0) ; //+ 2;
		//	y = _yy*(height+0) ;//+ 2;
		}
	}
}

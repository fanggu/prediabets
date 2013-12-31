package com.refract.air.shared.components.profile {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.components.profile.Profile;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TransformGestureEvent;

	/**
	 * @author kanish
	 */
	public class MobileProfile extends Profile {
		
		private var _location:int = 0;
		
		private var _msk:Shape;
		
		public function MobileProfile() {
			super();
		}
		
		override protected function init(evt:Event):void{
			_msk = new Shape();
			parent.addChild(_msk);
			this.mask = _msk;
			
			super.init(evt);
			
			
			_location = 0;
			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe);
		}
		
		private function onSwipe(evt:TransformGestureEvent):void{
		//	evt.stopImmediatePropagation();
			var over:Boolean = false;
			if(evt.offsetX == 1){ // left to right
				if(x < AppSettings.VIDEO_LEFT){
					_location--;
				}else{
					over = true;
					_location = 0;
				}
			}else if(evt.offsetX == -1){ // right to left
				if(x > AppSettings.VIDEO_LEFT -(_buttons[0].width*3 - AppSettings.VIDEO_WIDTH)){
					_location++;
				}else{
					over = true;
					_location = 2;
				}
			}
			_location = _location < 0 ? 0 : _location > 2 ? 2 : _location;
			if(over){
				if(_location == 0){
					TweenMax.to( this, 0.2,{x: 30, repeat:1,yoyo:true});
				}else{
					TweenMax.to( this, 0.2,{x: AppSettings.VIDEO_RIGHT- _buttons[0].width*3 - 30, repeat:1,yoyo:true});
				}
			}else{
				if(_location < 2){
					TweenMax.to(this,0.5,{x:AppSettings.VIDEO_LEFT - _buttons[0].width*_location});
				}else{
					TweenMax.to(this,0.5,{x:AppSettings.VIDEO_RIGHT- _buttons[0].width*3});
				}
			}
			
		}
		
		override protected function onResize(evt : Event = null) : void {
			super.onResize(evt);
			this.x = _location < 2 ? AppSettings.VIDEO_LEFT - _buttons[0].width*_location : AppSettings.VIDEO_RIGHT- _buttons[0].width*3;//AppSettings.VIDEO_LEFT;
			
			_msk.graphics.clear();
			_msk.graphics.beginFill(0xff00,1);
			_msk.graphics.drawRect(0,0,AppSettings.VIDEO_WIDTH,AppSettings.VIDEO_HEIGHT);
			_msk.x = AppSettings.VIDEO_LEFT;
			_msk.y = AppSettings.VIDEO_TOP;
			
		}
		
		override public function destroy():void{
			parent.removeChild(_msk);
			_msk.graphics.clear();
			_msk = null;
			
			stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe);
			super.destroy();
		}
	}
}

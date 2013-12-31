package com.refract.air.shared.components.sceneselector {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.components.sceneselector.SceneSelectorQuestions;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;

	/**
	 * @author kanish
	 */
	public class MobileSceneSelectorQuestions extends SceneSelectorQuestions {

		private var _msk:Shape;
		
		private var _location:int = 0;
		private const _totalLocations:int = 11;
		
		public function MobileSceneSelectorQuestions() {
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
		
		override protected function onResize(evt:Event = null):void{
			super.onResize();
			
			_msk.graphics.clear();
			_msk.graphics.beginFill(0xff,1);
			_msk.graphics.drawRect(0,0,AppSettings.VIDEO_WIDTH,AppSettings.VIDEO_HEIGHT);
			_msk.x = AppSettings.VIDEO_LEFT;
			_msk.y = AppSettings.VIDEO_TOP;
		}
	
		private var _didSwipe:Boolean = false;
		
		private function onSwipe(evt:TransformGestureEvent):void{
		//	Logger.general(this,"SWIPE");
			_didSwipe = true;
			evt.stopImmediatePropagation();
			var over:Boolean = false;
			if(evt.offsetX == 1){ // left to right
				if(x < AppSettings.VIDEO_LEFT){
					_location--;
				}else{
					over = true;
					_location = 0;
				}
			}else if(evt.offsetX == -1){ // right to left
				if(x > AppSettings.VIDEO_LEFT -(getChildAt(1).width*(_totalLocations+1) - AppSettings.VIDEO_WIDTH)){
					_location++;
				}else{
					over = true;
					_location = _totalLocations;
				}
			}
			_location = _location < 0 ? 0 : _location > _totalLocations ? _totalLocations : _location;
			if(over){
				if(_location == 0){
					this.x = 0;
					TweenMax.to( this, 0.2,{x: 30, repeat:1,yoyo:true});
				}else{
					this.x = AppSettings.VIDEO_RIGHT- getChildAt(1).width*(_totalLocations+1);
					TweenMax.to( this, 0.2,{x: AppSettings.VIDEO_RIGHT- getChildAt(1).width*(_totalLocations+1) - 30, repeat:1,yoyo:true});
				}
			}else{
				if(_location < _totalLocations){
					TweenMax.to(this,0.5,{x:AppSettings.VIDEO_LEFT - getChildAt(1).width*_location});
				}else{
					TweenMax.to(this,0.5,{x:AppSettings.VIDEO_RIGHT- getChildAt(1).width*(_totalLocations+1)});
				}
			}
		}
		
		override protected function onButtonClick(evt:MouseEvent):void{
			if(_didSwipe){
				_didSwipe = false;
			}else{
				super.onButtonClick(evt);
			}
		}
		
		override public function destroy():void{
			parent.removeChild(_msk);
			_msk.graphics.clear();
			_msk = null;
			
			stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe);
			
			super.destroy();
		}
		
		
		override protected function createGrid() : void{}
	}
}

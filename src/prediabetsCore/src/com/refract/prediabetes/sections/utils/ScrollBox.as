package com.refract.prediabetes.sections.utils {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.stateMachine.SMSettings;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Rectangle;


	public class ScrollBox extends Sprite {
		private var _w:Number;
		private var _h:Number;
		
		private var _content:DisplayObject;
		
		private var _mask:Shape;
		
		private var _pivotLine:Shape;
		private var _pivotTrigger:Sprite;
		private var _pivotRect:Rectangle;
		
		private var _overscroll:Boolean;
		
		private var _autoScroll:Boolean = false;
		public function get autoScroll():Boolean {return _autoScroll;}
		public function set autoScroll(scroll:Boolean):void { _autoScroll = scroll; startAutoScroll(); }
		
		public function get contentHeight():Number{
			return _content.height > _h ? _h : _content.height;
		}
		
		public function get contentWidth():Number{
			return this.width > _w ? this.width : _w;
		}
		
		public function ScrollBox(width:Number, height:Number,content:DisplayObject,overscroll:Boolean = false) {
			_w = width;
			_h = height;
			_content = content;
			_overscroll = overscroll;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			drawContent();
			
			addEvents();
			this.mouseChildren = true;
		}
		
		public function updateSize(ww:Number,hh:Number):void{
		//	if(_w != ww || _h != hh){	
				
				_w = ww;
				_h = hh;
			
				drawContent();
				startAutoScroll();
		//	}
		}
		
		private function drawContent():void
		{
			if(_content.height > _h)
			{
				var pivotHeight:Number = (_h/_content.height)*_h;
				if(_mask)
				{
					_mask.graphics.clear();
				}
				else
				{
					_mask = new Shape();
				}
				_mask.graphics.beginFill(0x0,1);
				_mask.graphics.drawRect(0, 0, _w-7, _h);
				
				if(_pivotLine){
					_pivotLine.graphics.clear();
				}else{
					_pivotLine = new Shape();
				}
				_pivotLine.graphics.beginFill( 0xc9c9c9 , 1 ) ;
				_pivotLine.graphics.drawRect(0, 0, AppSettings.SCROLLBAR_BACK_W , _h + AppSettings.SCROLLBAR_GAP_H);
				
				if(_pivotTrigger)
				{
					_pivotTrigger.graphics.clear();
				}
				else
				{
					_pivotTrigger = new Sprite();
				}
				_pivotTrigger.graphics.beginFill( SMSettings.CHOICE_BACK_COLOR , 1 ) ;
				_pivotTrigger.graphics.drawRect(0, 0, AppSettings.SCROLLBAR_TRIGGER_W , pivotHeight);
				
				
				addChild(_content);
				addChild(_mask);
				addChild(_pivotLine);
				addChild(_pivotTrigger);
				_pivotTrigger.buttonMode = true;
				_pivotLine.x = _w + 13 ;
				_pivotTrigger.x = _w + 13 + _pivotLine.width / 2 - _pivotTrigger.width / 2   ;//- 7;//+ 30;
				_content.mask = _mask;
				_pivotRect = new Rectangle( _pivotTrigger.x ,0,0,_h-pivotHeight);
				_pivotTrigger.y = (_content.y/(-_content.height+_h))*_pivotRect.height;
				_pivotLine.y = -AppSettings.SCROLLBAR_GAP_H / 2 ; 
			}
			else
			{
				addChild(_content);
			}
		}
		
		private function addEvents():void{
			if(_content.height > _h){
				_pivotTrigger.addEventListener(MouseEvent.MOUSE_DOWN,startPivotDrag);
				stage.addEventListener(TouchEvent.TOUCH_BEGIN, beginTouchDrag);
				stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
				stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
			}
		}
		
		private function onMouseWheel(evt:MouseEvent):void{
			TweenMax.killTweensOf(_pivotTrigger);
			var delta:Number = evt.delta*2;
			_pivotTrigger.y -= delta/2;
			_pivotTrigger.y = _pivotTrigger.y < 0 ? 0 : _pivotTrigger.y;
			_pivotTrigger.y = _pivotTrigger.y > _pivotRect.height ? _pivotRect.height : _pivotTrigger.y;
			
			
			onMouseMove(evt);	
			startAutoScroll();	
						
		}
		
		private function startPivotDrag(evt:MouseEvent):void{
			TweenMax.killTweensOf(_pivotTrigger);
			stage.addEventListener(MouseEvent.CLICK, endPivotDrag);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_pivotTrigger.startDrag(false,_pivotRect);
		}
		
		private var touchY:Number = 0;
		
		private function beginTouchDrag(evt:TouchEvent):void{
			//trace(Logger.OVERLAY,"touch begin");
			touchY = evt.stageY;
			stage.addEventListener(TouchEvent.TOUCH_MOVE,onTouchMove);
			stage.addEventListener(TouchEvent.TOUCH_END,endTouchDrag);
		//	_pivotTrigger.startTouchDrag(evt.touchPointID,false,_pivotRect);
		}
		
		private function endPivotDrag(evt:MouseEvent = null):void{
			stage.removeEventListener(MouseEvent.CLICK, endPivotDrag);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			if(_pivotTrigger){
				_pivotTrigger.stopDrag();
				startAutoScroll();
			}
		}
		
		private function endTouchDrag(evt:TouchEvent):void{
			//trace(Logger.OVERLAY,"ontouchEnd");
			stage.removeEventListener(TouchEvent.TOUCH_MOVE,onTouchMove);
			stage.removeEventListener(TouchEvent.TOUCH_END,endTouchDrag);
		//	touchY = touchY - evt.stageY;
		//	movePivotTouch(touchY*0.3);
			if(_pivotTrigger){
			//	_pivotTrigger.stopTouchDrag(evt.touchPointID);
				startAutoScroll();
			}
		}
		
		private function onMouseMove(evt:MouseEvent = null):void{
			_content.y = int((-_content.height+_h)*(_pivotTrigger.y/_pivotRect.height));
		}
		
		private function onTouchMove(evt:TouchEvent):void{
		//	evt.
			touchY = touchY - evt.stageY;
			movePivotTouch( touchY*0.1);
			touchY = evt.stageY;
		}
		
		private function movePivotTouch(amt:Number):void{
			_pivotTrigger.y += amt;
			if(_pivotTrigger.y < _pivotRect.top){
				_pivotTrigger.y = _pivotRect.top;
			}else if(_pivotTrigger.y > _pivotRect.bottom){
				_pivotTrigger.y = _pivotRect.bottom;
			}
			_content.y = int((-_content.height+_h)*(_pivotTrigger.y/_pivotRect.height));
		}
		
		private function onSwipe(evt:TransformGestureEvent):void{
			if(AppSettings.isDisplayObjectVisible(this)){
				 if(evt.offsetY == 1){ //swipe top to bottom
					pageDown();
				}else if(evt.offsetY == -1){//swipe bottom to top
					pageUp();
				}
			}
		}
		
		private function pageUp():void{
			
			var newPivotY:Number = _pivotTrigger.y;
			newPivotY += _pivotTrigger.height >> 1;
			newPivotY = newPivotY > _pivotRect.height ? _pivotRect.height : newPivotY;
			
			scrollTo(newPivotY/_pivotRect.height);
		}
		
		private function pageDown():void{
			
			var newPivotY:Number = _pivotTrigger.y;
			newPivotY -= _pivotTrigger.height >> 1;
			newPivotY = newPivotY < 0 ? 0 : newPivotY;
			
			scrollTo(newPivotY/_pivotRect.height);
			
		}
		
		
		public function scrollTo(bodyPosition : Number) : void {
			TweenMax.to(_pivotTrigger,0.7,{y:bodyPosition*_pivotRect.height,onUpdate:onMouseMove,onComplete:startAutoScroll});
		}
		
		
		public function startAutoScroll() : void {
			if(autoScroll){
				var delay:Number = _pivotTrigger.y == 0 ? 0.5 : 4;
				TweenMax.killTweensOf(_pivotTrigger);
				var time:Number = (1-(_pivotTrigger.y/_pivotRect.height)) * 25*(_content.height/contentHeight);
				TweenMax.to(_pivotTrigger,time,{y:_pivotRect.height,onUpdate:onMouseMove,delay:delay,ease:Linear.easeNone});		
			}
		}
		
		public function destroy():void{
			_autoScroll = false;
			if(stage){
				endPivotDrag();
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
				stage.removeEventListener(TouchEvent.TOUCH_BEGIN, beginTouchDrag);
				stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
			}
			if(_mask){
				_content.mask = null;
				_mask.graphics.clear();
				removeChild(_mask);
				_mask = null;
			}
			
			if(_pivotRect){
				_pivotRect.setEmpty();
				_pivotRect = null;
			}
			
			if(_pivotLine){
				removeChild(_pivotLine);
				_pivotLine.graphics.clear();
				_pivotLine = null;
			}
			if(_pivotTrigger){
				TweenMax.killTweensOf(_pivotTrigger);
				removeChild(_pivotTrigger);
				_pivotTrigger.removeEventListener(MouseEvent.MOUSE_DOWN,startPivotDrag);
				_pivotTrigger.graphics.clear();
				_pivotTrigger = null;
			}
			
			if(_content){
				removeChild(_content);
				_content = null;
			}
		}


	}
}

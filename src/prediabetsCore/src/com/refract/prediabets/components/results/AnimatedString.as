package com.refract.prediabets.components.results {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabets.assets.TextManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;

	/**
	 * @author kanish
	 */
	public class AnimatedString extends Sprite {
		
		private var _textID:String;
		private var _styleObj:Object;
		
		private var _txt:TextField;
		public function get text():TextField{return _txt;}
		
		
		public var startValue:String;
		public var endValue:String;
		
		private var _currentCodes:Array;
		private var _endCodes:Array;
		
		public function AnimatedString(textID:String,styleObj:Object) {
			_textID = textID;
			_styleObj = styleObj;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			_txt = TextManager.makeText(_textID,this,_styleObj);
			_txt.text = startValue;
			
		}
		public function animate():void{
			if(startValue && endValue){
				_currentCodes = [];
				_endCodes = [];
				var diffs:int = 0;
				for(var i:int = 0, len:int = startValue.length; i < len; ++i){
					_currentCodes.push(startValue.charCodeAt(i));
					_endCodes.push(endValue.charCodeAt(i));
					diffs = _endCodes[i] - _currentCodes[i] > diffs ? _endCodes[i] - _currentCodes[i] : diffs;
				}
				var time:Number = timeInMS/1000*diffs;
				
			//	TweenMax.to(_currentCodes,time,{endArray:_endCodes,onUpdate:updateText,ease:Linear.easeNone});
				timer = getTimer();
				TweenMax.to(this,time,{delay:0.7,onUpdate:updateText,ease:Linear.easeNone,onComplete:onComplete});
			}
		}
		
		private var timer:int;
		private const timeInMS:int = 2/25 * 1000;
		
		private function updateText():void{
			if(getTimer() - timer  > timeInMS){
				timer = getTimer();
				var str:String = "";
				for(var i:int = 0, len:int = _currentCodes.length; i < len; ++i){
					if(_currentCodes[i] < _endCodes[i]){
						_currentCodes[i]++;
					}
					str += String.fromCharCode(_currentCodes[i]);
				
				}
				_txt.text = str;
			}
		}
		
		private function onComplete():void{
			var str:String = "";
			for(var i:int = 0, len:int = _endCodes.length; i < len; ++i){
				str += String.fromCharCode(_endCodes[i]);
			}
			_txt.text = str;
		}
		
	}
}

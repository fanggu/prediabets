package com.refract.prediabets.components.nav.header {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.TextManager;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class HeaderProgressBar extends Sprite {
		
//		private var _label:TextField;
		private var _emptyBars:Shape;
		private var _fullBars:Shape;
		private var _fullBarsMask:Shape;
		
		public function HeaderProgressBar() {
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
//			_label = TextManager.makeText("header_progress",this,{fontSize:12});
			
			addBars();
		}

		private function addBars() : void {
			_emptyBars = new Shape();
			_fullBars = new Shape();
			_fullBarsMask = new Shape();
			makeBar(_emptyBars,AppSettings.RED,0.2);
			//_emptyBars.alpha = 0.5;
			makeBar(_fullBarsMask,0xff00ff,1);
			_fullBars.graphics.beginFill(AppSettings.RED,1);
			_fullBars.graphics.drawRect(0, 0, 103, 7);
			addChild(_fullBars);
			
//			_emptyBars.x = _fullBars.x = _fullBarsMask.x = _label.textWidth + 15;
//			_emptyBars.y = _fullBars.y = _fullBarsMask.y = _label.y + _label.height/2 - 3.5;
			
			//33x7 + 2
			_fullBars.mask = _fullBarsMask;		
			setBar(0);	
		//	TweenMax.to(_fullBarsMask,10,{scaleX:1});
		
			this.scaleX = this.scaleY = AppSettings.FONT_SCALE_FACTOR;
		}
		
		private function makeBar(bar:Shape,colour:uint,alpha:Number):void{
			addChild(bar);
			var g:Graphics = bar.graphics;
			g.clear();
			g.beginFill(colour,alpha);
			g.drawRect(0, 0, 103, 7);
		//	g.beginFill(colour,alpha);
		//	g.drawRect(35,0,33,7);
		//	g.beginFill(colour,alpha);
		//	g.drawRect(70,0,33,7);
			
		}
		//scale between 0 and 1
		public function setBar(scale:Number):void{
		//	Logger.log(Logger.NAV,"newScale:",scale);
			_fullBars.scaleX = scale;
		//	TweenMax.killTweensOf(_fullBars);
		//	var time:Number = 0.4;//Math.abs(2.1 * (_fullBars.scaleX-scale));
		//	TweenMax.to(_fullBars,time,{scaleX:scale});
		}
		
		public function destroy():void{
			TweenMax.killTweensOf(_fullBars);
			_emptyBars.graphics.clear();
			_fullBars.graphics.clear();
			_fullBarsMask.graphics.clear();
			_fullBars.mask = null;
			
			removeChildren();
			
		}
	}
}

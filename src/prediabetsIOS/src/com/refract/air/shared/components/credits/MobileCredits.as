package com.refract.air.shared.components.credits {
	import com.refract.prediabets.components.credits.Credits;

	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class MobileCredits extends Credits {
		public function MobileCredits() {
			super();
		}
		
		override protected function init(evt:Event):void{
			super.init(evt);
		}
		
		override protected function setStyles():void{
			super.setStyles();
			_bodyTitleStyle.fontSize = 14;
			_bodySubtitleStyle.fontSize = 14;
			_bodyStyle.fontSize = 14;
		}
		
		protected override function createContent():void{
			
		//	_bodyTitleStyle.width = _bodySubtitleStyle.width = _bodyStyle.width = _scrollerWidth-5;
			
			super.createContent();
		}
		
		
		override protected function onResize(evt:Event = null,b:Boolean = true):void{
			super.onResize(evt,b);
			/* this */
			
			/* WC */
//			_bodyContent.x = int(AppSettings.VIDEO_WIDTH/2);
//			_bodyContent.y = int(AppSettings.VIDEO_HEIGHT);
//			_bodyContent.graphics.clear();
//			_bodyContent.graphics.beginFill(0xff00,0);
//			_bodyContent.graphics.drawRect(0,-AppSettings.VIDEO_HEIGHT,2,_bodyContent.height + AppSettings.VIDEO_HEIGHT*2);
//			
//			/* GO */
//			_scrollbox.x = int(-_scrollbox.contentWidth/2);
//			_scrollbox.y = _header ? int(_header.y + _header.height + 10) : 0;
//			
//			this.x = int(AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2);
//			this.y = int(AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - this.effectiveHeight/2);
//			/*GO */
//			
//			_scrollbox.updateSize(AppSettings.VIDEO_WIDTH,AppSettings.VIDEO_HEIGHT);
//			if(b){
//				TweenMax.to(this,0.5,{onComplete:onResize,onCompleteParams:[null,false]});
//			}
			/* WC */
			
			
	/*		_bodyContent.graphics.clear();
			_bodyContent.graphics.beginFill(0xff00,1);
			_bodyContent.graphics.drawRect(0,-AppSettings.VIDEO_HEIGHT,2,_bodyContent.height + AppSettings.VIDEO_HEIGHT*2);
			
			_scrollbox.updateSize(AppSettings.VIDEO_WIDTH,AppSettings.VIDEO_HEIGHT);
			_scrollbox.x = int(-_scrollbox.contentWidth/2);
			_scrollbox.y = _header ? int(_header.y + _header.height + 10) : 0;
			
			this.x = int(AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2);
			this.y = int(AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - this.effectiveHeight/2);
			*/
	//		graphics.clear();
	//		graphics.beginFill(0xffffff,1);
	//		graphics.drawRect(0,0,20,20);
			/* this */
		//	Logger.general(this,_scrollbox.width,_scrollbox.contentWidth,AppSettings.VIDEO_WIDTH);
		}
	}
}

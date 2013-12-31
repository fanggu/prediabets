package com.refract.air.shared.components.about {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.components.about.About;

	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class MobileAbout extends About {
		public function MobileAbout() {
			super();
		}
		
		override protected function init(evt:Event):void{
			_scrollerWidth = AppSettings.VIDEO_WIDTH*.85;//BODY_WIDTH*AppSettings.FONT_SCALE_FACTOR;
			_scrollerHeight =  AppSettings.VIDEO_HEIGHT*.7; //BODY_HEIGHT*AppSettings.FONT_SCALE_FACTOR/2;
			
			_headerStyle.fontSize = 54;
		//	_bodyTitleStyle.fontSize = 16;
		//	_bodyStyle.fontSize = 12;
			super.init(evt);
		}
		
		protected override function createContent():void{
			
			_bodyTitleStyle.width = _bodySubtitleStyle.width = _bodyStyle.width = _scrollerWidth-5;
			
			super.createContent();
		}
	}
}

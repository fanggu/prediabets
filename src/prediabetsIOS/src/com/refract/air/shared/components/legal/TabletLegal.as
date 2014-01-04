package com.refract.air.shared.components.legal {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.sections.legal.Legal;

	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class TabletLegal extends Legal {
		public function TabletLegal() {
			super();
		}
		
		override protected function init(evt:Event):void{
			_scrollerWidth = AppSettings.VIDEO_WIDTH*.75;//BODY_WIDTH*AppSettings.FONT_SCALE_FACTOR;
			_scrollerHeight =  AppSettings.VIDEO_HEIGHT*.75; //BODY_HEIGHT*AppSettings.FONT_SCALE_FACTOR/2;
			super.init(evt);
		}
		
		protected override function createContent():void{
			
			_bodyTitleStyle.width = _bodySubtitleStyle.width = _bodyStyle.width = _scrollerWidth-5;
			
			super.createContent();
		}
	}
}

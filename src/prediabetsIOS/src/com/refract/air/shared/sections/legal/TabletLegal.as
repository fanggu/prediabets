package com.refract.air.shared.sections.legal {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.sections.Legal;

	import flash.events.Event;

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
			
			//_bodyTitleStyle.width = _bodySubtitleStyle.width = _bodyStyle.width = _scrollerWidth-5;
			
			super.createContent();
		}
	}
}

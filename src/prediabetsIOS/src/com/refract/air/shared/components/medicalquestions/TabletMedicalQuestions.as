package com.refract.air.shared.components.medicalquestions {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.components.medicalquestions.MedicalQuestions;

	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class TabletMedicalQuestions extends MedicalQuestions {
		public function TabletMedicalQuestions() {
			super();
		}
		
		
		override protected function init(evt:Event):void{
			_scrollerWidth = AppSettings.VIDEO_WIDTH*.75;//BODY_WIDTH*AppSettings.FONT_SCALE_FACTOR;
			_scrollerHeight =  AppSettings.VIDEO_HEIGHT*.60; //BODY_HEIGHT*AppSettings.FONT_SCALE_FACTOR/2;
			super.init(evt);
		}
		
		protected override function createContent():void{
			
			_bodyTitleStyle.width = _bodySubtitleStyle.width = _bodyStyle.width = _scrollerWidth-5;
			
			super.createContent();
		}
	}
}
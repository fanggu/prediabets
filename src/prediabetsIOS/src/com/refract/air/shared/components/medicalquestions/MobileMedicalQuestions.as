package com.refract.air.shared.components.medicalquestions {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.components.medicalquestions.MedicalQuestions;

	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class MobileMedicalQuestions extends MedicalQuestions {
		public function MobileMedicalQuestions() {
			super();
		}
	
		override protected function init(evt:Event):void{
			_scrollerWidth = AppSettings.VIDEO_WIDTH*.85;//BODY_WIDTH*AppSettings.FONT_SCALE_FACTOR;
			_scrollerHeight =  AppSettings.VIDEO_HEIGHT*.50; //BODY_HEIGHT*AppSettings.FONT_SCALE_FACTOR/2;
			super.init(evt);
		}
		
		protected override function createContent():void{
			
			_bodyTitleStyle.width = _bodySubtitleStyle.width = _bodyStyle.width = _scrollerWidth-5;
			
			super.createContent();
		}
		
		override protected function setStyles():void{
			super.setStyles();
			_headerStyle.fontSize = 54;
			_bodyTitleStyle.fontSize = 20; // font size 36;
			_bodySubtitleStyle.fontSize = 18;
			_bodyStyle.fontSize = 12;
		}
	}
}

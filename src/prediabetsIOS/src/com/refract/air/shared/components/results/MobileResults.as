package com.refract.air.shared.components.results {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.components.results.Results;

	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class MobileResults extends Results {
		public function MobileResults(suppressAnim:Boolean = false) {
			super(suppressAnim);
		}
		
		override protected function makeStyles():void{
			super.makeStyles();
			/*
			filmTitleStyle = {fontSize:24,align:"center"};
			mainRatingStyle = {fontSize:100,align:"center"};
			labelStyle = {fontSize:24,autoSize:"right"};
			sepStyle = {fontSize:36,autoSize:"left"};
			friendsHeaderStyle = {fontSize:16};
			continueButtonStyle = {fontSize:36};
			*/
			
			filmTitleStyle.fontSize = 20;
			mainRatingStyle.fontSize = 48;
			labelStyle.fontSize = 20;
			sepStyle.fontSize = 20;
			friendsHeaderStyle.fontSize = 16;
			continueButtonStyle.fontSize = 24;
			
		}
		
		
		override protected function onResize(evt:Event = null):void{
			this.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;
			this.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2;
			_top.y = -_top.height*0.9;
			_bottom.y = _top.y + _top.height + 10;
			//_top.x = -_top.width/2;
		}
	}
}

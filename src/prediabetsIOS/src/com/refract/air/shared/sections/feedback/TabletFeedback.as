package com.refract.air.shared.sections.feedback {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * @author kanish
	 */
	public class TabletFeedback extends Sprite {
		
		
		private var _title:TextField;
		private var _body:TextField;
		
		public function TabletFeedback() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void{
			
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			
			_title = TextManager.makeText("page_feedback_title",this,{fontSize:72});
			_title.x = -_title.width/2;
			
			_body = TextManager.makeText("page_feedback_mobile_copy",this,{fontSize:14,mouseEnabled:true, selectable:true});
			_body.x = -_body.width/2;
			_body.y = _title.y + _title.height + 10;
			
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		protected function onResize(evt:Event = null):void{
			this.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - this.height/2;
			this.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;
		}
		
		public function destroy():void{
			stage.removeEventListener(Event.RESIZE, onResize);
			
			if(_title){
				_title = null;
			}
			if(_body){
				_body = null;
			}
			
			removeChildren();
			_title = null;
		}
	}
}

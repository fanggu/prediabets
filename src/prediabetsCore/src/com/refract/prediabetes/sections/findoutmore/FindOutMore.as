package com.refract.prediabetes.sections.findoutmore  
{
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.GeneralOverlay;
	import com.refract.prediabetes.sections.utils.LSButton;

	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class FindOutMore extends GeneralOverlay {
		private var _bodyText:TextField;
		private var _bodyHeader:TextField;
		
		private var _bookBtn:LSButton;
		
		public function FindOutMore() {
			super();
		}
	
		protected override function createContent():void{
			
			_header = TextManager.makeText("findoutmore_title",this,_headerStyle);
			_bodyStyle.mouseEnabled = true;
			_bodyStyle.selectable = true;
			_bodyHeader = TextManager.makeText("page_findoutmore_subtitle", _body,_bodySubtitleStyle);
			_bodyText = TextManager.makeText("page_findoutmore_copy", _body,_bodyStyle); 
			_bodyText.y = _header.height+5;
			
			var buttonStyle:Object = {fontSize:36};
			_bookBtn = new LSButton("page_findoutmore_link",buttonStyle,100,50,true,false);
			addChild(_bookBtn);
			_bookBtn.addEventListener(MouseEvent.CLICK, launchCoursePage);
			
			super.createContent();
			_bookBtn.x = _scrollbox.x;
			_bookBtn.y = _scrollbox.y + _scrollbox.height + 20;
		}
	
		
		private function launchCoursePage(event : MouseEvent) : void {
			
			
			//AppSettings.goToLink(AppSettings.COURSE_URL);
			if(stage.displayState != StageDisplayState.NORMAL && AppSettings.DEVICE == AppSettings.DEVICE_PC){
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		
		override public function destroy():void{
			_bookBtn.removeEventListener(MouseEvent.CLICK, launchCoursePage);
			_bookBtn.destroy();
			_bookBtn = null;
			_bodyText = null;
			_bodyHeader = null;
			super.destroy();
		}

	}
}

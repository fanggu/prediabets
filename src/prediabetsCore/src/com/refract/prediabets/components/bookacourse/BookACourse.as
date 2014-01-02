package com.refract.prediabets.components.bookacourse {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.backend.BackendResponder;
	import com.refract.prediabets.components.shared.GeneralOverlay;
	import com.refract.prediabets.components.shared.LSButton;
	import com.refract.prediabets.user.UserModel;

	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class BookACourse extends GeneralOverlay {
		private var _bodyText:TextField;
		private var _bodyHeader:TextField;
		
		private var _bookBtn:LSButton;
		
		public function BookACourse() {
			super();
		}
	
		protected override function createContent():void{
			
			_header = TextManager.makeText("page_book_a_course_title",this,_headerStyle);
			_bodyStyle.mouseEnabled = true;
			_bodyStyle.selectable = true;
			_bodyHeader = TextManager.makeText("page_book_a_course_subtitle", _body,_bodySubtitleStyle);
			_bodyText = TextManager.makeText("page_book_a_course_copy", _body,_bodyStyle);
			_bodyText.y = _bodyHeader.height+20;
			
			var buttonStyle:Object = {fontSize:36};
			_bookBtn = new LSButton("page_book_a_course_link",buttonStyle,100,50,true,false);
			addChild(_bookBtn);
			_bookBtn.addEventListener(MouseEvent.CLICK, launchCoursePage);
			
			super.createContent();
			_bookBtn.x = _scrollbox.x;
			_bookBtn.y = _scrollbox.y + _scrollbox.height + 20;
		}
	
		
		private function launchCoursePage(event : MouseEvent) : void {
			
			BackendResponder.apiLog( 
									"page/book_a_course"+
									"/module1/"+ UserModel.getModuleStats(1).isComplete+
									"/module2/"+ UserModel.getModuleStats(2).isComplete+
									"/module3/"+ UserModel.getModuleStats(3).isComplete
									);
			
			AppSettings.goToLink(AppSettings.COURSE_URL);
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
package com.refract.prediabetes.sections.legal {
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.GeneralOverlay;

	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class Legal extends GeneralOverlay {
		
		private var _bodyText:TextField;
		private var _bodyTitle:TextField;
		
		public function Legal() {
			super();
		}
		
		
		protected override function createContent():void{
			_header = TextManager.makeText("page_legal_title",this,_headerStyle);
			_bodyTitle = TextManager.makeText("page_legal_heading",_body,_bodyTitleStyle);
			_bodyText = TextManager.makeText("page_legal_content",_body,_bodyStyle);
			_bodyText.y = _bodyTitle.height+5;
			super.createContent();
		}
		
	}
}

package com.refract.prediabetes.sections.legal {
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.GeneralOverlay;

	import flash.text.TextField;


	public class Legal extends GeneralOverlay {
		
		private var _bodyText:TextField;
		private var _bodyTitle:TextField;
		
		public function Legal() 
		{
			name = 'LEGAL' ; 
			super();
		}
		
		
		protected override function createContent():void
		{	
			_header = TextManager.makeText("page_legal_title",this,_headerStyle);
			/*
			_bodyTitle = TextManager.makeText("page_legal_heading_1",_body,_bodyTitleStyle);
			_bodyText = TextManager.makeText("page_legal_content_1",_body,_bodyStyle);
			_bodyText.y = _bodyTitle.y + _bodyTitle.height + 10 ; 
			
			var bodyTitle2 : TextField = TextManager.makeText("page_legal_heading_2",_body,_bodyTitleStyle);
			var bodyText2 : TextField = TextManager.makeText("page_legal_content_2",_body,_bodyStyle);
			
			bodyTitle2.y = _bodyText.y + _bodyText.height + 10 ; 
			bodyText2.y = bodyTitle2.y + bodyTitle2.height + 10 ; 
			
			var bodyTitle3 : TextField = TextManager.makeText("page_legal_heading_3",_body,_bodyTitleStyle);
			var bodyText3 : TextField = TextManager.makeText("page_legal_content_3",_body,_bodyStyle);
			
			bodyTitle3.y = bodyText2.y + bodyText2.height + 10 ; 
			bodyText3.y = bodyTitle3.y + bodyTitle3.height + 10 ; 
			 * 
			 */
			 var i : int = 0 ; 
			 var l : int = 10 ; 
			 var bodyTextMemory : TextField ; 
			 for( i = 1 ; i <= l ; i++ )
			 {
				var bodyTitle : TextField = TextManager.makeText("page_legal_heading_" + i,_body,_bodyTitleStyle);
				var bodyText : TextField = TextManager.makeText("page_legal_content_" + i,_body,_bodyStyle) ;
				if( bodyTextMemory )
				{
					bodyTitle.y = bodyTextMemory.y + bodyTextMemory.height + 15 ; 
				}
				bodyText.y = bodyTitle.y + bodyTitle.height + 5 ; 
				bodyTextMemory = bodyText ; 
			 }
			
			//_bodyText.y = _bodyTitle.height+5;
			super.createContent();
		}
		
	}
}

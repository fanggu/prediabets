package com.refract.prediabetes.sections {
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.GeneralOverlay;

	import flash.text.TextField;


	public class Legal extends GeneralOverlay 
	{
		
		public function Legal() 
		{
			name = 'LEGAL' ; 
			super();
		}
		
		
		protected override function createContent():void
		{	
			_header = TextManager.makeText("page_legal_title",this,_headerStyle);
			 var i : int = 0 ; 
			 var l : int = 13 ; 
			 var bodyTextMemory : TextField ; 
			 for( i = 1 ; i <= l ; i++ )
			 {
				var bodyTitle : TextField = TextManager.makeText("page_legal_heading_" + i,_body,_bodyTitleStyle);
				
				
				//_bodyStyle.width = 200 ; 
				var bodyText : TextField = TextManager.makeText("page_legal_content_" + i,_body,_bodyStyle) ;
				if( bodyTextMemory )
				{
					bodyTitle.y = bodyTextMemory.y + bodyTextMemory.height + 15 ; 
				}
				bodyText.y = bodyTitle.y + bodyTitle.height + 5 ; 
				bodyTextMemory = bodyText ; 
			 }
			super.createContent();
		}
	}
}

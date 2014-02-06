package com.refract.prediabetes.sections {
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.GeneralOverlay;
	import com.refract.prediabetes.tracking.TrackingCloseAttachment;
	import com.refract.prediabetes.tracking.TrackingGetAttachment;
	import com.refract.prediabetes.tracking.TrackingSettings;

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
			var trackAttachment : TrackingGetAttachment = new TrackingGetAttachment() ; 
			trackAttachment.track( 3 ) ; 
			
			_header = TextManager.makeText("page_legal_title",this,_headerStyle) ;
			_header.y = -10 ; 
			 var i : int = 0 ; 
			 var l : int = 13 ; 
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
			super.createContent();
		}
		override public function destroy():void
		{
			var trackCloseAttachment : TrackingCloseAttachment = new TrackingCloseAttachment() ; 
			trackCloseAttachment.track( TrackingSettings.ATTACHMENT_ID ) ; 
			super.destroy() ; 
		}
	}
}

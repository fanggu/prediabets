package com.refract.prediabetes.sections.findoutmore  
{
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.GeneralOverlay;
	import com.refract.prediabetes.sections.utils.PrediabetesButton;

	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class FindOutMore extends GeneralOverlay {
		private var _bodyText:TextField;
		private var _bodyHeader:TextField;
		
		
		public function FindOutMore() 
		{
			name = 'FIND_OUT_MORE' ; 
			super();
		}
	
		protected override function createContent():void{
			
			_header = TextManager.makeText("findoutmore_title",this,_headerStyle);
			_bodyStyle.mouseEnabled = true;
			_bodyStyle.selectable = true;
			_bodyHeader = TextManager.makeText("page_findoutmore_subtitle", _body,_bodySubtitleStyle);
			_bodyText = TextManager.makeText("page_findoutmore_copy", _body,_bodyStyle); 
			_bodyText.y = _header.height+5;
			
			super.createContent();
		}
		
		
		override public function destroy():void
		{
			super.destroy();
		}

	}
}

package com.refract.prediabetes.sections.findoutmore  
{
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.GeneralOverlay;

	import flash.display.Bitmap;
	import flash.text.TextField;

	public class FindOutMore extends GeneralOverlay 
	{	
		public function FindOutMore() 
		{
			name = 'FIND_OUT_MORE' ; 
			super();
		}
	
		protected override function createContent():void{
			
			_header = TextManager.makeText("findoutmore_title",this,_headerStyle);
			_bodyStyle.mouseEnabled = true;
			_bodyStyle.selectable = true;
			//_bodyHeader = TextManager.makeText("page_findoutmore_subtitle", _body,_bodySubtitleStyle);
			var bodyText : TextField = TextManager.makeText("page_findoutmore_copy_1", _body,_bodyStyle); 
			bodyText.y = 0 ; //_header.height+5;
			
			var logoAddress : String = AppSettings.LOGO_ADDRESS ; 
			var logo : Bitmap = AssetManager.getEmbeddedAsset( logoAddress );
			_body.addChild( logo ) ;
			var spacer : int = 10 ; 
			if( AppSettings.RETINA ) spacer = 20 ; 
			logo.y = bodyText.y + bodyText.height + spacer ; 
			
			var logoDNZAddress : String = AppSettings.LOGO_DNZ_ADDRESS ; 
			var logoDNZ : Bitmap = AssetManager.getEmbeddedAsset( logoDNZAddress );
			_body.addChild( logoDNZ ) ; 
			logoDNZ.y = bodyText.y + bodyText.height + spacer ; 
			logoDNZ.x = logo.x + logo.width + spacer ; 
			
			var bodyText2 : TextField = TextManager.makeText("page_findoutmore_copy_2", _body,_bodyStyle); 
			bodyText2.y = logo.y + logo.height + spacer ; 
			
			var bodyText3 : TextField = TextManager.makeText("page_findoutmore_copy_3", _body,_bodyStyle); 
			bodyText3.y = bodyText2.y + bodyText2.height + spacer ; 
			
			super.createContent();
		}
		
		
		override public function destroy():void
		{
			super.destroy();
		}

	}
}

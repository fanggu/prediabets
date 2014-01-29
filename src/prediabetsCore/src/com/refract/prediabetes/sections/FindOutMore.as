package com.refract.prediabetes.sections  
{
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.GeneralOverlay;
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.view.buttons.ButtonChoice;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class FindOutMore extends GeneralOverlay 
	{
		private var _findoutmoreBt1 : ButtonChoice;
		private var _findoutmoreBt2 : ButtonChoice;
		private var _bodyHeading : TextField;

		public function FindOutMore() 
		{
			name = 'FIND_OUT_MORE' ; 
			super();
		}
	
		protected override function createContent():void
		{
			var spacer : int = 10 ; 
			if( AppSettings.RETINA ) spacer = 20 ; 
			
			var interaction : Object ;
			
			_header = TextManager.makeText("page_findoutmore_title",this,_headerStyle);
			_bodyStyle.mouseEnabled = true;
			_bodyStyle.selectable = true;
			
			_bodyStyle.autoSize = TextFieldAutoSize.CENTER ; 
			_bodyStyle.align = TextFieldAutoSize.CENTER ; 
			
			_bodyTitleStyle.autoSize = TextFieldAutoSize.CENTER ; 
			_bodyTitleStyle.align = TextFieldAutoSize.CENTER ; 
			_bodyHeading = TextManager.makeText("page_findoutmore_heading_1" ,_body,_bodyTitleStyle);
			
			var bodyText2 : TextField = TextManager.makeText("page_findoutmore_copy_2", _body,_bodyStyle); 
			bodyText2.y = _bodyHeading.y + _bodyHeading.height + spacer ; 
			
			_findoutmoreBt1 = new ButtonChoice( SMSettings.FONT_BUTTON, { fontSize:26 , findoutmore : true  }, SMSettings.MIN_BUTTON_SIZE, 70  , false , false);
			interaction = SMController.me.model.findoutmoreBt1State ; 
			interaction.iter = 'findoutmore_1'; 
			interaction.external = true ; 
			interaction.findoutmore = true ; 
			addChild( _findoutmoreBt1 ) ; 
			_findoutmoreBt1.visible = true ;
			 
			_findoutmoreBt1.setButton( interaction ) ; 
			_findoutmoreBt1.addEventListener(MouseEvent.CLICK, onfindoutmore_1);
			_findoutmoreBt1.y = bodyText2.y + bodyText2.height + spacer ; ///+ _findoutmoreBt1.height / 2 + spacer ;
			//findoutmoreBt1.x = -findoutmoreBt1.width / 2 ; 
			_body.addChild( _findoutmoreBt1 ) ; 
			
			
			var bodyText3 : TextField = TextManager.makeText("page_findoutmore_copy_3", _body,_bodyStyle); 
			bodyText3.y = _findoutmoreBt1.y + _findoutmoreBt1.height + spacer ; 
			
			_findoutmoreBt2 = new ButtonChoice( SMSettings.FONT_BUTTON, { fontSize:26 , findoutmore : true }, SMSettings.MIN_BUTTON_SIZE, 70  , false , false); 
			interaction = SMController.me.model.findoutmoreBt2State ; 
			interaction.iter = 'findoutmore_2'; 
			addChild( _findoutmoreBt2 ) ; 
			interaction.external = true ; 
			interaction.findoutmore = true ; 
			_findoutmoreBt2.visible = true ; 
			_findoutmoreBt2.setButton( interaction ) ; 
			_findoutmoreBt2.addEventListener(MouseEvent.CLICK, onfindoutmore_2);
			_findoutmoreBt2.y = bodyText3.y + bodyText3.height + spacer + _findoutmoreBt2.height / 2 + spacer ;
			//findoutmoreBt2.x = -findoutmoreBt2.width / 2 ; 
			_body.addChild( _findoutmoreBt2 ) ;
			
			
			super.createContent();
		}

		private function onfindoutmore_2(event : MouseEvent) : void 
		{
			
		}

		private function onfindoutmore_1(event : MouseEvent) : void 
		{
			
		}
		
		override protected function onResize(evt:Event = null,b:Boolean = true):void
		{	
			super.onResize() ; 
			_findoutmoreBt1.x =  _scrollbox.width / 2 - _findoutmoreBt1.width / 2
			_findoutmoreBt2.x =  _scrollbox.width / 2 - _findoutmoreBt2.width / 2  
		}
		
		
		override public function destroy():void
		{
			super.destroy();
		}

	}
}

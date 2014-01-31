package com.refract.prediabetes.sections  
{
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.GeneralOverlay;
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.view.buttons.ButtonChoice;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class FindOutMore extends GeneralOverlay 
	{
		private var _findoutmoreBt1 : ButtonChoice;
		private var _findoutmoreBt2 : ButtonChoice;
		private var _bodyHeading : TextField;
		private var _cont : Sprite ; 

		public function FindOutMore() 
		{
			name = 'FIND_OUT_MORE' ; 
			super();
		}
	
		protected override function createContent():void
		{
			_cont = new Sprite() ; 
			addChild( _cont )
			///this.y = this.y - 120 ; 
			var spacer : int = 4 ; 
			if( AppSettings.RETINA ) spacer = 10 ; 
			
			var interaction : Object ;
			
			_header = TextManager.makeText("page_findoutmore_title",this,_headerStyle);
			_header.y = - 10 ; 
			_bodyStyle.mouseEnabled = true;
			_bodyStyle.selectable = true;
			
			_bodyStyle.autoSize = TextFieldAutoSize.CENTER ; 
			_bodyStyle.align = TextFieldAutoSize.CENTER ; 
			_bodyStyle.leading = 1 ; 
			
			_bodyTitleStyle.autoSize = TextFieldAutoSize.CENTER ; 
			_bodyTitleStyle.align = TextFieldAutoSize.CENTER ; 
			_bodyHeading = TextManager.makeText("page_findoutmore_heading_1" , _cont ,_bodyTitleStyle);
			_bodyHeading.y = -5 ;
			_bodyHeading.x = -_bodyHeading.width / 2 ;  
			
			var bodyText2 : TextField = TextManager.makeText("page_findoutmore_copy_2", _cont,_bodyStyle); 
			bodyText2.y = _bodyHeading.y + _bodyHeading.height + spacer ; 
			bodyText2.x = -bodyText2.width / 2 ; 
			
			_findoutmoreBt1 = new ButtonChoice( SMSettings.FONT_BUTTON, { fontSize:26 , findoutmore : true  }, SMSettings.MIN_BUTTON_SIZE, 70  , false , false);
			interaction = SMController.me.model.findoutmoreBt1State ; 
			interaction.iter = 'findoutmore_1'; 
			interaction.external = true ; 
			
			_cont.addChild( _findoutmoreBt1 ) ; 
			_findoutmoreBt1.visible = true ;
			_findoutmoreBt1.setButton( interaction ) ; 
			_findoutmoreBt1.addEventListener(MouseEvent.CLICK, onfindoutmore_1);
			_findoutmoreBt1.y = bodyText2.y + bodyText2.height + spacer ; ///+ _findoutmoreBt1.height / 2 + spacer ;
			//_body.addChild( _findoutmoreBt1 ) ; 
			
			
			var bodyText3 : TextField = TextManager.makeText("page_findoutmore_copy_3", _cont ,_bodyStyle); 
			bodyText3.y = _findoutmoreBt1.y + _findoutmoreBt1.height + spacer ; 
			bodyText3.x = -bodyText3.width / 2 ; 
			
			_findoutmoreBt2 = new ButtonChoice( SMSettings.FONT_BUTTON, { fontSize:26 , findoutmore : true }, SMSettings.MIN_BUTTON_SIZE, 70  , false , false); 
			interaction = SMController.me.model.findoutmoreBt2State ; 
			interaction.iter = 'findoutmore_2'; 
			_cont.addChild( _findoutmoreBt2 ) ; 
			interaction.external = true ; 
			
			_findoutmoreBt2.visible = true ; 
			_findoutmoreBt2.setButton( interaction ) ; 
			_findoutmoreBt2.addEventListener(MouseEvent.CLICK, onfindoutmore_2);
			_findoutmoreBt2.y = bodyText3.y + bodyText3.height + spacer;
			//_body.addChild( _findoutmoreBt2 ) ;
			
			var bodyText4 : TextField = TextManager.makeText("page_findoutmore_copy_4", _cont ,_bodyStyle); 
			bodyText4.y = _findoutmoreBt2.y + _findoutmoreBt2.height + spacer ; 
			bodyText4.x = -bodyText4.width / 2 ; 
			
			super.createContent();
		}

		private function onfindoutmore_2(event : MouseEvent) : void 
		{
			var urlRequest : URLRequest = new URLRequest("http://www.diabetes.org.nz" ) ;
			navigateToURL( urlRequest, "_blank" );
		}

		private function onfindoutmore_1(event : MouseEvent) : void 
		{
			var urlRequest : URLRequest = new URLRequest("http://www.healthmentoronline.com") ;
			navigateToURL( urlRequest , "_blank");
		}
		
		override protected function onResize(evt:Event = null,b:Boolean = true):void
		{	
			super.onResize() ; 
			_findoutmoreBt1.x =  _scrollbox.width / 2 - _findoutmoreBt1.width / 2 ;
			_findoutmoreBt2.x =  _scrollbox.width / 2 - _findoutmoreBt2.width / 2  ;
			
	
			_cont.y =( AppSettings.VIDEO_HEIGHT - AppSettings.OVERLAY_GAP - SMSettings.CHOICE_BUTTON_HEIGHT ) / 2 - _cont.height / 2 ; 
			//**fix pos
			if( AppSettings.stage.stageHeight < 550)
			{
				//_body.y = _body.y + 150 ; 
			}
		}
		
		
		override public function destroy():void
		{
			super.destroy();
		}

	}
}

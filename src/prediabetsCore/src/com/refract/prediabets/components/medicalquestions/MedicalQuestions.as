package com.refract.prediabets.components.medicalquestions {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSections;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.backend.BackendResponder;
	import com.refract.prediabets.components.shared.GeneralOverlay;
	import com.refract.prediabets.components.shared.LSButton;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author kanish
	 */
	public class MedicalQuestions extends GeneralOverlay {
		
		
		private var _bodyTitles:Array;
		private var _bodyTitlesContainer:Sprite;
		private var _bodyPositions:Array;
		private var _subline:TextField;
		
		public function MedicalQuestions() {
			super();
			
			BackendResponder.apiLog("page/medical_questions");
		}
		
		protected function setStyles():void{
			
			_bodyTitleStyle.fontSize = 24; // font size 36;
			_bodyTitleStyle.width = null;
			_bodyTitleStyle.autoSize = "left";
			_bodyTitleStyle.multiline = false;
			_bodyTitleStyle.wordWrap = false;
			_bodyTitleStyle.toUpper = true;
			_bodyTitleStyle.mouseEnabled = true;
			
			_bodySubtitleStyle.toUpper = true;
			_bodySubtitleStyle.mouseEnabled = true;
			_bodyStyle.mouseEnabled = true;
		//	_bodyStyle.leading = 4;
		}
		
		protected override function createContent():void{
			
			
			var lastDisp:DisplayObject;
			var currDisp:DisplayObject;
			var i:int;
			var str:String;
			var totalHeadings:int;
			
			setStyles();
		//	_scrollerWidth = 580;
			
			addChild(_body);
			
			_header = TextManager.makeText("page_med_questions_title",this,_headerStyle);
			var headings:String = "page_med_questions_heading_";
			var titles:Array = TextManager.getDataListForId(headings);
			_bodyTitles = [];
			_bodyTitlesContainer = new Sprite();
			addChild(_bodyTitlesContainer);
			i=0;
			for (str in titles){
				i++;
				currDisp = new LSButton(headings+i,_bodyTitleStyle);
				(currDisp as LSButton).overColor = AppSettings.RED;
				_bodyTitles.push(currDisp);
				_bodyTitlesContainer.addChild(currDisp);
				currDisp.addEventListener(MouseEvent.CLICK,scrollToPosition);
				
				var tf:TextFormat = TextField(currDisp["textfield"]).getTextFormat();
				tf.color = AppSettings.WHITE;
				TextField(currDisp["textfield"]).setTextFormat(tf);
				
				if(lastDisp){
					currDisp.x = lastDisp.x + lastDisp.width + 20;
					//currDisp.y = lastDisp.y + lastDisp.height;
				}
				//currDisp.y = _header.y + _header.height + 10;
				lastDisp = currDisp;
			}
			
			totalHeadings = i;
			var xx:int; var yy:int; var hh:int;
			for(i = 0; i < totalHeadings - 1; ++i){
				_bodyTitlesContainer.graphics.lineStyle(1,AppSettings.LIGHT_GREY,0.6);
				currDisp = _bodyTitlesContainer.getChildAt(i);
				hh = (currDisp as LSButton).textfield.textHeight*0.65;
				xx = currDisp.x + currDisp.width;
				xx = (_bodyTitlesContainer.getChildAt(i+1).x - xx)/2 + xx;
				yy =(currDisp as LSButton).textfield.height;
				_bodyTitlesContainer.graphics.moveTo(xx,(yy-hh)/2);
				_bodyTitlesContainer.graphics.lineTo(xx,(yy-hh)/2+hh);
			}
			
			
			
			_subline = TextManager.makeText("page_med_questions_disclaimer",this,_bodyStyle);
			_subline.y = lastDisp.y + lastDisp.height;
			lastDisp = _subline;
			
			_bodyPositions = [];
			
			var questionsTypes:Array = ["page_med_questions_gen_","page_med_questions_cpr_","page_med_questions_choking_"];
			var medListQ:String;
			var medListA:String;
			var medQs:Array;
			var spacer:int = _bodyStyle.fontSize*2 + 4;
			var headingSpacer:int = spacer*2;
			for(var j:int = 0; j < totalHeadings; ++j){
				
				medListQ = questionsTypes[j]+"q";
				medListA = questionsTypes[j]+"a";
				medQs = TextManager.getDataListForId(medListQ);	
				i = 0; 
				
				//_bodyPositions.push(_body.height+headingSpacer);
				currDisp = TextManager.makeText(headings+(j+1).toString(),_body,_bodyTitleStyle);
				if(j > 0){
			//		currDisp.y = _scrollerHeight;
				currDisp.y = lastDisp.y + lastDisp.height + headingSpacer;
				}
				_bodyPositions.push(currDisp.y);
				lastDisp = currDisp;
				for(str in medQs){
					i++;
					currDisp = TextManager.makeText(medListQ+i,_body,_bodySubtitleStyle);
					currDisp.y = lastDisp.y + lastDisp.height;
					currDisp.y += i == 1 ?  0 : spacer;
					lastDisp = currDisp;
					currDisp = TextManager.makeText(medListA+i,_body,_bodyStyle);
					currDisp.y = lastDisp.y + lastDisp.height;
					lastDisp = currDisp;
				}
				
			}
			removeChild(_body);
		//	_bodyText = TextManager.makeText("page_legal_content",_body,_bodyStyle);
		//	_bodyText.y = _bodyTitle.height+5;
			super.createContent();
			_header.x = _scrollbox.x;
			_bodyTitlesContainer.x = _subline.x = _header.x;
			_bodyTitlesContainer.y = _header.height + 10;
			_subline.y = _bodyTitlesContainer.y + _bodyTitlesContainer.height + 10;
			_scrollbox.y = _subline.y + _subline.height + 10;			
			
			
		}
		
		private function scrollToPosition(evt:MouseEvent):void{
			var lsButton:LSButton = evt.currentTarget as LSButton;
			var index:int = _bodyTitles.indexOf(lsButton);
			switch(index){
				case(0):
					AppController.i.setSWFAddress(AppSections.MEDICAL_QUESTIONS_GENERAL);
				break;
				case(1):
					AppController.i.setSWFAddress(AppSections.MEDICAL_QUESTIONS_CPR);
				break;
				case(2):
					AppController.i.setSWFAddress(AppSections.MEDICAL_QUESTIONS_CHOKING);
				break;
			}
			scrollByIndex(index);
		}
		
		private function scrollByIndex(index:int):void{
			var position:Number = _bodyPositions[index];
			var bodyHeight:Number = _body.height - _scrollerHeight;
			position = (position)/(bodyHeight);
			_scrollbox.scrollTo(position);
		}
		
		override protected function handleSWFAddress(evt:SWFAddressEvent):void{
			var paths:Array = SWFAddress.getPathNames();
			var index:int;
			if(paths.length > 1){
				switch(paths[1]){
					case(AppSections.MEDICAL_QUESTIONS_GENERAL.split("/")[1]):
						index = 0;
						scrollByIndex(index);
					break;
					case(AppSections.MEDICAL_QUESTIONS_CPR.split("/")[1]):
						index = 1;
						scrollByIndex(index);
					break;
					case(AppSections.MEDICAL_QUESTIONS_CHOKING.split("/")[1]):
						index = 2;
						scrollByIndex(index);
					break;
				}
			}
		}
		
		override protected function onResize(evt:Event = null,b:Boolean = true):void{
			
			
		//	_scrollbox.x = int(-_scrollbox.contentWidth/2);
		//	_scrollbox.y = _header ? int(_header.y + _header.height + 20) : 0;
			
			this.x = int(AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2);
			this.y = int(AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - this.effectiveHeight/2);
			
		}
		
		override public function destroy():void{
			for(var i:int = 0; i < _bodyTitles.length;++i){
				_bodyTitles[i].removeEventListener(MouseEvent.CLICK,scrollToPosition);
			}
			super.destroy();
		}
	}
}

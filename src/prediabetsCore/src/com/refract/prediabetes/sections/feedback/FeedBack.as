package com.refract.prediabetes.sections.feedback {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.logger.Logger;
	import com.refract.prediabetes.nav.Nav;
	import com.refract.prediabetes.sections.utils.LSButton;
	import com.refract.prediabetes.sections.utils.LSInputBox;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.text.TextField;


	public class FeedBack extends Sprite {
		
		private var _title:TextField;
		private var _name:LSInputBox;
		private var _email:LSInputBox;
		private var _message:LSInputBox;
		private var _validation:LSInputBox;
		private var _validationReload:LSButton;
		private var _validationImg:Bitmap;
		
		private var _resultContainer:Sprite;
		
		private var _endLine:Sprite;
	//	private var _close:LSButton;
		private var _submit:LSButton;
		
		public function FeedBack() {
			AppSettings.checkFSStatus();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			_title = TextManager.makeText("page_feedback_title",this,{fontSize:72});
			_title.x = -_title.width/2;
			
			var inputWidth:Number = 330;
			var btnWidth:Number = inputWidth + 24;//(inputWidth+24)/2 - 10;
			
			_name = new LSInputBox("page_feedback_name",{fontSize:20},inputWidth,36);
			addChild(_name);
			_name.x = -_name.width/2;
			_name.y = _title.y + _title.height + 28;
			
			_email = new LSInputBox("page_feedback_email",{fontSize:20},inputWidth,36);
			addChild(_email);
			_email.x = -_email.width/2;
			_email.y = _name.y + _name.height + 8;
			_email.textfield.restrict = "0-9a-zA-Z.@_";
			
			_message = new LSInputBox("page_feedback_message",{fontSize:20,multiline:true},inputWidth,92);
			addChild(_message);
			_message.x = -_message.width/2;
			_message.y = _email.y + _email.height + 8;
			
			
			loadValidation();
			
			_validationReload = new LSButton("page_feedback_reload",{fontSize:13},0,0,true,false);
			_validationReload.addEventListener(MouseEvent.CLICK, loadValidation);
			_validationReload.arrowScale = 0.65;
			addChild(_validationReload);
			_validationReload.x = _message.x + _message.width - _validationReload.width;
			_validationReload.visible = false;
			
	//		_validationImg.y = _message.y + _message.height + 8;
			
			_validation = new LSInputBox("page_feedback_validation",{fontSize:20},inputWidth,36);
			addChild(_validation);
			_validation.x = -_validation.width/2;
			_validation.y = _message.y + _message.height + _validation.height + 24;
			_validation.text = "ENTER TEXT SHOWN IN THE IMAGE ABOVE";
			_validation.originalCopy = _validation.text;
		//	_validation.textfield.restrict = "0-9";
		//	_validation.textfield.maxChars = 3;

			_endLine = new Sprite();
			addChild(_endLine);


//			_submit = new LSButton("page_feedback_submit",{fontSize:36},btnWidth,70,true,false);
			_submit = new LSButton("page_feedback_submit",{fontSize:36},btnWidth - 5,70,true,false);
			_submit.addEventListener(MouseEvent.CLICK,onSubmit);
			_endLine.addChild(_submit);
			
			
			
			//191
			
			
	//		_close = new LSButton("overlay_close",{fontSize:36},btnWidth,70,true,false);
	//		_close.addEventListener(MouseEvent.CLICK,onClose);
	//		_endLine.addChild(_close);
	//		_close.x = _submit.x + _submit.width + 10;

			_endLine.x = -_endLine.width/2;
			_endLine.y = _validation.y + _validation.height + 35;
			
			
			_resultContainer = new Sprite();
			addChild(_resultContainer);
			_resultContainer.visible = false;
			_resultContainer.alpha = 0;
			var tf:TextField = TextManager.makeText("page_feedback_thanks",_resultContainer,{fontSize:16});
			tf.x = -tf.width/2;
			tf.y = (_endLine.y -  (_title.y + _title.height))/2 - tf.height/2;

			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		protected function loadValidation(evt:MouseEvent = null) : void {
			
			//BackendResponder.getCaptcha(onCaptcha,onError);
		}
		
		protected function onCaptcha(evt:Event,loader:Loader):void{
			if(_validationImg && contains(_validationImg)){
				removeChild(_validationImg);
			}
		//	Logger.log(Logger.OVERLAY,"loaded, adding bitmap");
			_validationImg = loader.content as Bitmap;
			addChild(_validationImg);
			_validationImg.x = -_validationImg.width/2;
			_validationImg.y = _message.y + _message.height + 8;
			_validationReload.visible = true;
			_validationReload.y = _validationImg.y + _validationImg.height + 2;
			_validation.y = _validationReload.y + _validationReload.height + 8;
		}
		protected function onError(evt:Event):void{
			
		}
		
		protected function onSubmit(evt:MouseEvent):void{
			if(validateInput()){
				_submit.removeEventListener(MouseEvent.CLICK,onSubmit);
				//BackendResponder.sendFeedback(_name.text, _email.text, _validation.text, _message.text,onFeedbackSent, onFeedbackError);
				//onClose(evt);
			}
		}
		
		protected function onFeedbackSent(evt:Event, loader:URLLoader):void{
			var data:Object =  JSON.parse(loader.data);
			if(data.hasOwnProperty("success")){
				showThanks();
				//onClose();
			}else{
				_validation.setErrorState();
				_submit.addEventListener(MouseEvent.CLICK,onSubmit);
			}
		}
		
		protected function onFeedbackError(evt:Event):void{
			Logger.log(Logger.OVERLAY,"PROBLEM!");
		}
		
		protected function validateInput():Boolean{
			var out:Boolean = true;
			if(!_name.isValid()){ out = false; }
			if(!_email.isValidEmail()){ out = false; }
			if(!_message.isValid()){ out = false; }
			if(!_validation.isValid()){ out = false; }
			return out;
		}
		
		protected function showThanks():void{
	//		page_feedback_thanks
			var oncomp:Function;
			for(var i:int =0; i < numChildren; ++i){
				if(getChildAt(i) != _title){
					oncomp = i == numChildren - 1 ? onShowThanks : null;
					TweenMax.to(getChildAt(i),0.5,{autoAlpha:0, onComplete:oncomp});
				}
			}
		
		}
		
		protected function onShowThanks():void{
			//_submit.text = TextManager.getDataListForId("signup_continue")["signup_continue"]["copy_"+AppSettings.LOCALE];
			//_submit.minW = 270;
			
			TweenMax.killTweensOf(_endLine);
			TweenMax.to(_endLine,0.5,{autoAlpha:1});
			TweenMax.to(_resultContainer,0.5,{autoAlpha:1});
			
		}
		

		protected function onResize(evt:Event = null):void{
			this.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - this.height/2;
			this.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;
		}
		
		public function destroy():void{
			stage.removeEventListener(Event.RESIZE, onResize);
		//	if(_close){
		//		_close.destroy();
		//		_close = null;
		//	}
			if(_email){
				_email.destroy();
				_email = null;
			}
			if(_endLine){
				_endLine.removeChildren();
				_endLine = null;
			}
			if(_message){
				_message.destroy();
				_message = null;
			}
			if(_name){
				_name.destroy();
				_name = null;
			}
			if(_submit){
				_submit.removeEventListener(MouseEvent.CLICK,onSubmit);
				_submit.destroy();
				_submit = null;
			}
			if(_title){
				_title = null;
			}
			if(_validation){
				_validation.destroy();
				_validation = null;
			}
			if(_validationImg){
				_validation = null;
			}
			
			removeChildren();
			_title = null;
		}
	}
}

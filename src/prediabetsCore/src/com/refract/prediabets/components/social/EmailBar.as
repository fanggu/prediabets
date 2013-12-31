package com.refract.prediabets.components.social {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.backend.BackendResponder;
	import com.refract.prediabets.components.shared.LSButton;
	import com.refract.prediabets.components.shared.LSInputBox;
	import com.refract.prediabets.logger.Logger;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class EmailBar extends Sprite {
		
		public static const EMAILBAR_SUCCESS:String = "EMAILBAR_SUCCESS";
		public static const EMAILBAR_ERROR:String = "EMAILBAR_ERROR";
		
		private var _w:int;
		
		private var _email:LSInputBox;
		private var _authCode:LSInputBox;
		private var _forgotCode:LSButton;
		private var _noCode:LSButton;
		private var _hasCode:LSButton;
		private var _go:LSButton;
		
		private var _errors:Sprite;
		
		public function EmailBar(width:int) {
			_w = width;
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void{			
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			
			var tf:TextField;
			tf = TextManager.makeText("signup_or",this,{fontSize:15});
			
			var lineWidthGap:int = tf.textWidth + 26;
			var lineHalfWidth:Number = (_w - lineWidthGap)*0.5;
			
			var line1:Shape = new Shape();
			addChild(line1);
			line1.graphics.lineStyle(1,AppSettings.GREY);
			line1.graphics.moveTo(0,0);
			line1.graphics.lineTo(lineHalfWidth,0);
			line1.graphics.moveTo(_w,0);
			line1.graphics.lineTo(_w - lineHalfWidth,0);
			
		//	line1.y = int(_twitter.height + 32);
			tf.x = int(this.width/2 - tf.width/2);
			tf.y = int(line1.y - tf.height/2);
		
		
			_errors = new Sprite();
			addChild(_errors);
			_errors.alpha = 0;
			_errors.visible = false;
			_errors.x = int(this.width/2);
			_errors.y = line1.y + 5;
			
			tf = TextManager.makeText("signup_input_error",_errors,{fontSize:12}); //0
			tf.x = -tf.width/2;
			tf = TextManager.makeText("login_input_error",_errors,{fontSize:12}); //1
			tf.x = -tf.width/2;
			tf = TextManager.makeText("signup_recheck_email",_errors,{fontSize:12}); //2
			tf.x = -tf.width/2;
			tf = TextManager.makeText("signup_auth_code_sent",_errors,{fontSize:12}); //3
			tf.x = -tf.width/2;
			tf = TextManager.makeText("signup_backend_error",_errors,{fontSize:12}); //4
			tf.x = -tf.width/2;
			tf = TextManager.makeText("signup_backend_error",_errors,{fontSize:12}); //5 - this one is the one to use for backend messages
			tf.x = -tf.width/2;
			tf = TextManager.makeText("signup_email_error",_errors,{fontSize:12}); //6
			tf.x = -tf.width/2;
			
			
			hideAllErrors();
			
		
			_go = new LSButton("signup_go",{fontSize:20},55,54,false,false);
			addChild(_go);
			_go.addEventListener(MouseEvent.CLICK,onGo);
			
			
			_email = new LSInputBox("signup_email",{fontSize:20},148,54);
			addChild(_email);
			_authCode = new LSInputBox("signup_auth_code",{fontSize:20},163,54);
			addChild(_authCode);
			
			var boxGap:int = (_w - _go.width - _email.width - _authCode.width)/2;
			_email.x = 0;
			_authCode.x = _email.width + _email.x + boxGap;
			_go.x = _authCode.x + _authCode.width + boxGap;
			_go.y = _email.y = _authCode.y = 31;
			
			_forgotCode = new LSButton("signup_forgot_code",{fontSize:13},0,0,true,false);
			_forgotCode.addEventListener(MouseEvent.CLICK, onForgotCode);
			_noCode = new LSButton("signup_no_code",{fontSize:13},0,0,true,false);
			_noCode.addEventListener(MouseEvent.CLICK, onSignUp);
			_forgotCode.arrowScale = _noCode.arrowScale = 0.65;
			addChild(_forgotCode);
			addChild(_noCode);
			_forgotCode.y = _noCode.y = int(_go.y + _go.height + 6);
			_forgotCode.x = int(_w/2 - _forgotCode.width - 14);
			_noCode.x = int(_w/2 + 3);
			
			
			_hasCode = new LSButton("signup_has_code",{fontSize:13},0,0,true,false);
			_hasCode.arrowScale = _noCode.arrowScale = 0.65;
			addChild(_hasCode);
			_hasCode.x = _w/2 - _hasCode.width/2;
			_hasCode.y = _forgotCode.y;
			_hasCode.alpha = 0;
			_hasCode.visible = false;
			_hasCode.addEventListener(MouseEvent.CLICK, onGoLogin);
			
			var line2:Shape = new Shape();
			addChild(line2);
			line2.graphics.lineStyle(1,AppSettings.GREY);
			line2.graphics.moveTo(0,0);
			line2.graphics.lineTo(_w,0);
			line2.y = _forgotCode.y + _forgotCode.height + 16;
			
		}
		
		private function hideAllErrors():void{
			for(var i:int = 0; i < _errors.numChildren; ++i){
				_errors.getChildAt(i).visible = false;
			}
		}
		
		private function onForgotCode(evt:MouseEvent):void{
			TweenMax.to(_forgotCode,0.5,{autoAlpha:0});
			TweenMax.to(_email,0.5,{autoAlpha:0});
			TweenMax.to(_authCode,0.5,{autoAlpha:0, onComplete:switchToForgotCode});
			
		}
		
		private function switchToForgotCode():void{
			var boxGap:int = (_w - _go.width - _email.width - _authCode.width)/2;
			_email.minW = _email.width + _authCode.width - 2*boxGap;
			_email.setNormalState();
			TweenMax.to(_email,0.5,{autoAlpha:1});
		}
		
		private function onSignUp(evt:MouseEvent):void{
			TweenMax.to(_email,0.5,{autoAlpha:0});
			TweenMax.to(_forgotCode,0.5,{autoAlpha:0});
			TweenMax.to(_noCode,0.5,{autoAlpha:0});
			TweenMax.to(_errors,0.5,{autoAlpha:0});
			TweenMax.to(_authCode,0.5,{autoAlpha:0, onComplete:switchToSignUp});
			
		}
		
		private function onGoLogin(evt:MouseEvent = null):void{
			TweenMax.to(_forgotCode,0.5,{autoAlpha:0});
			TweenMax.to(_noCode,0.5,{autoAlpha:0});
			TweenMax.to(_email,0.5,{autoAlpha:0});
			TweenMax.to(_errors,0.5,{autoAlpha:0});
			TweenMax.to(_hasCode,0.5,{autoAlpha:0});
			TweenMax.to(_authCode,0.5,{autoAlpha:0, onComplete:switchToLogin});
		}
		
		private function switchToLogin():void{
			
			_email.minW = 148;
			
			_go.addEventListener(MouseEvent.CLICK,onGo);
			var list:Array = TextManager.getDataListForId("signup_auth_code");
			
			var name:String = list["signup_auth_code"]["copy_"+AppSettings.LOCALE];
			_authCode.text = name;
			_authCode.originalCopy = name;
			_authCode.setNormalState();
			
			_email.text = _email.originalCopy;
			_email.setNormalState();
			
			TweenMax.to(_email,0.5,{autoAlpha:1});
			TweenMax.to(_authCode,0.5,{autoAlpha:1});
			TweenMax.to(_forgotCode,0.5,{autoAlpha:1});
			TweenMax.to(_noCode,0.5,{autoAlpha:1});
			
		}
		
		private function switchToSignUp():void{
			
			_email.minW = 148;
			
			_go.addEventListener(MouseEvent.CLICK,onGo);
			var list:Array = TextManager.getDataListForId("signup_name");
			
			var name:String = list["signup_name"]["copy_"+AppSettings.LOCALE];
			_authCode.text = name;
			_authCode.originalCopy = name;
			_authCode.setNormalState();
			
			_email.text = _email.originalCopy;
			_email.setNormalState();
			
			TweenMax.to(_email,0.5,{autoAlpha:1});
			TweenMax.to(_authCode,0.5,{autoAlpha:1});
			TweenMax.to(_hasCode,0.5,{autoAlpha:1});
			
			
			
			hideAllErrors();
		}
		
		private function onGo(evt:MouseEvent):void{
			if(_noCode.visible == true && _forgotCode.visible == true){ //log in
				validateLogIn();
			}else if(_hasCode.visible == true){ // sign up;
				validateSignUp();
			}else if(_noCode.visible == true && !_forgotCode.visible == true){ // forgot code
				validateForgotCode();
			}
		}
		
		private function validateLogIn():void{
			if( _email.isValidEmail() && _authCode.isValid()){
				
				BackendResponder.login(_email.text,_authCode.text,onLogInSent,onSignUpError);
				_go.removeEventListener(MouseEvent.CLICK,onGo);
			}else{
				showError(1);
			}
		}
		
		private var _emailRecheck:Boolean = false;
		
		private function validateSignUp():void{
			
			if(_authCode.isValid() && _email.isValidEmail()){
				
				if(_emailRecheck == true){
					BackendResponder.signUp(_authCode.text, _email.text,onSignUpSent,onSignUpError);
					_go.removeEventListener(MouseEvent.CLICK,onGo);
				}else{	
					
					_emailRecheck = true;
					showError(2);
				}
			}else{
				
				_emailRecheck = false;
				showError(0);
			}
		}
		
		private function validateForgotCode():void{
			if(_email.isValidEmail()){
				BackendResponder.resendAuth(_email.text,onResendAuthSent,onSignUpError);
				_go.removeEventListener(MouseEvent.CLICK,onGo);
			}else{
				showError(6);
			}
		}
		
		private function showError(num:int,text:String = ""):void{
				hideAllErrors();
				if(num == 5){
					(_errors.getChildAt(5) as TextField).text = text;
				}
				_errors.getChildAt(num).visible = true;
				TweenMax.to(_errors,0.5,{autoAlpha:1});
		}
		
		
		private function onLogInSent(evt:Event,loader:URLLoader):void{
				
			var result:Object = JSON.parse(loader.data);
			
			if(result.hasOwnProperty("success")){
			//	onGoLogin();
			//	showError(3);
				dispatchEvent(new Event(EMAILBAR_SUCCESS));
				return;
			}else if (result.hasOwnProperty("error")){
				if(result.data.message == "user already logged"){
					
					dispatchEvent(new Event(EMAILBAR_SUCCESS));
				}
			//	var txt:TextField = _errors.getChildAt(5) as TextField;
			//	txt.text = result.data.message;
				showError(5,result.data.message);
			}else{
				onSignUpError(evt);
			}
		}
		
		
		private function onSignUpSent(evt:Event,loader:URLLoader):void{
			var result:Object = JSON.parse(loader.data);
			if(result.hasOwnProperty("success")){
				onGoLogin();
				showError(3);
			//	dispatchEvent(new Event(EMAILBAR_SUCCESS));
				return;
			}else if (result.hasOwnProperty("error")){
			//	var txt:TextField = _errors.getChildAt(5) as TextField;
			//	txt.text = result.data.message;
				showError(5,result.data.message);
			}else{
				onSignUpError(evt);
			}
		}
		
		private function onResendAuthSent(evt:Event,loader:URLLoader):void{
			var result:Object = JSON.parse(loader.data);
			if(result.hasOwnProperty("success")){
				onGoLogin();
				showError(3);
				return;
			}else if (result.hasOwnProperty("error")){
				showError(5,result.data.message);
			}else{
				onSignUpError(evt);
			}
		}
		
		private function onSignUpError(evt:Event):void{
			showError(4);
			onError(evt);
		}
		
		private function onError(evt:Event):void{
			Logger.log(Logger.OVERLAY,"ERROR:",evt.toString());
			dispatchEvent(new Event(EMAILBAR_ERROR));
		}
	}
}

package com.refract.prediabets.components.login {
	import com.asual.swfaddress.SWFAddress;
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSections;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.backend.BackendResponder;
	import com.refract.prediabets.components.nav.Nav;
	import com.refract.prediabets.components.shared.LSButton;
	import com.refract.prediabets.components.social.EmailBar;
	import com.refract.prediabets.components.social.ShareBar;
	import com.refract.prediabets.user.UserModel;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class Login extends Sprite {
		
		public static const SIGNUP_ENDED:String = "SIGNUP_ENDED";
		public static const SIGNUP_SUCCESS:String = "SIGNUP_SUCCESS";
		
		private var _isSignUp:Boolean = false;
		public function get isSignUp():Boolean { return _isSignUp; }
		
		private var _bkg:Bitmap;
		
		private var _navButton:LSButton;
		
		private var _socialContainer:ShareBar;
		private var _emailContainer:EmailBar;
		private var _resultContainer:Sprite;
		
		public function Login() {
			_isSignUp = "SECTION:"+SWFAddress.getPathNames()[0] == AppSections.SIGN_UP;
			
			AppSettings.checkFSStatus();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);	
			stage.addEventListener(Event.RESIZE,onResize);
			addBkg();
			//if(_isSignUp){
				addSkip();
		//	}
			addSocial();
			addEmail();
			addResult();
			onResize();
			
			//endSignUp() ; 
			//setTimeout( endSignUp, 10 ) ; 
		}
		
		protected function addBkg():void{
			_bkg = AssetManager.getEmbeddedAsset("BKG");
			_bkg.smoothing = true;
			_bkg.alpha = 0.2;
		//	addChild(_bkg);
		}
		
		protected function addSkip():void{
			_navButton = new LSButton("signup_skip",{fontSize:36},191,70,true,false);
			_navButton.buttonAlpha = 0.1;
			addChild(_navButton);
			_navButton.addEventListener(MouseEvent.CLICK, endSignUp);
			_navButton.visible = isSignUp;
		}

		protected function addSocial():void{
			_socialContainer = new ShareBar("signup_title","signup_subheading");
			addChild(_socialContainer);
			
			_socialContainer.facebook.addEventListener(MouseEvent.CLICK, onSocialClick);
			_socialContainer.twitter.addEventListener(MouseEvent.CLICK, onSocialClick);
			_socialContainer.google.addEventListener(MouseEvent.CLICK, onSocialClick);
		}

		private function onSocialClick(evt:MouseEvent):void{
			var social:String = "";
			switch(evt.currentTarget){
				case(_socialContainer.facebook):
					social = "facebook";
				break;
				case(_socialContainer.twitter):
					social = "twitter";
					stage.addEventListener(Event.DEACTIVATE,onWindowOut);
				break;
				case(_socialContainer.google):
					social = "google";
					stage.addEventListener(Event.DEACTIVATE,onWindowOut);
				break;
			}
			if(stage.displayState != StageDisplayState.NORMAL){
				stage.displayState = StageDisplayState.NORMAL;
			}
			BackendResponder.loginViaSocial(social,onSocialComplete,onSocialFauxPas);
		}
		
		private function onSocialComplete(data:Object):void{
			dealWithData(data);
		}
		
		private function onSocialFauxPas(evt:Event):void{
			
			switchUI(false);
		}

		private function onWindowOut(evt:Event):void{
			stage.removeEventListener(Event.DEACTIVATE,onWindowOut);
			stage.addEventListener(Event.ACTIVATE,onWindowReturn);
		}

		private function onWindowReturn(evt:Event):void{
			stage.removeEventListener(Event.ACTIVATE,onWindowReturn);
			
			BackendResponder.getUserData(onUserData,onSocialFauxPas);
		}
		
		private function onUserData(evt:Event,loader:URLLoader):void{
			stage.removeEventListener(Event.ACTIVATE,onWindowReturn);
			
			var dat:Object = JSON.parse(loader.data);
			dealWithData(dat);
		}
		
		private function dealWithData(data:Object):void{
			if(data.hasOwnProperty("success")){
				UserModel.setUserData(data);
				switchUI(true);
			}else{
				switchUI(false);
			}
		}

		protected function addEmail():void{
			_emailContainer = new EmailBar(_socialContainer.barWidth);
			addChild(_emailContainer);
			_emailContainer.addEventListener(EmailBar.EMAILBAR_ERROR, onEmailError);
			_emailContainer.addEventListener(EmailBar.EMAILBAR_SUCCESS, onEmailSuccess);
		}

		private function onEmailError(evt:Event):void{
			
		}
		
		private function onEmailSuccess(evt:Event):void{
			onWindowReturn(evt);
		}

		protected function addResult():void{
			_resultContainer = new Sprite();
			addChild(_resultContainer);
			_resultContainer.visible = false;
			_resultContainer.alpha = 0;
			var tf:TextField = TextManager.makeText("signup_success_message",_resultContainer,{fontSize:16});
			tf.x = -tf.width/2;
			tf = TextManager.makeText("signup_error_message",_resultContainer,{fontSize:16});
			tf.x = -tf.width/2;
		}

		protected function endSignUp(evt:Event = null ) : void {
			_navButton.removeEventListener(MouseEvent.CLICK, endSignUp);
			
			trace('SKIP')
			if(_isSignUp)
				DispatchManager.dispatchEvent(new Event(SIGNUP_ENDED));
			else
				DispatchManager.dispatchEvent(new Event(Nav.CLOSE_OVERLAY));
		}

		private function switchUI(isGood:Boolean):void{
			if(isGood){
				_resultContainer.getChildAt(0).visible = true;
				_resultContainer.getChildAt(1).visible = false;
			}else{
				_resultContainer.getChildAt(0).visible = false;
				_resultContainer.getChildAt(1).visible = true;
			}
			
			TweenMax.to(_socialContainer,0.5,{autoAlpha:0});
			TweenMax.to(_emailContainer,0.5,{autoAlpha:0});
			TweenMax.to(_resultContainer,0.5,{autoAlpha:1});
			
			
			TweenMax.to(_navButton,0.5,{autoAlpha:0,onComplete:switchNavBtn});	
			
			onResize();
		}

		private function switchNavBtn():void{
			_navButton.text = TextManager.getDataListForId("signup_continue")["signup_continue"]["copy_"+AppSettings.LOCALE];
			onResize();
			
			TweenMax.to(_navButton,0.5,{autoAlpha:1});
		}
		
		protected function onResize(evt:Event = null):void{
			
	//		graphics.clear();
	//		graphics.beginFill(0x000000,1);
	//		graphics.drawRect(0,0,AppSettings.VIDEO_WIDTH,AppSettings.VIDEO_HEIGHT);
			
			_socialContainer.x = AppSettings.VIDEO_WIDTH/2;
			_socialContainer.y = AppSettings.VIDEO_HEIGHT/2 -_socialContainer.height;
			_emailContainer.x = AppSettings.VIDEO_WIDTH/2 - _emailContainer.width/2;
			_emailContainer.y = _socialContainer.height + _socialContainer.y + 32;
			_resultContainer.x = AppSettings.VIDEO_WIDTH/2;
			_resultContainer.y = AppSettings.VIDEO_HEIGHT/2 - _resultContainer.height;
			
			_navButton.x = AppSettings.VIDEO_WIDTH/2 - _navButton.width/2;
			_navButton.y = _emailContainer.height + _emailContainer.y + 12;
				
			
			
			_bkg.width = AppSettings.VIDEO_WIDTH;
			_bkg.height = AppSettings.VIDEO_HEIGHT;
			this.x = AppSettings.VIDEO_LEFT;
			this.y = AppSettings.VIDEO_TOP;
		}
		
		public function destroy():void{
			stage.removeEventListener(Event.ACTIVATE,onWindowReturn);
			stage.removeEventListener(Event.DEACTIVATE,onWindowOut);
			
			_navButton.destroy();
			_navButton.removeEventListener(MouseEvent.CLICK, endSignUp);
			_navButton = null;
			
			removeChildren();
			_bkg = null;
			stage.removeEventListener(Event.RESIZE, onResize);
			
		}
	}
}

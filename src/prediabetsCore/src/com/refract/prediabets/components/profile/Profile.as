package com.refract.prediabets.components.profile {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.ClassFactory;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.user.UserModel;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class Profile extends Sprite {
		
		protected var _buttons:Array;
		
		protected var _header:Sprite;
		
		protected var _name:Sprite;
		protected var _email:Sprite;
		protected var _code:Sprite;
		
		public function Profile() {
			
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		protected function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			_buttons = [];
			var button:ProfileButton;
			for (var i:int = 0; i < 3; ++i){
				button = new ClassFactory.PROFILE_BUTTON(i+1);
				_buttons[i] = button;
				button.state = UserModel.getModuleStats(button.id).unlocked ? ProfileButton.UNLOCKED : ProfileButton.LOCKED;
				addChild(_buttons[i]);
			}
			
			_header = new Sprite();
			if(UserModel.isLoggedIn){
				addChild(_header);
				_header.y = 15;
				
				_name = new Sprite();
				_header.addChild(_name);
				
				var tf:TextField = TextManager.makeText("page_profile_name",_name,{fontSize:24});
			//	tf.x = 20;
			//	tf.y = 35 - tf.height/2;
				var lastTF:TextField = tf;
				
				tf =  TextManager.makeText("page_profile_data",_name,{fontSize:24});
				tf.text = UserModel.getUserInfo().name;
				tf.x = lastTF.x + lastTF.width;
		//		tf.y = lastTF.y;
				lastTF = tf;
				
				_email = new Sprite();
				_header.addChild(_email);
				
				
				tf = TextManager.makeText("page_profile_email",_email,{fontSize:24});
				lastTF = tf;
				
				
				tf =  TextManager.makeText("page_profile_data",_email,{fontSize:24});
				tf.text = UserModel.getUserInfo().email;
				tf.x = lastTF.x + lastTF.width;
		//		tf.y = lastTF.y;
				lastTF = tf;
				
				_code = new Sprite();
				_header.addChild(_code);
				
				tf = TextManager.makeText("page_profile_passcode",_code,{fontSize:24});
				lastTF = tf;
				
				tf =  TextManager.makeText("page_profile_data",_code,{fontSize:24});
				tf.text = UserModel.getUserInfo().authCode;
				tf.x = lastTF.x + lastTF.width;
		//		tf.y = lastTF.y;
				lastTF = tf;
				
				_name.y = 35 - _name.height/2;
				_email.y = 35 - _email.height/2;
				_code.y = 35 - _code.height/2;
			}
			
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}

		protected function onResize(evt : Event = null) : void {
			if(contains(_header)){
				_header.graphics.clear();
				_header.graphics.beginFill(AppSettings.WHITE,0.25);
				_header.graphics.drawRect(0,0,AppSettings.VIDEO_WIDTH,70);
				
				_name.x = 20;
				_email.x = _buttons[1].x + 10;
				_code.x = _buttons[2].x + 10;
				
			}
			this.x = AppSettings.VIDEO_LEFT;
			this.y = AppSettings.VIDEO_TOP;
		}
		
		public function destroy():void{
			if(contains(_header)){
				_name.removeChildren();
				_email.removeChildren();
				_code.removeChildren();
				_header.removeChildren();
				
			}
			for (var i:int = 0,len:int = _buttons.length; i < len; ++i){
				_buttons[i].destroy();
			}
			removeChildren();
			
			stage.removeEventListener(Event.RESIZE,onResize);
		}
	}
}

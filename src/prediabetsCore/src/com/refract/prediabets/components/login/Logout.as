package com.refract.prediabets.components.login {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.backend.BackendResponder;
	import com.refract.prediabets.components.nav.Nav;
	import com.refract.prediabets.components.shared.LSButton;
	import com.refract.prediabets.user.UserModel;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class Logout extends Sprite {
		
		private static const USER_LOGGED_OUT:String = "USER_LOGGED_OUT";
		
		private var _title:TextField;
		private var _subTitle:TextField;
		private var _yes:LSButton;
		private var _no:LSButton;
		
		public function Logout() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_title = TextManager.makeText('logout_title',this,{fontSize:72});
			_subTitle = TextManager.makeText('logout_are_you_sure',this,{fontSize:16});
			
			_title.x = -_title.width/2;
			_subTitle.x = -_subTitle.width/2;
			_subTitle.y = _title.y + _title.height + 20;
			
			_yes = new LSButton("logout_yes",{fontSize:24},140,54,true,false);
			_no = new LSButton("logout_no",{fontSize:24},140,54,true,false);
			addChild(_yes);
			addChild(_no);
			
			_yes.y = _no.y = _subTitle.y + _subTitle.height + 20;
			_yes.x = -_yes.width - 10;
			_no.x = 10;
			
			_yes.addEventListener(MouseEvent.CLICK,onYes);
			_no.addEventListener(MouseEvent.CLICK,onNo);
			
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}

		private function onNo(evt : MouseEvent) : void {
			close();
		}

		private function onYes(evt : MouseEvent) : void {
			BackendResponder.logout(onLoggedOut,onError);
		}

		private function onError(evt:Event) : void {
			
			close();
		}
		
		private function onLoggedOut(evt:Event, loader:URLLoader):void{
		//	UserModel.reset();
			DispatchManager.dispatchEvent(new Event(UserModel.USER_LOGGED_OUT));
			close();
		}
		
		private function close():void{
			DispatchManager.dispatchEvent(new Event(Nav.CLOSE_OVERLAY));
		}
		
		private function onResize(evt:Event = null):void{
			
			
			
			this.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;
			this.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - this.height/2;
		}
		
		public function destroy():void{
			
			_yes.destroy();
			_no.destroy();
			_yes.removeEventListener(MouseEvent.CLICK,onYes);
			_no.removeEventListener(MouseEvent.CLICK,onNo);
			_yes = null;
			_no = null;
			
			removeChildren();
			stage.removeEventListener(Event.RESIZE, onResize);
			
		}
	}
}

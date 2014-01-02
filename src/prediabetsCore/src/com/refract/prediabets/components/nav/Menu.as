package com.refract.prediabets.components.nav {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.ClassFactory;
	import com.refract.prediabets.components.events.MenuEvent;
	import com.refract.prediabets.components.nav.menu.MenuButton;
	import com.refract.prediabets.stateMachine.events.StateEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.refract.prediabets.user.UserModel;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * @author kanish
	 */
	public class Menu extends Sprite {
		
		protected static const SHOWTIME:Number = 0.5;
		protected static const SHOWTIME_DELAY:Number = SHOWTIME/4;
		
		protected var _shown : Boolean = false;
		public function get shown() : Boolean { return _shown; }
		
		
		
		public function Menu() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			var sp:MenuButton;
			for(var i:int = 0; i < 4; ++i){
				addChild(sp = new ClassFactory.MENU_BUTTON(String(i+1),this));
				sp.x = sp.width*i ;//+ i;
				if(sp.enabled) sp.addEventListener(MouseEvent.CLICK,onClick);
				sp.mouseEnabled = false;
			}
			
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}
		
		public function refreshMenuLocks():void{
			destroy();
			init();
		}
		
		public function show():void{
			resetButtonVideos();
			DispatchManager.dispatchEvent(new Event(MenuEvent.MENU_SHOW));
			_shown = true;
			DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndMenuUp") );	
			for(var i:int = 0; i < 4; ++i){
				TweenMax.killTweensOf(getChildAt(i));
				TweenMax.to(getChildAt(i),SHOWTIME,{y: - MenuButton(getChildAt(0)).bkgHeight,delay:i*SHOWTIME_DELAY,onComplete:checkLockedState,onCompleteParams:[getChildAt(i)]});
				MenuButton(getChildAt(i)).mouseEnabled = true;
				MenuButton(getChildAt(i)).resetState();
			}
		}
		
		public function hide():void{
			_shown = false;
			DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndMenuDown") );	
			var _onComplete:Function = null;
			for(var i:int = 0; i < 4; ++i){
				TweenMax.killTweensOf(getChildAt(i));
				TweenMax.killChildTweensOf(getChildAt(i) as MenuButton);
			//	_onComplete = (i < 3) ? null : resetButtonVideos;	
				TweenMax.to(getChildAt(i),SHOWTIME,{y:0,delay:(3-i)*SHOWTIME_DELAY,onComplete:_onComplete,canBePaused:false});
				MenuButton(getChildAt(i)).mouseEnabled = false;
			}
			DispatchManager.dispatchEvent(new Event(MenuEvent.MENU_HIDE));
			
		}
		
		protected function checkLockedState(btn:MenuButton):void{
		
			if(!btn.enabled && UserModel.getModuleStats(int(btn.type)).unlocked){
				btn.unlock();
				btn.addEventListener(MouseEvent.CLICK,onClick);
			}
		}
		
		protected function resetButtonVideos():void{
			for(var i:int = 0; i < 4; ++i){
				MenuButton(getChildAt(i)).resetVideo();
			}
			stage.dispatchEvent(new Event(Event.RESIZE));
		}
		
		protected function drawBlack():void{
			return;
			graphics.clear();
			graphics.beginFill(0x000000,1);
			graphics.drawRect(0, 0, width+1, MenuButton(getChildAt(0)).bkgHeight);
		}
		
		protected function onClick(evt:MouseEvent):void{
			var type:int = int((evt.currentTarget as MenuButton).type);
			if(UserModel.getModuleStats(type).isDownloaded)
			{
				trace("::Menu:: -a-")
				DispatchManager.dispatchEvent(new MenuEvent(MenuEvent.MENU_SELECTED,type));
			}
			else
			{
				trace("::Menu:: -b-")
			//	(evt.currentTarget as MenuButton).listenForDownload();
				DispatchManager.dispatchEvent(new MenuEvent(MenuEvent.MENU_LOAD_MODULE,type));
			}
		}
		
		
		protected function onResize(evt:Event = null):void{
			drawBlack();
			//this.y = _shown ? AppSettings.VIDEO_BOTTOM  - MenuButton(getChildAt(0)).bkgHeight : AppSettings.VIDEO_BOTTOM ;
			
			this.y = AppSettings.VIDEO_BOTTOM;
			this.x = AppSettings.VIDEO_LEFT;
		}
		
		public function destroy():void{
			stage.removeEventListener(Event.RESIZE,onResize);
			for(var i:int = 0; i < 4; ++i){
				MenuButton(getChildAt(i)).destroy();
				getChildAt(i).removeEventListener(MouseEvent.CLICK,onClick);
			}
			removeChildren();
		}

	}
}

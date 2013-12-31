package com.refract.air.shared.components.nav.filmsmenu {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.components.events.MenuEvent;
	import com.refract.prediabets.components.nav.Menu;
	import com.refract.prediabets.components.nav.menu.MenuButton;
	import com.refract.prediabets.stateMachine.events.StateEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.refract.prediabets.user.UserModel;
	import com.robot.comm.DispatchManager;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;

	/**
	 * @author kanish
	 */
	public class FilmsMenu extends Menu {
		
		private var _location:int = 0;
		private const _totalLocations:int = 3;
		
		private var _msk:Shape;
		
		public function FilmsMenu() {
			super();
		}
		
		override protected function init(evt:Event = null):void{
			
			_msk = new Shape();
			parent.addChild(_msk);
			this.mask = _msk;
			
			super.init(evt);
			var sp:FilmsMenuButton;
			for(var i:int = 0; i < 4; ++i){
				sp = getChildAt(i) as FilmsMenuButton;
				//sp.removeEventListener(MouseEvent.CLICK,onClick);
				sp.start.addEventListener(MouseEvent.CLICK,onClick);
			}
			
			
			_location = 0;
			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe);
		}
		
		override protected function onClick(evt:MouseEvent):void{
			var type:int = int((evt.currentTarget.parent.parent as MenuButton).type);
//			if(UserModel.getModuleStats(type).isDownloaded || true){ //cheat to ignore download - not for production
			if(UserModel.getModuleStats(type).isDownloaded){		 // use this line in production
				DispatchManager.dispatchEvent(new MenuEvent(MenuEvent.MENU_SELECTED,type));
			}else{
			//	(evt.currentTarget as MenuButton).listenForDownload();
				DispatchManager.dispatchEvent(new MenuEvent(MenuEvent.MENU_LOAD_MODULE,type));
			}
		}
		
		override protected function onResize(evt:Event = null):void{
			super.onResize(evt);
			
			_msk.graphics.clear();
			_msk.graphics.beginFill(0xff,1);
			_msk.graphics.drawRect(0,0,AppSettings.VIDEO_WIDTH,AppSettings.VIDEO_HEIGHT);
			_msk.x = AppSettings.VIDEO_LEFT;
			_msk.y = AppSettings.VIDEO_TOP;
		}
		
		override public function show():void{
			if(!_shown){
				_shown = true;
			//	DispatchManager.dispatchEvent(new Event(MenuEvent.MENU_SHOW));
				dispatchEvent(new Event(MenuEvent.MENU_SHOW));
				DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndMenuUp") );
				TweenMax.killTweensOf(this);
				TweenMax.to(this,0.5,{y:AppSettings.VIDEO_TOP});
				this.mouseEnabled = true;
				this.mouseChildren = true;
				/*for(var i:int = 0; i < 4; ++i){
					TweenMax.killTweensOf(getChildAt(i));
					TweenMax.to(getChildAt(i),SHOWTIME,{y: - MenuButton(getChildAt(0)).bkgHeight});
					MenuButton(getChildAt(i)).mouseEnabled = true;
					MenuButton(getChildAt(i)).resetState();
				}*/
			}
		}
		
		override public function hide():void{
			if(_shown){
				_shown = false;
				DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndMenuDown") );	
				TweenMax.killTweensOf(this);
				TweenMax.to(this,0.5,{y:AppSettings.VIDEO_BOTTOM,onComplete:resetButtonVideos});
				this.mouseEnabled = false;
				this.mouseChildren = false;
			/*	var _onComplete:Function;
				for(var i:int = 0; i < 4; ++i){
					TweenMax.killTweensOf(getChildAt(i));
					TweenMax.killChildTweensOf(getChildAt(i) as MenuButton);
					_onComplete = (i < 3) ? null : resetButtonVideos;	
					TweenMax.to(getChildAt(i),SHOWTIME,{y:0,onComplete:_onComplete,canBePaused:false});
					MenuButton(getChildAt(i)).mouseEnabled = false;
				}*/
			//	DispatchManager.dispatchEvent(new Event(MenuEvent.MENU_HIDE));
				dispatchEvent(new Event(MenuEvent.MENU_HIDE));
			}
		}
		
		
		
		private function onSwipe(evt:TransformGestureEvent):void{
			var over:Boolean = false;
			if(evt.offsetX == 1){ // left to right
				if(x < AppSettings.VIDEO_LEFT){
					_location--;
				}else{
					over = true;
					_location = 0;
				}
			}else if(evt.offsetX == -1){ // right to left
				if(x > AppSettings.VIDEO_LEFT -(getChildAt(0).width*(_totalLocations+1) - AppSettings.VIDEO_WIDTH)){
					_location++;
				}else{
					over = true;
					_location = _totalLocations;
				}
			}
			_location = _location < 0 ? 0 : _location > _totalLocations ? _totalLocations : _location;
			if(over){
				if(_location == 0){
					this.x = 0;
					TweenMax.to( this, 0.2,{x: 30, repeat:1,yoyo:true});
				}else{
					this.x = AppSettings.VIDEO_RIGHT- getChildAt(0).width*(_totalLocations+1);
					TweenMax.to( this, 0.2,{x: AppSettings.VIDEO_RIGHT- getChildAt(0).width*(_totalLocations+1) - 30, repeat:1,yoyo:true});
				}
			}else{
				if(_location < _totalLocations){
					TweenMax.to(this,0.5,{x:AppSettings.VIDEO_LEFT - getChildAt(0).width*_location});
				}else{
					TweenMax.to(this,0.5,{x:AppSettings.VIDEO_RIGHT- getChildAt(0).width*(_totalLocations+1)});
				}
			}
		}
		
		override public function destroy():void{
			parent.removeChild(_msk);
			_msk.graphics.clear();
			_msk = null;
			
			stage.removeEventListener(TransformGestureEvent.GESTURE_SWIPE,onSwipe);
			super.destroy();
		}
	}
}

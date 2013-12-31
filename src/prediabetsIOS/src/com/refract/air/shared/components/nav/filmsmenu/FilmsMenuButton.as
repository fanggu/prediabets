package com.refract.air.shared.components.nav.filmsmenu {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.components.nav.Menu;
	import com.refract.prediabets.components.nav.menu.LoadedMenuButton;
	import com.refract.prediabets.components.shared.LSButton;

	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class FilmsMenuButton extends LoadedMenuButton {
		
		public function get start():LSButton { return _start; }
		
		public function FilmsMenuButton(type : String, menu : Menu) {
			BKG_ALPHA = 1;
			super(type, menu);
		}
		
		override protected function setProperties():void{
			super.setProperties();
			mouseChildren = true;
		}
		
		
		override protected function onResize(evt : Event = null) : void {
			_bkgBmp.height = AppSettings.VIDEO_HEIGHT;
			_bkgBmp.scaleX = _bkgBmp.scaleY;
			
			
			if(_start){
			//	_label.removeChild(_start);
				_start.minW = _bkgBmp.width - 63;
				_start.y = _start.height + 10;
			//	_start.y = _label.height + 10;
			//	_label.addChild(_start);
			}
			
			_label.x = 28;
			_label.y = _bkgBmp.height - 10 - _label.height;
			
			
			graphics.clear();
			graphics.beginFill(0x0,1);
			graphics.drawRect(0,0,_bkgBmp.width+1,_bkgBmp.height);
			
			this.x = (_pos)*(this._bkgBmp.width + 1);
		}
	}
}

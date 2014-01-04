package com.refract.prediabets.nav.events {
	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class MenuEvent extends Event {
		public static const MENU_LOAD_MODULE:String = "MENU_LOAD_MODULE";
		public static const MENU_LOAD_ERROR:String = "MENU_LOAD_ERROR";
		public static const MENU_SELECTED:String = "MENU_SELECTED";
		public static const MENU_HIDE:String = "MENU_HIDE";
		public static const MENU_SHOW:String = "MENU_SHOW";
		
		private var _menuItem:int;
		public function get menuItem():int{ return _menuItem; }
		
		public function MenuEvent(type : String, menuItem:int = 1, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			_menuItem = menuItem;
		}
	}
}

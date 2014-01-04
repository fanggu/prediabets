package com.refract.prediabets.nav.events {
	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class FooterEvent extends Event {
		
		public static const FLASH_FOOTER:String = "FLASH_FOOTER";
		public static const FOOTER_CLICKED:String = "FOOTER_CLICKED";
		public static const ADD_FOOTER_ITEM:String = "ADD_FOOTER_ITEM";
		public static const REMOVE_FOOTER_ITEM:String = "REMOVE_FOOTER_ITEM";
		public static const HIGHLIGHT_BUTTON : String = "HIGHLIGHT_BUTTON";
		
		public static const TOP_LEFT:String = "TOP_LEFT";
		public static const TOP_MIDDLE:String = "TOP_MIDDLE";
		public static const TOP_RIGHT:String = "TOP_RIGHT";
		public static const BOTTOM_LEFT:String = "BOTTOM_LEFT";
		public static const BOTTOM_MIDDLE:String = "BOTTOM_MIDDLE";
		public static const BOTTOM_RIGHT : String = "BOTTOM_RIGHT";
		
		
		private var _info:Object;
		public function get info():Object{ return _info; }
		
		public function FooterEvent(type : String, info:Object , bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			_info = info;
		}
	}
}

package com.refract.prediabetes.nav.events {
	import flash.events.Event;

	public class FooterEvent extends Event {
		
		public static const FOOTER_CLICKED:String = "FOOTER_CLICKED";
		public static const HIGHLIGHT_BUTTON : String = "HIGHLIGHT_BUTTON";

		private var _info:Object;
		public function get info():Object{ return _info; }
		
		public function FooterEvent(type : String, info:Object , bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			_info = info;
		}
	}
}

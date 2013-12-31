package com.refract.prediabets.components.events {
	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class IntroEvent extends Event {
		
		public static const INTRO_ENDED:String = "INTRO_ENDED";
		
		private var _video:String;
		public function get video():String {return _video;}
		
		public function IntroEvent(type : String, video:String,bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			_video = video;
		}
	}
}

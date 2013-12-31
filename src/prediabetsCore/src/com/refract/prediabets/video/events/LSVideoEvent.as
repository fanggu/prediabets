package com.refract.prediabets.video.events {
	import flash.events.Event;
	


	/**
	 * @author kanish
	 */
	public class LSVideoEvent extends Event {
		
		public static const VIDEO_READY:String = "VIDEO_READY";
		public static const CHECK_STORAGE:String = "CHECK_STORAGE";
		public static const LOAD_FROM_STORAGE:String = "LOAD_FROM_STORAGE";
		public static const STREAM_VIDEO_ONLY:String = "STREAM_VIDEO_ONLY";
		public static const STREAM_VIDEO_AND_STORE:String = "STREAM_VIDEO_AND_STORE";
		public static const DOWNLOAD_AND_STORE_VIDEO:String = "DOWNLOAD_AND_STORE_VIDEO";
		
		private var _url:String; public function get url():String{return _url;}
		
		public function LSVideoEvent(type : String, url:String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			_url = url;
		}
	}
}

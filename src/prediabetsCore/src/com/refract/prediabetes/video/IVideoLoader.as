package com.refract.prediabetes.video {
	import flash.media.Video;
	/**
	 * @author kanish
	 */
	public interface IVideoLoader {
		
		function checkStorageforVideo(filename:String):void;
		
		function loadVideoFromStorage(filename:String,callback:Function):void;
		
		function preloadAndStoreVideo(filename:String,callback:Function):void;
		
		function streamVideo(filename:String,callback:Function):void;
		
		function streamAndStoreVideo(filename:String,callback:Function):void;
		
		
		
	}
}

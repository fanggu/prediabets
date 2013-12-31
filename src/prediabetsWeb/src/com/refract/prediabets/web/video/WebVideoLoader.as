package com.refract.prediabets.web.video {
	import com.refract.prediabets.video.VideoLoader;

	/**
	 * @author kanish
	 */
	public class WebVideoLoader extends VideoLoader {
		public function WebVideoLoader() {
			VIDEO_BASE_URL = "video/flv/";
			super();
		}
	}
}

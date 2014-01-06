package com.refract.prediabets.web.video {
	import com.refract.prediabetes.video.VideoLoader;
	public class WebVideoLoader extends VideoLoader 
	{
		public function WebVideoLoader() 
		{
			VIDEO_BASE_URL = "video/flv/";
			super();
		}
	}
}

package com.refract.air.shared {
	import com.refract.prediabetes.AppSettings;
	public class AppSettingsIOS {
		
		public static var RESERVED_FOOTER_HEIGH_RETINA  			: int = 210 ; 
		public static var RESERVED_HEADER_HEIGH_RETINA 				: int = 202 ; 
		public static var RESERVED_FOOTER_HEIGH_NO_RETINA 			: int = 105 ; 
		public static var RESERVED_HEADER_HEIGH_NO_RETINA 			: int = 101 ; 
		public static var TOP_HEIGHT_BAR				  			: int = 38 ; 
		public static var TOP_HEIGHT_BAR_RETINA				  		: int = 17 ; 
		public static var TOP_HEIGHT_BAR_NO_RETINA				  	: int = 238 ; 
		public static const LOGO_RETINA_ADDRESS 					: String = 'LogoRetina' ; 
		
		public static var VIDEO_NAV_SIDE_RETINA 					: int = AppSettings.VIDEO_NAV_SIDE * 2; 
		public static var VIDEO_NAV_HEIGHT_RETINA 					: int = AppSettings.VIDEO_NAV_HEIGHT * 2 ;
		public static var VIDEO_NAV_PROGRESS_BAR_HEIGHT_NO_RETINA 	: int = AppSettings.VIDEO_NAV_PROGRESS_BAR_HEIGHT / 2; 
		
		public static function checkWifiAvailable():Boolean
		{
			
		//	var interfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
			
			
			return false;
		}
	}
}

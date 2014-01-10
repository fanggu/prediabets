package com.refract.prediabetes.logger {
	import com.refract.prediabetes.AppSettings;

	public class Logger {
		
		public static const PRELOADER:String = "PRELOADER";
		
		public static const GENERAL:String = "GENERAL";
		public static const FILE_LOADING:String = "FILE_LOADING";
		public static const BACKEND:String = "BACKEND";
		public static const NAV:String = "NAV";
		
		public static const VIDEO:String = "VIDEO";
		public static const SCORING:String = "SCORING";
		public static const STATE_MACHINE:String = "STATE_MACHINE";
		public static const SWF_ADDRESS:String = "SWF_ADDRESS";
		public static const TEXT : String = "TEXT";
		public static const OVERLAY : String = "OVERLAY";
		
		public static const GYRO:String = "GYRO";
		
//		private static const enabledSections:Array = [];
	
		private static const enabledSections:Array = [
														BACKEND,
														FILE_LOADING,
														SWF_ADDRESS,
														STATE_MACHINE
													  ];	
		
		private static var _i : Logger;
		
		public static function get i():Logger { 
			if(!_i){
				_i = new Logger();
			}
			return _i;
		}
		
		public static function log(section:String,str:*,...rest):void{
			i.log(section,str,rest);
		}
		
		public static function general(str:*,...rest):void{
			i.log(GENERAL,str,rest);
		}
		
		private function log(section:String,str:*,rest:Array):void{
			if(AppSettings.DEBUG && enabledSections.indexOf(section) != -1){
				if(rest){
					trace(section+":",str,rest.join(" "));
				}else{
					trace(section+":",str);	
				}
			}
		}
	}
}

package com.refract.air.shared.data {
	import flash.net.SharedObject;
	/**
	 * @author kanish
	 */
	public class StoredData {
		
		public function StoredData(){}
		
		public static const APP_ID:String = "PrediabetesApp";
		
		private static var _so:SharedObject;
		public static function get so():SharedObject{
			if(!_so){
				_so = SharedObject.getLocal(APP_ID);
				SharedObject.preventBackup = true;
			}
			return _so;
		}
		
		
		private static var INITIALIZED:Boolean = init();
		
		public static function init():Boolean{
			SharedObject.preventBackup = true;
			return true;
		}
		
		
		public static function getData(key:String):Object{
		//	return so.hasOwnProperty("key") ? so[key] : null;	
			return so.data[key];
		}
		
		public static function setData(key:String,data:Object):void{
		//	so.setProperty(propertyName)
		//	so[key] = data;	
			so.data[key] = data;
			so.flush();
		}
		
	}
}

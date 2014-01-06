package com.refract.prediabetes.assets {
	import br.com.stimuli.loading.BulkLoader;

	import flash.display.MovieClip;
	/**
	 * @author kanish
	 */
	public class AssetManager {
	
		/*
		 * 
		 * STATIC
		 * 
		 */
	
	
		public static const DefaultLoader:String = "DefaultCoreLoader";
		
		public static function getAsset(url:String,clearMemory:Boolean = false):*{
			return i.getAsset(url,clearMemory);
		}
		
		public static function hasEmbeddedAsset(className:String):Boolean{
			return i.hasEmbeddedAsset(className);
		}
		
		public  static function getEmbeddedAsset(className:String):*{
			return i.getEmbeddedAsset(className);
		}
		
		public static function getImage(url:String,clearMemory:Boolean = false):*{
			i.getImage(url,clearMemory);
			return null;
		}
		
		public static function addLoad(url:String,options:Object = null):void{
			i.addLoad(url,options);
		}
		
		private static var _i:AssetManager;
		public static function get i():AssetManager{ if(!_i){ _i = new AssetManager(); } return _i; }
		public static function set i(am:AssetManager):void { _i = am; }
		
		
		
		
		/*
		 * 
		 * INSTANCE
		 * 
		 */
		
		
		
		private var _bulk:BulkLoader;
		private var _assets:AssetManagerEmbeds;
		
		public function AssetManager(){
			_assets = new AssetManagerEmbeds();
			_bulk = new BulkLoader(DefaultLoader);
		}
		
		protected function addLoad(url:String,options:Object = null):void{
			_bulk.add(url,options);
		}
		
		protected function getAsset(url:String,clearMemory:Boolean = false):*{
			_bulk.getContent(url,clearMemory);
			return null;
		}
		
		protected function getImage(url:String,clearMemory:Boolean = false):*{
			_bulk.getBitmap(url,clearMemory);
			return null;
		}
		
		protected function getEmbeddedAsset(className:String):*{
		//	return new _assets[className]();
			if(_assets.getClass(className) != null){
				return new (_assets.getClass(className))();
			}else{
				return null;
			}
		}
		
		protected function hasEmbeddedAsset(className:String):Boolean{
			return _assets.getClass(className) != null;
		}
		
		
	}
}

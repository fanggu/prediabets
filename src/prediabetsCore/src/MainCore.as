package {
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.ClassFactory;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.FontManager;
	import com.refract.prediabets.assets.TextManager;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 * @author robertocascavilla
	 */
	public class MainCore extends Sprite 
	{	
		public function MainCore() 
		{
			new FontManager();
			addEventListener( Event.ADDED_TO_STAGE , init ) ; 
		}
		
		private function init(  evt : Event ) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			AppSettings.stage = stage ; 
			
			
			stage.align = StageAlign.TOP_LEFT; 
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//SoundMixer.soundTransform = new SoundTransform(0);
	
			var bytes : ByteArray = AssetManager.getEmbeddedAsset("CopyJSON") as ByteArray;
			TextManager.parseData(bytes.readUTFBytes(bytes.length));
			 
			trace('DEVICE :' , AppSettings.DEVICE ) 
			startApp() ; 
		}

		private function startApp():void{
			 var appController : AppController = new ClassFactory.APP_CONTROLLER( this );
			 appController.init( ) ; 
		}
	}
}

package {
	import com.flashdynamix.utils.SWFProfiler;
	import com.refract.prediabetes.AppController;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.FontManager;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.tracking.TrackingInteractive;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	//import com.refract.prediabetes.tracking.Tracking;


	[SWF( backgroundColor='#000000', frameRate='60')]
	public class PrediabetesCore extends Sprite 
	{	
		public function PrediabetesCore() 
		{
			new FontManager();
			addEventListener( Event.ADDED_TO_STAGE , init ) ; 
			
		}

		private function init(  evt : Event ) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			SWFProfiler.init(stage, this);
			AppSettings.stage = stage ; 
			
			
			stage.align = StageAlign.TOP_LEFT; 
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//SoundMixer.soundTransform = new SoundTransform(0);
	
			var bytes : ByteArray = AssetManager.getEmbeddedAsset("CopyJSON") as ByteArray;
			TextManager.parseData(bytes.readUTFBytes(bytes.length));
			
			//AppSettings.RETINA = false ; 
			startApp() ; 
		}

		private function startApp():void{
			 var appController : AppController = new ClassFactory.APP_CONTROLLER( this );
			 appController.init( ) ; 
		}
	}
}

package {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.ClassFactory;
	import com.refract.prediabets.web.video.WebVideoLoader;

	import flash.display.Sprite;
	import flash.events.Event;

	
//	[SWF(width='1280', height='800', backgroundColor='#000000', frameRate='25')]

	/**
	 * @author robertocascavilla
	 */
	public class MainWeb extends Sprite {
		
		public function MainWeb() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onStage);
		}
		
		private function onStage(evt:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,onStage);
			
			setAppSettings();
			setAppClasses();
			
			var mainCore : MainCore = new MainCore(); 
			addChild ( mainCore ) ;
		}
		
		
		private function setAppSettings():void{
			
			AppSettings.stage = stage;
			var dataURL:String = AppSettings.getFlashVar("dataURL");
			if(dataURL && dataURL != ""){
	//			trace("data path set to: " + dataURL)
				AppSettings.DATA_PATH = dataURL;
			}else{
				
				AppSettings.DATA_PATH = "../data/";
	//			trace("data path set to default: " + AppSettings.DATA_PATH)
			}
			
		}
		
		private function setAppClasses():void{
			ClassFactory.VIDEO_LOADER = WebVideoLoader;
			
		}
	}
}

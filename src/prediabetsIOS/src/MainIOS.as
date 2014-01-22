package {
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;

	import com.refract.air.shared.data.StoredData;
	import com.refract.air.shared.prediabetes.stateMachine.MobileSMController;
	import com.refract.air.shared.prediabetes.video.IOSVideoLoader;
	import com.refract.air.shared.sections.feedback.TabletFeedback;
	import com.refract.air.shared.sections.legal.TabletLegal;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.nav.IOSNav;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Box;

	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;

	/**

	 * @author robertocascavilla
	 */
	//[SWF( backgroundColor='#000000', frameRate='25')]
	public class MainIOS extends Sprite 
	{
		public static var STORAGE_DIR:File;
		
		protected var _bkg:Loader;
		
		
		public function MainIOS()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(evt:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
			setAppSettings();
			setAppClasses();
			
			addBkg();
			
			showTerms();
		}

		protected function setScreenRatio():void
		{
			AppSettings.setScreenRatio(true);
		}
		
		protected function setAppSettings():void{
			//allow multitouch input and prevent auto lock.
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			//set the global stage and global resize
			AppSettings.stage = stage;
			AppSettings.DATA_PATH = "http://rob.otlabs.net/stuff/prediabetes/" ; 
			AppSettings.RESERVED_HEADER_HEIGHT_DEFAULT = 60 ; 
			AppSettings.FOOTER_VIDEONAV_FIXED = true ; 
			//**this is the retina value. the app will detect if no retina, and divide / 2
			AppSettings.FOOTER_FONT_SIZE = 19 ;
			AppSettings.HEADER_FONT_SIZE = 19 ;  
			AppSettings.FOOTER_FIX_TABLET_POSITION = 10 ; 
			AppSettings.HEADER_FIX_COPY_TABLET_POSITION = 40 ; 
			setScreenRatio();

			 AppSettings.VIDEO_BASE_URL = "video/flv/1024/" ; 
			 AppSettings.VIDEO_FILE_EXT = ".flv" ;
			 AppSettings.VIDEO_FILE_FORMAT_DESCRIPTOR = "";
			 
			 AppSettings.BUFFER_DELAY = 1 ; 
			 //AppSettings.RESERVED_SIDE_BORDER = 7 ; 
			
			 
			 
			 var ext : String = "flv" ; 
			 var localPath:String = "video/flv/";
			 MainIOS.STORAGE_DIR = File.cacheDirectory;
			 AppSettings.APP_VIDEO_BASE_URL = MainIOS.STORAGE_DIR.nativePath + "/" + localPath ;
			 var videoFileFormatDescriptor : String = "";
			 var videoFileExt : String = "."+ext ;
			 var storageFolder:File = MainIOS.STORAGE_DIR.resolvePath("video");
			 storageFolder.preventBackup = true;
			 var newFile:File = MainIOS.STORAGE_DIR.resolvePath(localPath + AppSettings.INTRO_URL+ videoFileFormatDescriptor + videoFileExt);
			 newFile.preventBackup = true;
			 if(!newFile.exists){
				var file:File = File.applicationDirectory.resolvePath(localPath + AppSettings.INTRO_URL+videoFileFormatDescriptor+videoFileExt);
				file.copyTo(newFile,true);
			}
			 
		}
		
		protected function setAppClasses():void
		{
			ClassFactory.NAV = IOSNav ; 
			ClassFactory.VIDEO_LOADER   = IOSVideoLoader;
			ClassFactory.SM_CONTROLLER = MobileSMController ; 
			ClassFactory.LEGAL = TabletLegal;
		}
		
		
		protected function addBkg():void
		{
			_bkg = new Loader();
			_bkg.load(new URLRequest("Default@2x.png"));
			addChild(_bkg);
			onResize();
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		protected function onResize(evt:Event = null):void{
			_bkg.x = AppSettings.VIDEO_LEFT;
			_bkg.y = AppSettings.VIDEO_TOP;
			_bkg.width = AppSettings.VIDEO_WIDTH;
			_bkg.height = AppSettings.VIDEO_HEIGHT;
		}
		
		protected function showTerms():void{
			onResize();
			
			var terms:Object = StoredData.getData("has_accepted_terms");
			if(terms){
				//skip terms popup
				getBackendData();
			}else{
				var bytes : ByteArray = AssetManager.getEmbeddedAsset("CopyJSON") as ByteArray;
				TextManager.parseData(bytes.readUTFBytes(bytes.length));
				/*
				 * use textfield to strip html characters from copy
				 */
				var tf:TextField = TextManager.makeText("page_legal_title");
				var title:String = tf.text;
				tf = TextManager.makeText("page_legal_heading");
				var body:String = tf.text;
				tf = TextManager.makeText("page_legal_content");
				var body2:String = tf.text;
				if(NativeAlert.isSupported){
					NativeAlert.show(body + "\n\n" + body2, title,"ACCEPT","",onTermsClose);	
				}else{
					onTermsClose(new NativeDialogEvent(NativeDialogEvent.CLOSED, "0"));
				}
			}
		}
		
		protected function onTermsClose(evt:NativeDialogEvent):void{
			if(int(evt.index) == 0){
				StoredData.setData("has_accepted_terms", true);
				getBackendData();
			}else{
				NativeApplication.nativeApplication.exit();
			}
		}
		
		protected function getBackendData():void{
			run();
		}

		protected function run() : void {
			stage.removeEventListener(Event.RESIZE, onResize);	
			removeChild(_bkg);
			_bkg = null;
			
			var mainCore : PrediabetesCore = new PrediabetesCore() ; 
			addChild ( mainCore ) ;
		}
	}
}
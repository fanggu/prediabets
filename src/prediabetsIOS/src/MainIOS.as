package {
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;

	import com.refract.air.shared.data.StoredData;
	import com.refract.air.shared.prediabetes.stateMachine.MobileSMController;
	import com.refract.air.shared.prediabetes.stateMachine.SMModelMobile;
	import com.refract.air.shared.prediabetes.stateMachine.view.MobieStateTextView;
	import com.refract.air.shared.prediabetes.stateMachine.view.interactions.MobileInteractionQP;
	import com.refract.air.shared.sections.feedback.TabletFeedback;
	import com.refract.air.shared.sections.legal.TabletLegal;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.nav.IOSNav;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.video.VideoLoader;
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
	[SWF( backgroundColor='#FFFFFF', frameRate='25')]
	public class MainIOS extends Sprite 
	{
		public static var STORAGE_DIR:File;
		
		protected var _bkg:Loader;
		
		
		public function MainIOS(){
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(evt:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
			setAppSettings();
			setAppClasses();
			
			addBkg();
			
			showTerms();
		}

		protected function setScreenRatio():void{
			AppSettings.setScreenRatio(true);
		}
		
		protected function setAppSettings():void{
			//allow multitouch input and prevent auto lock.
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			//set the global stage and global resize
			AppSettings.stage = stage;
			AppSettings.DATA_PATH = "http://rob.otlabs.net/stuff/prediabetes/" ; 
			AppSettings.PLATFORM = AppSettings.PLATFORM_IOS;
			AppSettings.RESERVED_HEADER_HEIGHT_DEFAULT = 60 ; 
			//AppSettings.DATA_PATH = "http://rob.otlabs.net/stuff/prediabetes/" ; //"data/" ; // "./../../../../website/data/";
			
			setScreenRatio();
			/*
			var ext:String = "mp4";
			// If we're not mobile show the top bar in ios and use flv
			if(AppSettings.DEVICE != AppSettings.DEVICE_MOBILE){
				stage.displayState = StageDisplayState.NORMAL;
				ext = "flv";
			}

			var localPath:String = "video/"+ext+"/";
			MainIOS.STORAGE_DIR = File.cacheDirectory;
			VideoLoader.VIDEO_BASE_URL = MainIOS.STORAGE_DIR.nativePath + "/" + localPath ;
			VideoLoader.VIDEO_FILE_FORMAT_DESCRIPTOR = "_800"+ext;
			VideoLoader.VIDEO_FILE_EXT = "."+ext ; 
			
			var storageFolder:File = MainIOS.STORAGE_DIR.resolvePath("video");
			storageFolder.preventBackup = true;
			
			var newFile:File = MainIOS.STORAGE_DIR.resolvePath(localPath + AppSettings.INTRO_URL+ VideoLoader.VIDEO_FILE_FORMAT_DESCRIPTOR + VideoLoader.VIDEO_FILE_EXT);
			newFile.preventBackup = true;
			Logger.log(Logger.FILE_LOADING,"NEW INTRO FILE:" + newFile.nativePath);
			if(!newFile.exists){
				var file:File = File.applicationDirectory.resolvePath(localPath + AppSettings.INTRO_URL+VideoLoader.VIDEO_FILE_FORMAT_DESCRIPTOR+VideoLoader.VIDEO_FILE_EXT);
				Logger.log(Logger.FILE_LOADING,"INTRO FILE: " + file.nativePath);
				file.copyTo(newFile,true);
			}
			 * 
			 */
			 
			 VideoLoader.VIDEO_BASE_URL = "video/flv/800/" ; 
			 var ext : String = "flv" ; 
			 var localPath:String = "video/flv/";
			 MainIOS.STORAGE_DIR = File.cacheDirectory;
			 AppSettings.APP_VIDEO_BASE_URL = MainIOS.STORAGE_DIR.nativePath + "/" + localPath ;
			 var videoFileFormatDescriptor : String = "_800"+ext;
			 var videoFileExt = "."+ext ;
			 var storageFolder:File = MainIOS.STORAGE_DIR.resolvePath("video");
			 storageFolder.preventBackup = true;
			 var newFile:File = MainIOS.STORAGE_DIR.resolvePath(localPath + AppSettings.INTRO_URL+ videoFileFormatDescriptor + videoFileExt);
			 newFile.preventBackup = true;
			 if(!newFile.exists){
				var file:File = File.applicationDirectory.resolvePath(localPath + AppSettings.INTRO_URL+videoFileFormatDescriptor+videoFileExt);
				file.copyTo(newFile,true);
			}
			
			var fix_ext : String = 'flv' ;
			VideoLoader.VIDEO_FILE_FORMAT_DESCRIPTOR = "_800"+fix_ext;
			VideoLoader.VIDEO_FILE_EXT = '.flv' ; 
			 
		}
		
		protected function setAppClasses():void{
			//ClassFactory.APP_CONTROLLER = MobileAppController;
			
			ClassFactory.NAV = IOSNav ; 
			//ClassFactory.MODULE_MODEL = LocalModuleModel;
			//ClassFactory.MENU_BUTTON = LoadedMenuButton;
			//ClassFactory.VIDEO_LOADER   = IOSVideoLoader;
			ClassFactory.INTERACTION_QP = MobileInteractionQP;
			ClassFactory.SM_MODEL = SMModelMobile ; 
			ClassFactory.STATE_TXT_VIEW = MobieStateTextView; 
			ClassFactory.SM_CONTROLLER = MobileSMController ; 
			
			//ClassFactory.PROFILE_BUTTON = LoadedProfileButton;
			
			ClassFactory.FEEDBACK = TabletFeedback;
			ClassFactory.LEGAL = TabletLegal;
			//ClassFactory.MEDICAL_QUESTIONS = TabletMedicalQuestions;
			//ClassFactory.EMERGENCY_INFO_CHOKING = TabletEmergencyInfoChoking;
			//ClassFactory.EMERGENCY_INFO_COLLAPSED = TabletEmergencyInfoCollapsed;
			
		}
		
		
		protected function addBkg():void{
		//	_bkg = new BKG();
			_bkg = new Loader();
			_bkg.load(new URLRequest("Default@2x.png"));
			addChild(_bkg);
		//	_bkg.alpha = 0.3;
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
			
			var skipButton : Box = new Box( 120 , 40 , 0xfff000 ) ; 
			addChild( skipButton ) ; 
			skipButton.x = 40 ; 
			skipButton.y = 40 ; 
			skipButton.addEventListener( MouseEvent.CLICK, onTouchPress ) ; 
		}

		private function onTouchPress(event : MouseEvent) : void 
		{
			trace('ON TOUCH SKIP PRESSED')
			DispatchManager.dispatchEvent(new Event(Flags.START_MOVIE));
		}
		
		
	}
}
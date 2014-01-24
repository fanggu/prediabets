package {
	import com.refract.air.shared.prediabetes.nav.footer.SoundButtonIOS;
	import com.refract.air.shared.prediabetes.nav.footer.PlayPauseButtonIOS;
	import com.refract.air.shared.prediabetes.nav.footer.BackwardButtonIOS;
	import com.refract.air.shared.prediabetes.assets.AssetsManagerEmbedsIOS;
	import com.refract.air.shared.prediabetes.stateMachine.SMSettingsIOS;
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;

	import com.refract.air.shared.AppSettingsIOS;
	import com.refract.air.shared.data.StoredData;
	import com.refract.air.shared.prediabetes.stateMachine.MobileSMController;
	import com.refract.air.shared.prediabetes.video.IOSVideoLoader;
	import com.refract.air.shared.sections.legal.TabletLegal;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.nav.IOSNav;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.robot.geom.Box;

	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
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
			
			//showTerms();
			getBackendData();
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
			
			SMSettings.STATE_TXT_FONT_SIZE = SMSettingsIOS.STATE_TXT_FONT_SIZE_NO_RETINA ; 
			AppSettings.FOOTER_FONT_SIZE = 19 ;
			AppSettings.HEADER_FONT_SIZE = 19 ;  
			AppSettings.FOOTER_FIX_MENU_TABLET_POSITION = 15 ; 
			AppSettings.HEADER_FIX_COPY_TABLET_POSITION = 40 ; 
			
			
			
			setScreenRatio();

			 AppSettings.VIDEO_BASE_URL = "video/flv/1024/" ; 
			 AppSettings.VIDEO_FILE_EXT = ".flv" ;
			 AppSettings.VIDEO_FILE_FORMAT_DESCRIPTOR = "";
			 
			 AppSettings.BUFFER_DELAY = 1 ; 

			  
			 storeIntroVideoFile() ; 
		}
		
		protected function setAppClasses():void
		{
			ClassFactory.NAV = IOSNav ; 
			ClassFactory.VIDEO_LOADER   = IOSVideoLoader;
			ClassFactory.SM_CONTROLLER = MobileSMController ; 
			ClassFactory.LEGAL = TabletLegal;
			ClassFactory.ASSETS_MANAGER_EMBEDS = AssetsManagerEmbedsIOS ; 
			ClassFactory.BACKWARD_BUTTON = BackwardButtonIOS ; 
			ClassFactory.PLAY_PAUSE_BUTTON = PlayPauseButtonIOS; 
			ClassFactory.SOUND_BUTTON = SoundButtonIOS ; 
		}
		
		
		protected function setScreenRatio():void
		{
			var dpi:Number = Capabilities.screenDPI;
			var inchesWide:Number = stage.fullScreenWidth/dpi;
			var inchesHigh:Number = stage.fullScreenHeight/dpi;	
			inchesWide *= inchesWide;
			inchesHigh *= inchesHigh;
			var inches:Number = Math.sqrt(inchesWide + inchesHigh);
			 
			AppSettings.DEVICE =  AppSettings.DEVICE_TABLET ; 			
			AppSettings.FONT_SCALE_FACTOR = dpi/72 * 0.6;
			
			AppSettings.RATIO = ( dpi / 72) ; 
			if( AppSettings.RATIO > 1.2) AppSettings.RATIO = AppSettings.RATIO / 2 ;
			
			if( dpi > 200 )
			{
				AppSettings.RETINA = true ; 
				AppSettings.FONT_SCALE_FACTOR = 1 ;
				//**fix positions in the footer - buttons
				AppSettings.PP_FIXER_Y = 3 ;
				AppSettings.SND_FIXER_X = -12 ; 
				
				AppSettings.RESERVED_FOOTER_HEIGHT = AppSettingsIOS.RESERVED_FOOTER_HEIGH_RETINA ; 
				AppSettings.RESERVED_HEADER_HEIGHT = AppSettingsIOS.RESERVED_HEADER_HEIGH_RETINA ; 		
				
				SMSettings.CHOICE_BUTTON_HEIGHT = SMSettingsIOS.CHOICE_BUTTON_HEIGHT_RETINA ; 	
				SMSettings.CHOICE_BUTTON_WIDTH = SMSettingsIOS.CHOICE_BUTTON_WIDTH_RETINA ; 
				SMSettings.CHOICE_BUTTON_SPACE = SMSettingsIOS.CHOICE_BUTTON_SPACE_RETINA ; 
				AppSettings.LOGO_ADDRESS = AppSettingsIOS.LOGO_RETINA_ADDRESS ;	
				
				AppSettings.VIDEO_NAV_SIDE = AppSettingsIOS.VIDEO_NAV_SIDE_RETINA ; 
				AppSettings.VIDEO_NAV_HEIGHT = AppSettingsIOS.VIDEO_NAV_HEIGHT_RETINA ; 
				AppSettings.VIDEO_NAV_PROGRESS_BAR_HIT_AREA_HEIGHT = AppSettings.VIDEO_NAV_PROGRESS_BAR_HIT_AREA_HEIGHT * 2 ; 
		//		AppSettings.VIDEO_NAV_PROGRESS_BAR_HEIGHT = AppSettingsIOS.VIDEO_NAV_HEIGHT_RETINA ;
		//		public static var VIDEO_NAV_SIDE_RETINA 						: int = AppSettings.VIDEO_NAV_SIDE * 2; 
		//public static var VIDEO_NAV_HEIGHT_RETINA 						: int = AppSettings.VIDEO_NAV_HEIGHT * 2 ;
		//public static var VIDEO_NAV_PROGRESS_BAR_HEIGHT_RETINA 			: int = AppSettings.VIDEO_NAV_PROGRESS_BAR_HEIGHT ; 
			}
			else
			{
				AppSettings.RETINA = false ; 
				AppSettings.FONT_SCALE_FACTOR = 0.5 ;
				
				AppSettings.PP_FIXER_Y = AppSettingsIOS.VIDEO_NAV_FIX_PAUSE_POS_Y  ; 
				AppSettings.SND_FIXER_X = -7 ; 
				AppSettings.SND_FIXER_Y = -2 ;
				
				AppSettings.RESERVED_FOOTER_HEIGHT = AppSettingsIOS.RESERVED_FOOTER_HEIGH_NO_RETINA ; 
				AppSettings.RESERVED_HEADER_HEIGHT = AppSettingsIOS.RESERVED_HEADER_HEIGH_NO_RETINA ; 
				
				SMSettings.CHOICE_BUTTON_HEIGHT = SMSettingsIOS.CHOICE_BUTTON_HEIGHT_NO_RETINA ; 
				SMSettings.CHOICE_BUTTON_WIDTH = SMSettingsIOS.CHOICE_BUTTON_WIDTH_NO_RETINA ; 
				SMSettings.CHOICE_BUTTON_SPACE = SMSettingsIOS.CHOICE_BUTTON_SPACE_NO_RETINA ; 
				
				AppSettingsIOS.TOP_HEIGHT_BAR = AppSettingsIOS.TOP_HEIGHT_BAR / 2; 
				AppSettings.HEADER_FIX_COPY_TABLET_POSITION = AppSettings.HEADER_FIX_COPY_TABLET_POSITION / 2; 
				AppSettings.FOOTER_FIX_MENU_TABLET_POSITION = AppSettings.FOOTER_FIX_MENU_TABLET_POSITION / 2; 
				
				//AppSettings.VIDEO_NAV_SIDE = AppSettingsIOS.VIDEO_NAV_SIDE_RETINA ; 
				//AppSettings.VIDEO_NAV_HEIGHT = AppSettingsIOS.VIDEO_NAV_HEIGHT_RETINA ; 
			    AppSettings.VIDEO_NAV_PROGRESS_BAR_HEIGHT = AppSettingsIOS.VIDEO_NAV_PROGRESS_BAR_HEIGHT_NO_RETINA ;
			}
			AppSettings.RESERVED_HEIGHT = AppSettings.RESERVED_FOOTER_HEIGHT + AppSettings.RESERVED_HEADER_HEIGHT;

		    if (dpi >= 200)
			{
				var rat200:Number =  2.277777778 ;
				AppSettings.FONT_SIZES[12] = 12*rat200;
				AppSettings.FONT_SIZES[13] = 13*rat200;
				AppSettings.FONT_SIZES[14] = 14*rat200;
				AppSettings.FONT_SIZES[15] = 15*rat200;
				AppSettings.FONT_SIZES[16] = 16*rat200;
				AppSettings.FONT_SIZES[18] = 18*rat200;
				AppSettings.FONT_SIZES[19] = 38;
				AppSettings.FONT_SIZES[20] = 20*rat200;
				AppSettings.FONT_SIZES[22] = 22*rat200;
				AppSettings.FONT_SIZES[24] = 24*rat200;
				AppSettings.FONT_SIZES[30] = 60 ; //30*rat200;
				AppSettings.FONT_SIZES[32] = 32*rat200;
				AppSettings.FONT_SIZES[35] = 61 ; 
				AppSettings.FONT_SIZES[36] = 36*rat200;
				AppSettings.FONT_SIZES[48] = 48*rat200*.75;
				AppSettings.FONT_SIZES[54] = 54*rat200*.75;
				AppSettings.FONT_SIZES[72] = 72*rat200*.75;
				AppSettings.FONT_SIZES[100] = 100*rat200*.75;
			}
		}
		
		protected function addBkg():void
		{
			_bkg = new Loader();
			_bkg.load(new URLRequest("Default@2x.png"));
			addChild(_bkg);
			onResize();
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function storeIntroVideoFile() : void
		{
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
			
			var box : Box = new Box( AppSettings.stage.stageWidth * 2 , AppSettingsIOS.TOP_HEIGHT_BAR , 0x000000 ); 
			addChild( box ) ; 
		}
	}
}
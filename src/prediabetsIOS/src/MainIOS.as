package {
	import com.refract.air.shared.AppSettingsIOS;
	import com.refract.air.shared.prediabetes.assets.AssetsManagerEmbedsIOS;
	import com.refract.air.shared.prediabetes.nav.footer.BackwardButtonIOS;
	import com.refract.air.shared.prediabetes.nav.footer.PlayPauseButtonIOS;
	import com.refract.air.shared.prediabetes.nav.footer.SoundButtonIOS;
	import com.refract.air.shared.prediabetes.stateMachine.MobileSMController;
	import com.refract.air.shared.prediabetes.stateMachine.SMSettingsIOS;
	import com.refract.air.shared.prediabetes.tracking.TrackingLocation;
	import com.refract.air.shared.prediabetes.tracking.TrackingStartIOS;
	import com.refract.air.shared.prediabetes.video.IOSVideoLoader;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.nav.IOSNav;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.tracking.TrackingSettings;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Box;

	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;

	/**

	 * @author robertocascavilla
	 */
	[SWF( backgroundColor='#000000', frameRate='25')]
	public class MainIOS extends Sprite 
	{
		public static var STORAGE_DIR:File;
		
		protected var _bkg : Loader;
		
		
		public function MainIOS()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(evt:Event):void
		{
			//checkWIFI() ; 
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);	
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE , onDeactivateApp);
			trackStart() ; 
		}
		private function checkWIFI() : void
		{
			var vNetworkInterfaces:Object; 
			if (flash.net.NetworkInfo.isSupported) 
			{ 
			  vNetworkInterfaces = getDefinitionByName('flash.net.NetworkInfo')['networkInfo']['findInterfaces'](); 
			  trace("fall 1" );
			} 
			else 
			{ 
			  vNetworkInterfaces = getDefinitionByName('com.adobe.nativeExtensions.Networkinfo.NetworkInfo')['networkInfo']['findInterfaces']();
			  trace("fall 2" );
			} 
			
			var hasWifi: Boolean = false;
			var hasMobile: Boolean = false;
			
			for each (var networkInterface:Object in vNetworkInterfaces) 
			{ 
			    if ( networkInterface.active && (networkInterface.name == "en0" || networkInterface.name == "en1") ) hasWifi = true;
			    if ( networkInterface.active && (networkInterface.name == "pdp_ip0" || networkInterface.name == "pdp_ip1" || networkInterface.name == "pdp_ip2") ) hasMobile = true;
			
			    trace( "active: " + networkInterface.active );
			    trace( "displayName: " + networkInterface.displayName );
			    trace( "name: " + networkInterface.name );
			    trace( "hwAddress: " + networkInterface.hardwareAddress );
			    trace( "--------------------" ); 
			} 
			
			trace( "has Mobile Internet: " + hasMobile );
			trace( "has Wifi Internet: " + hasWifi );
		}

		private function onDeactivateApp(event : Event) : void 
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function trackStart() : void
		{
			var trackingStartIOS : TrackingStartIOS = new TrackingStartIOS( ) ; 
			DispatchManager.addEventListener( TrackingSettings.HEADER_REGISTERED, onTrackingStart)
			trackingStartIOS.track() ; 
		}
		private function onTrackingStart( evt : Event ) : void
		{
			if( AppSettings.TRACKING)
			{
				var trackingLocation : TrackingLocation = new TrackingLocation() ; 
				//DispatchManager.addEventListener( TrackingSettings.LOCATION_PRIVACY_CLICK, onLocationPrivacy)
				trackingLocation.track() ; 
				setTimeout( init , 200 ) ; 
			}
			else
			{
				init() ; 
			}
			
		}
		
		private function init() : void
		{
			setAppSettings();
			setAppClasses();
			addBkg();
			 
			start() ; 
		}

		protected function setAppSettings():void{
			//allow multitouch input and prevent auto lock.
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
			//set the global stage and global resize
			AppSettings.stage = stage;
			//AppSettings.DATA_PATH = "http://rob.otlabs.net/stuff/prediabetes/" ; 
			AppSettings.RESERVED_HEADER_HEIGHT_DEFAULT = 60 ; 
			AppSettings.FOOTER_VIDEONAV_FIXED = true ; 
			AppSettings.TYPE_APP = 'iosapp' ; 
			SMSettings.STATE_TXT_FONT_SIZE = SMSettingsIOS.STATE_TXT_FONT_SIZE_NO_RETINA ; 
			AppSettings.FOOTER_FONT_SIZE = 19 ;
			AppSettings.HEADER_FONT_SIZE = 19 ;  
			AppSettings.FOOTER_FIX_MENU_TABLET_POSITION = 15 ; 
			AppSettings.HEADER_FIX_COPY_TABLET_POSITION = 40 ; 
			
			
			
			setScreenRatio();

			 AppSettings.VIDEO_BASE_URL = "video/flv/" ; 
			 AppSettings.VIDEO_FILE_EXT = ".flv" ;
			 AppSettings.VIDEO_FILE_FORMAT_DESCRIPTOR = "";
			 //AppSettings.INTRO_URL = 'd01_intro_800flv' ; 
			 
			 AppSettings.BUFFER_DELAY = 1 ; 

			  
			 //IntroVideoFile() ; 
		}
		
		protected function setAppClasses():void
		{
			ClassFactory.NAV = IOSNav ; 
			ClassFactory.VIDEO_LOADER   = IOSVideoLoader;
			ClassFactory.SM_CONTROLLER = MobileSMController ; 
			//ClassFactory.LEGAL = TabletLegal;
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
				AppSettings.OVERLAY_GAP = AppSettings.OVERLAY_GAP * 2 ; 
				AppSettings.OVERLAY_BODY_DIFF_W = AppSettings.OVERLAY_BODY_DIFF_W * 2 ; 
				AppSettings.OVERLAY_BODY_DIFF_H = AppSettings.OVERLAY_BODY_DIFF_H * 2 ; 
				
				AppSettings.SCROLLBAR_BACK_W = AppSettings.SCROLLBAR_BACK_W_RETINA ; 
				AppSettings.SCROLLBAR_TRIGGER_W = AppSettings.SCROLLBAR_TRIGGER_W_RETINA ; 
				AppSettings.SCROLLBAR_GAP_H = AppSettings.SCROLLBAR_GAP_H * 2 ; 
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
				
				AppSettings.SCROLLBAR_BACK_W = AppSettings.SCROLLBAR_BACK_W_NO_RETINA ; 
				AppSettings.SCROLLBAR_TRIGGER_W = AppSettings.SCROLLBAR_TRIGGER_W_NO_RETINA ; 
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
		protected function onResize(evt:Event = null):void
		{
			_bkg.x = AppSettings.VIDEO_LEFT;
			_bkg.y = AppSettings.VIDEO_TOP;
			_bkg.width = AppSettings.VIDEO_WIDTH;
			_bkg.height = AppSettings.VIDEO_HEIGHT;
		}



		protected function start() : void {
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
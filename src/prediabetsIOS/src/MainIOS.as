package {
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;

	import com.refract.air.shared.MobileAppController;
	import com.refract.air.shared.components.emergencyinfo.TabletEmergencyInfoChoking;
	import com.refract.air.shared.components.emergencyinfo.TabletEmergencyInfoCollapsed;
	import com.refract.air.shared.components.feedback.TabletFeedback;
	import com.refract.air.shared.components.legal.TabletLegal;
	import com.refract.air.shared.components.medicalquestions.TabletMedicalQuestions;
	import com.refract.air.shared.data.StoredData;
	import com.refract.air.shared.prediabets.stateMachine.MobileSMController;
	import com.refract.air.shared.prediabets.stateMachine.SMModelMobile;
	import com.refract.air.shared.prediabets.stateMachine.view.MobieStateTextView;
	import com.refract.air.shared.prediabets.stateMachine.view.interactions.MobileInteractionQP;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.ClassFactory;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.profile.LoadedProfileButton;
	import com.refract.prediabets.user.UserModel;

	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;

	/**

	 * @author robertocascavilla
	 */
	[SWF( backgroundColor='#000000', frameRate='25')]
	public class MainIOS extends Sprite 
	{
		
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
			AppSettings.DATA_PATH = "file://";
			AppSettings.PLATFORM = AppSettings.PLATFORM_IOS;
			
			setScreenRatio();
			
			var ext:String = "mp4";
			// If we're not mobile show the top bar in ios and use flv
			if(AppSettings.DEVICE != AppSettings.DEVICE_MOBILE)
			{
				stage.displayState = StageDisplayState.NORMAL;
				ext = "flv";
			}

			
		}
		
		protected function setAppClasses():void{
			ClassFactory.APP_CONTROLLER = MobileAppController;
			
			//ClassFactory.VIDEO_LOADER   = IOSVideoLoader;
			ClassFactory.INTERACTION_QP = MobileInteractionQP;
			ClassFactory.SM_MODEL = SMModelMobile ; 
			ClassFactory.STATE_TXT_VIEW = MobieStateTextView; 
			ClassFactory.SM_CONTROLLER = MobileSMController ; 
			
			ClassFactory.PROFILE_BUTTON = LoadedProfileButton;
			
			ClassFactory.FEEDBACK = TabletFeedback;
			ClassFactory.LEGAL = TabletLegal;
			ClassFactory.MEDICAL_QUESTIONS = TabletMedicalQuestions;
			ClassFactory.EMERGENCY_INFO_CHOKING = TabletEmergencyInfoChoking;
			ClassFactory.EMERGENCY_INFO_COLLAPSED = TabletEmergencyInfoCollapsed;
			
		}
		
		
		protected function addBkg():void
		{
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
			if(terms)
			{
				//skip terms popup
				getBackendData();
			}
			else
			{
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
		//	BackendResponder.initialize(run,run);
			run();
		}

		protected function run() : void {
			stage.removeEventListener(Event.RESIZE, onResize);	
			removeChild(_bkg);
			_bkg = null;
			
			trace("finaqqua ttapost")
			
			var mainCore : MainCore = new MainCore() ; 
			addChild ( mainCore ) ;
			
			trace("maincore iniziat")
			UserModel.getModuleStats(1).unlocked = true;
			UserModel.getModuleStats(2).unlocked = true;
			UserModel.getModuleStats(3).unlocked = true;
			UserModel.getModuleStats(4).unlocked = true;
			trace("cazzate di user model")
		}
		
		
	}
}
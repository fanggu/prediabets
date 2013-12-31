package com.refract.prediabets 
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.greensock.TweenMax;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.backend.BackendResponder;
	import com.refract.prediabets.components.events.FooterEvent;
	import com.refract.prediabets.components.events.MenuEvent;
	import com.refract.prediabets.components.events.SceneSelectorEvent;
	import com.refract.prediabets.components.intro.Intro;
	import com.refract.prediabets.components.login.Login;
	import com.refract.prediabets.components.nav.Header;
	import com.refract.prediabets.components.nav.Nav;
	import com.refract.prediabets.components.results.Results;
	import com.refract.prediabets.logger.Logger;
	import com.refract.prediabets.stateMachine.SMController;
	import com.refract.prediabets.stateMachine.SMView;
	import com.refract.prediabets.stateMachine.events.BooleanEvent;
	import com.refract.prediabets.stateMachine.events.ObjectEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.refract.prediabets.stateMachine.sound.SoundMachine;
	import com.refract.prediabets.user.UserModel;
	import com.refract.prediabets.video.VideoLoader;
	import com.robot.comm.DispatchManager;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	/**
	 * @author robertocascavilla
	 */
	public class AppController 
	{ 	
		
		protected static var _i:AppController;
		public static function get i():AppController{return _i;}
		
		protected var _status:String;
		
		protected var _main : MainCore ;
		protected var _nav : Nav;
		public function get nav():Nav {return _nav;}
		protected var _intro : Intro;
	//	protected var _results: Results;
		protected var _ui:Sprite;
		protected var _smView : SMView;
		protected var _smController : SMController;
		
		protected var _quickSM:Boolean = false;
		protected var _nextStory:int = -1 ;
		public function get nextStory():int {return _nextStory;}
		public function set nextStory(story:int):void { _nextStory = story;}
		
		protected var _stories:Array = ["",AppSections.MODULE_LS1, AppSections.MODULE_LS2, AppSections.MODULE_LS3, AppSections.REAL_STORIES];
		
		protected var _interactiveSections:Array = [AppSections.MODULE_LS1, AppSections.MODULE_LS2, AppSections.MODULE_LS3, AppSections.REAL_STORIES,AppSections.SIGN_UP,AppSections.FEEDBACK,AppSections.LOGIN];
		
		protected var _nextStoryState:String = null;
		public function get nextStoryState() : String { return _nextStoryState; }
		public function set nextStoryState(nextStoryState : String) : void { _nextStoryState = nextStoryState; }
		
		protected var currentPath:Array = ["iAmNotAPath"];
		protected var previousPath:Array = ["iAmNotAPath"];
		protected var lastMajor:String = "";
		
		protected var _dictQuestions : Dictionary ; 
		public function AppController( main : MainCore)
		{
			_i = this;
			_main = main ; 
		}
		
		public function init() : void
		{
			createSoundMachine() ; 
			//SoundMixer.soundTransform = new SoundTransform(0);
			
			createUI();
			createNav();
			createSM();		
			
			DispatchManager.addEventListener( Flags.DRAW_VIDEO_STATUS ,onDrawVideoStatus  ) ;
			DispatchManager.addEventListener( SceneSelectorEvent.QUESTION_SELECTED ,onQuestionSelected  ) ;
			
			createQuestionsDictionary() ;
			
			
			initSWFAddress();
		}
		
		protected function createSM() : void
		{
			//*state machine main view
			_smView = new ClassFactory.SM_VIEW();
			_main.addChildAt( _smView, 0 );
			
			//*state machine engine			
			_smController = new ClassFactory.SM_CONTROLLER();
			
		}
		
		protected function createUI():void{
			_ui = new Sprite();
			_main.addChild(_ui);
			
			AppSettings._stageCoverCopy = TextManager.makeText("full_screen_blocker",null,{fontSize:24,align:"center"});
			_main.stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFSChange);
		}
		
		protected function onFSChange(evt:FullScreenEvent):void{
			if(evt.fullScreen && _interactiveSections.indexOf("SECTION:"+currentPath[0]) != -1){
				DispatchManager.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, fsAcceptedOrNot);
				onMenuShow();
				AppSettings.checkFSStatus();
			}
		}
		
		protected function fsAcceptedOrNot(evt:Event):void{
			DispatchManager.removeEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, fsAcceptedOrNot);
			onMenuHide();
		}
		
		protected function createNav():void{
			_nav = new ClassFactory.NAV();
			_main.addChild(_nav);
			
			DispatchManager.addEventListener(Flags.APP_ACTIVATE, onAppActivated);
			DispatchManager.addEventListener(Flags.APP_DEACTIVATE, onAppDeactivated);
			
			DispatchManager.addEventListener(MenuEvent.MENU_SHOW,onMenuShow);
			DispatchManager.addEventListener(MenuEvent.MENU_HIDE,onMenuHide);
			DispatchManager.addEventListener(MenuEvent.MENU_SELECTED,onMenuSelected);
			DispatchManager.addEventListener(SceneSelectorEvent.BUTTON_SELECTED,onSceneSelectorSelected);
			DispatchManager.addEventListener(Nav.NO_MORE_OVERLAYS,onNoMoreOverlays);
			DispatchManager.addEventListener(SceneSelectorEvent.QUESTION_SELECTED,onBeginModuleQuestions);
		//	_nav.addEventListener(Nav.SHOW_SCENE_SELECTOR,onSceneSelector);
		//	_smController.start();
		}
			
		protected function onAppActivated(evt:Event = null):void{
			Logger.general(this,"activate");
			TweenMax.resumeAll();
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.FOOTER_CLICKED,{value:Header.LS_LOGO}));
			
			if(VideoLoader.i){
				VideoLoader.i.reattachStageVideo();
			}
			
			onMenuHide();
		}
		
		protected function onAppDeactivated(evt:Event = null):void{
			Logger.general(this,"deactivate");
			onMenuShow();
			TweenMax.pauseAll(true,true,true);
			
		//	DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.FOOTER_CLICKED,{value:Header.LS_LOGO}));
		//	onMenuShow();
		}	
			
		protected function onMenuHide(evt:Event = null):void{
			if(_nav.overlayShown){
				
			}else{
				DispatchManager.dispatchEvent(new Event(Flags.UN_FREEZE));
				DispatchManager.dispatchEvent(new Event(Intro.INTRO_VIDEO_UNPAUSE));
			}
		}
		
		protected function onMenuShow(evt:Event = null):void{
			DispatchManager.dispatchEvent(new Event(Flags.FREEZE));
			DispatchManager.dispatchEvent(new Event(Intro.INTRO_VIDEO_PAUSE));
		}
			
		protected function createSoundMachine() : void {
			new SoundMachine() ; 
		}
		
		protected function createQuestionsDictionary() : void {
			_dictQuestions = new Dictionary( true ) ; 
		}
		protected function onQuestionSelected( evt : SceneSelectorEvent ) : void {
			_dictQuestions[evt.id] = true ;  
		}
		public function get nrQuestionSelected() : int {
			var n:int = 0;
    		for (var key:* in _dictQuestions){
        		n++;
    		}
    		return n;
		}

		protected function onKeyDown(event : KeyboardEvent) : void {
			if( event.charCode == Keyboard.SPACE)
			{
				if( VideoLoader.i)
				{
					VideoLoader.i.onSpaceBarClicked() ; 
				}
			}
		}
		
		protected function setState(path:Array,checkFS:Boolean = true):void {
			if(currentPath[0] != path[0] || path[0] == AppSections.INTRO.split(":")[1]){
				
				switch("SECTION:"+path[0]){
					case(AppSections.MODULE_LS1):
					case(AppSections.MODULE_LS2):
					case(AppSections.MODULE_LS3):
					case(AppSections.REAL_STORIES):
						removeCurrentSection();	
		//				if(UserModel.isModuleLocked(nextStory))
						
							if(lastMajor != path[0]){
								AppSettings.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ;
								DispatchManager.dispatchEvent( new Event( Flags.SM_KILL ) ) ; 
								lastMajor = path[0];
								nextStory = -1;
								nextStoryState = null;
								beginModule();
								AppSettings.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ;
							}
						 
						break;
					case(AppSections.SIGN_UP):
						removeCurrentSection();	
						if(!UserModel.isLoggedIn){
							lastMajor = path[0];
							createSignUp();
							AppSettings.stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ;
						}else{
							setSWFAddress(AppSections.INTRO);
						}
						DispatchManager.dispatchEvent( new Event( Flags.SM_KILL ) ) ; 
						break;
					case(AppSections.ABOUT):
					case(AppSections.CREDITS):
					case(AppSections.EMERGENCY_INFO):
					case(AppSections.FEEDBACK):
					case(AppSections.GET_THE_APP):
					case(AppSections.LEGAL):
					case(AppSections.MEDICAL_QUESTIONS):
					case(AppSections.LOGIN):
					case(AppSections.SHARE):
					case(AppSections.PROFILE):
					case(AppSections.BOOK_A_COURSE):
						addOverlay(path[0]);
						AppSettings.stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ;
						break;
					case(AppSections.INTRO):
					default://intro is default state so no break
						lastMajor = path[0];
						removeCurrentSection();	
						createIntro();
						AppSettings.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ;
						DispatchManager.dispatchEvent( new Event( Flags.SM_KILL ) ) ; 
					
				}
				
				//if(currentPath[0] != path[0]){
					currentPath = path.concat();
					previousPath = currentPath;
				//}
					if(lastMajor != "INTRO" && _intro){
					//	destroyIntro();
					}
			}
		}

		protected function removeCurrentSection():void{
			switch("SECTION:"+currentPath[0]){
				case(AppSections.INTRO):
					destroyIntro();
					break;
				case(AppSections.SIGN_UP):
					//_nav.removeCurrentOverlay();
					break;
				case(AppSections.MODULE_LS1):
				case(AppSections.MODULE_LS2):
				case(AppSections.MODULE_LS3):
				case(AppSections.REAL_STORIES):
					//story, do nothing
					break;
				case(AppSections.ABOUT):
				case(AppSections.CREDITS):
				case(AppSections.EMERGENCY_INFO):
				case(AppSections.FEEDBACK):
				case(AppSections.GET_THE_APP):
				case(AppSections.LEGAL):
				case(AppSections.MEDICAL_QUESTIONS):
				case(AppSections.LOGIN):
				case(AppSections.SHARE):
				case(AppSections.PROFILE):
				case(AppSections.BOOK_A_COURSE):
					
					//overlay, do nothing
					break;
			}
			DispatchManager.removeEventListener(Results.CONTINUE,onResultsContinue);
			AppSettings.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ;
		}

		protected function addOverlay(path:String,suppressAnim:Boolean = false) : void {
			//Logger.log(Logger.SWF_ADDRESS,"ADDING OVERLAY",path);
			_nav.addSection(path,suppressAnim);
		}
		
		
		protected function onNoMoreOverlays(evt:Event):void{
			var out:String = "";
			if(lastMajor == AppSections.RESULTS && nextStory == 3){
				out = "intro";
				setSWFAddress(AppSections.INTRO);	
			}else if(lastMajor == AppSections.RESULTS){
				//setSWFAddress(AppSections.INTRO);	
				out = "results";
				addOverlay(AppSections.RESULTS.split(":")[1],true);
			}else if (lastMajor == AppSections.SIGN_UP.split(":")[1]){
			//	
				
				out = "nothing";
			}else{
				out = lastMajor;
				setSWFAddress("SECTION:"+lastMajor);
			}
			Logger.log(Logger.SWF_ADDRESS, "No More Overlays "+ out);
			
			/*if(_nextStory == -1){
				if(_status == AppSections.INTRO){
					setSWFAddress(AppSections.INTRO);
				}
			}else{
				beginModule();SWFAddress
			}*/
		}

		protected function createIntro():void{
			if(!_intro){
				_nextStory = -1;
				DispatchManager.dispatchEvent(new Event(Flags.SM_RESET));
				DispatchManager.dispatchEvent( new Event( Flags.SM_KILL ) ) ; 
				VideoLoader.i.stopVideo();
				DispatchManager.addEventListener(Intro.INTRO_ENDED, onIntroEnded);
				_intro  = new ClassFactory.INTRO();
				_status = AppSections.INTRO;
				_ui.addChild(_intro);
				DispatchManager.dispatchEvent(new Event(Flags.HIDE_FOOTER_PLAY_PAUSE));
			}else{
				
				DispatchManager.dispatchEvent(new Event(Flags.UN_FREEZE));
			}
		//	_nav.addOverlay(ClassFactory.INTRO);
		}		
		
		protected function onIntroEnded(evt:Event):void{
			DispatchManager.removeEventListener(Intro.INTRO_ENDED, onIntroEnded);
			_nav.showMenu();
		}
		
		protected function onMenuSelected(evt:MenuEvent):void{
			_nav.hideMenu();
			
			/*			
			if(_stories[evt.menuItem] != "SECTION:"+SWFAddress.getPathNames()[0] ){
				_nextStory = evt.menuItem;
				nextStoryState = null;
				if(!UserModel.isLoggedIn){ //and in sign up
					if(SWFAddress.getPathNames()[0] != AppSections.SIGN_UP.split(":")[1]){
						_nav.removeCurrentOverlay();
						setSWFAddress(AppSections.SIGN_UP);
					}
				}else{
					_nav.removeCurrentOverlay();
					setSWFAddress(_stories[evt.menuItem]);
				}
			}
			*/
			
			if(_stories[evt.menuItem] != "SECTION:"+SWFAddress.getPathNames()[0] || lastMajor == AppSections.RESULTS){
			//	Logger.log(Logger.SWF_ADDRESS,"IF1:",_stories[evt.menuItem] != "SECTION:"+SWFAddress.getPathNames()[0],lastMajor == AppSections.RESULTS);
				_nextStory = evt.menuItem;
				nextStoryState = null;
				if(SWFAddress.getPathNames()[0] != AppSections.SIGN_UP.split(":")[1]){
				//	Logger.log(Logger.SWF_ADDRESS,"IF2:",SWFAddress.getPathNames()[0] != AppSections.SIGN_UP.split(":")[1]);
					if(!UserModel.isLoggedIn && AppSettings.DEVICE == AppSettings.DEVICE_PC){ //and in sign up
				//		Logger.log(Logger.SWF_ADDRESS,"IF3:",!UserModel.isLoggedIn,AppSettings.DEVICE == AppSettings.DEVICE_PC);
					//	_nav.removeCurrentOverlay();
						setSWFAddress(AppSections.SIGN_UP);
					}else{
				//		Logger.log(Logger.SWF_ADDRESS,"ELSE3:",!UserModel.isLoggedIn,AppSettings.DEVICE == AppSettings.DEVICE_PC);
						if(lastMajor == AppSections.RESULTS && _stories[evt.menuItem] == "SECTION:"+SWFAddress.getPathNames()[0]){
				//			 Logger.log(Logger.SWF_ADDRESS,"IF4",lastMajor == AppSections.RESULTS, _stories[evt.menuItem] == "SECTION:"+SWFAddress.getPathNames()[0]);
							 _nextStory = -1;
						//	 Logger.log(Logger.SWF_ADDRESS,"RESULTS && story is same");
							 beginModule();
						}else{
				//			Logger.log(Logger.SWF_ADDRESS,"ELSE4,",lastMajor == AppSections.RESULTS, _stories[evt.menuItem] == "SECTION:"+SWFAddress.getPathNames()[0]);
							_nav.removeCurrentOverlay();
							setSWFAddress(_stories[evt.menuItem]);
						}
					}
				}else if(UserModel.isLoggedIn){ //and in sign up
				//	Logger.log(Logger.SWF_ADDRESS,"ELSE IF2:",UserModel.isLoggedIn);
						_nav.removeCurrentOverlay();
						setSWFAddress(_stories[evt.menuItem]);
					
				}
			}else{
				//Logger.log(Logger.SWF_ADDRESS,"ELSE1",_stories[evt.menuItem] != "SECTION:"+SWFAddress.getPathNames()[0],lastMajor == AppSections.RESULTS);
			}
			
		}
		
		protected function destroyIntro():void{
			if(_intro){
				_intro.destroy();
				_ui.removeChild(_intro);
				_intro = null;
			}
		}
		
		protected function onDrawVideoStatus( evt : BooleanEvent) : void
		{
			var value :Boolean = evt.value ;
			var statusMC : MovieClip ;
			if( value )
			{
				statusMC = AssetManager.getEmbeddedAsset('GreenPlay') ;
				if( _smView )_smView.addChild( statusMC ) ;
				statusMC.gotoAndStop(1) ;
				TweenMax.to( statusMC , 1.2 , {frame:36} ) ;
			}
			else
			{
				statusMC = AssetManager.getEmbeddedAsset('RedPause') ;
				if( _smView )_smView.addChild( statusMC ) ;
				
				TweenMax.to( statusMC , 1.2 , {frame:36} ) ;
			}
			statusMC.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2 + statusMC.width/2 ;
			statusMC.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 + statusMC.height/2 + 100;
			
			statusMC.mouseChildren = false ;
			statusMC.mouseEnabled = false ; 
			statusMC.buttonMode = false ; 
		}
		
		protected function createSignUp():void{
			_status = AppSections.SIGN_UP;
			_nav.addOverlay(ClassFactory.SIGN_UP);
			DispatchManager.addEventListener(Login.SIGNUP_ENDED,onSignUpEnded);
		}
		
		protected function onSignUpEnded(evt:Event):void{
			DispatchManager.removeEventListener(Login.SIGNUP_ENDED,onSignUpEnded);
			var ns:int = nextStory;
			
			if(ns == -1){
				setSWFAddress(AppSections.INTRO);
			}else{
			//	nextStory = -1;
				setSWFAddress(_stories[ns]);
			}
		//	_nav.removeCurrentOverlay();
			/*
			if(nextStory == 4)
			{
				setSWFAddress(AppSections.REAL_STORIES);
			}else{
				setSWFAddress(AppSections['MODULE_LS'+nextStory]);
			}*/
		//	beginModule();
		}
		
		protected function onSceneSelectorSelected(event : SceneSelectorEvent) : void {
			var pos:int = event.id;
			nextStoryState = _smController.model.sceneSelect[pos];	
			beginModule(-1,nextStoryState);
		}
		
		protected function beginModule(module:int = -1, scene:String = null):void{
			var paths:Array = SWFAddress.getPathNames();
			var story:int = _stories.indexOf("SECTION:"+paths[0]);
		/*	switch(SECTIONpaths[0]){
				case(AppSections.MODULE_LS1):
					story = 1;
					break;
				case(AppSections.MODULE_LS2):
					story = 2;
					break;
				case(AppSections.MODULE_LS3):
					story = 3;
					break;
				case(AppSections.REAL_STORIES):
					story = 4;
					break;
			}*/
			
		//	Logger.log(Logger.SWF_ADDRESS,"BEGIN MODULE:",story);
			
			if(nextStory != story || paths.length > 1 || scene != null){
		//		Logger.log(Logger.SWF_ADDRESS,"IF1",nextStory != story, paths.length > 1 , scene != null)
				nextStory = story;
				if(scene == null){
					nextStoryState = paths.length > 1 ? (paths[1] == "null" ? null : paths[1]) : null;	
				}else{
			//		Logger.log(Logger.SWF_ADDRESS,"ELSE2",scene == null);
					nextStoryState = scene;
				}
			
				_status = paths[0];
			
				_nav.removeCurrentOverlay();
				destroyIntro();
				DispatchManager.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, goModule);
				AppSettings.checkFSStatus();
			}
		}
		
		protected function goModule(evt:Event):void{
		//	Logger.log(Logger.SWF_ADDRESS,"GO MODULE");
				DispatchManager.removeEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, goModule);
				if(nextStory != 4){				
					DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onStateMachineEnd);
//					UserModel.getModuleStats(nextStory + 1).unlocked = true;	
//					if(nextStory == -1){
						UserModel.getModuleStats(nextStory).resetScore();
						Logger.log(Logger.SWF_ADDRESS,"nextStoryState",nextStoryState);
						_smController.start({module:nextStory,footerBar: _nav.footer.progressBar,selectedState:nextStoryState});
/*				
					} 
					else{
						var mod:ModuleModel = UserModel.getModuleStats(nextStory);
						mod.accuracy = 72;
						mod.correct = 17;
						mod.total = 19;
						mod.speed = 1.4;
						mod.starBonus = 0;
						
						onStateMachineEnd(new ObjectEvent(Flags.STATE_MACHINE_END,{
							correctAnswers:"33",
							totalQuestions:"57",
							cprAccuracy:"82",
							speedAnswers:"2.2"
						}));
					}
//*/
				}else{
					Logger.log(Logger.SWF_ADDRESS, "goModule: Scene Selector Questions");
					BackendResponder.apiLog("/ls6/scene_selector");
					_smController.startQuestions();
				}
		}
		
		
		protected function onBeginModuleQuestions( evt : SceneSelectorEvent):void
		{
			var id : int = evt.id ;
			_nav.removeCurrentOverlay();	
				
			DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onStateMachineEnd);
			
			BackendResponder.apiLog("ls6/scene/"+id);
			_smController.questionSelected( id ) ; 	
			AppSettings.stage.focus = AppSettings.stage ; 
		}
		
		
		protected function onStateMachineEnd(evt:ObjectEvent):void{
			lastMajor = AppSections.RESULTS;
			var obj:Object = evt.object;
			obj.cprAccuracy = obj.cprAccuracy == null ? 0 : int(obj.cprAccuracy);
			UserModel.setModuleComplete(_nextStory,obj.cprAccuracy);
		//	_results = new ClassFactory.RESULTS();
			addOverlay(AppSections.RESULTS.split(":")[1]);
			DispatchManager.addEventListener(Results.CONTINUE,onResultsContinue);
		//	_ui.addChild(_results);
		}
		
		protected function onResultsContinue(evt:Event):void{
			if(UserModel.getModuleStats(3).isComplete){
				DispatchManager.removeEventListener(Results.CONTINUE,onResultsContinue);
				setSWFAddress(AppSections.PROFILE);
			}else{
				_nav.showMenu();
			}
		}


		/*
		 * 
		 * SWF ADDRESS
		 * 
		 * 
		 */
		protected function initSWFAddress():void
		{
            SWFAddress.addEventListener(SWFAddressEvent.INIT, handleSWFAddress);
            SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
        }
		
		public function setSWFAddress(path:String='', depth:int=0):void {
			path = path.split(":")[1];
			var value:String = path;
         /*   if (scope.currentState != '' && scope.currentState != null) {
                value += scope.currentState.toLowerCase();
            }*/
          Logger.log(Logger.SWF_ADDRESS,"VALUE: "+value+" path: "+SWFAddress.getPathNames()[depth]+" LAST MAJOR: "+lastMajor);
		  if (value != SWFAddress.getPathNames()[depth] || path == AppSections.INTRO) {
                Logger.log(Logger.SWF_ADDRESS,"VALUE: "+value);
			    var parts:Array = new Array();
                if (path != '') parts.push(path);
              //  if (value != '') parts.push(value);
                SWFAddress.setValue('/' + parts.join('/'));
            }
        }
        
        protected function handleSWFAddress(event:SWFAddressEvent, depth:int=0):void {
       /*     var value:String = toTitleCase(event.pathNames.length > depth ? event.pathNames[depth] : '');
              if (scope.currentState != value) {
                scope.currentState = value;
            } */
            var title:String = 'LifeSaver';
			var titleArray:Array;
			var j:int,len:int;
            for (var i:int = 0; i < event.pathNames.length; i++) {
				titleArray = event.pathNames[i].split("_");
                title += ' » ';
				for(j = 0, len = titleArray.length; j < len; ++j){
					title += toTitleCase(titleArray[j]) + " ";
				}
            }
            SWFAddress.setTitle(title);
			
			if(event.pathNames[0] == undefined){
				if(SWFAddress.getPath() == "/"){
					if(!_quickSM){
						//	createIntro();
						setSWFAddress(AppSections.INTRO);
					}else{
						setSWFAddress(AppSections.MODULE_LS1);
					}
					return;
				}
			}
			setState(event.pathNames);
        }
		
		public static function toTitleCase(str:String):String {
            return str.substr(0,1).toUpperCase() + 
                str.substr(1).toLowerCase();
        }
	}
}

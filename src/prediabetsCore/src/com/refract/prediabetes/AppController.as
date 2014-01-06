package com.refract.prediabetes 
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.greensock.TweenMax;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.nav.Header;
	import com.refract.prediabetes.nav.Nav;
	import com.refract.prediabetes.nav.events.FooterEvent;
	import com.refract.prediabetes.sections.intro.Intro;
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.SMView;
	import com.refract.prediabetes.stateMachine.events.BooleanEvent;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.stateMachine.sound.SoundMachine;
	import com.refract.prediabetes.video.VideoLoader;
	import com.robot.comm.DispatchManager;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

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
		
		protected var _nextStory:int = -1 ;
		public function get nextStory():int {return _nextStory;}
		public function set nextStory(story:int):void { _nextStory = story;}
		
		protected var _stories:Array = 
		[
			""
			,AppSections.MODULE_LS1
			, AppSections.MODULE_LS2
			, AppSections.MODULE_LS3
		];
		
		protected var _interactiveSections:Array = 
		[
			AppSections.MODULE_LS1
			, AppSections.MODULE_LS2
			, AppSections.MODULE_LS3
			, AppSections.FEEDBACK
		];
		
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
			createUI();
			createNav();
			createStateMachine();		
			
			DispatchManager.addEventListener( Flags.DRAW_VIDEO_STATUS ,onDrawVideoStatus  ) ;
			DispatchManager.addEventListener(Flags.START_MOVIE , onStartMovie  );
			DispatchManager.addEventListener(Flags.APP_ACTIVATE, onAppActivated);
			DispatchManager.addEventListener(Flags.APP_DEACTIVATE, onAppDeactivated);
			
			initSWFAddress();
		}
		
		protected function createStateMachine() : void
		{
			//*state machine main view
			_smView = new ClassFactory.SM_VIEW();
			_main.addChildAt( _smView, 0 );
			//*state machine engine			
			_smController = new ClassFactory.SM_CONTROLLER();
			
		}
		
		protected function createUI():void
		{
			_ui = new Sprite();
			_main.addChild(_ui);
			
			
			AppSettings._stageCoverCopy = TextManager.makeText("full_screen_blocker",null,{fontSize:24,align:"center"});
			_main.stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFSChange);
		}
		
		protected function onFSChange(evt:FullScreenEvent):void
		{
			if(evt.fullScreen && _interactiveSections.indexOf("SECTION:"+currentPath[0]) != -1){
				DispatchManager.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, fsAcceptedOrNot);
				
				AppSettings.checkFSStatus();
			}
		}
		
		protected function fsAcceptedOrNot(evt:Event):void{
			DispatchManager.removeEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, fsAcceptedOrNot);
			
		}
		
		protected function createNav():void{
			_nav = new ClassFactory.NAV();
			_main.addChild(_nav);
			DispatchManager.addEventListener(Nav.NO_MORE_OVERLAYS,onNoMoreOverlays);

		}
			
		protected function onAppActivated(evt:Event = null):void{
			TweenMax.resumeAll();
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.FOOTER_CLICKED,{value:Header.LS_LOGO}));
			
			if(VideoLoader.i){
				VideoLoader.i.reattachStageVideo();
			}
		}
		
		protected function onAppDeactivated(evt:Event = null):void
		{
			TweenMax.pauseAll(true,true,true);
		}	
			

			
		protected function createSoundMachine() : void {
			new SoundMachine() ; 
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
				
				switch("SECTION:"+path[0])
				{
					case(AppSections.MODULE_LS1):
					case(AppSections.MODULE_LS2):
					case(AppSections.MODULE_LS3):
					
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
					
					
					
					
					case(AppSections.FEEDBACK):
					case(AppSections.LEGAL):
					case(AppSections.SHARE):
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
				currentPath = path.concat();
				previousPath = currentPath;
				
			}
		}

		protected function removeCurrentSection():void{
			switch("SECTION:"+currentPath[0]){
				case(AppSections.INTRO):
					destroyIntro();
					break;
				case(AppSections.MODULE_LS1):
				case(AppSections.MODULE_LS2):
				case(AppSections.MODULE_LS3):
					//story, do nothing
					break;
				
				case(AppSections.FEEDBACK):
				case(AppSections.LEGAL):
				case(AppSections.SHARE):
				case(AppSections.BOOK_A_COURSE):
					
					//overlay, do nothing
					break;
			}
			AppSettings.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ;
		}

		protected function addOverlay(path:String,suppressAnim:Boolean = false) : void 
		{
			_nav.addSection(path,suppressAnim);
		}
		
		
		protected function onNoMoreOverlays(evt:Event):void
		{
			var out:String = "";
			out = lastMajor;
			setSWFAddress("SECTION:"+lastMajor);
		}

		protected function createIntro():void
		{
			if(!_intro)
			{
				_nextStory = -1;
				DispatchManager.dispatchEvent(new Event(Flags.SM_RESET));
				DispatchManager.dispatchEvent( new Event( Flags.SM_KILL ) ) ; 
				VideoLoader.i.stopVideo();
				_intro  = new ClassFactory.INTRO();
				_status = AppSections.INTRO;
				_ui.addChild(_intro);
				DispatchManager.dispatchEvent(new Event(Flags.HIDE_FOOTER_PLAY_PAUSE));
			}
			else
			{
				DispatchManager.dispatchEvent(new Event(Flags.UN_FREEZE));
			}
		//	_nav.addOverlay(ClassFactory.INTRO);
		}		
		
		
		private function onStartMovie( evt : Event ) : void
		{
			setSWFAddress(_stories[ 1 ]);
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

		protected function onSignUpEnded(evt:Event):void
		{
			var ns:int = nextStory;
			
			if(ns == -1)
			{
				setSWFAddress(AppSections.INTRO);
			}
			else
			{
				setSWFAddress(_stories[ns]);
			}
		}

		protected function beginModule(module:int = -1, scene:String = null):void{
			var paths:Array = SWFAddress.getPathNames();
			var story:int = _stories.indexOf("SECTION:"+paths[0]);
			if(nextStory != story || paths.length > 1 || scene != null)
			{
				nextStory = story;
				if(scene == null)
				{
					nextStoryState = paths.length > 1 ? (paths[1] == "null" ? null : paths[1]) : null;	
				}
				else
				{
					nextStoryState = scene;
				}
			
				_status = paths[0];
			
				_nav.removeCurrentOverlay();
				destroyIntro();
				DispatchManager.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, goModule);
				AppSettings.checkFSStatus();
			}
		}
		
		protected function goModule(evt:Event):void
		{
				DispatchManager.removeEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, goModule);
				if(nextStory != 4)
				{				
					DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onStateMachineEnd);	
					_smController.start({module:nextStory,footerBar: _nav.footer.progressBar,selectedState:nextStoryState});

				}

		}
		
		
		protected function onStateMachineEnd(evt:ObjectEvent):void
		{	
			trace('::onStateMachineEnd::')
		}
		


		/*
		 * 
		 * SWF ADDRESS
		 * 
		 * 
		 */
		protected function initSWFAddress():void
		{
            SWFAddress.addEventListener(SWFAddressEvent.INIT , handleSWFAddress);
            SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
        }
		
		public function setSWFAddress(path:String='', depth:int=0):void 
		{
			path = path.split(":")[1];
			var value:String = path;

		  	if (value != SWFAddress.getPathNames()[depth] || path == AppSections.INTRO) 
			{
			    var parts:Array = new Array();
                if (path != '') parts.push(path);
                SWFAddress.setValue('/' + parts.join('/'));
            }
        }
        
        protected function handleSWFAddress(event:SWFAddressEvent, depth:int=0):void 
		{
            //SWFAddress.setTitle(title);
			
			if(event.pathNames[0] == undefined)
			{
				if(SWFAddress.getPath() == "/")
				{
					setSWFAddress(AppSections.INTRO);
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

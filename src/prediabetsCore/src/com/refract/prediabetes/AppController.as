package com.refract.prediabetes 
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.greensock.TweenMax;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.nav.Header;
	import com.refract.prediabetes.nav.Nav;
	import com.refract.prediabetes.nav.events.FooterEvent;
	import com.refract.prediabetes.sections.intro.Intro;
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.SMSettings;
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

	public class AppController 
	{ 	
		private static var _i:AppController;
		
		private var _status:String;
		private var _main : PrediabetesCore ;
		private var _nav : Nav;
		private var _intro : Intro;
		private var _ui:Sprite;
		private var _smView : SMView;
		private var _smController : SMController;
		
		private var currentPath:Array = ["iAmNotAPath"];
		private var previousPath:Array = ["iAmNotAPath"];
		private var lastMajor:String = ""; 
		
		public function AppController( main : PrediabetesCore)
		{
			_i = this;
			_main = main ; 
		}
		
		//**init
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

		//**Create Interactive Movie Manager ( StateMachine ) 
		private function createStateMachine() : void
		{
			//*state machine main view
			_smView = new ClassFactory.SM_VIEW();
			_main.addChildAt( _smView, 0 );
			//*state machine engine			
			_smController = new ClassFactory.SM_CONTROLLER();
			
		}
		
		//**Create UI
		private function createUI():void
		{
			_ui = new Sprite();
			_main.addChild(_ui);
			
			_main.stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFSChange);
		}
		
		//**FS management
		private function onFSChange(evt:FullScreenEvent):void
		{
			if(evt.fullScreen )
			{
				trace('FS CHange :' , evt.fullScreen)
			}
		}
		
		//**Create Nav
		private function createNav():void{
			_nav = new ClassFactory.NAV();
			_main.addChild(_nav);
			DispatchManager.addEventListener(Nav.NO_MORE_OVERLAYS,onNoMoreOverlays);

		}
			
		//**on App Active and Deactive
		private function onAppActivated(evt:Event = null):void{
			TweenMax.resumeAll();
			
			if(VideoLoader.i){
				VideoLoader.i.reattachStageVideo();
			}
		}
		
		private function onAppDeactivated(evt:Event = null):void
		{
			TweenMax.pauseAll(true,true,true);
		}	
			
		//Create Sound Manager
		private function createSoundMachine() : void {
			new SoundMachine() ; 
		}
		
		//**Space bar clicked		
		private function onKeyDown(event : KeyboardEvent) : void {
			if( event.charCode == Keyboard.SPACE)
			{
				if( VideoLoader.i)
				{
					VideoLoader.i.onSpaceBarClicked() ; 
				}
			}
		}
		
		private function setState(path:Array,checkFS:Boolean = true):void {
			if(currentPath[0] != path[0] || path[0] == AppSections.INTRO.split(":")[1]){
				
				switch("SECTION:"+path[0])
				{
					case(AppSections.INTERACTIVE_MOVIE):
					
						removeCurrentSection();	
						
						if(lastMajor != path[0]){
							AppSettings.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ; 
							lastMajor = path[0];
							beginModule();
							AppSettings.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ;
						}
						 
						break;
	
					case(AppSections.START_AGAIN):
					case(AppSections.LEGAL):
					case(AppSections.SHARE):
					case(AppSections.FIND_OUT_MORE):
						addOverlay(path[0]);
						AppSettings.stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ;
						break;
					case(AppSections.INTRO):
					default://intro is default state so no break
						lastMajor = path[0];
						removeCurrentSection();	
						createIntro();
						AppSettings.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ;
				}
				currentPath = path.concat();
				previousPath = currentPath;
				
			}
		}

		private function removeCurrentSection():void{
			switch("SECTION:"+currentPath[0]){
				case(AppSections.INTRO):
					destroyIntro();
					break;
				case(AppSections.INTERACTIVE_MOVIE):
					//story, do nothing
					break;
				
				case(AppSections.START_AGAIN):
				case(AppSections.LEGAL):
				case(AppSections.SHARE):
				case(AppSections.FIND_OUT_MORE):
					
					
					break;
			}
			AppSettings.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown ) ;
		}

		private function addOverlay(path:String ) : void 
		{
			_nav.addSection( path );
		}
		
		
		private function onNoMoreOverlays(evt:Event):void
		{
			var out:String = "";
			out = lastMajor;
			setSWFAddress("SECTION:"+lastMajor);
		}

		private function createIntro():void
		{
			if(!_intro)
			{
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
			setSWFAddress( AppSections.INTERACTIVE_MOVIE );
		}
		
		private function destroyIntro():void{
			if(_intro){
				_intro.destroy();
				_ui.removeChild(_intro);
				_intro = null;
			}
		}
		
		private function onDrawVideoStatus( evt : BooleanEvent) : void
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


		private function beginModule( ):void
		{
			var paths:Array = SWFAddress.getPathNames();
			_status = paths[0];
			_nav.removeCurrentOverlay();
			destroyIntro();
			goModule() ; 
		}
		
		private function goModule( ):void
		{				
			DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onStateMachineEnd);	
			
			if( !SMSettings.DEBUG_GET_CLIP_LENGTH)
				_smController.start();
			else
				_smController.startGetClipLength() ; 
		}
		
		
		private function onStateMachineEnd(evt:ObjectEvent):void
		{	
		}
		


		//**SWFADDRESS 
		private function initSWFAddress():void
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
        
        private function handleSWFAddress(event:SWFAddressEvent, depth:int=0):void 
		{
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
		

		
		//**GET AND SET
		public static function get i():AppController
		{
			return _i;
		}
		public function get nav():Nav 
		{
			return _nav;
		}
		
		/*
		public function get nextStoryState() : String 
		{ 
			return _nextStoryState; 
		}
		public function set nextStoryState(nextStoryState : String) : void 
		{ 
			_nextStoryState = nextStoryState; 
		}
		
		public function get nextStory():int 
		{
			return _nextStory;
		}
		public function set nextStory(story:int):void 
		{ 
			_nextStory = story;
		}
		 * 
		 */
		
	}
}

package com.refract.prediabetes.sections {
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;

	public class Intro extends Sprite 
	{
		private const _intro_length : int = 38266 ; 
		public function Intro() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			/*	
			setVideo();
			createSkipButton() ; 
			
			//DispatchManager.addEventListener(Intro.INTRO_VIDEO_PAUSE , onIntroPause );
			//DispatchManager.addEventListener(Intro.INTRO_VIDEO_UNPAUSE , onIntroResume );
			
			DispatchManager.addEventListener(Flags.FREEZE, onFreeze);
			DispatchManager.addEventListener(Flags.UN_FREEZE, onUnFreeze);
			*/
			
			onIntroEnded() ; 
		}
		/*
		private function onFreeze(event : Event) : void 
		{
			if( !VideoLoader.i.paused ) 
			{
				VideoLoader.i.pauseVideo() ; 
			}	
		}

		private function onUnFreeze(event : Event) : void 
		{
			if( VideoLoader.i.paused ) 
			{
				//_videoFreeze = true ; 
				VideoLoader.i.resumeVideo() ; 
			}	
		}
		 
		
		private function createSkipButton() : void
		{
			var skipButton : Box = new Box( 20 , 20 , 0xff0099 ) ; 
			addChild( skipButton ) ; 
			skipButton.addEventListener( MouseEvent.MOUSE_DOWN , onSkipPress ) ; 
		}
		* 
		 */
		
		/*
		private function setVideo():void
		{	
			DispatchManager.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			if( VideoLoader.i) 
				VideoLoader.i.update( AppSettings.INTRO_URL );	
			
			if( VideoLoader.i )
				 VideoLoader.i.activateClickPause();
		}
		 * 
		 */

		//*  LISTENERS	
		/*	 
		private function onSkipPress(event : MouseEvent) : void 
		{
			DispatchManager.dispatchEvent(new Event(Flags.START_MOVIE));
		}
		
		protected function onNetStatus(event:NetStatusEvent):void{
			switch (event.info.code) 
		    { 
				case "NetStream.Play.Stop":
		        case "NetStream.Buffer.Empty": 
					endIntro();
		            break; 
		    } 
		}
		
		protected function endIntro():void{
			DispatchManager.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			onIntroEnded() ;
		}
		 * 
		 */

		protected function onIntroEnded( ) : void 
		{
			DispatchManager.dispatchEvent(new Event(Flags.START_MOVIE));
		}

		
		public function destroy() : void 
		{
		    //DispatchManager.removeEventListener( NetStatusEvent.NET_STATUS,onNetStatus);
			
			//VideoLoader.i.pauseVideo();
			//removeChildren();
		}
	}
}

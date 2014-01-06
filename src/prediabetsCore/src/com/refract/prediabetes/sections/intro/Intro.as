package com.refract.prediabetes.sections.intro {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.nav.events.MenuEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.video.VideoLoader;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Box;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;

	/**
	 * @author kanish
	 */
	public class Intro extends Sprite 
	{
		public static const INTRO_VIDEO_PAUSE:String = "INTRO_VIDEO_PAUSE";
		public static const INTRO_VIDEO_UNPAUSE : String = "INTRO_VIDEO_UNPAUSE";
		
		public function Intro() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);	
			setVideo();
			createSkipButton() ; 
			
			DispatchManager.addEventListener(Intro.INTRO_VIDEO_PAUSE , onIntroPause );
			DispatchManager.addEventListener(Intro.INTRO_VIDEO_UNPAUSE , onIntroResume );
			
		}
		private function createSkipButton() : void
		{
			var skipButton : Box = new Box( 20 , 20 , 0xff0099 ) ; 
			addChild( skipButton ) ; 
			skipButton.addEventListener( MouseEvent.MOUSE_DOWN , onSkipPress ) ; 
		}

		

		protected function setVideo():void
		{	
			DispatchManager.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			if( VideoLoader.i) 
				VideoLoader.i.update( AppSettings.INTRO_URL );	
			
			if( VideoLoader.i )
				 VideoLoader.i.activateClickPause();
				 
			//DispatchManager.addEventListener(INTRO_VIDEO_PAUSE, onVideoClick);
			//DispatchManager.addEventListener(INTRO_VIDEO_UNPAUSE, onVideoClick);
			
		}

		/*
		 *  LISTENERS
		 */
		 
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
		private function onIntroPause( evt : Event ) : void
		{
			VideoLoader.i.pauseVideo();
		}
		private function onIntroResume( evt : Event ) : void
		{
			VideoLoader.i.resumeVideo() ; 
		}
		
		protected function endIntro():void{
			DispatchManager.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			onIntroEnded() ;
		}

		protected function onIntroEnded(evt : MenuEvent = null) : void 
		{
			DispatchManager.dispatchEvent(new Event(Flags.START_MOVIE));
		}

		
		public function destroy() : void 
		{
		    DispatchManager.removeEventListener( NetStatusEvent.NET_STATUS,onNetStatus);
			
			VideoLoader.i.pauseVideo();
			removeChildren();
		}
	}
}

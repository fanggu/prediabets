package com.refract.air.shared.prediabetes.nav.footer {
	import com.greensock.TweenMax;
	import com.refract.air.shared.AppSettingsIOS;
	import com.refract.prediabetes.nav.footer.PlayPauseButton;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	/**
	 * @author otlabs
	 */
	public class PlayPauseButtonIOS extends PlayPauseButton {
		public function PlayPauseButtonIOS() 
		{
			super();
		}
		override protected function init( evt : Event = null ) : void
		{
			_fixHitArea_w = 20 ;
			_fixHitArea_x = 5 ;  
			super.init( evt ) ; 	
			
			this.y = AppSettingsIOS.VIDEO_NAV_FIX_PAUSE_POS_Y ; 	
		}
		override protected function createState() : void
		{
			playBtn = new Sprite( ) ; 
			var l1 : Loader = new Loader();
			l1.load(new URLRequest("img/play_retina.png"));
			playBtn.addChild( l1 );
			addChild( playBtn ) ; 
			
			//pauseBtn = AssetManager.getEmbeddedAsset("Pause");
			
			pauseBtn = new Sprite( ) ; 
			var l2 : Loader = new Loader();
			l2.load(new URLRequest("img/pause_retina.png"));
			pauseBtn.addChild( l2 );
			addChild( pauseBtn ) ;
			 
			w = 30 ; 
			h = 36 ; 
		}
		override protected function onOverOut(evt:MouseEvent):void{
			if(evt.type == MouseEvent.MOUSE_OVER){
				DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralRollover") );
				TweenMax.to(this,0.5,{tint:SMSettings.CHOICE_BACK_COLOR });	
				
			}else{
				TweenMax.to( this , 0.3 , { tint:null } ) ;
			}
		}
	}
}

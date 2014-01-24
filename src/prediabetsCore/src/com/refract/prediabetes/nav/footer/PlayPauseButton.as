package com.refract.prediabetes.nav.footer {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.stateMachine.events.BooleanEvent;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class PlayPauseButton extends Sprite {
		
		protected var pauseBtn:*;
		protected var playBtn:*;
		
		public var id : String;
		private var _fixHitArea_w : int;
		private var _fixHitArea_h : int;
		
		
		public function PlayPauseButton() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		protected function init( evt : Event = null ) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_fixHitArea_w = 10 ; 
			_fixHitArea_h = 10 ; 
			
			createState() ; 
			pauseBtn.y = playBtn.height/2 - pauseBtn.height/2;
			addEventListener(MouseEvent.MOUSE_OUT, onOverOut);
			addEventListener(MouseEvent.MOUSE_OVER, onOverOut);
			addEventListener(MouseEvent.CLICK, onClick);
			mouseChildren = false;
			useHandCursor = true;
			buttonMode = true;
			graphics.beginFill(0xff0000,1 ) ;
			if(AppSettings.DEVICE == AppSettings.DEVICE_PC)
			{
				graphics.drawRect( -_fixHitArea_w / 2 , _fixHitArea_h / 2 , width + _fixHitArea_w , height + _fixHitArea_h );
			}
			else
			{
				graphics.drawRect( 0 , 0  , width  , height ) ;	
			}
			
			DispatchManager.addEventListener(Flags.FREEZE,onFreezeUnFreeze);
			DispatchManager.addEventListener(Flags.UN_FREEZE,onFreezeUnFreeze);
			DispatchManager.addEventListener(Flags.UPDATE_PLAY_BUTTON, onUpdatePlayButton) ;
			
			scaleX = scaleY = AppSettings.FONT_SCALE_FACTOR;
		}
		protected function createState() : void
		{
			pauseBtn = AssetManager.getEmbeddedAsset("Pause");
			playBtn = AssetManager.getEmbeddedAsset("Play");
			pauseBtn.smoothing = true;
			playBtn.smoothing = true;
			
			TweenMax.to(pauseBtn,0,{tint:AppSettings.GREY});
			addChild(pauseBtn);
			
			TweenMax.to(playBtn,0,{tint:AppSettings.GREY});
			playBtn.scaleX = playBtn.scaleY = pauseBtn.width/playBtn.width;
			addChild(playBtn);
			playBtn.visible = false;
			
		}
		
		private function onOverOut(evt:MouseEvent):void{
			if(evt.type == MouseEvent.MOUSE_OVER){
				DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralRollover") );
				TweenMax.to(this,0.5,{tint:AppSettings.WHITE});	
			}else{
				TweenMax.to(this,0.5,{tint:null});
			}
		}
		
		private function onClick(evt:MouseEvent):void{
			DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndGeneralClick") );	
			if(pauseBtn.visible)
			{
				DispatchManager.dispatchEvent(new Event(Flags.FREEZE));
			}
			else
			{
				DispatchManager.dispatchEvent(new Event(Flags.UN_FREEZE));
			}
		}
		
		private function onFreezeUnFreeze(evt:Event):void
		{
			pauseBtn.visible = false ; 
			playBtn.visible = false ; 
			if(evt.type == Flags.FREEZE)
			{
				playBtn.visible = true ; 
			}
			else
			{
				pauseBtn.visible = true ;
			}
			/*
			if(evt.type == Flags.FREEZE)
			{
				
				TweenMax.to(pauseBtn,0,{autoAlpha:0});
				TweenMax.to(playBtn,0,{autoAlpha:1});
			}else{
				TweenMax.to(pauseBtn,0,{autoAlpha:1});
				TweenMax.to(playBtn,0,{autoAlpha:0});
			}
			 * 
			 */
		}
		private function onUpdatePlayButton( evt : BooleanEvent ) : void
		{
			pauseBtn.visible = false ; 
			playBtn.visible = false ; 
			if( !evt.value )
			{
				playBtn.visible = true ; 
			}
			else
			{
				pauseBtn.visible = true ; 
			}
			
		}
		
	}
}

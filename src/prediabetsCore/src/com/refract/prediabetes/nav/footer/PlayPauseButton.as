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
		
		private var pauseBtn:Bitmap;
		private var playBtn:Bitmap;
		
		public var id:String;
		
		
		public function PlayPauseButton() {
			pauseBtn = AssetManager.getEmbeddedAsset("Pause");
			pauseBtn.smoothing = true;
			TweenMax.to(pauseBtn,0,{tint:AppSettings.GREY});
			addChild(pauseBtn);
			
			
			playBtn = AssetManager.getEmbeddedAsset("RedArrow");
			playBtn.smoothing = true;
			TweenMax.to(playBtn,0,{tint:AppSettings.GREY});
			playBtn.scaleX = playBtn.scaleY = pauseBtn.width/playBtn.width;
			addChild(playBtn);
			playBtn.visible = false;

			pauseBtn.y = playBtn.height/2 - pauseBtn.height/2;
			
			this.addEventListener(MouseEvent.MOUSE_OUT, onOverOut);
			this.addEventListener(MouseEvent.MOUSE_OVER, onOverOut);
			this.addEventListener(MouseEvent.CLICK, onClick);
			mouseChildren = false;
			useHandCursor = true;
			buttonMode = true;
			
			this.graphics.beginFill(0xff0000,AppSettings.BUTTON_HIT_AREA_ALPHA);
			if(AppSettings.PLATFORM == AppSettings.PLATFORM_PC){
				graphics.drawRect(0,0,width,height);
			}else{
				this.graphics.drawRect(-AppSettings.BUTTON_HIT_AREA_EDGE,-AppSettings.BUTTON_HIT_AREA_EDGE,width+AppSettings.BUTTON_HIT_AREA_WIDTH,height+AppSettings.BUTTON_HIT_AREA_WIDTH);
			}
			
			DispatchManager.addEventListener(Flags.FREEZE,onFreezeUnFreeze);
			DispatchManager.addEventListener(Flags.UN_FREEZE,onFreezeUnFreeze);
			DispatchManager.addEventListener(Flags.UPDATE_PLAY_BUTTON, onUpdatePlayButton) ;
			
			this.scaleX = this.scaleY = AppSettings.FONT_SCALE_FACTOR;
			
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
			}else{
				DispatchManager.dispatchEvent(new Event(Flags.UN_FREEZE));
			}
		}
		
		private function onFreezeUnFreeze(evt:Event):void
		{
			if(evt.type == Flags.FREEZE){
				//TweenMax.to(pauseBtn,0.5,{autoAlpha:0});
				TweenMax.to(pauseBtn,0,{autoAlpha:0});
				//TweenMax.to(playBtn,0.5,{autoAlpha:1});
				TweenMax.to(playBtn,0,{autoAlpha:1});
			}else{
				//TweenMax.to(pauseBtn,0.5,{autoAlpha:1});
				TweenMax.to(pauseBtn,0,{autoAlpha:1});
				//TweenMax.to(playBtn,0.5,{autoAlpha:0});
				TweenMax.to(playBtn,0,{autoAlpha:0});
			}
		}
		private function onUpdatePlayButton( evt : BooleanEvent ) : void
		{
			if( !evt.value )
			{
				TweenMax.to(pauseBtn,0,{autoAlpha:0});
				TweenMax.to(playBtn,0,{autoAlpha:1});
			}
			else
			{
				TweenMax.to(pauseBtn,0,{autoAlpha:1});
				TweenMax.to(playBtn,0,{autoAlpha:0});
			}
		}
		
	}
}

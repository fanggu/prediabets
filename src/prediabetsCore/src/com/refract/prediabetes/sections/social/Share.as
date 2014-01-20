package com.refract.prediabetes.sections.social {
	import com.refract.prediabetes.AppSettings;

	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class Share extends Sprite 
	{	
		private var _shareBar:ShareBar;
		
		public function Share() {
			super();
			
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			_shareBar = new ShareBar("page_share_title","page_share_subheading");
			addChild(_shareBar);
			_shareBar.facebook.addEventListener(MouseEvent.CLICK, onSocialClick);
			_shareBar.twitter.addEventListener(MouseEvent.CLICK, onSocialClick);
			_shareBar.google.addEventListener(MouseEvent.CLICK, onSocialClick);
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
			
			
		}

		private function onSocialClick(evt:MouseEvent):void
		{
			var social:String = "";
			switch(evt.currentTarget)
			{
				case(_shareBar.facebook):
					social = "facebook";
				break;
				case(_shareBar.twitter):
					social = "twitter";
				break;
				case(_shareBar.google):
					social = "google";
				break;
			}
			if(stage.displayState != StageDisplayState.NORMAL)
			{
				stage.displayState = StageDisplayState.NORMAL;
			}
			//BackendResponder.share(social);
		}

		private function onResize(evt:Event = null):void{
			
			this.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;
			this.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - this.height/2;
		}
		
		public function destroy():void{
			stage.removeEventListener(Event.RESIZE, onResize);
			
			
			_shareBar.facebook.removeEventListener(MouseEvent.CLICK, onSocialClick);
			_shareBar.twitter.removeEventListener(MouseEvent.CLICK, onSocialClick);
			_shareBar.google.removeEventListener(MouseEvent.CLICK, onSocialClick);
			
			_shareBar.destroy();
			
			removeChildren();
		}
	}
}
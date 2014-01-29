package com.refract.prediabetes.sections 
{
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.view.buttons.ButtonChoice;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	public class Share extends Sprite 
	{
		private var _bodyTitleStyle : Object;
		public function Share() 
		{
			name = 'SHARE' ; 
			super();
			
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			var interaction : Object ;
			_bodyTitleStyle =  {fontSize:24, autoSize:"left", selectable:true, wordWrap: false, multiline:false, width:500 } ;
			var bodyTitle : TextField = TextManager.makeText("page_share_title" , this , _bodyTitleStyle);
			bodyTitle.y = -50 ;
			if( AppSettings.RETINA )
				bodyTitle.y = -100 ;  
			
			  
			var shareFacebookButton : ButtonChoice= new ButtonChoice( SMSettings.FONT_BUTTON, { fontSize:26  }, SMSettings.MIN_BUTTON_SIZE, 70  , false , false);
			addChild( shareFacebookButton ) ; 
			interaction = SMController.me.model.shareButtonFacebookState ; 
			interaction.iter = 'facebook'; 
			interaction.external = true ; 
			shareFacebookButton.visible = true ; 
			shareFacebookButton.setButton( interaction ) ; 
			shareFacebookButton.addEventListener(MouseEvent.CLICK, onSharePress);
			
			var shareTwitterButton : ButtonChoice= new ButtonChoice( SMSettings.FONT_BUTTON, { fontSize:26  }, SMSettings.MIN_BUTTON_SIZE, 70  , false , false);
			addChild( shareTwitterButton ) ; 
			interaction = SMController.me.model.shareButtonTwitterState ; 
			interaction.iter = 'twitter'; 
			interaction.external = true ; 
			shareTwitterButton.visible = true ; 
			shareTwitterButton.setButton( interaction ) ; 
			shareTwitterButton.addEventListener(MouseEvent.CLICK, onSharePress);
			var spacer : int = 10 ;
			if( AppSettings.RETINA ) spacer = spacer * 2 ; 
			shareTwitterButton.y = shareFacebookButton.y + shareFacebookButton.height + spacer ; 
			
			var shareGoogleButton : ButtonChoice= new ButtonChoice( SMSettings.FONT_BUTTON, { fontSize:26  }, SMSettings.MIN_BUTTON_SIZE, 70  , false , false);
			addChild( shareGoogleButton ) ; 
			interaction = SMController.me.model.shareButtonGoogleState ; 
			interaction.iter = 'google'; 
			interaction.external = true ; 
			shareGoogleButton.visible = true ; 
			shareGoogleButton.setButton( interaction ) ; 
			shareGoogleButton.addEventListener(MouseEvent.CLICK, onSharePress); 
			shareGoogleButton.y = shareTwitterButton.y + shareTwitterButton.height + spacer ; 
			
			bodyTitle.x = this.width / 2 - bodyTitle.width/2; 
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		private function onSharePress(event : MouseEvent) : void 
		{
			switch( event.target.name)
			{
				case 'facebook' : 
					trace('-facebook-')
				break ;
				case 'twitter' : 
					trace('-twitter-')
				break ;
				case 'google' : 
					trace('-google-')
				break ;
				default :
					trace('default')
			}
		}


		private function onResize(evt:Event = null):void{
			
			this.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2 - this.width / 2 ;
			this.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - this.height/2;
		}
		
		public function destroy():void{
			stage.removeEventListener(Event.RESIZE, onResize);
			var i : int = 0 ;
			var l : int = this.numChildren ; 
			for( i = 0 ; i < l ; i ++ )
			{
				var child : * = this.getChildAt( 0 ) ; 
				try
				{
					child.dispose() ;
				}catch( e: * ){}
				this.removeChild( child ) ; 
			}
			
		}
	}
}

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
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	public class Share extends Sprite 
	{
		private var _bodyTitleStyle : Object;
		private var videoInfo : Object;
		private var address : String;
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
			
			//**test
			videoInfo ={} ; 
			address ='ciao' ; 
		}

		private function onSharePress(event : MouseEvent) : void 
		{
			switch( event.target.name)
			{
				case 'facebook' : 
					
					shareFB() ; 
				break ;
				case 'twitter' : 
					
					shareTwitter() ; 
				break ;
				case 'google' : 
					
					shareGoogle() ; 
				break ;
				default :
					trace('default')
			}
		}
		
		
		public function openPage(url:String, linkWindow:String = "_blank", popUpDimensions:Array = null):void 
		{
            if (linkWindow == "_popup" && ExternalInterface.available) {
                var dimensions:Array = [400,300];
                ExternalInterface.call("window.open('" + url + "','PopUpWindow','width=" + dimensions[0] + ",height=" + dimensions[1] + ",toolbar=yes,scrollbars=yes')");
            } else {
                // Use JS to bypass popup blockers if ExternalInterface is available
                var window:String = linkWindow == "_popup" ? "_blank" : linkWindow;
                if (ExternalInterface.available) {
                    ExternalInterface.call('window.open("' + url + '","' + window + '")');
                } else {
                    //request a blank page
                    navigateToURL(new URLRequest(url), window);
                }
            }
        }
		
		
		
		
		// FACEBOOK
        private function shareFB(e:Event = null ):void
        { 
            var p = {
			    "Look at details": {
			        "text": "here",
			        "href": "http://prediabetes.co.nz/"
			    }
			};
            //openPage("https://www.facebook.com/dialog/feed?app_id=639244382790610&display=popup&link=http://prediabetes.co.nz&picture=http://prediabetes.co.nz/img/fb_icon.JPG&name=Pre%20Diabetes%20-%20What%20you%20can%20do&caption=I%20just%20learned%20how%20to%20stop%20getting%20diabetes.%20It%27s%20easy%20and%20free.%20http://prediabetes.co.nz/&properties="+p+"&redirect_uri=" + AppSettings.SHARE_REDIRECT  , '_popup') ;
			//openPage("https://www.facebook.com/dialog/feed?app_id=639244382790610&display=popup&link=http://prediabetes.co.nz&picture=http://prediabetes.co.nz/img/fb_icon.JPG&name=Pre%20Diabetes%20-%20What%20you%20can%20do&caption=I%20just%20learned%20how%20to%20stop%20getting%20diabetes.%20It%27s%20easy%20and%20free.%20http://prediabetes.co.nz/&description=xxyyzz&properties="+p+"&redirect_uri=" + AppSettings.SHARE_REDIRECT  , '_popup') ;
			openPage("https://www.facebook.com/dialog/feed?app_id=639244382790610&display=popup&link=http://prediabetes.co.nz&picture=http://prediabetes.co.nz/img/fb_icon.JPG&name=Pre%20Diabetes%20-%20What%20you%20can%20do&caption=I%20just%20learned%20how%20to%20stop%20getting%20diabetes.%20It%27s%20easy%20and%20free.%20http://prediabetes.co.nz/&description=&redirect_uri=" + AppSettings.SHARE_REDIRECT  , '_popup') ; 
               
        }	
        
        // TWITTER
        private function shareTwitter(e:Event = null ):void
        {
            //openPage('https://twitter.com/intent/tweet?source=webclient&text=A+cool+video%3A+'+escape("http://flepstudio.org/utilita/VideoPlayer/IronMan2.mov"),"_popup");
            openPage('https://twitter.com/intent/tweet?text=I%20just%20learned%20how%20to%20stop%20getting%20diabetes.%20It%27s%20easy%20and%20free.%20%20&url=http%3A%2F%2Fprediabetes.co.nz' , "_popup" ) ; 
        }
        
        // MAIL
        private function shareMail(e:Event):void
        {
            var request:URLRequest = new URLRequest("mailto:"+address+"?subject="+videoInfo.videoTitle+"&body="+"\n\n Video Link: "+videoInfo.videoLink);            
            navigateToURL(request, "_self");
        }
        
        // TUMBLR
        private function shareTumblr(e:Event):void
        {
            openPage("http://www.tumblr.com/share/link?url=" + escape(videoInfo.videoLink) + "&name=" + escape(videoInfo.videoTitle) + "&description=" + escape(videoInfo.videoArtist),'_popup');
        }
        
        // STUMBLE UPON
        private function shareSU(e:Event):void
        {
            openPage("http://www.stumbleupon.com/submit?url="+escape(videoInfo.videoLink)+"&title="+escape(videoInfo.videoTitle));
        }
        
        // GOOGLE +
        private function shareGoogle(e:Event = null ):void
        {
            //openPage("https://m.google.com/app/plus/x/?v=compose&content="+escape(videoInfo.videoLink),"_popup");
            openPage('https://plus.google.com/share?text=ciaocioa&url=http%3A%2F%2Fprediabetes.co.nz' , "_popup") ; 
        }
        
        // LinkedIn
        private function shareLinkedIn(e:Event):void
        {
            openPage("http://www.linkedin.com/shareArticle?mini=true&url=CONTENT-URL&title="+escape(videoInfo.videoArtist)+"&summary="+escape(videoInfo.videoArtist)+"&source="+escape(videoInfo.videoTitle),'_popup');
        }
        
        // DIGG
        private function shareDigg(e:Event):void
        {
            openPage("http://digg.com/submit?phase=2&url="+escape(videoInfo.videoLink)+"&title="+escape(videoInfo.videoTitle)+"&bodytext="+''+"&topic="+escape(videoInfo.videoArtist));
        }
        
        //BEBO
        private function shareBebo(e:Event):void
        {
            openPage("http://www.bebo.com/c/share?Url="+escape(videoInfo.videoLink)+"&Title="+escape(videoInfo.videoTitle),'_popup');
        }
        
        //ORKUT
        private function shareOrkut(e:Event):void
        {   
            openPage("http://www.orkut.com/FavoriteVideos.aspx?u="+escape(videoInfo.videoLink),'_popup');
        }
        
        //REDDIT
        private function shareReddit(e:Event):void
        {
            openPage("http://www.reddit.com/submit?url="+escape(videoInfo.videoLink),'_popup');
        }
        
        // DELICIOUS
        private function shareDelicious(e:Event):void
        {
            openPage("http://www.delicious.com/save?v=5&jump=close&url="+escape(videoInfo.videoLink)+"&title="+escape(videoInfo.videoTitle));
        }
        
        // MYSPACE
        private function shareMySpace(e:Event):void
        {
            openPage("http://www.myspace.com/Modules/PostTo/Pages/?t="+escape(videoInfo.videoTitle)+"&c="+escape(videoInfo.videoArtist)+"&u="+escape(videoInfo.videoLink)+"&l="+escape(videoInfo.videoLink),'_popup');
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

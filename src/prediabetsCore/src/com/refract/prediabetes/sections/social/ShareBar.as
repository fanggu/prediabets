package com.refract.prediabetes.sections.social {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.LSButton;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class ShareBar extends Sprite {
		
		
		private var _facebook:LSButton;
		public function get facebook() : LSButton {return _facebook;}
		private var _twitter:LSButton;
		public function get twitter() : LSButton {return _twitter;}
		private var _google:LSButton;
		public function get google() : LSButton {return _google;}
		
		private var _titleID:String;
		private var _subTitleID:String;
		
		public function get barWidth():int { return _google.x + _google.width - _facebook.x;}
		
		public function ShareBar(titleID:String,subTitleID:String) {
			_titleID = titleID;
			_subTitleID = subTitleID;
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void{			
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			var tf:TextField;
			tf = TextManager.makeText(_titleID,this,{fontSize:72});
			tf.x = int(-tf.textWidth/2);
			
			tf = TextManager.makeText(_subTitleID,this,{fontSize:16});
			tf.x = int(-tf.textWidth/2);		
			tf.y = getChildAt(0).y + getChildAt(0).height + 12;
			
			var buttonStyle:Object = {fontSize:20};
			_facebook = new LSButton("signup_facebook",buttonStyle,140,54,true,false);
			_twitter = new LSButton("signup_twitter",buttonStyle,140,54,true,false);
			_google = new LSButton("signup_google",buttonStyle,140,54,true,false);
			
			_facebook.arrowAsset = "Facebook";
			_twitter.arrowAsset = "Twitter";
			_google.arrowAsset = "GooglePlus";
			
			_facebook.buttonAlpha = _twitter.buttonAlpha = _google.buttonAlpha = 0.1;
			_facebook.arrowScale = _twitter.arrowScale = _google.arrowScale = 0.65;
			//_facebook.minBkgWidthGap = _twitter.minBkgWidthGap = _google.minBkgWidthGap = 0;
			
			this.addChild(_facebook);
			this.addChild(_twitter);
			this.addChild(_google);
			_twitter.x = -_twitter.width/2;
			_google.x = _twitter.x + _twitter.width + 15;
			_facebook.x = _twitter.x - _facebook.width - 15;
			_facebook.y = _twitter.y = _google.y = tf.y + tf.height + 12;
			/*
			_twitter.x = _facebook.width + 15;
			_google.x = _twitter.x + _twitter.width + 15;
			_facebook.y = _twitter.y = _google.y = 124;
			*/
			
	 	}
		
		public function destroy():void{
			_facebook.destroy();
			_twitter.destroy();
			_google.destroy();
			
			_facebook = null;
			_twitter = null;
			_google = null;
			
			removeChildren();
		}

		
	}
}

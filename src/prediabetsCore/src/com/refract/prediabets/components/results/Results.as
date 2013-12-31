package com.refract.prediabets.components.results {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.backend.BackendResponder;
	import com.refract.prediabets.components.shared.LSButton;
	import com.refract.prediabets.stateMachine.events.StateEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.refract.prediabets.user.ModuleModel;
	import com.refract.prediabets.user.UserModel;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class Results extends Sprite {
		public static const CONTINUE : String = "RESULTS_CONTINUE";
		
		
		protected var facebook:LSButton;
		protected var googleplus:LSButton;
		protected var twitter:LSButton;
		
		protected var _top:Sprite;
		protected var _bottom:Sprite;
		
		protected var _continue:LSButton;
		
		protected var filmTitleStyle:Object;
		protected var mainRatingStyle:Object;
		protected var labelStyle:Object;
		protected var sepStyle:Object;
		protected var friendsHeaderStyle:Object;
		protected var continueButtonStyle:Object;
		
		protected var _suppressAnim:Boolean = false;
		
		public function Results(suppressAnim:Boolean = false) {
			_suppressAnim = suppressAnim;
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		
		protected function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			makeStyles();
			buildUI();
			
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
			this.alpha = 0;
			TweenMax.to(this,0.5,{alpha:1});
		}
		
		protected function onResize(evt:Event = null):void{
			this.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;
			this.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2;
			_top.y = -_top.height*0.8;
			_bottom.y = AppSettings.VIDEO_HEIGHT/2 - _bottom.height - 50;
			//_top.x = -_top.width/2;
		}
		
		protected function buildUI():void{
			addChild(_top = new Sprite());
			buildTop();
			addChild(_bottom = new Sprite());
			buildBottom();
		}
		
		
		protected function makeStyles():void{
			filmTitleStyle = {fontSize:24,align:"center"};
			mainRatingStyle = {fontSize:100,align:"center"};
			labelStyle = {fontSize:24,autoSize:"right"};
			sepStyle = {fontSize:36,autoSize:"left"};
			friendsHeaderStyle = {fontSize:16};
			continueButtonStyle = {fontSize:36};
		}
		
		protected function buildTop():void{
			var moduleID:int = AppController.i.nextStory;
			var module:ModuleModel = UserModel.getModuleStats(moduleID);
			var lastTF:TextField;
			var tf:TextField = TextManager.makeText("results_title_film"+moduleID,_top,filmTitleStyle);
			tf.x = -tf.width/2;
			lastTF = tf;
			
			var normalizedRating:int = module.rating == 0 ? 1 : module.rating;
			tf = TextManager.makeText("results_main_rating"+normalizedRating,_top,mainRatingStyle);
			tf.x = -tf.width/2;
			tf.y = lastTF.textHeight - 10;
			lastTF = tf;
			var crosses:Sprite = new Sprite();
			_top.addChild(crosses);
			var cross:Bitmap;
			for(var i:int = 0; i < 5; ++i){
				cross = AssetManager.getEmbeddedAsset("ResultsCross");
				cross.scaleX = cross.scaleY = AppSettings.GET_FONT_SCALE(18)*.65;
				cross.smoothing = true;
				crosses.addChild(cross);
				cross.x = cross.width*i + i*10;
				if(i >= normalizedRating){
					cross.alpha = 0.4;
					TweenMax.to(cross,0,{colorMatrixFilter:{saturation:0}});
				}
			}
			crosses.x = -crosses.width/2;
			crosses.y = lastTF.y + lastTF.textHeight - 10;
			/*
			if(normalizedRating > 2){
				DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndResultGood") );	
			}else{
				DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndResultBad") );	
			}
			*/
			var answerLine:Sprite;
			var lastLine:Sprite = crosses;
			var label:TextField;
			var result:AnimatedString;
			var rating:TextField;
			var ratingID:int;
			var lines:Array = ["correct_answers","speed_answers","accuracy_cpr"];
			var totalLines:int = module.accuracy == 0 ? 2 : 3;
			
			var ratings:Array = [];
			var rpos:int = 0;
			for(i = 0; i < totalLines; ++i){
				answerLine = new Sprite();
				_top.addChild(answerLine);
				answerLine.y = lastLine.y + lastLine.height;
				answerLine.y += i == 0 ? 10 : 0;
			
				label = TextManager.makeText("results_"+lines[i]+"_label",answerLine,labelStyle);
			
				
				result = new AnimatedString("results_"+lines[i]+"_sep",sepStyle);
				
				switch(lines[i]){
					case(lines[0]):
					/*
					 * 33/55
					 * 2.20s
					 * 73%
					 */
//						result.text = _results.correctAnswers + result.text + _results.totalQuestions;
						result.startValue = "00/"+module.total;
						result.endValue = module.correctWithTotalString.charAt(1) == "/" ? "0"+ module.correctWithTotalString : module.correctWithTotalString;
						
				//		result.text = module.correctWithTotalString;
						ratingID = module.questionRating;
					break;
					case(lines[1]):
//						result.text = Number(_results.speedAnswers).toFixed(2) + result.text;
						result.startValue = "0.00s";
						result.endValue = module.speedString;
						//result.text = module.speedString;
						ratingID = module.speedRating;
					break;
					case(lines[2]):
//						result.text = _results.cprAccuracy + result.text;
						result.startValue = "00%";
						result.endValue = module.accuracyString.charAt(1) == "%" ? "0"+ module.accuracyString : module.accuracyString;
					//	result.text = module.accuracyString;
						ratingID = module.accuracyRating;
					break;
				}
				if(_suppressAnim){
					result.startValue = result.endValue;
				}
				answerLine.addChild(result);
				result.x = 125;
				result.animate();
				label.y = result.text.textHeight/2 - label.textHeight/2;
			
				ratingID = ratingID == 0 ? 1 : ratingID;
			
	//			rating = TextManager.makeText("results_sub_rating"+_results[lines[i]+"_rating"],answerLine,sepStyle);
				rating = TextManager.makeText("results_sub_rating"+ratingID,answerLine,sepStyle);
				ratings.push(rating);
				rating.x = result.x + result.width + 10; // 180;
				rpos = rating.x > rpos ? rating.x : rpos;
				
				answerLine.x = -133;
				lastLine = answerLine;
			}
			
			for(var j:int = 0; j < ratings.length; ++j){
				ratings[j].x = rpos;
			}
		}
		
		protected function buildBottom():void{
			var tag:TextField = TextManager.makeText("results_friends_header",_bottom,friendsHeaderStyle);
			tag.x = -tag.textWidth/2;
			var social:Sprite = new Sprite();
			_bottom.addChild(social);
			
			facebook = new LSButton(null,null,54,54,true);
			facebook.arrowAsset = "Facebook";
			facebook.minBkgWidthGap = 0;
			facebook.minBkgHeightGap = 0;
			social.addChild(facebook);
			
			twitter = new LSButton(null,null,54,54,true);
			twitter.arrowAsset = "Twitter";
			twitter.minBkgWidthGap = 0;
			twitter.minBkgHeightGap = 0;
			social.addChild(twitter);
			twitter.x = facebook.x + facebook.width + 15;
			
			googleplus = new LSButton(null,null,54,54,true);
			googleplus.arrowAsset = "GooglePlus";
			googleplus.minBkgWidthGap = 0;
			googleplus.minBkgHeightGap = 0;
			social.addChild(googleplus);
			googleplus.x = twitter.x + twitter.width + 15;
			
			social.x = -social.width/2;
			social.y = tag.height + 14;
			
			
			facebook.addEventListener(MouseEvent.CLICK, onSocialClick);
			twitter.addEventListener(MouseEvent.CLICK, onSocialClick);
			googleplus.addEventListener(MouseEvent.CLICK, onSocialClick);
			
			
			_continue = new LSButton("results_continue",continueButtonStyle,276,70,true);
			_bottom.addChild(_continue);
			_continue.x = -_continue.width/2;
			_continue.y = social.y + social.height + 18;
			_continue.addEventListener(MouseEvent.CLICK, onContinue);
		//	_bottom.x = -_bottom.width/2;
			
		}
		
		
		protected function onSocialClick(evt:MouseEvent):void{
			var social:String = "";
			switch(evt.currentTarget){
				case(facebook):
					social = "facebook";
				break;
				case(twitter):
					social = "twitter";
				break;
				case(googleplus):
					social = "google";
				break;
			}
			BackendResponder.share(social);
		}
		
		protected function onContinue(evt:MouseEvent):void{
			DispatchManager.dispatchEvent(new Event(CONTINUE));
		}

		public function destroy() : void {
			stage.removeEventListener(Event.RESIZE,onResize);
			_continue.removeEventListener(MouseEvent.CLICK,onContinue);
			TweenMax.to(this,0.5,{alpha: 0, onComplete:onDestroy});
		}
		
		protected function onDestroy():void{
			
			facebook.removeEventListener(MouseEvent.CLICK, onSocialClick);
			twitter.removeEventListener(MouseEvent.CLICK, onSocialClick);
			googleplus.removeEventListener(MouseEvent.CLICK, onSocialClick);
			
			facebook.destroy();
			twitter.destroy();
			googleplus.destroy();
			
			removeChildren();
			_top = null;
			_bottom = null;
			_continue = null;
		//	parent ? parent.removeChild(this) : null;
		}
	}
}

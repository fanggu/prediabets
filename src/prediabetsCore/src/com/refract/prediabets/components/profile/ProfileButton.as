package com.refract.prediabets.components.profile {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.backend.BackendResponder;
	import com.refract.prediabets.components.events.MenuEvent;
	import com.refract.prediabets.components.nav.Nav;
	import com.refract.prediabets.components.shared.LSButton;
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
	public class ProfileButton extends Sprite {
		
		public static const LOCKED:int = 0;
		public static const UNLOCKED:int = 1;
		
		protected var _id:int;
		public function get id() : int { return _id; }
		
		protected var _state:int;
		public function get state():int{ return _state; }
		public function set state(s:int):void{ _state = s; if(stage) {setState();} }
		
		protected var _bkg:Bitmap;
		protected var _top:Sprite;
		protected var _bottom:Sprite;
		
		protected var _startNow:LSButton;
		protected var _certificate:LSButton;
		
		public function ProfileButton(id:int) {
			_id = id;
			
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		protected function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			_bkg = AssetManager.getEmbeddedAsset("PROFILE"+_id) as Bitmap;
			_bkg.smoothing = true;
			addChild(_bkg);
			_top = new Sprite();
			addChild(_top);
			buildTop();
			
			_bottom = new Sprite();
			addChild(_bottom);
			buildBottom();
			
			stage.addEventListener(Event.RESIZE,onResize);
			
			setState(true);
			onResize();
		}

		protected function setState(init:Boolean = false):void{
			var tweenTime:Number = init ? 0 : 0.5;
			switch(state){
				case(LOCKED):
					TweenMax.to(_bkg,tweenTime,{colorMatrixFilter:{colorize:0x0066ff, amount:0.2, saturation:0.5}});
				break;
				case(UNLOCKED):
					TweenMax.to(_bkg,tweenTime,{colorMatrixFilter:{contrast:1.3, saturation:0}});
				break;
			}
		}
		
		
		protected function buildTop():void{
			var moduleID:int = id;
			var module:ModuleModel = UserModel.getModuleStats(moduleID);
			var lastTF:TextField;
			var tf:TextField = TextManager.makeText("results_title_film"+moduleID,_top,{fontSize:24,align:"center"});
			tf.x = -tf.width/2;
			lastTF = tf;
			var normalRating:int = module.rating;
			normalRating = normalRating < 1 ? 1 : normalRating > 5 ? 5 : normalRating;
			
			if(state == LOCKED){
				tf = TextManager.makeText("page_profile_locked",_top,{fontSize:54,align:"center"});
			}else{
				if(module.isComplete){
					tf = TextManager.makeText("results_main_rating"+normalRating,_top,{fontSize:54,align:"center"});
				}else{
					tf = TextManager.makeText("page_profile_incomplete",_top,{fontSize:54,align:"center"});
				}
			}
			tf.x = -tf.width/2;
			tf.y = lastTF.textHeight - 10;
			tf.name = "pageHeading";
			lastTF = tf;
			var crosses:Sprite = new Sprite();
			_top.addChild(crosses);
			var cross:Bitmap;
			for(var i:int = 0; i < 5; ++i){
				cross = AssetManager.getEmbeddedAsset("ResultsCross");
				cross.smoothing = true;
				crosses.addChild(cross);
				cross.scaleX = cross.scaleY = AppSettings.GET_FONT_SCALE(18)*.65;
				cross.x = cross.width*i + i*10;
				if(i >= normalRating || state == LOCKED){
					cross.alpha = 0.4;
					TweenMax.to(cross,0,{colorMatrixFilter:{saturation:0}});
				}
			}
			crosses.x = -crosses.width/2;
			crosses.y = lastTF.y + lastTF.textHeight ;//- 10;
			if(state != LOCKED){
				var answerLine:Sprite;
				var lastLine:Sprite = crosses;
				var label:TextField;
				var result:TextField;
				var rating:TextField;
				var ratingID:int;
				var labelStyle:Object = {fontSize:16,autoSize:"right"};
				var sepStyle:Object = {fontSize:20,autoSize:"left"};
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
				
					result = TextManager.makeText("results_"+lines[i]+"_sep",answerLine,sepStyle);
					switch(lines[i]){
						case(lines[0]):
	//						result.text = _results.correctAnswers + result.text + _results.totalQuestions;
							result.text = module.correctWithTotalString;
							ratingID = module.questionRating;
						break;
						case(lines[1]):
	//						result.text = Number(_results.speedAnswers).toFixed(2) + result.text;
							result.text = module.speedString;
							ratingID = module.speedRating;
						break;
						case(lines[2]):
	//						result.text = _results.cprAccuracy + result.text;
							result.text = module.accuracyString;
							ratingID = module.accuracyRating;
						break;
					}
					result.x = 120;
					label.y = result.textHeight/2 - label.textHeight/2;
				
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
		}
		
		protected function buildBottom():void{
			if(state != LOCKED){
				_startNow = new LSButton("intro_menu_start_now",{fontSize:36},257,70,true,false);
			//	_startNow.minBkgWidthGap = 0;
				_startNow.buttonAlpha = 0.15;
				_bottom.addChild(_startNow);
				_startNow.x = -_startNow.width/2;
				_startNow.addEventListener(MouseEvent.CLICK,onClick);

				if(UserModel.getModuleStats(id).isDownloaded){
					if(UserModel.getModuleStats(id).isComplete){
						_startNow.text = TextManager.getDataListForId("intro_menu_replay")["intro_menu_replay"]["copy_"+AppSettings.LOCALE];
					}else if(AppController.i.nextStory == id){
						_startNow.text = TextManager.getDataListForId("intro_menu_resume")["intro_menu_resume"]["copy_"+AppSettings.LOCALE];
					}else{
						//_startNow.text = TextManager.getDataListForId("intro_menu_start_now")["intro_menu_start_now"]["copy_"+AppSettings.LOCALE];
					}
				}else{
					_startNow.text = TextManager.getDataListForId("intro_menu_download")["intro_menu_download"]["copy_"+AppSettings.LOCALE];
				}

				if(id == 3 && UserModel.getModuleStats(3).isComplete && AppSettings.DEVICE == AppSettings.DEVICE_PC){
					_certificate = new LSButton("page_profile_cert",{fontSize:36},290,70,true,false);
				//	_certificate.minBkgWidthGap = 0;
					_certificate.buttonAlpha = 0.15;
					addChild(_certificate);
					_certificate.addEventListener(MouseEvent.CLICK,onCertClick);
					_certificate.x = _bkg.width/2 -_certificate.width/2;
					_certificate.y = 100;
					_certificate.startDancingArrow();
				}
			}
		}

		protected function onClick(evt : MouseEvent) : void {
//			if(AppController.i.nextStory != id){
				DispatchManager.dispatchEvent(new MenuEvent(MenuEvent.MENU_SELECTED,id));
			//	AppController.i.setSWFAddress(AppSections["MODULE_LS"+id]);
//			}else{
//				DispatchManager.dispatchEvent(new Event(Nav.CLOSE_OVERLAY));
//			}
		}
		
		protected function onCertClick(evt : MouseEvent) : void {
			BackendResponder.getCertificate();
		}
		

		protected function onResize(evt : Event = null) : void {
			_bkg.width = (AppSettings.VIDEO_WIDTH-2)/3;
			_bkg.height = AppSettings.VIDEO_HEIGHT;
			
			if(_certificate){
				_certificate.x = _bkg.width/2 -_certificate.width/2;
			}
			_top.x = _bkg.width/2;
		//	_top.y = _bkg.height/2 - TextField(_top.getChildByName("pageHeading")).textHeight;
			_top.y = _bkg.height/2 - 40;
			
			_bottom.x = _bkg.width/2;
			_bottom.y = _bkg.height - 20 - _bottom.height;
			
			this.x = (_id - 1)*(this._bkg.width + 1);
		}

		public function destroy() : void {
			if(_startNow){
				_startNow.destroy();
				_startNow.removeEventListener(MouseEvent.CLICK,onClick);
			}
			if(_certificate){
				_certificate.destroy();
				_certificate.removeEventListener(MouseEvent.CLICK,onCertClick);
			}
			stage.removeEventListener(Event.RESIZE, onResize);
			_bkg = null;
			removeChildren();
		}

	}
}

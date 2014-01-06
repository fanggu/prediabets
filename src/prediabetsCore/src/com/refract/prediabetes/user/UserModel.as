package com.refract.prediabetes.user 
{
	import com.refract.prediabetes.AppController;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.logger.Logger;
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.events.Event;
	import flash.net.SharedObject;
	/**
	 * @author kanish
	 */
	public class UserModel {
		
		public static const MODULE_STATS_UPDATED:String = "MODULE_STATS_UPDATED";
		public static const USER_LOGGED_IN : String = "USER_LOGGED_IN";
		public static const USER_LOGGED_OUT : String = "USER_LOGGED_OUT";
		
		/*
		 * STATIC
		 * 
		 */
		
		private static var _i : UserModel;
		private static function get i():UserModel{ if(_i == null){ _i = new UserModel(); } return _i; }
		
		
		public static function reset() : void {
			i.reset();
		}

		
		public static function get isLoggedIn() : Boolean { return i.isLoggedIn; } ;
		
		public static function initialize() : void {
			_i = new UserModel();
		}
		
		public static function setUserData(data:Object):void{
			i.setUserData(data);
		}
		
		/*
		 * module = 1
		 * rank = "very good"
		 * correct = "22/31"
		 * speed = "3.4s"
		 * accuracy = "76%"
		 */
		public static function setModuleComplete(module:int,cprAccuracy:int):void{
			i.setModuleComplete(module,cprAccuracy);
		}
		
		public static function getModuleStats(id:int):ModuleModel{
			return i.getModuleStats(id);
		}
		
		public static function getUserInfo():UserInfoModel{
			return i.getUserInfo();
		}

		
		/*
		 * 
		 * INSTANCE
		 * 
		 */
		
		private var _modules:Vector.<ModuleModel>;
		
		private function getModuleStats(id : int) : ModuleModel { return _modules[id];}
		
		private function getUserInfo():UserInfoModel { return _userInfo; }
		private var _userInfo:UserInfoModel;
		
		
		public function UserModel(){
			init();
		}
		
		private function init():void{
			
			setRatingsAndLabels();
			
			_modules = new Vector.<ModuleModel>();
			_modules[0] = null;
			for(var i:int = 1; i < 5; ++i){
				_modules[i] = new ClassFactory.MODULE_MODEL(i);
			}
			
			var model2Locked : Boolean = false ; 
			var model3Locked : Boolean = false ; 
			var so:SharedObject = SharedObject.getLocal("lifesaver");
	 		if( so.data['model2Locked'] ) model2Locked = so.data['model2Locked'] ; 
			if( so.data['model3Locked'] ) model3Locked = so.data['model3Locked'] ; 

	      	//so.flush();
	      
	      // Also, indicate the value for debugging.
	      
			_modules[1].unlocked = true;
			_modules[2].unlocked = model2Locked;
			_modules[3].unlocked = model3Locked;
			_modules[4].unlocked = true;
			
			_userInfo = new UserInfoModel();
			
			
			
			// Get the shared object.
	    
			
			
			DispatchManager.addEventListener(Flags.UPDATE_SCORE, onSMEvent);
			DispatchManager.addEventListener(Flags.UPDATE_UI_PROGRESS, onSMEvent);
			DispatchManager.addEventListener(Flags.STATE_MACHINE_START, onSMEvent);
			DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onSMEvent);
			DispatchManager.addEventListener(USER_LOGGED_OUT, onLoggedOut);
			
			
			
		}

		private function onLoggedOut(event : String) : void {
			reset();
		}

		
		private function reset() : void {
			
			for(var i:int = 1; i < 5; ++i){
				_modules[i].resetScore();
			}
			
			var model2Locked : Boolean = false ; 
			var model3Locked : Boolean = false ; 
			var so:SharedObject = SharedObject.getLocal("lifesaver");
	 		if( so.data['model2Locked'] ) model2Locked = so.data['model2Locked'] ; 
			if( so.data['model3Locked'] ) model3Locked = so.data['model3Locked'] ; 
			
			_modules[1].unlocked = true;
			_modules[2].unlocked = model2Locked;
			_modules[3].unlocked = model3Locked;
			_modules[4].unlocked = true;
			
			if(AppController.i.nextStory != -1){
				_modules[AppController.i.nextStory].unlocked = true;
			}
			
			_userInfo.reset();
			
			//AppController.i.setSWFAddress(AppSections.INTRO);
		}
		

	
		private function get isLoggedIn():Boolean{ return _userInfo.isLoggedIn; }
		
		
		private function setRatingsAndLabels():void{
			var ratingLabels:Array = [];
			var resultsData:Array = TextManager.getDataListForId("results_");
			ratingLabels[0] = "";
			for(var i:int = 1; i < 6; ++i){
				ratingLabels[i] = resultsData["results_main_rating"+i]["copy_"+AppSettings.LOCALE];
			}
			ModuleModel.RATINGS_LABELS = ratingLabels;
			
			ModuleModel.CORRECT_SEPERATOR = resultsData["results_correct_answers_sep"]["copy_"+AppSettings.LOCALE];
			ModuleModel.SPEED_SEPERATOR = resultsData["results_speed_answers_sep"]["copy_"+AppSettings.LOCALE];
			ModuleModel.ACCURACY_SEPARATOR = resultsData["results_accuracy_cpr_sep"]["copy_"+AppSettings.LOCALE];
		}
		
		private function setUserData(data:Object):void{
			if(isDefined(data.success)){
				setData(data.data);
			}else{
				return;
			}
		}
		
		private function setData(data:Object):void{
			setModules(data.modules);
			setUser(data.user);
		}
		
		private function setModules(data:Object):void{
			var so:SharedObject
			if(data.ls1){
				setModule(1,data.ls1);
				
				_modules[2].unlocked = true;
				
				so= SharedObject.getLocal("lifesaver");
				so.data['model2Locked'] = true ;
				so.flush() ; 
				
			}
			if(data.ls2){
				setModule(2,data.ls2);
				_modules[3].unlocked = true;
				
				so = SharedObject.getLocal("lifesaver");
				so.data['model3Locked'] = true ;
				so.flush() ; 
			}
			if(data.ls3){
				setModule(3,data.ls3);
			}
		}
		
		private function setModule(loc:int,data:Object):void{
			//_modules[loc] = data;
			if(data){
				_modules[loc].setData(data);
			}
		}
		
		private function setUser(data:Object):void{
			if(isDefined(data.name)) _userInfo.name = data.name;
			if(isDefined(data.email)) _userInfo.email = data.email;
			
			_userInfo.isLoggedIn = true;
			setMeta(data.meta);
			DispatchManager.dispatchEvent(new Event(USER_LOGGED_IN));
		}
		
		private function setMeta(data:Object):void{
			var facebook:Object = _userInfo.metaFacebook;
			var twitter:Object = _userInfo.metaTwitter;
			var google:Object = _userInfo.metaGoogle;
			
			if(isDefined(data.refresh)) _userInfo.refresher = data.refresh;
			
			if(isDefined(data.auth_code)) _userInfo.authCode = data.auth_code;
			
			if(isDefined(data.facebook_id)) facebook.id = data.facebook_id;
			if(isDefined(data.facebook_name)) facebook.name = data.facebook_name;
			if(isDefined(data.facebook_link)) facebook.link = data.facebook_link;
			
			
			if(isDefined(data.twitter_id)) twitter.id = data.twitter_id;
			if(isDefined(data.twitter_screen_name)) twitter.name = data.twitter_screen_name;
			if(isDefined(data.twitter_access_token)) twitter.accessToken = data.twitter_access_token;
			if(isDefined(data.twitter_access_token_secret)) twitter.accessTokenSecret = data.twitter_access_token_secret;
			
			
			if(isDefined(data.google_id)) google.id = data.google_id;
			if(isDefined(data.google_link)) google.link = data.google_link;
			if(isDefined(data.google_picture)) google.picture = data.google_picture;
		}
		
		
		private function setModuleComplete(moduleID:int,accuracy:int):void{
			var module:ModuleModel = _modules[moduleID];
			var best:ModuleModel = module.best;
			
			module.accuracy = accuracy;
			module.isComplete = true;
			module.unlocked = true; //just in case you log out during a module
			if(best != null ){
				/*
				 * TODO: proper formula for when best is surpassed
				 * right now: if all are better overwrite
				 */
				 if(best.rating <= module.rating && best.correct <= module.correct && best.speed <= module.speed && best.accuracy <= module.accuracy){
					best.rating = module.rating;
					best.correct = module.correct;
					best.total = module.total;
					best.speed = module.speed;
					best.accuracy = module.accuracy;
				 }
			}else{
				best = new ModuleModel(moduleID);
				best.rating = module.rating;
				best.correct = module.correct;
				best.total = module.total;
				best.speed = module.speed;
				best.accuracy = module.accuracy;
			}
			if(moduleID < 3){
				_modules[moduleID+1].unlocked = true;
				
				var so:SharedObject = SharedObject.getLocal("lifesaver");
				if( moduleID+1 == 2 ) so.data['model2Locked'] = true ;
				else
				{
					so.data['model2Locked'] = true ;
					so.data['model3Locked'] = true ;
				}
				so.flush() ; 
			}
			
			module.setModuleComplete();
		}
		
		
		private function updateScore(obj:Object):void{
			var model:ModuleModel = _modules[AppController.i.nextStory];
			
			var oldRating:int = model.rating;
			//rounded to 2dp
			model.speed = Math.round(Number(obj.avgSpeed/10))/100;
			model.correct = int(obj.totCorrectChoices);
			model.total = int(obj.totChoices);
			model.maxQuestions =  SMController.me.model.scoreTot;  //obj.maxQuestions ? int(obj.maxQuestions) : sm;
			model.starBonus += int(obj.addStar);
		
			Logger.log(Logger.SCORING,"=======================================================================");
			Logger.log(Logger.SCORING,"UPDATE SCORE: speed: "+obj.avgSpeed+", correctAnswers: "+obj.totCorrectChoices+", totalAnswers: "+obj.totChoices+", maxQs: "+SMController.me.model.scoreTot);
			Logger.log(Logger.SCORING,"STAR WAS: "+(model.starBonus - obj.addStar)+", adding: "+obj.addStar+" NOW: "+model.starBonus);
			Logger.log(Logger.SCORING,"RATING WAS:"+ oldRating + ", IS: "+model.rating);
			Logger.log(Logger.SCORING,"=======================================================================");
			
			DispatchManager.dispatchEvent(new ObjectEvent(MODULE_STATS_UPDATED, {module:model}));
		}
		
		/*
		 * 
		 * EVENTS
		 * 
		 */
		private function onSMEvent(evt:Event):void{
			switch(evt.type){
				case(Flags.STATE_MACHINE_START):
					if(AppController.i.nextStory != -1){
					//	Logger.log(Logger.SCORING,"RESET SCORE: "+AppController.i.nextStory);
					//	_modules[AppController.i.nextStory].resetScore();	
					}
					break;
				case(Flags.STATE_MACHINE_END):
					break;
				case(Flags.UPDATE_SCORE):
						updateScore((evt as ObjectEvent).object);
					break;
				case(Flags.UPDATE_UI_PROGRESS):
					break;			
				default:
			}
		}
		
		
		/*
		 * 
		 * UTILITIES
		 * 
		 */
		 
		private function isDefined(prop:*):Boolean{
			return (prop != undefined && prop != null && prop != "");
		}



	}
}

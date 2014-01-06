package com.refract.prediabetes.user {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.logger.Logger;
	/**
	 * @author kanish
	 */
	public class ModuleModel {
		
		public static var RATINGS_LABELS:Array;
		
		public static var CORRECT_SEPERATOR:String;
		public static var SPEED_SEPERATOR:String;
		public static var ACCURACY_SEPARATOR:String;
		
		private var _isComplete:Boolean = false;
		public function get isComplete():Boolean{ return _isComplete; }
		public function set isComplete(b:Boolean):void { _isComplete = b; }
		
		private var _best:ModuleModel;
		public function get best():ModuleModel {return _best;}
		public function set best(b:ModuleModel):void{ _best = b; }
		
		private var _id:int;
		public function get id():int { return _id; }
		public function set id(id:int):void { _id = id;}
		
		public function get thisModule():int {return id == 4 ? 6 : id;}
		
		private var _unlocked:Boolean;
		public function get unlocked():Boolean{ return _unlocked; }
		public function set unlocked(b:Boolean):void{ _unlocked = b; }
		
		private var _rating:int;
		public function set rating(rat:int):void{ _rating = isNaN(rat) ? 1 : rat; }
		public function get rating() : int { 
//			var ave:int = _accuracy == 0 ? (Math.round(questionRating + speedRating )/2)  : (Math.round(questionRating + accuracyRating + speedRating )/3);
			var ave:int = _accuracy == 0 ? (questionRating)  : (Math.round(questionRating + accuracyRating )/2);
			
			var rating:int = ave +  starBonus;
			//rating += starBonus;
			_rating = rating > 5 ? 5 : rating < 0 ? 0 : rating;
			Logger.log(Logger.SCORING,"RATING CALC: "+_rating+" BECAUSE RATING: "+rating + " STARS " + starBonus +" AVE " +ave+" QUESTIONS "+questionRating+" SPEED "+speedRating+" ACCURACY "+accuracyRating);
			return _rating;
		}
		public function get ratingString():String { return rating == 0 ? RATINGS_LABELS[1] : RATINGS_LABELS[rating];}
		
		private var _correct:int;
		public function get correct() : int { return _correct; }
		public function set correct(correct : int) : void { _correct = isNaN(correct) ? 0 : correct; }
		public function get correctString() : String { return _correct.toString(); }
		public function get correctWithTotalString() : String { return _correct.toString() + CORRECT_SEPERATOR + _totalQuestions.toString(); }
		
		private var _totalQuestions:int;
		public function get total() : int { return _totalQuestions; }
		public function set total(total : int) : void { _totalQuestions = isNaN(total) ? 0 : total; }
		public function get totalString() : String { return _totalQuestions.toString(); }
		
		private var _maxQuestions:int;
		public function get maxQuestions() : int { return _maxQuestions; }
		public function set maxQuestions(maxQuestions : int) : void { _maxQuestions = isNaN(maxQuestions) ? 0 : maxQuestions; }
		public function get maxQuestionsString() : String { return _maxQuestions.toString(); }
		
		
		public function get questionRating():int { 
			var rat:int = Math.ceil(_maxQuestions == 0 ? 5*(_correct/_totalQuestions) : 5*(_correct/_totalQuestions)*(_totalQuestions/_maxQuestions));
			return rat; 
		}
		
		private var _accuracy:int;
		public function get accuracy() : int { return _accuracy; }
		public function set accuracy(accuracy : int) : void { _accuracy = isNaN(accuracy) ? 0 : accuracy; }
		public function get accuracyString() : String { return _accuracy.toString() + ACCURACY_SEPARATOR; }
		
		public function get accuracyRating():int { return Math.ceil(_accuracy == 0 ? 0: 5*(_accuracy/100)); }
		
		private var _speed:Number;
		public function get speed() : Number { return _speed; }
		public function set speed(speed : Number) : void { _speed = isNaN(speed) ? 0 : speed; }
		public function get speedString():String { return _speed.toFixed(2) + SPEED_SEPERATOR;  }
		
		public function get speedRating():int { return Math.ceil(_speed == 0 ? 0 : 5*(1 - _speed/AppSettings.MAX_ANSWER_TIME)); }
		
		private var _starBonus:int;
		public function get starBonus():int { return _starBonus;}
		public function set starBonus(star:int):void
		{ 
			Logger.log(Logger.SCORING,"StarWas "+_starBonus+" StarIs "+star);  
			_starBonus = isNaN(star) ? 0 : star; 
		}
		
		protected var _isDownloaded:Boolean;
		public function get isDownloaded() : Boolean { return true; }
 		public function set isDownloaded(isDownloaded : Boolean) : void { _isDownloaded = isDownloaded; }
		
		public function get isDownloading() : Boolean { return false; }
		
		public function get downloadPercent():Number { return 1; }
		
		
		public function ModuleModel(id:int) {
			_id = id;
			_unlocked = false;
			resetScore();
			/*
			//cheat to start with completed modules
			var mods:Array = [1,2,3,4];
			if(mods.indexOf(id) != -1){
				_rating = 3;
				_correct = 27;
				_totalQuestions = 32;
				_maxQuestions = 32;
				_speed = 2.02;
				_accuracy = 78;
				_starBonus = 0;
				
				_isComplete = true;
				_unlocked = true;
			}
			 
//			 */
		}

		public function setData(data : Object) : void {
			
			/*
			 *  {	"user_id":"3",
			 *  	"module_id":"2",
			 *  	"state":"",
			 *  	"interaction_type":"end",
			 *  	"meta":{
			 *  		"ranking":"well done",
			 *  		"correct":"33\/57",
			 *  		"speed":"2.2s",
			 *  		"accuracy":"76%"},
			 *  		"created":"2013-01-19 22:48:29"
			 *  		}
			 */
			 
			 if(int(data.module_id) == id){
				_rating = RATINGS_LABELS.indexOf(data.meta.ranking) == -1 ? 1 : RATINGS_LABELS.indexOf(data.meta.ranking);
				_correct = data.meta.correct.split(CORRECT_SEPERATOR)[0];
				_totalQuestions = data.meta.correct.split(CORRECT_SEPERATOR)[1];
				_accuracy = data.meta.accuracy.split(ACCURACY_SEPARATOR)[0];
				_speed = data.meta.speed.split(SPEED_SEPERATOR)[0];
				_isComplete = true;
				_unlocked = true;
				
			 }else{
				throw new Error("MODULE IDS NOT EQUAL. This: "+id+", data: "+ data.module_id);
			 }
		}

		public function resetScore() : void {
			Logger.log(Logger.SCORING,"MODULEMODEL RESET SCORE");
			_rating = 0;
			_correct = 0;
			_totalQuestions = 0;
			_maxQuestions = 0;
			_accuracy = 0;
			_speed = 0;
			_starBonus = 0;
		}

		public function setModuleComplete() : void {
			//BackendResponder.setModuleComplete( _id, ratingString, correctWithTotalString, speedString, accuracyString );
		}

	}
}

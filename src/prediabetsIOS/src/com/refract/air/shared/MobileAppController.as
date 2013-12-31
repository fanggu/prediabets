package com.refract.air.shared {
	import com.refract.air.shared.data.StoredData;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.components.events.SceneSelectorEvent;

	import flash.utils.Dictionary;
	/**
	 * @author kanish
	 */
	public class MobileAppController extends AppController {
		
		private static const REAL_STORIES_KEY:String = "real_stories_watched";  
		
		public function MobileAppController(main : MainCore) {
			super(main);
		}
		
		override protected function createQuestionsDictionary() : void {
			_dictQuestions = StoredData.getData(REAL_STORIES_KEY) as Dictionary;
			if(!_dictQuestions){
				_dictQuestions = new Dictionary( true ) ;
				StoredData.setData(REAL_STORIES_KEY,_dictQuestions); 
			}
		}
		
		override protected function onQuestionSelected( evt : SceneSelectorEvent ) : void {
			_dictQuestions[evt.id] = true ;  
			StoredData.setData(REAL_STORIES_KEY,_dictQuestions); 
		}
		override public function get nrQuestionSelected() : int {
			var n:int = 0;
    		for (var key:* in _dictQuestions){
        		n++;
    		}
    		return n;
		}
	}
}

package com.refract.prediabets.components.events {
	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class SceneSelectorEvent extends Event {
		public static const BUTTON_SELECTED:String = "SCENE_SELECTOR_BUTTON_SELECTED";
		public static const QUESTION_SELECTED : String = 'questionSelected' ; 
		private var _id:int;
		public function get id():int {return _id;}
		
		public function SceneSelectorEvent(type : String, id:int, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			_id = id;
		}
	}
}

package com.refract.prediabetes.stateMachine.events {
	import flash.events.Event;

	/**
	 * @author robertocascavilla
	 */
	public class BooleanEvent extends Event 
	{
		private var _value:Boolean;
		public function BooleanEvent(type : String, value : Boolean ,bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		  	_value = value;
		}
		
		public function get value():Boolean
		{
		  return _value;
		}
		override public function clone():Event
		{
		  return new ObjectEvent(type, value, bubbles, cancelable);
		}
	}
}

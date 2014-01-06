package com.refract.prediabetes.stateMachine.events {
	import flash.events.Event;

	/**
	 * @author robertocascavilla
	 */
	public class StateEvent extends Event 
	{
		private var _stringParam:String;
		public function StateEvent(type : String, stringParam : String ,bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		  	_stringParam = stringParam;
		}
		
		public function get stringParam():String
		{
		  return _stringParam;
		}
		override public function clone():Event
		{
		  return new StateEvent(type, stringParam, bubbles, cancelable);
		}
	}
}

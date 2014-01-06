package com.refract.prediabetes.stateMachine.events {
	import flash.events.Event;

	/**
	 * @author robertocascavilla
	 */
	public class ObjectEvent extends Event 
	{
		private var _object:Object;
		public function ObjectEvent(type : String, object : Object,bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		  	_object = object;
		}
		
		public function get object():Object
		{
		  return _object;
		}
		override public function clone():Event
		{
		  return new ObjectEvent(type, object, bubbles, cancelable);
		}
	}
}

package com.refract.prediabets.stateMachine.events {
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author robertocascavilla
	 */
	public class OverlayEvent extends Event 
	{
		public static const DRAW_BALLOON : String = 'DrawBalloon' ; 
		
		private var _object:Sprite;
		public function OverlayEvent(type : String, object : Sprite,bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		  	_object = object;
		}
		
		public function get object():Sprite
		{
		  return _object;
		}
		override public function clone():Event
		{
		  return new ObjectEvent(type, object, bubbles, cancelable);
		}
	}
}

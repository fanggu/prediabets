package com.robot.comm {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	//	import flash.events.Event;
  	public class DispatchManager 
	{
    		private static var dispatcher:EventDispatcher;
    		public static function addEventListener
			(
				e_name:String, 
				e_listener:Function, 
				e_useCapture:Boolean=false, 
				e_priority:int=0, 
				e_useWeakReference:Boolean=false
			)
			:void 
			{
      			if (dispatcher == null) { dispatcher = new EventDispatcher(); }
      			dispatcher.addEventListener
				(
					e_name, 
					e_listener, 
					e_useCapture, 
					e_priority, 
					e_useWeakReference
				);
      		}
    		public static function removeEventListener
			(
				e_name:String, 
				e_listener:Function,
				e_useCapture:Boolean=false
			)
			:void 
			{
      			if (dispatcher == null) { return; }
      			dispatcher.removeEventListener(e_name, e_listener, e_useCapture);
      		}
    		public static function dispatchEvent(p_event:Event):void {
      			if (dispatcher == null) { return; }
      			dispatcher.dispatchEvent(p_event);
      		}
    		
			// Public API that dispatches an event
			public static function loadSomeData():void 
			{
				//dispatchEvent(new R_Event(Event.COMPLETE));
			}
		
    }
}
package com.robot.comm 
{
	import flash.events.Event;		

	public class R_Event extends Event
	{
		public var param:*;
		public function R_Event( type:String, w_param:* = null ):void
		{
			param = w_param;
			super( type );
		}
		
	}
}
package com.robot.utils {
	import flash.display.*;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.geom.ColorTransform;
	import flash.net.*;	
	public class Utils 
	{
		public function Utils()
		{
		}
		public static function setRGB(w_mc:* , w_color:uint):void
		{
			var newColorTransform:ColorTransform = w_mc['transform'].colorTransform;
			newColorTransform.color = w_color;
			w_mc['transform'].colorTransform = newColorTransform;
		}

	}
	
}

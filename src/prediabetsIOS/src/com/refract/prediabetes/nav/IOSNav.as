package com.refract.prediabetes.nav {
	import flash.events.Event;

	/**
	 * @author otlabs
	 */
	public class IOSNav extends Nav 
	{
		public function IOSNav() 
		{
			super();
		}
		override protected function init(evt:Event):void
		{
			super.init( evt ) ; 
			_header.visible = true ; 
		}
	}
}

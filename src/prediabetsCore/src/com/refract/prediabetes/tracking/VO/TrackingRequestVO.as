package com.refract.prediabetes.tracking.VO {
	import flash.net.URLVariables;
	/**
	 * @author otlabs
	 */
	public class TrackingRequestVO 
	{
		public var address : String ; 
		public var variables : URLVariables ; 
		public var method : String ; 
		public var callBack : Boolean ; 
	}
}

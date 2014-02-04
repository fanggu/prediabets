package com.refract.prediabetes.tracking {
	
	/**
	 * @author otlabs
	 */
	public class TrackingSettings 
	{
		public static const HEADER_REGISTERED : String = 'headerRegistered' ; 
		public static const HEADER_NOT_REGISTERED : String = 'headerNotRegistered' ; 
		public static const LOCATION_PRIVACY_CLICK	: String ='locationPrivacyClick' ; 
		
		public static const LOCATION : String = 'location' ;
		public static const START : String = 'start' ;  
		
		public static const BASE_ADDRESS : String = 'http://healthmentoronline.com:8086/' ; 
		
		public static const LOCATION_ADDRESS : String = 'location' ; 
		public static const START_ADDRESS : String = 'timespent/start' ; 
		public static const END_ADDRESS : String = 'timespent/end/' ; 
		public static const ATTACHMENT_GET_ADDRESS : String = '/action/getAttachment/' ; 
		public static const ATTACHMENT_CLOSE_ADDRESS : String = '/action/closeAttachment/' ; 
		public static const INTERACTIVE_ADDRESS : String = '/interactive'
		
 		public static var USER_ID : String = '65C68682-5052-52DD-14FB-B07465E37313' ; 
		public static var TRACK_ID : String ='13'; 
		public static var IP_ADDRESS : String = '000' ; 
		public static var TIMESPENT_ID : String = '0' ; 
		
		public static var CURRENT_STEP : int = 0;
		public static var EPISODE_ID : String = '';
		public static var CHOICE : String = '';  
		public static var NEXT_EPISODE_ID : String = '';  
		
		public static var ATTACHMENT_ID : int = -1 ; 
		

		
	}
}

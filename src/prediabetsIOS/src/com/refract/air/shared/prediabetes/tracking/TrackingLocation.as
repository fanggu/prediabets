package com.refract.air.shared.prediabetes.tracking {
	import com.adobe.nativeExtensions.Networkinfo.InterfaceAddress;
	import com.adobe.nativeExtensions.Networkinfo.NetworkInfo;
	import com.adobe.nativeExtensions.Networkinfo.NetworkInterface;
	import com.refract.prediabetes.tracking.Tracking;
	import com.refract.prediabetes.tracking.TrackingSettings;
	import com.refract.prediabetes.tracking.VO.TrackingRequestVO;
	import com.robot.comm.DispatchManager;

	import flash.events.Event;
	import flash.events.GeolocationEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.StatusEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.sensors.Geolocation;

	/**
	 * @author otlabs
	 */
	public class TrackingLocation extends Tracking 
	{
		private var _geo : Geolocation;
		public function TrackingLocation() 
		{
			
		}
		public function track() : void
		{
			findIPAddress() ; 
			startGeoLocation() ; 
		}
		private function startGeoLocation() : void
		{
			trace('start geolocation')
			if (Geolocation.isSupported)
			{ 
				trace('geolocation is supported')
				_geo = new Geolocation(); 
				trace('_get muted :' , _geo.muted)
				/*
                if (!_geo.muted) 
                { 
					trace('geo is not muted')
                    _geo.addEventListener(GeolocationEvent.UPDATE, geoUpdateHandler); 
                } 
				else
				{
					trace('geo is muted')
					//DispatchManager.dispatchEvent( new Event( TrackingSettings.LOCATION_PRIVACY_CLICK)) ;
					
				}
				 * 
				 */
				 _geo.addEventListener(StatusEvent.STATUS, geoStatusHandler);
				 _geo.addEventListener(GeolocationEvent.UPDATE, geoUpdateHandler);
                
				//DispatchManager.dispatchEvent( new Event( TrackingSettings.LOCATION_PRIVACY_CLICK)) ;
			}
		}
		
		

		private function geoStatusHandler(event : StatusEvent) : void 
		{	
			//trace('geo status handler')
			if( _geo.muted ) DispatchManager.dispatchEvent( new Event( TrackingSettings.LOCATION_PRIVACY_CLICK)) ;
		}
		private function geoUpdateHandler(event : GeolocationEvent) : void 
		{
			//DispatchManager.dispatchEvent( new Event( TrackingSettings.LOCATION_PRIVACY_CLICK)) ;
			//trace('geo update handler')
			_geo.removeEventListener( GeolocationEvent.UPDATE, geoUpdateHandler) ;
			if( !_geo.muted)
			{
				var objTrackRequest : TrackingRequestVO = new TrackingRequestVO() ; 
				objTrackRequest.address = TrackingSettings.LOCATION_ADDRESS ; 
				var variables:URLVariables = new URLVariables();
				variables.param = '{"latitude":"' + event.latitude + '","longitude":"' + event.longitude + '","ipaddress":"' + TrackingSettings.IP_ADDRESS + '"}';
				objTrackRequest.variables = variables ; 
				objTrackRequest.method = URLRequestMethod.POST ; 
				
				//variables.param = '{"latitude":"33.8404","longitude":"170.7399","ipaddress":"192.168.1.1"}';
			    
				trackRequest( objTrackRequest ) ; 
			}
		}
		
		private static function findIPAddress():void
		{
		   var networkInfo:NetworkInfo = NetworkInfo.networkInfo; 
        	var interfaces:Vector.<NetworkInterface> = networkInfo.findInterfaces(); 
			if( interfaces != null ) 
	        { 
	            trace( "Interface count: " + interfaces.length ); 
	            for each ( var interfaceObj:NetworkInterface in interfaces ) 
	            { 
	                trace( "\nname: "             + interfaceObj.name ); 
	                trace( "display name: "     + interfaceObj.displayName ); 
	                trace( "mtu: "                 + interfaceObj.mtu ); 
	                trace( "active?: "             + interfaceObj.active ); 
	                trace( "hardware address: " + interfaceObj.hardwareAddress ); 
	              
	                trace("# addresses: "     + interfaceObj.addresses.length ); 
	                for each ( var address:InterfaceAddress in interfaceObj.addresses ) 
	                { 
	                    trace( "  type: "           + address.ipVersion ); 
	                    trace( "  address: "         + address.address ); 
	                    trace( "  broadcast: "         + address.broadcast ); 
						if( address.broadcast.length > 0 && interfaceObj.active)
						{
							TrackingSettings.IP_ADDRESS = address.broadcast ; 
							trace('=== ' , address.broadcast )
						}
	                    trace( "  prefix length: "     + address.prefixLength ); 
	                } 
	            }             
	        } 
		}
		override protected function trackRequest( obj : Object ) : void
		{ 
			super.trackRequest( obj ) ; 
		}
		
		override protected function loaderCompleteHandler(e:Event):void
		{
			trace('loader complete')
		    dispose() ; 
		}
		
		override protected function httpStatusHandler(e:HTTPStatusEvent):void
		{
		    trace("httpStatusHandler:" + e.status);
			dispose() ;
		}
		
		override protected function dispose() : void
		{
			 
			if( _geo ) _geo = null ; 
			trace('dispose::')
			super.dispose() ; 
			
		}
	}
}

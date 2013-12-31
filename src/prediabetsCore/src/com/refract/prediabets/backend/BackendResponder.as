package com.refract.prediabets.backend {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.logger.Logger;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;

	// import com.unit9.lifesaver.video.VideoLoader;
	/**
	 * @author kanish
	 */
	public class BackendResponder {
		
		public static const BACKEND_BASE_URL_DEFAULT_LIVE:String = "http://life-saver.org.uk/index.php/api/";
		public static const BACKEND_BASE_URL_DEFAULT_DEV:String = "http://svn526.dev.unit9.net/backend/index.php/api/";
	 	public static var BACKEND_BASE_URL_DEFAULT:String;
		public static var BACKEND_BASE_URL:String;
		
		
		public static const BACKEND_DATA_URL_DEFAULT_LIVE:String = "http://life-saver.org.uk/";
		public static const BACKEND_DATA_URL_DEFAULT_DEV:String = "http://svn526.dev.unit9.net/";
//		public static const BACKEND_DATA_URL_DEFAULT_DEV:String = "http://192.168.168.190/lifesaver/";
	 	public static var BACKEND_DATA_URL_DEFAULT:String;
		public static var BACKEND_DATA_URL:String;
		
		private static function getLiveEndpointsDefault():Object{
			return {
					"signup":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/user_signup","type":["post"],"postParams":["name","email"]},
					"activate":{"url":"http:\/\/life-saver.org.uk\/index.php\/main\/activate","type":["get"],"getParams":["email","activation_code"]},
					"login":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/user_login","type":["post"],"postParams":["email","auth_code"]},
					"resendAuth":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/user_resend_auth","type":["post"],"postParams":["email"]},
					"loginFacebook":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/login_facebook","type":["get"]},
					"loginTwitter":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/login_twitter","type":["get"]},
					"loginGoogle":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/login_google","type":["get"]},
					"logout":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/user_logout","type":["get"]},
					"fsmEvent":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/user_fsm_event","type":["get","post"],"urlParams":{"module_1":"\/module\/1","module_2":"\/module\/2","module_3":"\/module\/3"},"postParams":["event=end","ranking","correct","speed","accuracy","hash=contact_admin"]},
					"userData":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/user_data","type":["get","post"],"postParams":["name","email"]},
					"certificate":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/user_certificate","type":["get"],"urlParams":{"view":"\/do\/view","download":"\/do\/download"}},
					"pages":{"url":"http:\/\/life-saver.org.uk\/index.php\/main\/page","type":["get"],"urlParams":{"terms":"\/terms"}},
					"sendFeedback":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/user_send_feedback","type":["post"],"postParams":["name","email","captcha","message"]},
					"moduleDescriptor":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/fsm_descriptor","type":["get"],"urlParams":{"device":{"desktop":"\/device\/desktop","mobile":"\/device\/mobile"},"module":{"1":"\/module\/1","2":"\/module\/2","3":"\/module\/3","6":"\/module\/6"}}},
					"videoSize":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/videos","type":["get","post"],"getParams":["list"],"urlParams":{"device":{"desktop":"\/device\/desktop","mobile":"\/device\/mobile"},"module":{"1":"\/module\/1","2":"\/module\/2","3":"\/module\/3","6":"\/module\/6"},"resolution":{"standard":"\/resolution\/standard","800flv":"\/resolution\/800flv","800mp4":"\/resolution\/800mp4","800f4v": "/resolution/800f4v"}}},
					"share":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/share","type":["get"],"urlParams":{"facebook":"\/on\/facebook","twitter":"\/on\/twitter","googleplus":"\/on\/googleplus"}},
					"mobileStoresUrl":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/mobile_stores_url","type":["get"]},
					"apiLog":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/api_log","type":["get"],"urlParams":{"custom":"url params will be filtered and logged"}},
					"captcha":{"url":"http:\/\/life-saver.org.uk\/index.php\/api\/captcha","type":["get"]}
				};
		}
		
		private static function getDevEndpointsDefault():Object{
			return {
					"signup":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/user_signup","type":["post"],"postParams":["name","email"]},
					"activate":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/main\/activate","type":["get"],"getParams":["email","activation_code"]},
					"login":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/user_login","type":["post"],"postParams":["email","auth_code"]},
					"resendAuth":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/user_resend_auth","type":["post"],"postParams":["email"]},
					"loginFacebook":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/login_facebook","type":["get"]},
					"loginTwitter":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/login_twitter","type":["get"]},
					"loginGoogle":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/login_google","type":["get"]},
					"logout":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/user_logout","type":["get"]},
					"fsmEvent":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/user_fsm_event","type":["get","post"],"urlParams":{"module_1":"\/module\/1","module_2":"\/module\/2","module_3":"\/module\/3"},"postParams":["event=end","ranking","correct","speed","accuracy","hash=contact_admin"]},
					"userData":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/user_data","type":["get","post"],"postParams":["name","email"]},
					"certificate":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/user_certificate","type":["get"],"urlParams":{"view":"\/do\/view","download":"\/do\/download"}},
					"pages":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/main\/page","type":["get"],"urlParams":{"terms":"\/terms"}},
					"sendFeedback":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/user_send_feedback","type":["post"],"postParams":["name","email","captcha","message"]},
					"moduleDescriptor":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/fsm_descriptor","type":["get"],"urlParams":{"device":{"desktop":"\/device\/desktop","mobile":"\/device\/mobile"},"module":{"1":"\/module\/1","2":"\/module\/2","3":"\/module\/3","6":"\/module\/6"}}},
					"videoSize":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/videos","type":["get","post"],"getParams":["list"],"urlParams":{"device":{"desktop":"\/device\/desktop","mobile":"\/device\/mobile"},"module":{"1":"\/module\/1","2":"\/module\/2","3":"\/module\/3","6":"\/module\/6"},"resolution":{"standard":"\/resolution\/standard","800flv":"\/resolution\/800flv","800mp4":"\/resolution\/800mp4","800f4v": "/resolution/800f4v"}}},
					"share":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/share","type":["get"],"urlParams":{"facebook":"\/on\/facebook","twitter":"\/on\/twitter","googleplus":"\/on\/googleplus"}},
					"mobileStoresUrl":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/mobile_stores_url","type":["get"]},
					"apiLog":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/api_log","type":["get"],"urlParams":{"custom":"url params will be filtered and logged"}},
					"captcha":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/api\/captcha","type":["get"]}
				};
		}
		
		//default endpoint list
		public static var ENDPOINTS:Object = AppSettings.DEBUG && !AppSettings.USE_LIVE_BACKEND_ON_DEBUG ? getDevEndpointsDefault() : getLiveEndpointsDefault();

		public static function initialize(onComplete:Function = null,onError:Function = null):void{
			BACKEND_BASE_URL_DEFAULT = AppSettings.DEBUG && !AppSettings.USE_LIVE_BACKEND_ON_DEBUG  ? BACKEND_BASE_URL_DEFAULT_DEV : BACKEND_BASE_URL_DEFAULT_LIVE;
			
			BACKEND_DATA_URL = AppSettings.DEBUG && !AppSettings.USE_LIVE_BACKEND_ON_DEBUG  ? BACKEND_DATA_URL_DEFAULT_DEV : BACKEND_DATA_URL_DEFAULT_LIVE;
			
			var apiURL:String = AppSettings.getFlashVar("apiUrl");
			if(apiURL != null && apiURL != ""){
				BACKEND_BASE_URL = apiURL;
			}else{
				BACKEND_BASE_URL = BACKEND_BASE_URL_DEFAULT;
			}
			
			_initialized = true;
			apiRequest(BACKEND_BASE_URL,function(evt:Event,loader:URLLoader):void{
				var json:Object = JSON.parse(loader.data as String).data;
				ENDPOINTS = json.endpoints;
				onComplete();
			},null,function():void{
				ENDPOINTS = AppSettings.DEBUG ? getDevEndpointsDefault(): getLiveEndpointsDefault();
				onError();
			});
			
			if(ExternalInterface.available){
				ExternalInterface.addCallback("jsCallback", handleJSCall);	
				jsCallbacks = [];
			}
				
		}
		public static function get initialized():Boolean {return _initialized;}
		private static var _initialized:Boolean = false;
		
		private static var jsCallbacks:Array;
		
		private static function handleJSCall(func:String,data:Object):void{
			if(jsCallbacks[func] != null){
				jsCallbacks[func](data);
			}else{
				Logger.log(Logger.BACKEND,"JS TRIED TO CALL func:",func,",data:",data,"BUT NOONE WAS LISTENING");
			}
		}
		
		public static function goExternalPage(id:String):void{
			//"pages":{"url":"http:\/\/svn526.dev.unit9.net\/backend\/index.php\/main\/page","type":["get"],"urlParams":{"terms":"\/terms"}},\
			var endPoint:Object = ENDPOINTS["pages"];
			navigateToURL(new URLRequest(endPoint.url+endPoint.urlParams[id]),"_blank");
		}
		
		public static function getUserData(onComplete:Function, onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["userData"];
			return apiRequest(endPoint.url, onComplete,{method:"GET"},onError);
		}
		
		public static function setUserData(onComplete:Function, name:String = null, email:String = null, onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["userData"];
			var vars:URLVariables = new URLVariables();
			vars[endPoint.postParams[0]] = name;
			vars[endPoint.postParams[1]] = email;
			return apiRequest(endPoint.url, onComplete,{method:"POST",data:vars},onError);
		}
		
		public static function getModuleVideoList(module:int,onComplete:Function = null,onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["videoSize"];
			var ext:String = AppSettings.VIDEO_FILE_EXT == ".flv" ? "800flv" : AppSettings.VIDEO_FILE_EXT == ".mp4" ? "800mp4" : "800f4v" ;
			var device:String = AppSettings.DEVICE == AppSettings.DEVICE_PC ? endPoint.urlParams.device.desktop : endPoint.urlParams.device.mobile;
			Logger.log(Logger.BACKEND,endPoint.url+device+endPoint.urlParams.module[module]+endPoint.urlParams.resolution[ext]);
			return apiRequest(endPoint.url+device+endPoint.urlParams.module[module]+endPoint.urlParams.resolution[ext], onComplete,{method:"GET"},onError);
		}
		
		
		public static function setModuleComplete(module : int, ranking : String, correct : String, speed : String, accuracy : String,onComplete:Function = null,onError:Function=null) : BackendResponder {
			var endPoint:Object = ENDPOINTS["fsmEvent"];
			var vars:URLVariables = new URLVariables();
			vars["event"] = "end";
			vars["hash"] = "12345";
			vars["ranking"] = ranking;
			vars["correct"] = correct;
			vars["speed"] = speed;
			vars["accuracy"] = accuracy;
			
			return apiRequest(endPoint.url + endPoint.urlParams["module_"+module],onComplete,{method:"POST",data:vars},onError);
		
		}
		
		public static function apiLog(urlParams:String,onComplete:Function = null,onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["apiLog"];
			return apiRequest(endPoint.url+urlParams,onComplete,{method:"GET"},onError);
		}
		
		public static function signUp(name:String,email:String,onComplete:Function = null,onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["signup"];
			var vars:URLVariables = new URLVariables();
			vars[endPoint.postParams[0]] = name;
			vars[endPoint.postParams[1]] = email;
			return apiRequest(endPoint.url,onComplete,{method:"POST",data:vars},onError);
		}
		
		
		public static function logout(onComplete:Function = null,onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["logout"];
			return apiRequest(endPoint.url,onComplete,{method:"GET"},onError);
		}
		
		public static function share(type : String,onComplete:Function = null,onError:Function = null) : void {
			var call:String;			
			if(AppSettings.DEVICE == AppSettings.DEVICE_PC){
				call = type == "facebook" ? "shareFacebook" : (type == "twitter" ? "shareTwitter" : (type == "google" ? "shareGooglePlus" : ""));
				if (call != ""){
					externalCall(call,onComplete,null,onError);
				}else if (onError != null){
					onError(new Event("BackendResponder::share -> InvalidTypeSupplied"));
				}
			}else{
				call = type == "facebook" ? "facebook" : (type == "twitter" ? "twitter" : (type == "google" ? "googleplus" : ""));
				var endPoint:Object = ENDPOINTS["share"];
				Logger.log(Logger.BACKEND,"calling",endPoint.url+endPoint.urlParams[call]);
				navigateToURL(new URLRequest(endPoint.url+endPoint.urlParams[call]));
				//return apiRequest(endPoint.url+endPoint.urlParams[call],onComplete,{method:"GET"},onError);
			}
		}
		
		public static function loginViaSocial(type:String,onComplete:Function = null,onError:Function = null):BackendResponder{
			var call:String = type == "facebook" ? "loginFacebook" : (type == "twitter" ? "loginTwitter" : (type == "google" ? "loginGoogle" : ""));
			//if(type == "twitter" || type == "google"){
			//	var endPoint:Object = ENDPOINTS[call];
			//	return apiRequest(endPoint.url,onComplete,{method:"GET"},onError);	
			//}else{
				if (call != ""){
					externalCall(call,onComplete,null,onError);
				}else if (onError != null){
					onError(new Event("BackendResponder::loginViaSocial -> InvalidTypeSupplied"));
				}else{
					throw new Error("BackendResponder::loginViaSocial -> InvalidTypeSupplied");
				}
				return null;
		//	}
		}
		
		public static function login(email:String,authCode:String,onComplete:Function = null,onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["login"];
			var vars:URLVariables = new URLVariables();
			vars[endPoint.postParams[0]] = email;
			vars[endPoint.postParams[1]] = authCode;
			return apiRequest(endPoint.url,onComplete,{method:"POST",data:vars},onError);
		}
		
		public static function resendAuth(email:String,onComplete:Function = null,onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["resendAuth"];
			var vars:URLVariables = new URLVariables();
			vars[endPoint.postParams[0]] = email;
			return apiRequest(endPoint.url,onComplete,{method:"POST",data:vars},onError);
		}
		
		
		public static function getCertificate() : void {
			var endPoint:Object = ENDPOINTS["certificate"];
		//	return apiRequest(endPoint.url+endPoint.urlParams.download,null,{method:"GET"},null);
			navigateToURL(new URLRequest(endPoint.url+endPoint.urlParams.download),"_blank");
		}
		
		//"name","email","captcha","message"
		public static function sendFeedback(name:String,email:String,captcha:String,message:String,onComplete:Function = null,onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["sendFeedback"];
			var vars:URLVariables = new URLVariables();
			vars[endPoint.postParams[0]] = name;
			vars[endPoint.postParams[1]] = email;
			vars[endPoint.postParams[2]] = captcha;
			vars[endPoint.postParams[3]] = message;
			return apiRequest(endPoint.url,onComplete,{method:"POST",data:vars},onError);
		}
		
		public static function getStoresLinks(onComplete:Function = null,onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["mobileStoresUrl"];
			return apiRequest(endPoint.url, onComplete,{method:"GET"},onError);
		}
		
		public static function videoListData(videos:String,onComplete:Function = null,onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["videoSize"];
			var vars:URLVariables = new URLVariables();
			vars[endPoint.getParams[0]] = videos;
			return apiRequest(endPoint.url,onComplete,{method:"GET",data:vars},onError);
		}
		
		public static function getCaptcha(onComplete:Function = null,onError:Function = null):BackendResponder{
			var endPoint:Object = ENDPOINTS["captcha"];
			return apiRequest(endPoint.url,onComplete,{method:"GET",useLoader:true},onError);
		}
		
		
		public static function apiRequest(endpoint:String,onComplete:Function,params:Object = null,onError:Function = null):BackendResponder{
			
			Logger.log(Logger.BACKEND,"calling backend",endpoint);
			if(_initialized){
				var be:BackendResponder = new BackendResponder(endpoint,onComplete,params,onError);
				return be;
			}else{
				var f:Function = function():void{
					apiRequest(endpoint,onComplete,params,onError);
				};
				initialize(f,f);
				return null;
			}
		}
		
		public static function externalCall(func:String,onComplete:Function,params:Object = null,onError:Function = null):void{
			if (ExternalInterface.available) {
				jsCallbacks[func] = onComplete;
				ExternalInterface.call(func);
				
			}
		}
		
		/*
		 * Object scope
		 * 
		 */
		 
		public static const DEFAULT_PARAMS:Object = {
			contentType: "application/x-www-form-urlencoded",
			data:null,
			method: "GET",
			requestHeaders: [],
			//urlloader params
			dataFormat: "text"
		};
		 
		private var _complete:Function;
		private var _endpoint:String;
		private var _params:Object;
		private var _error:Function;
		
		private var _loader:*;
		
		public function BackendResponder(endpoint:String,onComplete:Function,params:Object = null,onError:Function = null){
			_endpoint = endpoint;
			_complete = onComplete;
			_params = params || {};
			_error = onError;
			loadURL();
		}
		
		private function loadURL():void{
			
			var urlreq : URLRequest = new URLRequest(_endpoint);
			
			if(_params.hasOwnProperty("useLoader") && _params["useLoader"] == true){
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, ioError);
				
				_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
	
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			}else{	
				urlreq.contentType = _params.contentType || DEFAULT_PARAMS.contentType;
				urlreq.data = _params.data || DEFAULT_PARAMS.data;
				urlreq.method = _params.method || DEFAULT_PARAMS.method;
				urlreq.requestHeaders = _params.requestHeaders || DEFAULT_PARAMS.requestHeaders;
				if(AppSettings.DEBUG && !AppSettings.USE_LIVE_BACKEND_ON_DEBUG ){
					urlreq.requestHeaders.push(new URLRequestHeader("Authorization","Basic a2FuaXNoOmVkcDUzd2tu"));
				}
				_loader = new URLLoader();
				_loader.dataFormat = _params.dataFormat || DEFAULT_PARAMS.dataFormat;
			
				_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
				_loader.addEventListener(IOErrorEvent.NETWORK_ERROR, ioError);
				
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
	
				_loader.addEventListener(Event.COMPLETE, onComplete);
			}
			
			_loader.load(urlreq);
		}
		
		private function onHTTPStatus(evt : HTTPStatusEvent) : void {
			Logger.log(Logger.BACKEND,"\nHttpStatus:", _endpoint, evt.toString(),"\n");
		}

		private function onSecurityError(evt : SecurityErrorEvent) : void {
			Logger.log(Logger.BACKEND,"\nSecurityError:", _endpoint, evt.toString(),"\n");
			onError(evt);
		}

		private function ioError(evt : IOErrorEvent) : void {
			Logger.log(Logger.BACKEND,"\nIOERROR:", _endpoint, evt.toString(),"\n");
			onError(evt);
		}
		
		private function onError(evt : Event):void{
			if(_error != null) _error(evt);
			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			_loader.removeEventListener(IOErrorEvent.NETWORK_ERROR, ioError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_loader.removeEventListener(Event.COMPLETE, onComplete);
		}

		private function onComplete(evt : Event):void{
		// 	Logger.log(Logger.BACKEND,"backend load complete");
			if(_complete != null) _complete(evt,_loader);
			if((_loader) as Loader){
				
				_loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, ioError);
				_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			}else{
				
				_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
				_loader.removeEventListener(IOErrorEvent.NETWORK_ERROR, ioError);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				_loader.removeEventListener(Event.COMPLETE, onComplete);
			}
		}



		
	}
}

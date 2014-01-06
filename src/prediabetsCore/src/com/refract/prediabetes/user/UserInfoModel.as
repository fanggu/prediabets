package com.refract.prediabetes.user 
{
	import com.refract.prediabetes.AppSettings;
	/**
	 * @author kanish
	 */
	public class UserInfoModel {
		
		
		public function UserInfoModel():void{
			_name = "";
			_email = "";
			_authCode = "";
			_meta = {
				facebook: {id:"",name:"",link:""},
				twitter:{id:"",name:"",accessToken:"",accessTokenSecret:""},
				google:{id:"",link:"",picture:""}
			};
			//_isLoggedIn = AppSettings.USER_LOGGED_IN_INIT;
			_refresher = false;
		}


		private var _refresher : Boolean;
		public function get refresher() : Boolean {
			return _refresher;
		}
		public function set refresher(refresher : Boolean) : void {
			_refresher = refresher;
		}

		private var _isLoggedIn:Boolean;
		
		public function get isLoggedIn() : Boolean {
			return _isLoggedIn;
		}

		public function set isLoggedIn(isLoggedIn : Boolean) : void {
			_isLoggedIn = isLoggedIn;
		}

		private var _name : String;

		public function get name() : String {
			return _name;
		}

		public function set name(name : String) : void {
			_name = name;
		}

		private var _email : String;

		public function get email() : String {
			return _email;
		}

		public function set email(email : String) : void {
			_email = email;
		}
		
		private var _authCode:String;
		public function get authCode() : String {
			return _authCode;
		}

		public function set authCode(code : String) : void {
			_authCode = code;
		}

		private var _meta : Object;

		public function get meta() : Object {
			return _meta;
		}

		public function set meta(meta : Object) : void {
			_meta = meta;
		}
		
		public function get metaFacebook():Object { return _meta.facebook; }

		public function get metaTwitter() : Object {
			return _meta.twitter;
		}

		public function get metaGoogle() : Object {
			return _meta.google;
		}

		public function reset() : void {
			_name = "";
			_email = "";
			_authCode = "";
			metaFacebook.id = "";
			metaFacebook.name = "";
			metaFacebook.link = "";
			metaTwitter.id = "";
			metaTwitter.name = "";
			metaTwitter.accessToken = "";
			metaTwitter.accessTokenSecret = "";
			metaGoogle.id = "";
			metaGoogle.link = "";
			metaGoogle.picture = "";
			_isLoggedIn = AppSettings.USER_LOGGED_IN_INIT;
			_refresher = false;
		}

		
	}
}

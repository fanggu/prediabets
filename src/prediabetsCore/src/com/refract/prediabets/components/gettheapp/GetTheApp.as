package com.refract.prediabets.components.gettheapp {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.shared.LSButton;

	import org.osmf.metadata.NullMetadataSynthesizer;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class GetTheApp extends Sprite {
		
		protected var _headerStyle:Object = {fontSize:72};
		protected var _bodyStyle:Object = {fontSize:12, autoSize:"left", selectable:true, wordWrap: true, multiline:true, width:385};
		private var _header:TextField;
		private var _bodyText:TextField;
		
		private var _buttons:Sprite;
		private var _tabletButtons:Sprite;
		
		private var _iOSButton:LSButton;
		private var _androidButton:LSButton;
		
		private var _iOSTabletButton:LSButton;
		private var _androidTabletButton:LSButton;
		
		public var useClose:Boolean = true;
		
		public function GetTheApp() {
			super();
			
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			
			_header = TextManager.makeText("page_get_the_app_title",this,_headerStyle);
			_header.x = -_header.width/2;
			
			_bodyText = TextManager.makeText("page_get_the_app_content",this,_bodyStyle);
			_bodyText.x = -_bodyText.width/2;
			_bodyText.y = _header.y + _header.height + 30;
			
			var buttonStyle:Object = {fontSize:30};
			
			_buttons = new Sprite();
			addChild(_buttons);
			_buttons.y = _bodyText.y + _bodyText.height+20;
			
			_iOSButton = new LSButton("page_get_the_app_ios",buttonStyle,100,50,true,false);
			_androidButton = new LSButton("page_get_the_app_android",buttonStyle,100,50,true,false);
			
			if(AppSettings.ITUNES_LINK != ""){
				_buttons.addChild(_iOSButton);
			}
			if(AppSettings.PLAY_LINK != ""){
				_buttons.addChild(_androidButton);
			}
			
			_tabletButtons = new Sprite();
			addChild(_tabletButtons);
			_tabletButtons.y = _buttons.y + _buttons.height + 10;
			
			_iOSTabletButton = new LSButton("page_get_the_app_ios_tablet",buttonStyle,100,50,true,false);
			_androidTabletButton = new LSButton("page_get_the_app_android_tablet",buttonStyle,100,50,true,false);
			
			if(AppSettings.ITUNES_TAB_LINK != ""){
				_tabletButtons.addChild(_iOSTabletButton);
			}
			if(AppSettings.PLAY_TAB_LINK != ""){
				_tabletButtons.addChild(_androidTabletButton);
			}
			
			var maxW:Number = 0;
			maxW = _buttons.contains(_iOSButton) && _iOSButton.width > maxW ? _iOSButton.width : maxW;
			trace(maxW);
			maxW = _buttons.contains(_androidButton) && _androidButton.width > maxW ? _androidButton.width : maxW;
			trace(maxW);
			maxW = _tabletButtons.contains(_iOSTabletButton) && _iOSTabletButton.width > maxW ? _iOSTabletButton.width : maxW;
			trace(maxW);
			maxW = _tabletButtons.contains(_androidTabletButton) && _androidTabletButton.width > maxW ? _androidTabletButton.width : maxW;
			trace(maxW);
			
			
			for(var i:int= 0; i < _buttons.numChildren; ++i){
				LSButton(_buttons.getChildAt(i)).minW = maxW;
				if(i != 0){
					_buttons.getChildAt(i).x = _buttons.getChildAt(i-1).x + _buttons.getChildAt(i-1).width + 10;
				}
			}
			
			for( i = 0; i < _tabletButtons.numChildren; ++i){
				LSButton(_tabletButtons.getChildAt(i)).minW = maxW;
				if(i != 0){
					_tabletButtons.getChildAt(i).x = _tabletButtons.getChildAt(i-1).x + _tabletButtons.getChildAt(i-1).width + 10;
				}
			}
			
		//	_bodyTextAndroid.y = _bodyTextiOS.y + _bodyTextiOS.height;
		//	_androidButton.x = _buttons.contains(_iOSButton) ? _iOSButton.x + _iOSButton.width + 10 : 0;
			
			
			_buttons.x =  -_buttons.width/2;
			_tabletButtons.x =  -_tabletButtons.width/2;
					
			_iOSButton.addEventListener(MouseEvent.CLICK, oniOS);
			_androidButton.addEventListener(MouseEvent.CLICK, onAndroid);
			_iOSTabletButton.addEventListener(MouseEvent.CLICK, oniOSTablet);
			_androidTabletButton.addEventListener(MouseEvent.CLICK, onAndroidTablet);
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		private function onResize(evt : Event=null) : void {
			this.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;
			this.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - this.height/2;
		}
		
		private function oniOS(evt:MouseEvent):void{
			AppSettings.goToLink(AppSettings.ITUNES_LINK);
		}
		
		private function onAndroid(evt:MouseEvent):void{
			AppSettings.goToLink(AppSettings.PLAY_LINK);
		}
		
		private function oniOSTablet(evt:MouseEvent):void{
			AppSettings.goToLink(AppSettings.ITUNES_TAB_LINK);
		}
		
		private function onAndroidTablet(evt:MouseEvent):void{
			AppSettings.goToLink(AppSettings.PLAY_TAB_LINK);
		}
		
		public function destroy():void{
			stage.removeEventListener(Event.RESIZE, onResize);
			
			_iOSButton.removeEventListener(MouseEvent.CLICK, oniOS);
			_androidButton.removeEventListener(MouseEvent.CLICK, onAndroid);
			
			_iOSTabletButton.removeEventListener(MouseEvent.CLICK, oniOSTablet);
			_androidTabletButton.removeEventListener(MouseEvent.CLICK, onAndroidTablet);
			
			_iOSButton.destroy();
			_androidButton.destroy();
			
			_iOSTabletButton.destroy();
			_androidTabletButton.destroy();
			
			_buttons.removeChildren();
			_bodyText = null;
			_header = null;
			_bodyStyle = null;
			_headerStyle = null;
			removeChildren();
		}
	}
}

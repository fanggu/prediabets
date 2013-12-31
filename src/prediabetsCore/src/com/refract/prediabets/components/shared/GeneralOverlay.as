package com.refract.prediabets.components.shared {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.refract.prediabets.AppSettings;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class GeneralOverlay extends Sprite {
		
		public static var BODY_WIDTH:int = 890;
		public static var BODY_HEIGHT:int = 400;
		
		protected var _headerStyle:Object = {fontSize:72,fontScale:1};
		protected var _bodyTitleStyle:Object = {fontSize:24, autoSize:"left", selectable:true, wordWrap: true, multiline:true, width:BODY_WIDTH-40};
		protected var _bodySubtitleStyle:Object = {fontSize:24, autoSize:"left",mouseEnabled:true, selectable:true, wordWrap: true, multiline:true, width:BODY_WIDTH-40};
		protected var _bodyStyle:Object = {fontSize:12, autoSize:"left",mouseEnabled:true, selectable:true, align:"left",leading:4, wordWrap: true, multiline:true, width:BODY_WIDTH-40};//385
		
		protected var _header:TextField;
		
		protected var _body:Sprite;
		
		protected var _scrollbox:ScrollBox;
		protected var _overscroll:Boolean = false;
		
		
		protected var _scrollerWidth:Number = BODY_WIDTH;//390
		protected var _scrollerHeight:Number = BODY_HEIGHT;//290
		
		
		
		public var useClose:Boolean = true;
		
		public function GeneralOverlay() {
			_scrollerWidth = BODY_WIDTH;
			_scrollerHeight = BODY_HEIGHT;
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		protected function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			if(AppSettings.DEVICE == AppSettings.DEVICE_TABLET){
				_headerStyle.fontScale = 1.2;
		//		BODY_WIDTH = BODY_WIDTH*_headerStyle.fontScale;
			//	BODY_HEIGHT = BODY_HEIGHT*_headerStyle.fontScale;
			}
			
			_body = new Sprite();
			
			_bodyTitleStyle.width = _bodySubtitleStyle.width = _bodyStyle.width = BODY_WIDTH-5;
			
			createContent();
			
			
			stage.addEventListener(Event.RESIZE,onResize);
            SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
			onResize();
		}
		
		protected function createContent():void{
			_scrollbox = new ScrollBox(_scrollerWidth, _scrollerHeight, _body,_overscroll);
			addChild(_scrollbox);
			
		//	_header.x = -_header.width/2;
			
			_scrollbox.x = int(-_scrollbox.contentWidth/2);
			_scrollbox.y = _header ? int(_header.y + _header.height + 20) : 0;
			
			if(_header){
				_header.x = _scrollbox.x;
			}
		}
		
		public function get effectiveHeight():Number{
		//	Logger.log(Logger.OVERLAY,"EFFECTIVE HEIGHT: this.height:", this.height,"_body.y:",_body.y,"_body.height:", _body.height,"_scrollbox.contentHeight:", _scrollbox.contentHeight,"result:", _scrollbox ? this.height - _body.height + _scrollbox.contentHeight : this.height);			
			var _bodyY:Number = _body.y;
			_body.y = 0;
			var effectiveHeight:Number = _scrollbox ? this.height - _body.height + _scrollbox.contentHeight : this.height;
			_body.y = _bodyY;
			return effectiveHeight;
		}
		
		protected function onResize(evt:Event = null,b:Boolean = true):void{
			
			if(_scrollbox){
				_scrollbox.x = int(-_scrollbox.contentWidth/2);
				_scrollbox.y = _header ? int(_header.y + _header.height + 10) : 0;
			}
			this.x = int(AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2);
			this.y = int(AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - this.effectiveHeight/2);
			
		//	_scrollbox.updateSize(_scrollbox.width,AppSettings.VIDEO_BOTTOM - 10 - this.y - _scrollbox.y);
		}
		
		protected function handleSWFAddress(evt:SWFAddressEvent):void{
			
		}
		
		
		public function destroy():void{
			if(_scrollbox){
				_scrollbox.destroy();
			}
			_body.removeChildren();
			removeChildren();
            SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
			stage.removeEventListener(Event.RESIZE,onResize);
			
			_headerStyle = null;
			_bodyTitleStyle = null;
			_bodySubtitleStyle = null;
			_bodyStyle = null;
			_header = null;
			_body = null;
			_scrollbox = null;
		}
		
	}
}

package com.refract.prediabets.components.about {
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.shared.GeneralOverlay;
	import com.refract.prediabets.logger.Logger;

	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class About extends GeneralOverlay {
		private var _bodyText:TextField;
		
		public function About() {
			super();
		}
		
		
		override protected function createContent():void{
			_header = TextManager.makeText("page_about_title",this,_headerStyle);
			_bodyStyle.mouseEnabled = true;
			_bodyStyle.selectable = true;
			_bodyStyle.width = _header.width;
			_bodyText = TextManager.makeText("page_about_content", _body,_bodyStyle);
			super.createContent();
			if(_header.width > _scrollbox.width){
				_header.x = int(-_header.width/2);
				_scrollbox.x = _header.x;
				Logger.log(Logger.OVERLAY,_header.width,_scrollbox.width);
			}
		}		
		
		override protected function onResize(evt:Event = null,b:Boolean = true):void{
			super.onResize(evt,b);
			if(_header.width > _scrollbox.width){
				_header.x = int(-_header.width/2);
				_scrollbox.x = _header.x;
			}else{
				_scrollbox.x = int(-_scrollbox.contentWidth/2);
				_header.x = _scrollbox.x ;
			}
		//	_scrollbox.updateSize(_scrollbox.width,AppSettings.VIDEO_BOTTOM - 10 - this.y - _scrollbox.y);
		}
		
	}
}

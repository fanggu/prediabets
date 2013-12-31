package com.refract.prediabets.components.emergencyinfo {
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSections;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.shared.LSButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * @author kanish
	 */
	public class EmergencyInfoLanding extends Sprite {
		
		private var _header:TextField;
		private var _collapsedBtn:LSButton;
		private var _chokingBtn:LSButton;
		
		public function EmergencyInfoLanding(){
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			_header = TextManager.makeText("page_emergency_info_landing_title",this,{fontSize:72});
			_header.x = -_header.width/2;
			
			
			var btnStyle:Object = {fontSize:36};
			//320x70
			_collapsedBtn = new LSButton("page_emergency_info_landing_collapsed",btnStyle,320,70,true,false);
			addChild(_collapsedBtn);
			_chokingBtn = new LSButton("page_emergency_info_landing_choking",btnStyle,_collapsedBtn.width,70,true,false);
			addChild(_chokingBtn);
			_collapsedBtn.x = - _collapsedBtn.width/2;
			_collapsedBtn.y = _header.y + _header.height + 50;
			_chokingBtn.x = - _chokingBtn.width/2;
			_chokingBtn.y = _collapsedBtn.y + _collapsedBtn.height + 10;
			
			_collapsedBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			_chokingBtn.addEventListener(MouseEvent.CLICK, onBtnClick);
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		private function onBtnClick(evt : MouseEvent) : void {
			switch(evt.currentTarget){
				case(_collapsedBtn):
					AppController.i.setSWFAddress(AppSections.EMERGENCY_INFO_COLLAPSED);
					break;
				default:
					AppController.i.setSWFAddress(AppSections.EMERGENCY_INFO_CHOKING);
					
			}
		}
		
		private function onResize(evt:Event = null):void{
			this.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;
			this.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT/2 - this.height/2;
		}
	
		public function destroy():void{
			removeChildren();
			_collapsedBtn.destroy();
			_chokingBtn.destroy();
			
			_header = null;
			_chokingBtn = null;
			_collapsedBtn = null;
		}
	
	}
}

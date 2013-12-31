package com.refract.prediabets.components.emergencyinfo {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSections;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.ClassFactory;
	import com.refract.prediabets.backend.BackendResponder;
	import com.refract.prediabets.components.events.FooterEvent;
	import com.refract.prediabets.components.shared.LSButton;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author kanish
	 */
	public class EmergencyInfo extends Sprite {
		
		private var _landing:EmergencyInfoLanding;
		private var _collapsed:EmergencyInfoCollapsed;
		private var _choking:EmergencyInfoChoking;
		
		
		private var _currentState:int = -1;
		private var _states:Array;
		
		private var _back:LSButton;
		private var _backCover:Sprite;
		
		public function EmergencyInfo() {
			super();
			BackendResponder.apiLog("page/emergency_info");
			
		//	TweenPlugin.activate([AutoAlphaPlugin]);
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			addChild(_landing = new ClassFactory.EMERGENCY_INFO_LANDING());
			addChild(_collapsed = new ClassFactory.EMERGENCY_INFO_COLLAPSED());
			addChild(_choking = new ClassFactory.EMERGENCY_INFO_CHOKING());
			_landing.alpha = _collapsed.alpha = _choking.alpha = 0;
			_landing.visible = _collapsed.visible =  _choking.visible = false;
			
			_states = [_landing,_collapsed,_choking];
			
			_back = new LSButton("page_emergency_info_back",{fontSize:AppSettings.FOOTER_FONT_SIZE});
			addChild(_back);
			_back.addEventListener(MouseEvent.CLICK,onBack);
			
			_backCover = new Sprite();
		//	_backCover.graphics.lineStyle(1,0xffffff,1);
			_backCover.graphics.beginFill(0x000000,1);
			_backCover.graphics.drawRect(0,0,_back.width + 180,_back.height);
			
			removeChild(_back);
			
            SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
			handleSWFAddress();
		}
		
		protected function onBack(evt:MouseEvent):void{
			SWFAddress.up();
		//	AppController.i.setSWFAddress(AppSections.EMERGENCY_INFO);
		//	setState(0);
		}
		
		protected function handleSWFAddress(evt:SWFAddressEvent = null):void{
			var paths:Array = SWFAddress.getPathNames();
			var index:int;
			
			if(paths.length > 1){
				switch(paths[1]){
					case(AppSections.EMERGENCY_INFO_COLLAPSED.split("/")[1]):
						index = 1;
						setState(index);
					break;
					case(AppSections.EMERGENCY_INFO_CHOKING.split("/")[1]):
						index = 2;
						setState(index);
					break;
					default:
						index = 0;
						setState(index);
				}
			}else{
				index = 0;
				setState(index);
			}
		}
		
		private function setState(state:int):void{
			if(state != _currentState){
				_currentState != -1 ? TweenMax.to(_states[_currentState],0.5,{autoAlpha:0}) : 0;
				TweenMax.to(_states[state],0.5,{autoAlpha:1});				
				_currentState = state;
				if(state == 0){
					DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.REMOVE_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_backCover,caller:this}));
					DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.REMOVE_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_back,caller:this}));
				}else{
					DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.ADD_FOOTER_ITEM, {position:FooterEvent.BOTTOM_MIDDLE,button:_backCover}));
					DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.ADD_FOOTER_ITEM, {position:FooterEvent.BOTTOM_MIDDLE,button:_back}));
				}
			}
		}
		
		
		public function destroy():void{
			
			_landing.destroy();
			_collapsed.destroy();
			_choking.destroy();
			
			_states.slice(0,_states.length);
			
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.REMOVE_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_backCover,caller:this}));
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.REMOVE_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_back,caller:this}));
			
			removeChildren();
			
			_back.removeEventListener(MouseEvent.CLICK, onBack);
			_back.destroy();
			
			_landing = null;
			_collapsed = null;
			_choking = null;
		}
	}
}

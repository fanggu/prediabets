package com.refract.air.shared.components.profile {
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.components.profile.LoadedProfileButton;

	import flash.events.Event;

	/**
	 * @author kanish
	 */
	public class MobileProfileButton extends LoadedProfileButton {
		
	//	private var _msk:Shape;
		
		
		public function MobileProfileButton(id : int) {
			super(id);
		}
		
		override protected function init(evt:Event):void{
		//	_msk = new Shape();
		//	addChild(_msk);
			super.init(evt);
			
		//	_bkg.mask = _msk;
		}
		
		override protected function onResize(evt : Event = null) : void {
			_bkg.width = AppSettings.VIDEO_WIDTH*.6;
			_bkg.scaleY = _bkg.scaleX;
			
	//		_msk.graphics.clear();
	//		_msk.graphics.beginFill(0xff00,1);
	//		_msk.graphics.drawRect(0,0,_bkg.width,AppSettings.VIDEO_HEIGHT);
			
			if(_certificate){
				_certificate.x = _bkg.width/2 -_certificate.width/2;
			}
			_top.x = _bkg.width/2;
			_top.y = 50;//_bkg.height/2 - 40;
			
			_bottom.x = _bkg.width/2;
			_bottom.y = AppSettings.VIDEO_HEIGHT - 20 - _bottom.height;
			
			this.x = (_id - 1)*(this._bkg.width + 1);
		}
	}
}

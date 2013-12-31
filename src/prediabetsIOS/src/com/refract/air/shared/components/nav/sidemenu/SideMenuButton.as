package com.refract.air.shared.components.nav.sidemenu {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.components.shared.LSButton;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author kanish
	 */
	public class SideMenuButton extends LSButton {
		public function SideMenuButton(copyID : String = null, props : Object = null, w : Number = 0, h : Number = 0, useArrow : Boolean = false, extraBlack : Boolean = false) {
			super(copyID, props, w, h, useArrow, extraBlack);
			_buttonAlpha = 1;
		}
		
		override protected function init(evt:Event = null):void{
			super.init(evt);
			
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
		}
		
		override protected function onMouseEvent(ev:MouseEvent):void{
			switch(ev.type){
				case(MouseEvent.CLICK):
						super.onMouseEvent(ev);
						TweenMax.to(_bkg,0,{tint:0xa04148});
					break;
			}
		}
		
		public function removeTint():void{
			TweenMax.to(_bkg,0,{tint:null});
		}
		
		override protected function arrange():void{
			if(_arrow && _copy){
				_arrow.y = _copy.y + _copy.textHeight/2 - _arrow.height/2 + 3;
				_copy.x = int(_arrow.width + _arrowSpace);
			}//else if (_copy){
				
		//	}
		}
		
		override protected function addBkg():void{
			if(_minW > 0  && _initComplete && _body){
				
				var ww:Number = _minW > _body.width + _minBkgWidthGap  ? _minW : _body.width + _minBkgWidthGap ;
				var hh:Number = _minH > _body.height + _minBkgHeightGap ? _minH : _body.height + _minBkgHeightGap ;
				
				if(!_bkgBorder){
					_bkgBorder = new Shape();
					addChildAt(_bkgBorder,0);
				}
				
				if(!_bkg){
					_bkg = new Shape();
					addChildAt(_bkg,0);
				}
				_bkg.graphics.clear();
				if(_extraBlack){
					_bkg.graphics.beginFill(0x00,0.3);
					_bkg.graphics.drawRect(0, 0, ww, hh);
				}
				_bkg.graphics.beginFill(0x2b2b2b,1);
				_bkg.graphics.drawRect(0, 0, ww, hh);
				_bkg.graphics.endFill();
				_bkg.graphics.lineStyle(1,0x363636);
				_bkg.graphics.moveTo(0,0);
				_bkg.graphics.lineTo(ww,0);
				_bkg.graphics.moveTo(0,hh);
				_bkg.graphics.lineTo(ww,hh);
				_bkg.alpha = _buttonAlpha;
				
				_bkgBorder.graphics.clear();
				_bkgBorder.graphics.lineStyle(1,0xffffff,1);
				_bkgBorder.graphics.drawRect(0, 0, ww, hh);
				_bkgBorder.alpha = 0;
				
				_body.x = 30;//int(_bkg.width/2 - _body.width/2);
				_body.y = int(_bkg.height/2 - _body.height/2);
			}else if(_initComplete && _body){
				graphics.clear();
				graphics.beginFill(0xff0000,AppSettings.BUTTON_HIT_AREA_ALPHA);
				if(AppSettings.PLATFORM == AppSettings.PLATFORM_PC){
					graphics.drawRect(0,0,body.width,body.height);
				}else{
					graphics.drawRect(-AppSettings.BUTTON_HIT_AREA_EDGE,-AppSettings.BUTTON_HIT_AREA_EDGE,body.width+AppSettings.BUTTON_HIT_AREA_WIDTH,body.height+AppSettings.BUTTON_HIT_AREA_WIDTH);
				}
				
			}
		}
	}
}

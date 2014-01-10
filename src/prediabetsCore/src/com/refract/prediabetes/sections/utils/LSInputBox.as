package com.refract.prediabetes.sections.utils {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class LSInputBox extends Sprite {
		private var _copy:TextField;
		private var _copyID:String;
		private var _copyProps:Object;
		private var _originalCopy:String;
		public function set originalCopy(str:String):void{ _originalCopy = str; }
		public function get originalCopy():String{ return _originalCopy; }
		public function set text(txt:String):void{	_copy.htmlText = txt; draw();	}
		public function get text():String{	return _copy.text;	}
		
		private var _bkg:Shape;
		
		private var _minW:Number; 
		public function get minW() : Number { return _minW; }
		public function set minW(minW : Number) : void { _minW = minW; draw(); }
		
		private var _minH:Number;
		public function get minH() : Number { return _minH; }
		public function set minH(minH : Number) : void { _minH = minH; draw(); }
		
		
		private var _minBkgHeightGap:Number = 18;
		public function get minBkgHeightGap():Number { return _minBkgHeightGap; }
		public function set minBkgHeightGap(num:Number):void { _minBkgHeightGap = num; draw(); }
		
		private var _minBkgWidthGap:Number = 18;
		public function get minBkgWidthGap():Number { return _minBkgWidthGap; }
		public function set minBkgWidthGap(num:Number):void { _minBkgWidthGap = num; draw(); }
		
		private var _inputAlpha:Number = 0.1;
		public function get inputAlpha():Number{return _inputAlpha;}
		public function set inputAlpha(alpha:Number):void{ _inputAlpha = alpha; addBkg();}
		
		public function get textfield():TextField{
			return _copy;
		}
		
		private var _initComplete:Boolean = false;
		
		public function LSInputBox(copyID:String = null, props:Object = null, w:Number = 0,h:Number = 0) {
			_copyID = copyID;
			_copyProps = props;
			_copyProps.width = w;
			_copyProps.mouseEnabled = true;
			if(_copyProps.multiline){
				_copyProps.height = h;
				_copyProps.wordWrap = true;
			}else{
				_copyProps.height = _copyProps.fontSize+4;
			}
			_copyProps.type = "input";
			_copyProps.autoSize = "none";
			_copyProps.selectable = true;
			
			_minW = w;
			_minH = h;
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			_initComplete = true;
			
			draw();
			setProperties();
			addEvents();
		}
		
		private function draw():void{
			if(_initComplete)
			{	
				addCopy();
				addBkg();
			}
		}
		private function addCopy() : void {
			_copyProps.width = _minW;
			if(!_copy && _copyID){
				_copy = TextManager.makeText(_copyID, this, _copyProps);
				_originalCopy = _copy.text;
			}else{
				_copy.width = _minW;
			}
		}
		
		private function addBkg():void{
			if(_minW > 0 && _minH > 0 && _initComplete){
				
				var ww:Number = _minW > _copy.width + _minBkgWidthGap  ? _minW : _copy.width + _minBkgWidthGap ;
				var hh:Number = _minH > _copy.height + _minBkgHeightGap ? _minH : _copy.height + _minBkgHeightGap ;
				
				
				if(!_bkg){
					_bkg = new Shape();
					addChildAt(_bkg,0);
				}
				_bkg.graphics.clear();
				_bkg.graphics.beginFill(0xffffff,_inputAlpha);
				_bkg.graphics.drawRect(0, 0, ww, hh);
				
				_copy.x = int(ww/2 - _copy.width/2);
				_copy.y = int(hh/2 - _copy.height/2);
			}
		}
		
		private function setProperties():void{
		//	mouseChildren = false;
			mouseEnabled = true;
			useHandCursor = true;
		//	buttonMode = true;
		}
		
		private function addEvents():void{
			this.addEventListener(MouseEvent.CLICK,setFocus);
			_copy.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_copy.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}

		private function onFocusOut(event : FocusEvent) : void {
			if(_copy.text == ""){
				_copy.text = _originalCopy;
				TweenMax.to(_copy,0,{tint:null});
			}
			dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
		}

		private function onFocusIn(evt : FocusEvent) : void {
			if(_copy.text == _originalCopy){
				_copy.text = "";
			}
			setNormalState();
			TweenMax.to(_copy,0,{tint:AppSettings.WHITE});
		}
		
		private function setFocus(evt:MouseEvent):void{
			stage.focus = _copy;
		}
		
		public function setErrorState():void{
			
			var ww:Number = _minW > _copy.width + _minBkgWidthGap  ? _minW : _copy.width + _minBkgWidthGap ;
			var hh:Number = _minH > _copy.height + _minBkgHeightGap ? _minH : _copy.height + _minBkgHeightGap ;
				
			_bkg.graphics.clear();
			_bkg.graphics.lineStyle(1,0xffffff,1);
			_bkg.graphics.beginFill(0xffffff,_inputAlpha);
			_bkg.graphics.drawRect(0, 0, ww, hh);
			
			TweenMax.killTweensOf(_bkg);
			TweenMax.to(_bkg,0.5,{tint:AppSettings.RED});
		}
		
		public function setNormalState():void{
			TweenMax.killTweensOf(_bkg);
			TweenMax.to(_bkg,0.5,{tint:null});
			
			var ww:Number = _minW > _copy.width + _minBkgWidthGap  ? _minW : _copy.width + _minBkgWidthGap ;
			var hh:Number = _minH > _copy.height + _minBkgHeightGap ? _minH : _copy.height + _minBkgHeightGap ;

			_bkg.graphics.clear();
			_bkg.graphics.beginFill(0xffffff,_inputAlpha);
			_bkg.graphics.drawRect(0, 0, ww, hh);
		}
		
		public function destroy():void{
			this.removeEventListener(MouseEvent.CLICK,setFocus);
			if(_copy){
				_copy.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
				_copy.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				_copy = null;
			}
			if(_copyProps){
				_copyProps = null;
			}
			if(_bkg){
				_bkg.graphics.clear();
				_bkg = null;
			}
			
			removeChildren();
		}

		public function isValid() : Boolean {
			if(this.text == _originalCopy || this.text == ""){
				setErrorState();
				return false;
			}
			else
				return true;
		}
		
		public function isValidEmail():Boolean{
			var valid:Boolean = isValid();
			var mail:String = this.text;
          	var pattern:RegExp = /^[0-9a-zA-Z][-.+_a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,4}$/;
			if(mail.match(pattern) == null){
				setErrorState();
				valid =  false;
			}
			
			return valid;
		}
		
	}
}

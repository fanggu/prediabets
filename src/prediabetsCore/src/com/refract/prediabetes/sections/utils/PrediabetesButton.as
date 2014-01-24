package com.refract.prediabetes.sections.utils {
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PrediabetesButton extends Sprite 
	{
		protected var _copy:TextField;
		protected var _copyID:String;
		protected var _copyProps:Object;
		
		
		protected var _id : String;
		protected var _deActiveShape : Shape;
		public function get id() : String {return _id;}
		public function set id(id : String) : void {_id = id;}
		
		
		protected var _overColor : int = AppSettings.BLACK;
		public function get overColor() : int { return _overColor; }
 		public function set overColor(overColor : int) : void { _overColor = overColor; }
		
		protected var activated : int ; 
		public function set text(txt:String):void{	_copy.htmlText = txt; draw();	}
		
		protected var _bkg:Shape;
		protected var _bkgBorder:Shape;
		
		protected var _body:Sprite;
		public function get body():Sprite{return _body;}
		
		protected var _useArrow:Boolean;
		protected var _arrow:Bitmap;
		
		public function get useArrow():Boolean {return _useArrow;}
		public function set useArrow(b:Boolean):void{_useArrow = b; draw();}
		
		protected var _extraBlack:Boolean = true;

		protected var _arrowAsset:String = "RedArrow";
		public function get arrowAsset():String{ return _arrowAsset; }
		public function set arrowAsset(str:String):void{ _arrowAsset = str;  if(_arrow){ if(_body.contains(_arrow)){ _body.removeChild(_arrow); } _arrow = null; } draw(); }
		
	
		protected var _arrowScale:Number = 0.5;
		public function get arrowScale() : Number { return _arrowScale; }
		public function set arrowScale(arrowScale : Number) : void { _arrowScale = arrowScale; draw(); }
		
		protected var _minW:Number; 
		public function get minW() : Number { return _minW; }
		public function set minW(minW : Number) : void { _minW = minW; draw(); }
		
		protected var _minH:Number;
		public function get minH() : Number { return _minH; }
		public function set minH(minH : Number) : void { _minH = minH; draw(); }
		
		
		protected var _arrowSpace:Number = 7;
		public function get arrowSpace():Number { return _arrowSpace; }
		public function set arrowSpace(num:Number):void { _arrowSpace = num; draw(); }
		
		protected var _minBkgHeightGap:Number = 21;
		public function get minBkgHeightGap():Number { return _minBkgHeightGap; }
		public function set minBkgHeightGap(num:Number):void { _minBkgHeightGap = num; draw(); }
		
		protected var _minBkgWidthGap:Number = 65;
		public function get minBkgWidthGap():Number { return _minBkgWidthGap; }
		public function set minBkgWidthGap(num:Number):void { _minBkgWidthGap = num; draw(); }
		
		protected var _buttonAlpha:Number = 1 ; //0.1;
		public function get buttonAlpha():Number{return _buttonAlpha;}
		public function set buttonAlpha(alpha:Number):void{ _buttonAlpha = alpha; addBkg();}
		
		public function get textfield():TextField{
			return _copy;
		}
		
		protected var _initComplete:Boolean = false;
		
		public function PrediabetesButton(copyID:String = null, props:Object = null, w:Number = 0,h:Number = 0, useArrow:Boolean = false, extraBlack:Boolean = true) {
			
			TweenPlugin.activate([TintPlugin]);
			_copyID = copyID;
			_copyProps = props;
			_extraBlack = extraBlack;
			_minW = w;
			_minH = h;
			activated = 0 ; 
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		protected function init(evt:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			_initComplete = true;
			
			_body = new Sprite();
			draw();
			addChild(_body);
			setProperties();
			addEvents();
		}
		
		protected function draw():void{
			if(_initComplete)
			{	
				addCopy();
				addArrow();
				arrange();
				addBkg();
				drawDeactivateShape() ; 
			}
		}
		
		protected function addArrow():void{
			if(_useArrow){
				_arrow = _arrow != null ? _arrow : AssetManager.getEmbeddedAsset(_arrowAsset);
				_arrow.smoothing = true;
				if( _body ) _body.addChild(_arrow);
				_arrow.scaleX = _arrow.scaleY = 1;
				_arrow.scaleX = _arrow.scaleY = _copy ? (_copy.textHeight*_arrowScale)/_arrow.height : 1;
			}else if(_arrow){
				_body.removeChild(_arrow);
				_arrow = null;
			}
		}

		public function startDancingArrow():void{
			if(_arrow){
				TweenMax.to(_arrow,0.5,{tint:AppSettings.WHITE});
				TweenMax.fromTo(_arrow,1,{x:-_body.x},{repeat:-1,ease:Cubic.easeInOut,x:_arrow.width});
				TweenMax.fromTo(_arrow,0.5,{alpha:0},{yoyo:true,repeat:-1,ease:Cubic.easeInOut,alpha:1});
			}
		}
		
		public function stopDancingArrow():void{
			if(_arrow){
				TweenMax.to(_arrow,0.5,{alpha:1,x:0});
				TweenMax.to(_arrow,0.5,{tint:null});
			}
		}

		protected function addCopy() : void {
			if(!_copy && _copyID)	
			{
				_copy = TextManager.makeText(_copyID, _body, _copyProps);
			}
		}
		
		protected function addBkg():void
		{
			if(_minW > 0 && _minH > 0 && _initComplete && _body)
			{
				
				var ww:Number = _minW > _body.width + _minBkgWidthGap  ? _minW : _body.width + _minBkgWidthGap ;
				var hh:Number = _minH ; //> _body.height + _minBkgHeightGap ? _minH : _body.height + _minBkgHeightGap ;
				 
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
				_bkg.graphics.beginFill(SMSettings.CHOICE_BACK_COLOR ,_buttonAlpha);
				_bkg.graphics.drawRect(0, 0, ww, hh);
				
				_bkgBorder.graphics.clear();
				_bkgBorder.graphics.lineStyle(2,SMSettings.CHOICE_BORDER_COLOR,1);
				_bkgBorder.graphics.drawRect(0, 0, ww, hh);
				_bkgBorder.alpha = 1;
				
				_body.x = int(_bkg.width/2 - _body.width/2);
				_body.y = int(_bkg.height/2 - _body.height/2);
			}else if(_initComplete && _body){
				graphics.clear();
				graphics.beginFill(0xff0000,AppSettings.BUTTON_HIT_AREA_ALPHA);
				if(AppSettings.DEVICE == AppSettings.DEVICE_PC){
					graphics.drawRect(0,0,body.width,body.height);
				}else{
					graphics.drawRect(-AppSettings.BUTTON_HIT_AREA_EDGE,-AppSettings.BUTTON_HIT_AREA_EDGE,body.width+AppSettings.BUTTON_HIT_AREA_WIDTH,body.height+AppSettings.BUTTON_HIT_AREA_WIDTH);
				}
				
			}
		}
		
		protected function arrange():void{
			if(_arrow && _copy){
				_arrow.y = _copy.y + _copy.textHeight/2 - _arrow.height/2 + 3;
				_copy.x = int(_arrow.width + _arrowSpace);
			}
		}
		
		protected function setProperties():void{
			mouseChildren = false;
			mouseEnabled = true;
			useHandCursor = true;
			buttonMode = true;
		}
		
		protected function addEvents():void{
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			this.addEventListener(MouseEvent.CLICK,onMouseEvent);
		}
		
		protected function onMouseEvent(ev:MouseEvent):void{
			switch(ev.type){
				case(MouseEvent.CLICK):
					playSound("SndGeneralClick");
					break;
				case(MouseEvent.MOUSE_OVER):
					playSound("SndGeneralRollover");
					TweenMax.to(_body,0.4,{tint:SMSettings.CHOICE_BACK_COLOR});
					//if(_bkgBorder)	TweenMax.to(_bkgBorder,0.5,{tint : SMSettings.CHOICE_BACK_COLOR });
					//if( _bkg ) TweenMax.to( _bkg , 0.5 , {tint : SMSettings.CHOICE_BORDER_COLOR } ) ;
				break;
				default:
					TweenMax.to(_body,0.2,{tint:null});
					//if(_bkgBorder) TweenMax.to(_bkgBorder,0.4,{alpha:0});
					//if( _bkg ) TweenMax.to( _bkg , 0.2 , {tint : null} ) ;
					//if( _bkgBorder ) TweenMax.to( _bkgBorder , 0.2 , {tint : null} ) ;
			}
		}
		
		public var soundEnabled:Boolean = true;
		
		protected function playSound(snd:String):void{
			if(soundEnabled)
				DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , snd) );	
		}
		
		public function removeEvents():void{
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			this.removeEventListener(MouseEvent.CLICK,onMouseEvent);
		}
		
		public function deActivate() : void
		{
			activated = -1 ;
			removeEvents() ; 
			
			mouseEnabled = false;
			useHandCursor = false;
			buttonMode = false;
			
			//_deActiveShape = new Shape() ; 
			//drawDeactivateShape() ; 
			
			//TweenMax.to( _deActiveShape , .1 , { alpha:0 , repeat:3, yoyo:true} );
			
		}
		
		protected function drawDeactivateShape( ) : void
		{
			if( _deActiveShape )
			{
				_deActiveShape.graphics.clear() ; 
				_deActiveShape.graphics.clear();
				_deActiveShape.graphics.beginFill( SMSettings.DEEP_RED, .5);
				_deActiveShape.graphics.drawRect(0, 0, _bkg.width +1, _bkg.height + 1);
				_deActiveShape.graphics.endFill() ; 
				//tempShape.x = 1 ; tempShape.y = 1 ; 
				addChild(_deActiveShape) ; 
			}
			
		}
		public function activate() : void
		{
			activated = 1 ; 
			removeEvents() ; 
			
			mouseEnabled = false;
			useHandCursor = false;
			buttonMode = false;
			
			var tempShape : Shape = new Shape() ; 
			
			tempShape.graphics.clear();
			tempShape.graphics.beginFill( SMSettings.GREEN_BUTTON, .3);
			tempShape.graphics.drawRect(0, 0, _bkg.width +1, _bkg.height + 1);
			tempShape.graphics.endFill() ; 
			//tempShape.x = 1 ; tempShape.y = 1 ; 
			addChild(tempShape) ; 
			
			TweenMax.to( tempShape , .1 , { alpha:0 , repeat:3, yoyo:true} );
			
		}
		public function destroy():void{
			stopDancingArrow();
			removeChildren();
			removeEvents();
			if(_body){
				_body.removeChildren();
				_body = null;
			}
			if(_bkg){
				_bkg.graphics.clear();
				_bkg = null;	
			}
			_copy = null;
			_copyID = null;
			_copyProps = null;
		}
		



	}
}

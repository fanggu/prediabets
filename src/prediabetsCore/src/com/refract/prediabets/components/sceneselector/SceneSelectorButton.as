package com.refract.prediabets.components.sceneselector {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.stateMachine.SMController;
	import com.refract.prediabets.stateMachine.SMSettings;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	/**
	 * @author kanish
	 */
	public class SceneSelectorButton extends Sprite {
		protected var _id : int;
		protected var _gridHeight : int;
		public function get id():int {return _id;}
		
		protected var _xx:int;
		protected var _yy:int;
		
		protected var _blocker:Shape;
		protected const _blockerAlpha:Number = 0.5;
		
		protected var _enabled:Boolean = false;
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(b:Boolean):void { _enabled = b; }
		
		protected var _image:Sprite;
		
		public function SceneSelectorButton(id : int, enabled: Boolean = false , gridHeight : int = 4) {
			_enabled = enabled;
			_id = id;
			_xx = id%4;
			_yy = Math.floor(id/4);
			_gridHeight = gridHeight ;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addEventListener(Event.RESIZE, onResize);
			
			this.buttonMode =true;
			this.mouseChildren = false;
			
			if(_enabled){
				this.useHandCursor = true;
				this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
				this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
			}else{
				this.useHandCursor = false;
			}
			
			var ls:int = AppController.i.nextStory;
			if( ls == 4) 
			{
				ls = 6 ; 
				var caption : String = SMController.me.model.captions[SMController.me.model.sceneSelect[id]] ;
			}
			 
			_image = new Sprite() ;
			var imgBmp : Bitmap = AssetManager.getEmbeddedAsset("SS_LS"+ls+"_"+(_id+1).toString(10)) as Bitmap; 
			_image.addChild( imgBmp ) ; 
			addChild(_image);
			imgBmp.smoothing = true;
			
			_blocker = new Shape();
			addChild(_blocker);		
			
			var captionTxt : TextField ; 	
			
			var tempFontSize : int = 30 ; 
			if( AppSettings.RATIO > 1.2 || AppSettings.DEVICE == AppSettings.DEVICE_MOBILE) 
			{
				tempFontSize = 14 ; 
			}
			var style:Object = 
			{ 
				fontSize: tempFontSize
				, align:TextFormatAlign.LEFT 
				, autoSize : TextFieldAutoSize.LEFT 
				, multiline: true
				, wordWrap : true
				, width : 300 
				,letterSpacing:.5
				,leading:-2.5
			} ; 
			
			if( caption )
			{
				captionTxt = TextManager.makeText( SMSettings.FONT_REAL_STORIES ,  null , style) ;
				captionTxt.htmlText = caption.toUpperCase() ;  
				_image.addChild( captionTxt ) ; 
			
				captionTxt.x = _image.width / 2 - captionTxt.width/2 + 10;
				captionTxt.y = _image.height/2 - captionTxt.height/2 ; 
			}
			onResize();
		}
		
		protected function onMouseOverOut(evt:MouseEvent):void{
			if(_enabled){
				switch(evt.type){
					case(MouseEvent.MOUSE_OVER):
							TweenMax.to(_blocker,0.5,{autoAlpha:0});
						break;
					default:
						TweenMax.to(_blocker,0.5,{autoAlpha:_blockerAlpha});
						
				}
			}else{
				_blocker.alpha = _blockerAlpha;
			}
		}
		
		
		protected function onResize(evt:Event = null):void{
			var w:Number = (AppSettings.VIDEO_WIDTH)/4 -1 ;
			var h:Number = (AppSettings.VIDEO_HEIGHT- 3)/_gridHeight -1 + 4;
			
		//	graphics.clear();
		//	graphics.beginFill(0xffffff*Math.random(),0.5);
		//	graphics.drawRect(0, 0, w, h);
			
			
			_image.width = w ;
			_image.height = h ;
			
			_blocker.graphics.clear();
			_blocker.graphics.beginFill(0x0,1);
			_blocker.graphics.drawRect(0, 0, w, h);
			
			_blocker.alpha = _blockerAlpha;
			
			x = _xx*(width+0) ; //+ 2;
			y = _yy*(height+0) ;//+ 2;
		}

		public function activate() : void
		{
			
		}
		public function deActivate() : void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
			this.useHandCursor = false; 
		}
		public function destroy():void{
			removeChildren();
			
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
			stage.removeEventListener(Event.RESIZE, onResize);
		}
		

	}
}

package com.refract.prediabets.web.preloader {
	import flash.events.TextEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class PreloaderSplash extends Sprite {
		
		public static const CONTINUE:String = "PRELOADER_SPLASH_CONTINUE";
		public static const GO_TERMS:String = "GO_TERMS";
		
		private var _assets:PreloaderAssets;
		
		
		private var lifeSaverLogo:Bitmap;
		private var unit9Logo:Bitmap;
		private var rcukLogo:Bitmap;
		
		private var splashContainer:Sprite;
		private var loaderCheckbox:Sprite;
		private var checkbox:PreloaderCheckbox;
		private var continueFS:Sprite;
		private var continueNoFS:Sprite;
		
		
		private var blankCT:ColorTransform = new ColorTransform();
		private var whiteCT:ColorTransform = new ColorTransform(1,1,1,1,255,255,255,0);
		
		public function get loaderRotation():Number{ return politeLoaderContainer.rotation; }
		public function set loaderRotation(rot:Number):void{ politeLoaderContainer.rotation = rot; }
		
		private var loaderContainer:Sprite;
		private var politeLoaderContainer:Sprite;
		private var politeText:TextField;
		
		public function PreloaderSplash(assets:PreloaderAssets) {
			_assets = assets;
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			addSplashContent();
			addLoader();
			addEvents();
		}
		
		private function addSplashContent():void{
			
			splashContainer = new Sprite();
			addChild(splashContainer);
			
			lifeSaverLogo = new _assets.LifeSaverLogo();
			splashContainer.addChild(lifeSaverLogo);
			_assets.exactCenter(lifeSaverLogo);
			lifeSaverLogo.x = -lifeSaverLogo.width/2;
			lifeSaverLogo.y = 0;//_assets.VIDEO_TOP + _assets.VIDEO_HEIGHT/2 - lifeSaverLogo.height - 30;
			lifeSaverLogo.smoothing = true;//footerContainer
			
			var lastTF:DisplayObject;
			
			var tf:TextField = _assets.createText("preloader_rcuk_presents", splashContainer);
		//	_assets.exactCenter(tf);
			tf.x = -tf.width/2;
			tf.y = lifeSaverLogo.y - tf.height - 7;
			lastTF = tf;
			
			tf = _assets.createText("preloader_martin_percy",splashContainer);
	//		_assets.exactCenter(tf);
			tf.x = -tf.width/2;
			tf.y = lifeSaverLogo.y + lifeSaverLogo.height + 7;
			lastTF = tf;
			
			tf = _assets.createText("preloader_produced_by",splashContainer);
	//		_assets.exactCenter(tf);
			tf.x = -tf.width -3;
			tf.y = lastTF.y + lastTF.height + 4;
			lastTF = tf;
			
			unit9Logo = new _assets.Unit9Logo();
			splashContainer.addChild(unit9Logo);
			unit9Logo.smoothing = true;
		//	_assets.exactCenter(unit9Logo);
			unit9Logo.x = 3;//unit9Logo.width/2 ;
			unit9Logo.y = lastTF.y+4;
			
			rcukLogo = new _assets.RCUKLogo();
			addChild(rcukLogo);
			rcukLogo.smoothing = true;
	//		_assets.exactCenter(rcukLogo);
			rcukLogo.x = -rcukLogo.width/2 - 14;
		
		}
		
		
		private function addLoader():void{
			loaderContainer = new Sprite();
			politeLoaderContainer = new Sprite();
			var pl:Bitmap = new _assets.PoliteLoader();
			politeText = _assets.createText("preloader_numbers", loaderContainer);
			
			addChild(loaderContainer);
			loaderContainer.addChild(politeLoaderContainer);
			politeLoaderContainer.addChild(pl);
			
			pl.blendMode = "screen";
			pl.smoothing = true;
			pl.scaleX = pl.scaleY = 0.77;
			pl.x = -pl.width/2;
			pl.y = -pl.height/2;
			
			politeText.x = -politeText.width/2 + 1;
			politeText.y = -politeText.height/2;
			politeText.alpha = 0.6;
			politeLoaderContainer.x += 2;
			
		//	_assets.exactCenter(loaderContainer);
		//	loaderContainer.x = -loaderContainer.width;
//			loaderContainer.y = _assets.VIDEO_BOTTOM - loaderContainer.height;
		}
		
		private function addEvents():void{
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}
		
		private function onResize(evt:Event = null):void{
			splashContainer.y =  _assets.VIDEO_TOP + _assets.VIDEO_HEIGHT/2 - lifeSaverLogo.height - 30;
			rcukLogo.y = _assets.VIDEO_BOTTOM - rcukLogo.height  - 14;
			if(loaderContainer){
				loaderContainer.y = _assets.VIDEO_BOTTOM - loaderContainer.height - 50;
			}
			if(continueFS){
				continueFS.y = _assets.VIDEO_BOTTOM - continueFS.height - 120;
			}
			if(continueNoFS){
				continueNoFS.y = continueFS.y + continueFS.height + 10;
			}
			if(loaderCheckbox){
				loaderCheckbox.y = continueFS.y - loaderCheckbox.height - 10;
			}
		}
		
		public function setLoaderText(str:String):void{
			politeText.text = str;
		}


		public function replaceLoader() : void {
			loaderContainer.visible = false;
			
			loaderCheckbox = new Sprite();
			addChild(loaderCheckbox);
			
			checkbox = new PreloaderCheckbox();
			loaderCheckbox.addChild(checkbox);
			checkbox.addEventListener(MouseEvent.CLICK, onCheckboxChange);
			
			var tf:TextField = _assets.createText("preloader_checkbox_copy",loaderCheckbox);
			tf.x = checkbox.width + 5;
			tf.y = -(tf.height - tf.textHeight);
			tf.addEventListener(TextEvent.LINK, onTextLink);
			tf.mouseEnabled = true;
			
						
			loaderCheckbox.x = -loaderCheckbox.width/2;
			
			continueFS = new Sprite();
			var arrow:Bitmap = new _assets.RedArrow();
			continueFS.addChild(arrow);
			arrow.x = 50; arrow.y = 26;
			tf = _assets.createText("preloader_enter",continueFS);
			tf.x = 72; 
			tf.y = 12;
			
			addChild(continueFS);
			drawContinueFS();
			continueFS.mouseChildren = false;
		//	_assets.exactCenter(continueFS);
			continueFS.x = -continueFS.width/2;
			
			continueNoFS = new Sprite();
			arrow = new _assets.RedArrow();
			continueNoFS.addChild(arrow);
			arrow.scaleX = arrow.scaleY = 0.5;
			arrow.y = 5;
			tf = _assets.createText("preloader_enter_noFS", continueNoFS);
			tf.x = 10;
			continueNoFS.graphics.beginFill(0xff0000,0);
			continueNoFS.graphics.drawRect(-2,0,continueNoFS.width+2,continueNoFS.height+2);
			addChild(continueNoFS);
		//	_assets.exactCenter(continueNoFS);
			continueNoFS.x = -continueNoFS.width/2;
			
			_assets.setButtonProps(continueNoFS);
			_assets.setButtonProps(continueFS);
			continueFS.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverOutFS);
			continueFS.addEventListener(MouseEvent.MOUSE_OUT, onMouseOverOutFS);
			continueNoFS.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverOutNoFS);
			continueNoFS.addEventListener(MouseEvent.MOUSE_OUT, onMouseOverOutNoFS);
			
			continueFS.addEventListener(MouseEvent.CLICK, onContinueFullScreen);
			continueNoFS.addEventListener(MouseEvent.CLICK, onContinueNoFullScreen);
			
			onResize();
			onCheckboxChange();
		}
		
		private function onTextLink(evt:TextEvent):void{
		//	Logger.log(Logger.PRELOADER,"TEXTY");
			dispatchEvent(new Event(GO_TERMS));
		}
		
		private function onCheckboxChange(evt:MouseEvent = null):void{
			if(checkbox.enabled){
				continueNoFS.alpha = 1;
				continueNoFS.mouseEnabled = true;
				
				continueFS.alpha = 1;
				continueFS.mouseEnabled = true;
			}else{
				
				continueFS.alpha = 0.5;
				continueFS.mouseEnabled = false;
				
				continueNoFS.alpha = 0.5;
				continueNoFS.mouseEnabled = false;
			}
		}
		
		
		private function drawContinueFS(withBorder:Boolean = false):void{
			continueFS.graphics.clear();
			if(withBorder){
				continueFS.graphics.lineStyle(1,0xffffff,1);
			}
			continueFS.graphics.beginFill(0xffffff,0.1);
			continueFS.graphics.drawRect(0,0,191,70);
			
		}
		
		private function onMouseOverOutFS(evt:MouseEvent):void{
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
					drawContinueFS(true);
					continueFS.transform.colorTransform = whiteCT;
					break;
				default:
					drawContinueFS(false);
					continueFS.transform.colorTransform = blankCT;
				
			}
		}
		
		
		private function onMouseOverOutNoFS(evt:MouseEvent):void{
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
						continueNoFS.transform.colorTransform = whiteCT;
					break;
				default:
						continueNoFS.transform.colorTransform = blankCT;
			}
		}
		
		private function onContinueFullScreen(evt:MouseEvent):void{
			stage.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED,onFSInteractiveAccepted);
			stage.displayState = "fullScreenInteractive";
			onContinueNoFullScreen(evt);
//			stage.displayState = "fullScreen";
		}
		
		private function onFSInteractiveAccepted(evt:FullScreenEvent):void{
		//	Logger.log(Logger.PRELOADER,evt.interactive);
		//	onContinueNoFullScreen(evt);
		}
		
		private function onContinueNoFullScreen(evt:Event):void{
			continueFS.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverOutFS);
			continueFS.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOverOutFS);
			continueNoFS.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverOutNoFS);
			continueNoFS.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOverOutNoFS);
			
			continueFS.removeEventListener(MouseEvent.CLICK, onContinueFullScreen);
			continueNoFS.removeEventListener(MouseEvent.CLICK, onContinueNoFullScreen);
			
			loaderCheckbox.getChildAt(1).removeEventListener(TextEvent.LINK, onTextLink);
			checkbox.removeEventListener(MouseEvent.CLICK, onCheckboxChange);
			
			dispatchEvent(new Event(CONTINUE));
		}

		public function destroy():void{
			
			stage.removeEventListener(Event.RESIZE,onResize);
			
			checkbox.destroy();
			
			
			loaderCheckbox.removeChildren();
			continueFS.removeChildren();
			continueNoFS.removeChildren();
			politeLoaderContainer.removeChildren();
			loaderContainer.removeChildren();
			splashContainer.removeChildren();
			splashContainer.graphics.clear();
			
			removeChildren();
			
			_assets = null;
			lifeSaverLogo = null;
			unit9Logo = null;
			rcukLogo = null;
			splashContainer = null;
			loaderContainer = null;
			politeLoaderContainer = null;
			politeText = null;
			continueFS = null;
			continueNoFS = null;
			
		}
		
	}
}

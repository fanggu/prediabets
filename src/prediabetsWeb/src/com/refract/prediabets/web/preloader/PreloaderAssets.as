package com.refract.prediabets.web.preloader {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class PreloaderAssets {
		
		public var VIDEO_WIDTH:Number = 0;
		public var VIDEO_HEIGHT:Number = 0;
		public var VIDEO_IS_STAGE_WIDTH:Boolean = false;
		public var VIDEO_LEFT:Number = 0;
		public var VIDEO_RIGHT:Number = 0;
		public var VIDEO_TOP:Number = 0;
		public var VIDEO_BOTTOM:Number = 0;

		public const RESERVED_HEADER_HEIGHT:int = 40;
		public const RESERVED_FOOTER_HEIGHT:int = 40;
		public const RESERVED_HEIGHT:int = RESERVED_FOOTER_HEIGHT + RESERVED_HEADER_HEIGHT;
		
		private const SIXTEEN_NINE_RATIO:Number = 16/9;
		
		
		//		[Embed(source="../../../../../../../lifeSaverCore/assets/img/preloaderbkg_flat.jpg")]
		[Embed(source="../../../../../../../prediabetsCore/assets/img/preloaderbkg.jpg")]
		public var BKG : Class;
		
		[Embed(source="../../../../../../../prediabetsCore/assets/img/Lifesaver.png")]
		public var LifeSaverLogo : Class;
		
		[Embed(source="../../../../../../../prediabetsCore/assets/img/politeloader.png")]
		public var PoliteLoader : Class;
		
		[Embed(source="../../../../../../../prediabetsCore/assets/img/unit9.png")]
		public var Unit9Logo : Class;
		
		[Embed(source="../../../../../../../prediabetsCore/assets/img/resuscitation_council_logo.png")]
		public var RCUKLogo : Class;
		
		
		[Embed(source="../../../../../../../prediabetsCore/assets/img/preloader_redArrow.png")]
		public var RedArrow : Class;
		
		[Embed(	source="./../../../../../../../prediabetsCore/src/com/refract/prediabets/assets/fonts/BebasNeue.otf", 
				fontName = "bebasPreloader", 
				mimeType = "application/x-font", 
				fontWeight="normal", 
				fontStyle="normal", 
				fontFamily="BebasNeuePreloader", 
    			unicodeRange="U+0020, U+0030-U+0039, U+0041-U+0046, U+0048-U+0049, U+004b-U+004d, U+004e-U+0050, U+0052-U+0057, U+0059",
    		//	unicodeRange="U+0020, U+0025, U+002e, U+0030-U+0039, U+0041-U+0045, U+0048-U+0049, U+004b-U+004c, U+004e-U+0050, U+0052-U+0055, U+0059, U+0061-U+0066, U+0068-U+0069, U+006c-U+0070, U+0072-U+0074, U+0076-U+0077",
				advancedAntiAliasing="true", 
				embedAsCFF="false" 
		)]
		private var BebasNeuePreloader : Class;
		
		[Embed(	source="./../../../../../../../prediabetsCore/src/com/refract/prediabets/assets/fonts/AkzidenzGrotesk-MediumCondAlt.otf", 
				fontName = "ak_mcaPreloader", 
				mimeType = "application/x-font", 
				fontWeight="normal", 
				fontStyle="normal", 
				fontFamily="AkzidenzGroteskMediumCondensedAltPreloader", 
    			unicodeRange="U+0020, U+0041-U+0043, U+0045-U+0046, U+0049, U+004c-U+004e, U+0050, U+0052, U+0054, U+0056, U+0059",
				advancedAntiAliasing="true", 
				embedAsCFF="false" 
		)]
		private var AkzidenzGroteskMediumCondAltPreloader:Class;
		
		[Embed(	source="./../../../../../../../prediabetsCore/src/com/refract/prediabets/assets/fonts/AkzidenzGrotesk-BoldCond.otf", 
				fontName = "ak_bcPreloader",
    			mimeType = "application/x-font", 
    			fontWeight="bold", 
    			fontStyle="normal", 
				fontFamily="AkzidenzGroteskBoldCondensedPreloader",
				unicodeRange="U+0020, U+002E, U+003f, U+0041, U+0043-U+0049, U+004b-U+004f, U+0052-U+0055, U+0057, U+0059", 
    			advancedAntiAliasing="true", 
    			embedAsCFF="false"
		)]
		private var AkzidenzGroteskBoldCondPreloader:Class;
    	//		unicodeRange="U+0020, U+003f, U+0041, U+0043-U+0049, U+004b-U+004f, U+0052, U+0054, U+0059",
		//		unicodeRange="U+0020-U+007F", 
		//		unicodeRange="U+003f, U+0041, U+0043-U+0049, U+004b-U+004f, U+0052-U+0055, U+0057, U+0059",
		
		private var _data:Array;
		public function get data():Array { return _data; }
		
		
		private var _stage:Stage;
		public function get stage():Stage { return _stage; }
		public function set stage(st:Stage):void{
			if(_stage){
				_stage.removeEventListener(Event.RESIZE, onStageResize);
			}
			_stage = st;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize();
		}
		
		public function PreloaderAssets(){
			makeData();
		}
		
		private function makeData():void{
			_data = [];
			
			_data["preloader_rcuk_presents"]={
				id:"preloader_rcuk_presents", copy_en:"THE RESUSCITATION COUNCIL UK PRESENTS",
				font: "bebasPreloader", fontSize:"16", fontWeight:"normal", align:"center",
				colour:"0x868989", gradientColor:"NONE"
			};
			
			_data["preloader_martin_percy"]={
				id:"preloader_martin_percy", copy_en:"AN INTERACTIVE FILM BY MARTIN PERCY",
				font: "ak_mcaPreloader", fontSize:"24", fontWeight:"normal", align:"center",
				colour:"0xc45252", gradientColor:"NONE"
			};
			
			_data["preloader_produced_by"]={
				id:"preloader_produced_by", copy_en:"PRODUCED BY",
				font: "bebasPreloader", fontSize:"14", fontWeight:"normal", align:"center",
				colour:"0x737877", gradientColor:"NONE"
			};
			
			_data["preloader_numbers"]={
				id:"preloader_numbers", copy_en:"00",
				font: "bebasPreloader", fontSize:"16", fontWeight:"normal", align:"center",
				colour:"0xffffff", gradientColor:"NONE"
			};
			
			_data["preloader_emergency"]={
				id:"preloader_emergency", copy_en:"NEED EMERGENCY INFORMATION? CLICK HERE",
				font: "ak_bcPreloader", fontSize:"13", fontWeight:"normal", align:"center",
				colour:"0xffffff", gradientColor:"NONE"
			};
			
			_data["preloader_enter"]={
				id:"preloader_enter", copy_en:"ENTER",
				font: "ak_mcaPreloader", fontSize:"36", fontWeight:"normal", align:"center",
				colour:"0xffffff", gradientColor:"NONE"
			};
			
			_data["preloader_enter_noFS"]={
				id:"preloader_enter_noFS", copy_en:"CONTINUE WITHOUT FULLSCREEN",
				font: "ak_bcPreloader", fontSize:"13", fontWeight:"normal", align:"center",
				colour:"0xffffff", gradientColor:"NONE"
			};
			
			
			_data["preloader_checkbox_copy"]={
				id:"preloader_checkbox_copy", copy_en:"I HAVE READ AND ACCEPTED ALL THE <u><a href='event:termsClick'>TERMS</a></u> OF THE LIFESAVER WEBSITE.",//copy_en:"I have read and accepted all the terms of the Lifesaver website.",
				font: "bebasPreloader", fontSize:"14", fontWeight:"normal", align:"center",
				colour:"0xffffff", gradientColor:"NONE", selectable:true
			};
		}
		
		public function exactCenter(disp:DisplayObject):void{
			disp.x = int(disp.parent.width/2 - disp.width/2);
			disp.y = int(disp.parent.height/2 - disp.height/2);
		}
		
		public function exactCenterStage(disp:DisplayObject):void{
			disp.x = int(stage.stageWidth/2 - disp.width/2);
			disp.y = int(stage.stageHeight/2 - disp.height/2);
		}
		
		
		public function createText(id:String,container:Sprite):TextField{
			var data:Object = _data[id];
			var txt:TextField = new TextField();
			container.addChild(txt);
			if(data){
				var format:TextFormat = new TextFormat();
				format.font = data.font;
				format.letterSpacing = data.letterSpacing ? data.letterSpacing : 0;
				format.align = data.align;
				format.size = Number(data.fontSize);
				txt.defaultTextFormat = format;
				txt.autoSize = data.align;
				txt.selectable = data.selectable ? data.selectable : false;
				txt.embedFonts = true;
			//	txt.antiAliasType = "advanced";
			//	Logger.log(Logger.PRELOADER,data.copy_en);
				txt.htmlText = data.copy_en;
				txt.textColor = int(data.colour);  //check me please
				txt.width += 3;
			}else{
			//	Logger.log(Logger.PRELOADER,"Missing Text ID: "+id+" for textfield: "+container.name)
				txt.text = "Missing Text ID: "+id+" for textfield: "+container.name;
			}
			return txt;
		}
		
		
		
		
		
		public function scaleToFit(disp:DisplayObject):void{
			var ww:Number = stage.stageWidth;
			var hh:Number = stage.stageHeight;
			
			disp.width = ww;
			disp.height = hh;
			var ratio:Number = 1.777777778; //1280/720
			
			var screenRatio:Number = ww/hh;
			if(screenRatio < ratio){
				disp.width = ww;
				disp.height = ww/ratio;
				disp.x = 0;
				disp.y = hh/2 - disp.height/2;
			}else{
				disp.width = hh*ratio;
				disp.height = hh; 
				disp.x = ww/2 - disp.width/2;
				disp.y = 0;
			}
		}
		
		private function onStageResize(evt:Event = null):void{
			var stageRatio:Number = _stage.stageWidth/(_stage.stageHeight-RESERVED_HEIGHT);
			if(SIXTEEN_NINE_RATIO > stageRatio){ //stage height greater than width -> fit to width
				VIDEO_HEIGHT = _stage.stageWidth/SIXTEEN_NINE_RATIO;
				VIDEO_WIDTH = _stage.stageWidth;
				VIDEO_IS_STAGE_WIDTH = true;
				VIDEO_LEFT = 0;
				VIDEO_RIGHT = VIDEO_WIDTH;
				VIDEO_TOP = _stage.stageHeight/2 - VIDEO_HEIGHT/2;
				VIDEO_BOTTOM = VIDEO_TOP + VIDEO_HEIGHT;
			}else{ //stage width greater than stage height -> fit to height
				VIDEO_WIDTH = (_stage.stageHeight - RESERVED_HEIGHT)*SIXTEEN_NINE_RATIO;
				VIDEO_HEIGHT = (_stage.stageHeight - RESERVED_HEIGHT);
				VIDEO_IS_STAGE_WIDTH = false;
				VIDEO_LEFT = _stage.stageWidth/2 - VIDEO_WIDTH/2;
				VIDEO_RIGHT = VIDEO_LEFT + VIDEO_WIDTH;
				VIDEO_TOP = RESERVED_HEADER_HEIGHT;
				VIDEO_BOTTOM = VIDEO_TOP + VIDEO_HEIGHT;
			}
		}
		
		public function setButtonProps(sp:Sprite):void{
			sp.mouseChildren = false;
			sp.useHandCursor = true;
			sp.mouseEnabled = true;
			sp.buttonMode = true;
		}
		
		public function destroy():void{
			BKG = null;
			LifeSaverLogo = null;
			PoliteLoader = null;
			Unit9Logo = null;
			RCUKLogo = null;
			RedArrow = null;
			BebasNeuePreloader = null;
			AkzidenzGroteskMediumCondAltPreloader = null;
			AkzidenzGroteskBoldCondPreloader = null;
			if(_stage){
				_stage.removeEventListener(Event.RESIZE, onStageResize);
				_stage = null;
			}
			_data = null;
		}
	}
}

package com.refract.prediabetes.assets {
	import com.refract.prediabetes.AppSettings;

	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextManager {
		
		private static var _i:TextManager;
		private static function get i():TextManager{
			if(!_i) _i = new TextManager(new Dummy());
			return _i;
		}
		
		public static const DEFAULT_PROPS:Object = { 
			fontSize: 16,
			fontScale: 1,
			align: "left",
			antiAlias:"advanced",
			letterSpacing: 0,
			leading: 0,
			autoSize: "left",
			selectable: false,
			wordWrap: false,
			multiline: false,
			type: "dynamic",
			toUpper: false,
			toLower: false,
			mouseEnabled: false
		};
		
		public static function makeText(id:String,container:DisplayObjectContainer = null, props:Object = null ):TextField{
			return i.makeText(id,container,props);
		}
		
		public static function styleText(id:String,txt:TextField, props:Object = null ):Boolean{
			return i.styleText(id,txt, props );
		}
		
		public static function parseData(json:String):void{
			i.parseData(json);
		}
		
		public static function getDataListForId(id:String):Array{
			return i.getDataListForId(id);
		}
		
		
		
		
		private var _data:Array;
		
		public function TextManager(dummy:Dummy){
			_data = [];
			makeDefaultData();
		}
		
		private function makeDefaultData():void
		{	
		}
		
		private function parseData(json:String):void{
			var jsonObject : Object = JSON.parse(json );
			if(jsonObject.success){
				var data:Array = jsonObject["data"];
				var len:int = data.length;
				for(var i:int = 0; i < len; ++i){
					_data[data[i]["flash_id"]] = data[i];
				}
			}
		}
		
		private function getDataListForId(id:String):Array{
			var arr:Array = [];
			for (var index:String in _data){
				if(index.indexOf(id) != -1){
					arr[index] = _data[index];
				}
			}
			return arr;
		}
		
		private function makeText(id:String,container:DisplayObjectContainer = null, props:Object = null  ):TextField
		{
			props = props || {};
			var txt:TextField = props.txt ? props.txt : new TextField();
			if( container != null ) container.addChild(txt);
			if(_data[id]){
				styleText(id,txt,props);
			}else{
				styleText("dummyTextLarge",txt,props);
				txt.text = "Missing Text ID: "+id+" in "+container.name;
			}
			return txt;	
		}
		
		private function styleText(id:String,txt:TextField, props:Object = null ):Boolean{
			var data:Object = _data[id],out:Boolean = true;
			props = props != null ? props : DEFAULT_PROPS;
			if(data)
			{
				//text format
				var format:TextFormat = new TextFormat();
				format.font = FontManager["FONT_"+data.font] ? FontManager["FONT_"+data.font] : FontManager["FONT_NEXABOLD"];
				format.letterSpacing = props.letterSpacing ? props.letterSpacing : DEFAULT_PROPS.letterSpacing;
				format.leading = props.leading ? props.leading : DEFAULT_PROPS.leading;
				format.bold = (data.bold == "true" || data.bold == "TRUE" || data.bold == true) ? true : false;
				format.align = props.align ? props.align : DEFAULT_PROPS.align;
				 
				if(isNaN(Number(props.fontSize)) )
				{
					format.size = AppSettings.FONT_SIZES[DEFAULT_PROPS.fontSize]   
				}
				else
				{
					format.size = AppSettings.FONT_SIZES[Number(props.fontSize)];
				}
				
				/*
				var size:Number = isNaN(Number(props.fontSize)) ? DEFAULT_PROPS.fontSize :Number(props.fontSize);
				format.size = isNaN(Number(props.fontScale)) ? (size * AppSettings.FONT_SCALE_FACTOR) : Number(props.fontScale) * size;
				*/
				
				txt.antiAliasType = props.antiAlias ? props.antiAlias : DEFAULT_PROPS.antiAlias;
				txt.embedFonts = true;
				txt.type = props.type ? props.type : DEFAULT_PROPS.type;
				//text properties
				txt.width = props.width ? props.width : txt.width;
				txt.height = props.height ? props.height : txt.height;
				props.toUpper = props.toUpper ? props.toUpper : DEFAULT_PROPS.toUpper;
				props.toLower = props.toLower ? props.toLower : DEFAULT_PROPS.toLower;
				txt.htmlText = props.toUpper ? 
									String(data["copy_"+AppSettings.LOCALE]).toUpperCase() 
									: props.toLower ? 
										String(data["copy_"+AppSettings.LOCALE]).toLowerCase() 
										: data["copy_"+AppSettings.LOCALE];
				txt.wordWrap = props.wordWrap ? props.wordWrap : DEFAULT_PROPS.wordWrap;
				txt.multiline = props.multiline ? props.multiline : DEFAULT_PROPS.multiline;
				txt.autoSize = props.autoSize ? props.autoSize : DEFAULT_PROPS.autoSize;
				txt.selectable = props.selectable ? props.selectable : DEFAULT_PROPS.selectable;
				txt.textColor = AppSettings[data.colour] ? AppSettings[data.colour] : 0xff0000;
				txt.mouseEnabled = props.mouseEnabled ? props.mouseEnabled : DEFAULT_PROPS.mouseEnabled ;
				txt.borderColor = props.borderColor ? props.borderColor: 0xff00ff;
				txt.border = props.border ? props.border : false;
				txt.setTextFormat(format);
				txt.defaultTextFormat = format;
				if(format.leading > 0){
					var h:Number = txt.height;
					txt.autoSize = "none";
					txt.height = h + int(format.leading);
				}
				
			}else{
				trace("Missing Text ID: "+id+" for textfield: "+txt.name)
				txt.text = "Missing Text ID: "+id+" for textfield: "+txt.name;
				out = false;
			}
			return out;	
		}
		
	}
}


class Dummy {
	public function Dummy(){
		
	}	
}

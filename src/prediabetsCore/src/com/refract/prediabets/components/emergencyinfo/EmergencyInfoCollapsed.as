package com.refract.prediabets.components.emergencyinfo {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.shared.GeneralOverlay;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author kanish
	 */
	public class EmergencyInfoCollapsed extends GeneralOverlay {
		
		protected var _imgScale:Number = 1;
		
		private var _steps:Vector.<Sprite>;
		
		public function EmergencyInfoCollapsed() {
			super();
		}
		
		protected function setDimensions():void{
			_scrollerWidth = BODY_WIDTH;
			_scrollerHeight = 480;
			_imgScale = 1;
		}
		
		override protected function createContent():void{
			_bodyStyle.fontSize = 14;
			setDimensions();
			
			_header = TextManager.makeText("page_emergency_info_collapsed_title",this,_headerStyle);
			
			_steps = new Vector.<Sprite>();
			
			var step:Sprite;
			var images:Sprite;
			var image:Bitmap;
			var slide:Bitmap;
			var title:TextField;
			var copy:TextField;
			var format:TextFormat;
			var formatSplit:int;
			var n:int;
			for(var i:int = 1; i < 5; ++i){
				step = new Sprite();
				_body.addChild(step);
				_steps.push(step);
				images = new Sprite();
				step.addChild(images);
				n = 1;
				while(AssetManager.hasEmbeddedAsset("EI_Collapsed"+i+"_"+n)){
				//	Logger.log(Logger.OVERLAY,"EI_Collapsed"+i+"_"+n);
					image = AssetManager.getEmbeddedAsset("EI_Collapsed"+i+"_"+n) as Bitmap;
					image.scaleX = image.scaleY = _imgScale;
					image.smoothing = true;
					images.addChild(image);
					image.x = (n-1)*(image.width + 2);
					if(n > 1){
						slide = AssetManager.getEmbeddedAsset("Slide") as Bitmap;
						slide.smoothing = true;
						TweenMax.to(slide,0,{tint:AppSettings.RED});
						images.addChild(slide);
						slide.scaleX = slide.scaleY = (40/slide.width)*_imgScale;
						slide.x = image.x - slide.width/2;
						slide.y = image.height/2 - slide.height/2;
					}
					n++;
				}
				images.x = _scrollerWidth - images.width - 20;
				
				_bodyTitleStyle.width = images.x - 10;
				_bodyStyle.width = _bodyTitleStyle.width;
				title = TextManager.makeText("page_emergency_info_collapsed_s"+i+"_title",step,_bodyTitleStyle);
				if(title.text.indexOf(":") != -1){
					formatSplit = title.text.indexOf(":")+1;
					format = title.getTextFormat(0,formatSplit);
					format.color = AppSettings.WHITE;
					title.setTextFormat(format,0,formatSplit);
				}
				
				copy = TextManager.makeText("page_emergency_info_collapsed_s"+i+"_subtitle",step,_bodyStyle);
				copy.y = title.y + title.height;
				
				step.y = i == 1 ? 0 : _steps[i-2].y + _steps[i-2].height + 5;
				
			}
			
			super.createContent();
		}
	/*	
		override protected function onResize(evt:Event = null):void{
			
			
		//	this.x = int(AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2);
		//	this.y = int(AppSettings.VIDEO_TOP);// + AppSettings.VIDEO_HEIGHT/2 - this.effectiveHeight/2);
			
			
			
			
			if(AppSettings.VIDEO_HEIGHT -10 > this.effectiveHeight){
				_scrollbox.updateSize(_scrollerWidth,AppSettings.VIDEO_HEIGHT - 20 - _header.y - _header.height );
//				_scrollbox.updateSize(_scrollerWidth,_scrollerHeight -  AppSettings.VIDEO_HEIGHT -10 - effectiveHeight);
			}else{
				_scrollbox.updateSize(_scrollerWidth,_scrollerHeight);
			}
			
			
			
		//	_scrollbox.x = int(-_scrollbox.contentWidth/2);
		//	_scrollbox.y = _header ? int(_header.y + _header.height + 10) : 0;
			
			
			
			super.onResize(evt);
		}
	*/	
		override public function destroy():void{
			var destroy:Function = function(item:Sprite,index:int,vector:Vector.<Sprite>):void{
				item.removeChildren();
			};
			_steps.every(destroy);
			super.destroy();
		}
	}
}

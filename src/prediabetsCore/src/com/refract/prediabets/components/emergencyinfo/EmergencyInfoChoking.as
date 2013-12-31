package com.refract.prediabets.components.emergencyinfo {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.shared.GeneralOverlay;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author kanish
	 */
	public class EmergencyInfoChoking extends GeneralOverlay {
		
		protected var _imgScale:Number = 1;
		
		private var _steps:Vector.<Sprite>;
		
		public function EmergencyInfoChoking() {
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
			
			
			_header = TextManager.makeText("page_emergency_info_choking_title",this,_headerStyle);
			
			
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
				while(AssetManager.hasEmbeddedAsset("EI_Choking"+i+"_"+n)){
					image = AssetManager.getEmbeddedAsset("EI_Choking"+i+"_"+n) as Bitmap;
					image.scaleX = image.scaleY = _imgScale;
					image.smoothing = true;
					images.addChild(image);
					image.x = (n-1)*(image.width + 1);
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
				title = TextManager.makeText("page_emergency_info_choking_s"+i+"_title",step,_bodyTitleStyle);
				if(title.text.indexOf(":") != -1){
					formatSplit = title.text.indexOf(":")+1;
					format = title.getTextFormat(0,formatSplit);
					format.color = AppSettings.WHITE;
					title.setTextFormat(format,0,formatSplit);
				}
				
				copy = TextManager.makeText("page_emergency_info_choking_s"+i+"_subtitle",step,_bodyStyle);
				copy.y = title.y + title.height;
				
				step.y = i == 1 ? 0 : _steps[i-2].y + _steps[i-2].height + 6;
				
			}
			
			super.createContent();
		}
		
		override public function destroy():void{
			var destroy:Function = function(item:Sprite,index:int,vector:Vector.<Sprite>):void{
				item.removeChildren();
			};
			_steps.every(destroy);
			super.destroy();
		}
	}
}

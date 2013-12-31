package fw.anim
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	//
	// AnimPack holds a single texture tile sheet, and can have 
	// multiple animation sequneces in it.
	//
	public class AnimTextureSheet
	{
		private var mName:String;
		private var mTextureRegions:Vector.<Rectangle>;
		private var mFrameOffsets:Vector.<Point>;
		
		
		private var mTextureSheet:BitmapData;
		private var mFrameRect:Rectangle;
		
		
		public function AnimTextureSheet()
		{
			//mName= seqName;
			mTextureRegions= new Vector.<Rectangle>();
			mFrameRect= new Rectangle();
			mFrameOffsets= new Vector.<Point>();
		}
		
		public function get name():String { return mName; }
		public function get maxRect():Rectangle { return mFrameRect; }
		public function get numFrames():int { return mTextureRegions.length; }
		
		public function getFrameWidth(fr:int):Number { return (mTextureRegions[fr].width + mFrameOffsets[fr].x); }
		public function getFrameHeight(fr:int):Number { return (mTextureRegions[fr].height + mFrameOffsets[fr].y); }
		
		public function init(sheet:BitmapData, arFrameData:Array):void
		{
			mTextureSheet= sheet;
			
			var rcFrame:Rectangle;
			var regPt:Point;
			
			for (var i:int = 0; i < arFrameData.length; i++) {
				rcFrame= new Rectangle();
				
				rcFrame.x = arFrameData[i].x;
				rcFrame.y = arFrameData[i].y;
				rcFrame.width = arFrameData[i].w;
				rcFrame.height = arFrameData[i].h;
				mTextureRegions.push(rcFrame);
				
				regPt= new Point();
				regPt.x = arFrameData[i].offX;
				regPt.y = arFrameData[i].offY;
				mFrameOffsets.push(regPt);
				
				mFrameRect.width = Math.max(mFrameRect.width, rcFrame.width + regPt.x); 
				mFrameRect.height = Math.max(mFrameRect.height, rcFrame.height+ regPt.y); 
			}
			
		}
		
		public function drawFrame(frame:int, destBmp:BitmapData):void
		{
			destBmp.copyPixels(mTextureSheet, mTextureRegions[frame], mFrameOffsets[frame]);
		}
		
	}
}
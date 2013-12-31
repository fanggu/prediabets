package fw.anim
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	// =============================  Created by: Amos Laber, Dec 2, 2011
	
	//
	// AnimSprite is a class to diplay an animated sprite sheet
	// it is initialized with a sprite sheet and can hold multiple 
	// animation sequnces that can be switched anytime
	//
	
	public class AnimSprite extends Bitmap 
	{
		protected var mAnimSheet:AnimTextureSheet;
		protected var mSequences:Array;
		
		protected var curAnim:AnimSeqData;  // current sequence
		protected var dirty:Boolean;
		protected var donePlaying:Boolean;
		protected var curIndex:uint;  // Frame index into tile sheet 
		protected var curFrame:uint;  // Frame index in a sequence (local)
		
		
		
		// Internal, used to time each frame of animation.
		protected var frameTimer:Number;
		
		public static const LEFT:uint= 1;
		public static const RIGHT:uint= 2;
		
		
		
		public function AnimSprite(bitmapData:BitmapData=null)
		{
			super(bitmapData);
			
			frameTimer= 0;
			mSequences= [];
			
		}
		
		//
		// Initialize the sprite with the texture sheet.
		//  supportFlip: set to true if you intend to use right/left flipping
		//
		public function initialize(sheet:AnimTextureSheet):void
		{
			if (!sheet) return;
			
			mAnimSheet= sheet;
			
			// Create the frame buffer
			bitmapData = new BitmapData(mAnimSheet.maxRect.width, mAnimSheet.maxRect.height); 
			smoothing= true;
			
			curAnim = null;
			this.frame= 0;
			
			drawFrame(true);
		}
		
		public function destroy():void
		{
			if (bitmapData) {
				bitmapData.dispose();
			}
		}
		
		// Check if we are playing a sequence
		//
		public function isPlaying(index:int=0):Boolean
		{
			return !donePlaying;
		}
		
		public function get tileSheet():AnimTextureSheet { return mAnimSheet; }
		
		public function get numFrames():int { return mAnimSheet.numFrames; }
		public function get numSequences():int { return mSequences.length; }
		
		public function get seqFrame():uint { return curFrame; }
		
		public function get frame():uint { return curIndex; }
		
		public function set frame(val:uint):void
		{
			curFrame = val;
			
			if (curAnim)
				curIndex= curAnim.arFrames[curFrame];
			else curIndex= val;
			
			//curAnim = null;
			dirty = true;
		}
		
		
		
		public function getSequenceData(seq:int):AnimSeqData { return mSequences[seq]; }
		public function getSequence(seq:int):String { return mSequences[seq].seqName; }
		
		public function addSequence(name:String, frames:Array, frameRate:Number=0, looped:Boolean=true):void
		{
			mSequences.push(new AnimSeqData(name, frames, frameRate, looped));
		}
		
		public function findSequence(name:String):AnimSeqData
		{
			return findSequenceByName(name);
		}
		
		private function findSequenceByName(name:String):AnimSeqData
		{
			var aSeq:AnimSeqData;
			for (var i:int = 0; i < mSequences.length; i++) {
				aSeq = AnimSeqData(mSequences[i]);
				if (aSeq.seqName == name) {
					return aSeq;
				}
			}
			return null;
		}
		
		// Start playing a sequence
		//
		public function play(name:String=null):void
		{
			// Continue playing from last frame
			if (name == null) {
				donePlaying= false;
				dirty= true;
				frameTimer = 0;
				
				return;
			}
			
			curFrame = 0;
			curIndex = 0;
			frameTimer = 0;
			
			curAnim= findSequenceByName(name);
			if (!curAnim) {
				trace("play: cannot find sequence: " + name);
				return;
			}
			
			// trace("playing " + name +", frames: " + curAnim.arFrames.length);
			
			// Set to first frame
			curIndex= curAnim.arFrames[0];
			donePlaying= false;
			dirty= true;
			
			// Stop if we only have a single frame
			if (curAnim.arFrames.length==1) donePlaying= true;
		}
		
		
		// External use only (editor) 
		//
		public function stop():void
		{
			donePlaying= true;
		}
		
		// Manually advance one frame forwards or back
		// Used by the viewer (not the game)
		//
		public function frameAdvance(next:Boolean):void
		{
			if (next) {
				if (curFrame < curAnim.arFrames.length -1) ++curFrame;
			}
			else {
				if (curFrame > 0) --curFrame;
			}
			
			curIndex= curAnim.arFrames[curFrame];
			dirty= true;
		}
		
		
		public function drawFrame(force:Boolean=false):void
		{
			if(force || dirty)
				drawFrameInternal();
		}
		
		// TODO: Replace with global time based on getTimer()
		private var fakeElapsed:Number= 0.016;
		
		//  Call this function on every frame update
		//  
		public function updateAnimation():void
		{
			
			if (curAnim!=null && curAnim.delay > 0 && !donePlaying) {
				
				// Check elapsed time and adjust to sequence rate 
				frameTimer += fakeElapsed;
				while(frameTimer > curAnim.delay) {
					frameTimer = frameTimer - curAnim.delay;
					advanceFrame();
				}
			}
			
			if (dirty) drawFrameInternal();
		}
		
		// 
		//
		protected function advanceFrame():void
		{
			if (curFrame == curAnim.arFrames.length -1) {
				if (curAnim.loop)
					curFrame = 0;
				else donePlaying= true; 
				
			}
			else ++curFrame;
			
			curIndex= curAnim.arFrames[curFrame];
			dirty= true;
		}
		
		// Internal function to update the current animation frame
		protected function drawFrameInternal():void
		{
			dirty = false;
			
			bitmapData.fillRect(bitmapData.rect, 0);
			mAnimSheet.drawFrame(curIndex, bitmapData);
		}
		
	}
}

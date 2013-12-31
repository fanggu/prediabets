package fw.anim
{
	//
	// Helper VO for storing sequence data
	//
	public class AnimSeqData
	{
		// String name of the animation sequence (e.g. "walk")
		public var seqName:String;
			
		// Seconds between frames (basically the framerate)
		public var delay:Number;
		
		 // Whether or not the animation is looped
		public var loop:Boolean;
		
		// A list of frames stored as uint objects
		public var arFrames:Array;
		
		
		public function AnimSeqData(name:String, frames:Array, frameRate:Number=0, looped:Boolean=true)
		{
			seqName = name;
			delay = 0;
			if(frameRate > 0)
				delay = 1.0/frameRate;
			
			arFrames = frames;
			loop = looped;
		}
		
		private function destroy():void
		{
			arFrames= null;
		}
	}
}
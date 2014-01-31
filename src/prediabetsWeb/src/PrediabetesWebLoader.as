package {
	import com.refract.prediabetes.utils.Buffer;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	[SWF(width='800', height='500', backgroundColor='#000000', frameRate='60')]

	public class PrediabetesWebLoader extends Sprite 
	{
		private var _buffer : Buffer;
		public function PrediabetesWebLoader() {
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init( evt : Event ) : void
		{ 
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			startLoad() ; 
		}
		private function startLoad() : void
		{
			_buffer = new Buffer() ; 
			addChild( _buffer ) ; 
			
			stage.addEventListener(Event.RESIZE, onResize)
			onResize() ; 
			
			
			var mLoader:Loader = new Loader();
			var mRequest:URLRequest = new URLRequest("PrediabetesWeb.swf");
			mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
		//	mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			mLoader.load(mRequest);
		}

		private function onResize(event : Event = null ) : void 
		{
			_buffer.x = stage.stageWidth * 0.5 ; 
			_buffer.y = stage.stageHeight * 0.5 ; 
		}
		
		private function onCompleteHandler(loadEvent:Event) : void
		{
			removeChild( _buffer )
		    addChild(loadEvent.currentTarget.content);
		}
		/*
		private function onProgressHandler(mProgress:ProgressEvent) : void
		{
			var percent:Number = mProgress.bytesLoaded/mProgress.bytesTotal;
			trace(percent);
		}
		 * 
		 */
	}
}

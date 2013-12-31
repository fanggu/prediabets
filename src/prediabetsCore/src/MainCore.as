package {
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.ClassFactory;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.FontManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.backend.BackendResponder;
	import com.refract.prediabets.user.UserModel;

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;

	/**
	 * @author robertocascavilla
	 */
	public class MainCore extends Sprite 
	{	
		private var _mtx:Matrix;
		
		
		public function MainCore() 
		{
			new FontManager();
			addEventListener( Event.ADDED_TO_STAGE , init ) ; 
		}
		
		private function init(  evt : Event ) : void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE,init);
			AppSettings.stage = stage ; 
			
			_mtx = new Matrix();
			
			stage.addEventListener(Event.RESIZE,onResize);
			
			stage.align = StageAlign.TOP_LEFT; 
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//SoundMixer.soundTransform = new SoundTransform(0);
			 //SWFProfiler.init( stage , this ) ;
	
	
			var bytes : ByteArray = AssetManager.getEmbeddedAsset("CopyJSON") as ByteArray;
			TextManager.parseData(bytes.readUTFBytes(bytes.length));
			 
			UserModel.initialize();
		
			if(AppSettings.DEVICE == AppSettings.DEVICE_PC){
				BackendResponder.getUserData(onUserData,onUserDataError);
			}else{
				startApp();
			}
			  
			   
			//initTestVideo() ;
			onResize();
		}
		
		private function onUserData(evt:Event,loader:URLLoader):void{
			var result:Object = JSON.parse(loader.data);
		
			if(result.hasOwnProperty("success")){
				UserModel.setUserData(result);
			}
			
			startApp();
		}
		
		private function onUserDataError(evt:Event):void{
			startApp();
		}
		
		private function startApp():void{
			 var appController : AppController = new ClassFactory.APP_CONTROLLER( this );
			 appController.init( ) ; 
		}

		private function onResize(evt:Event = null):void{
			graphics.clear();
			
			_mtx.identity();
			_mtx.createGradientBox(stage.stageWidth, stage.stageHeight,Math.PI/2,0,0);
			
			graphics.beginGradientFill(GradientType.LINEAR, [0x0,0x333333,0x0], [1,1,1], [30,128,225],_mtx);
		//	graphics.beginFill(0xff0000,1);
			graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			//unblocking the stage video
			graphics.drawRect(AppSettings.VIDEO_LEFT,0,AppSettings.VIDEO_WIDTH,stage.stageHeight);
			
			graphics.beginFill(0x0,1);
			//left border
			graphics.drawRect( 	AppSettings.VIDEO_LEFT - AppSettings.RESERVED_SIDE_BORDER,
								AppSettings.VIDEO_TOP - AppSettings.RESERVED_HEADER_HEIGHT,
								AppSettings.RESERVED_SIDE_BORDER,
								AppSettings.RESERVED_HEADER_HEIGHT + AppSettings.VIDEO_HEIGHT + AppSettings.RESERVED_FOOTER_HEIGHT);
			//right border					
			graphics.drawRect( 	AppSettings.VIDEO_RIGHT,
								AppSettings.VIDEO_TOP - AppSettings.RESERVED_HEADER_HEIGHT,
								AppSettings.RESERVED_SIDE_BORDER,
								AppSettings.RESERVED_HEADER_HEIGHT + AppSettings.VIDEO_HEIGHT + AppSettings.RESERVED_FOOTER_HEIGHT);
			
		}
		
		
		
		
		/*
		
		protected function initTestVideo() : void
		{
			var testVideo : TestVideo = new TestVideo() ; 
			addChild( testVideo ) ; 
		}
		
		protected function initTestAnimations() : void
		{
			var testAnimations : TestAnimations = new TestAnimations();
			addChild( testAnimations ) ;
		}
		
		protected function initTestInteraction_1( ) : void
		{
			var testInteraction_1 : TestInteraction_1 = new TestInteraction_1();
			addChild( testInteraction_1 ) ; 
		}
		
		protected function initTestInteraction_2( ) : void
		{
			var testInteraction_2 : TestInteraction_2 = new TestInteraction_2();
			addChild( testInteraction_2 ) ; 
		}
		 * 
		 */
	}
}

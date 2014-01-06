package com.refract.prediabetes.stateMachine.view {
	import com.refract.prediabetes.AppSettings;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author robertocascavilla
	 */
	public class DebugView extends Sprite 
	{
		private var _myTVideo : TextField;
		private var _myT : TextField;
		
		private var panel:Sprite;
		
		public function DebugView() 
		{
			addEventListener( Event.ADDED_TO_STAGE , init) ; 
		}
		private function init( evt : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE , init) ; 
			stage.addEventListener(Event.RESIZE, onResize);
			createDebugWindow() ;
			
			onResize() ; 
		}
		
		
		public function updateState( message : String ) : void
		{
			if( _myT ) _myT.text = message ; 
		}
		public function updateVideoName( message : String ) : void
		{
			if( _myTVideo ) _myTVideo.text = message ; 
		}
		
		protected function createText( str : String , size : int = 15) : TextField
		{
			var myFormat:TextFormat = new TextFormat("bebas", size);
			var myTextField:TextField = new TextField(); 
			myTextField.embedFonts = true ; 
			
			myTextField.autoSize          = TextFieldAutoSize.LEFT;
			  
			myTextField.defaultTextFormat = myFormat;
			myTextField.text = str ; 
			myTextField.y = 0 ;
			myTextField.x = 0 ; 
			myTextField.mouseEnabled = false ;
			myTextField.textColor = 0x000000;
			
			return myTextField ; 	
		}
		
		private function createDebugWindow() : void
		{
			panel = new Sprite() ; 
			panel.graphics.lineStyle( 1 , 0x999999 ) ;
			panel.graphics.beginFill( 0x999999 );
			panel.graphics.drawRect( 0, 0, 250, 200 );
			panel.graphics.endFill( );
			addChild( panel );
			panel.alpha = .5 ;
			
		//	panel.x = 10 ; 
			panel.y = 690 ; 
			
			_myT =  createText('' ) ;
			_myT.y = 10 ;
			_myTVideo = createText('' ) ;
			_myTVideo.y = 30 ; 
			panel.addChild( _myT) ; 
			panel.addChild( _myTVideo) ; 
		}
		
		private function onResize(evt:Event = null):void{
		//	panel.x = 10;
			panel.x = AppSettings.VIDEO_LEFT + 10;
			panel.y = AppSettings.VIDEO_HEIGHT - 40;	
		}
	}
}

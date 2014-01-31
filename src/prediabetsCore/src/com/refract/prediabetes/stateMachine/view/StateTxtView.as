package com.refract.prediabetes.stateMachine.view {
	import avmplus.getQualifiedClassName;

	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.stateMachine.SMSettings;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;

	/**
	 * @author robertocascavilla
	 */
	public class StateTxtView extends Sprite
	{
		public var perc_x : int ; 
		public var perc_y : int ;
		public var txt : TextField ; 
		
		private var _fontSize : int ;
		private var _stateObjectText : Object ;
		private var _usePos : Boolean;
		private var _style : Object;
		 
		public function StateTxtView( stateObjectText : Object , usePos : Boolean = false ) 
		{
			_fontSize = SMSettings.STATE_TXT_FONT_SIZE ; 
			_stateObjectText = stateObjectText ; 
			_usePos = usePos ;
			
			addEventListener(Event.ADDED_TO_STAGE , init );
		}
		private function init( evt : Event ) : void
		{
			if( _usePos ) 
			{
				AppSettings.stage.addEventListener( Event.RESIZE , onResize ) ; 
			}
			removeEventListener(Event.ADDED_TO_STAGE , init );
			if( _stateObjectText.state_txt ) if( _stateObjectText.state_txt.length > 0)
			{
				create( ) ;
			}
		}
		
		private function create( ) : void
		{
			var myfontSize : int = _fontSize ; 
			
			var w : Number = SMSettings.STATE_TXT_MAX_W*AppSettings.RATIO ; 
			if( _stateObjectText.width ) w = _stateObjectText.width ; 
			_style = 
			{ 
				fontSize: myfontSize
				, align:TextFormatAlign.CENTER 
				, autoSize : TextFieldAutoSize.CENTER 
				, multiline: true
				, wordWrap : true
				, width : w 
				, border : false
				,mouseEnabled : false 
			} ; 
			
			
			txt = TextManager.makeText( SMSettings.FONT_STATETXT ,  null , _style) ;
			txt.htmlText = _stateObjectText.state_txt  ; 

			addChild( txt ) ; 
			
			perc_x = _stateObjectText.state_txt_x ; 
			perc_y = _stateObjectText.state_txt_y ; 
			
			if( _usePos ) 
			{
				onResize() ; 
			}
			
			alpha = 0 ; 
			TweenMax.to( this , .25 , { alpha : 1 , ease : Linear.easeNone , canBePaused:true} ) ;
			
			 
			
			if( AppSettings.DEVICE != AppSettings.DEVICE_TABLET)
				AppSettings.stage.addEventListener( FullScreenEvent.FULL_SCREEN , onFullScreenChange ) ;
		}
		
		private function onFullScreenChange ( evt : FullScreenEvent ) : void
		{
			var temp : String = txt.text ; 
			_style.fontSize = SMSettings.STATE_TXT_FONT_SIZE ; 
			TextManager.styleText( SMSettings.FONT_STATETXT , txt , _style) ; 
			txt.text  = temp ; 
		}
		
		public function updateColor( color : uint ) : void
		{
			txt.textColor = color ; 
		}
		protected function onResize(event : Event = null ) : void 
		{
			x = ( perc_x * AppSettings.VIDEO_WIDTH) / 100 - width/2 + AppSettings.VIDEO_LEFT;
			y = ( perc_y * AppSettings.VIDEO_HEIGHT ) / 100  + AppSettings.VIDEO_TOP - height / 2;
		}
		public function dispose() : void
		{
			_stateObjectText = null ; 
			AppSettings.stage.removeEventListener( Event.RESIZE , onResize ) ; 
		}
	}
}

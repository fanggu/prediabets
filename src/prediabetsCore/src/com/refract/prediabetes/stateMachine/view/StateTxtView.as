package com.refract.prediabetes.stateMachine.view {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.stateMachine.SMSettings;

	import flash.display.Sprite;
	import flash.events.Event;
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
		 
		public function StateTxtView( stateObjectText : Object , fontSize : int , usePos : Boolean = false ) 
		{
			_fontSize = fontSize ; 
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
			var style:Object = 
			{ 
				fontSize: myfontSize
				, align:TextFormatAlign.CENTER 
				, autoSize : TextFieldAutoSize.CENTER 
				, multiline: true
				, wordWrap : true
				, width : w 
				, border : false
			} ; 
			
			txt = TextManager.makeText( SMSettings.FONT_STATETXT ,  null , style) ;
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
			
			mouseEnabled = false ; 
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

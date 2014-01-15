package com.refract.prediabetes.stateMachine.view {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.flags.Flags;

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
		 
		public function StateTxtView( stateObjectText : Object , fontSize : int) 
		{
			_fontSize = fontSize ; 
			init( stateObjectText  ) ;
		}
		private function init( stateObjectText : Object ) : void
		{
			AppSettings.stage.addEventListener( Event.RESIZE , onResize ) ; 
			var myfontSize : int = _fontSize ; 
			
			
			var style:Object = 
			{ 
				fontSize: myfontSize
				, align:TextFormatAlign.CENTER 
				, autoSize : TextFieldAutoSize.CENTER 
				, multiline: true
				, wordWrap : true
			//	, width: 500
				, width : SMSettings.STATE_TXT_MAX_W*AppSettings.RATIO 
			} ; 
			
			txt = TextManager.makeText( SMSettings.FONT_STATETXT ,  null , style) ;
			txt.htmlText = stateObjectText.state_txt  ; 
			
			if( stateObjectText.state_txt_grey)
			{
				txt.textColor = SMSettings.DEEP_RED ; 
			}
			
			addChild( txt ) ; 
			
			perc_x = stateObjectText.state_txt_x ; 
			perc_y = stateObjectText.state_txt_y ; 
			
			onResize() ; 
			
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
			y = ( perc_y * AppSettings.VIDEO_HEIGHT ) / 100  + AppSettings.VIDEO_TOP;
			
			
			
			//if( AppSettings.RATIO > 1.2){
//			if( AppSettings.DEVICE == AppSettings.DEVICE_TABLET || AppSettings.DEVICE == AppSettings.DEVICE_MOBILE)
//			{
//				if( AppSettings.RATIO > 1.2)
//				{
//					y = y - height /2 ; 
//				}
//			}
		}
		public function dispose() : void
		{
			AppSettings.stage.removeEventListener( Event.RESIZE , onResize ) ; 
		}
	}
}

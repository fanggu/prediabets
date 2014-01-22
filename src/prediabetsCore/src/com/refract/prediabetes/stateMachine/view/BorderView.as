package com.refract.prediabetes.stateMachine.view {
	import com.refract.prediabetes.AppSettings;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author otlabs
	 */
	public class BorderView extends Sprite 
	{
		private var _borderTop : Sprite ; 
		private var _borderBottom : Sprite ; 
		private var _borderLeft : Sprite ; 
		private var _borderRight : Sprite ; 
		
		public function BorderView() 
		{
			addEventListener(Event.ADDED_TO_STAGE , init );
		}
		
		private function init( evt : Event ) : void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE , init );
			
			AppSettings.stage.addEventListener(Event.RESIZE, onResize );
			createBorders() ; 
		}
		private function createBorders() : void
		{
			_borderTop = new Sprite() ; 
			_borderBottom = new Sprite() ; 
			_borderLeft = new Sprite() ; 
			_borderRight = new Sprite() ; 
			
			addChild( _borderTop ) ; 
			addChild( _borderBottom ) ; 
			addChild( _borderLeft ) ; 
			addChild( _borderRight ) ; 
			
			onDrawBorders() ; 
		}
		private function onDrawBorders() : void
		{
			var w : int ; 
			var h : int ; 
			h = 
				AppSettings.stage.stageHeight 
				- AppSettings.VIDEO_HEIGHT 
				- AppSettings.RESERVED_HEADER_HEIGHT ; 
			
			drawBorder( 
				_borderBottom 
				, 0 
				, AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT 
				, AppSettings.stage.stageWidth
				, h
			) ; 
			
			drawBorder( 
				_borderTop 
				, 0 
				, 0 
				, AppSettings.stage.stageWidth
				, AppSettings.VIDEO_TOP
			) ; 
			
			w = AppSettings.stage.stageWidth - AppSettings.VIDEO_LEFT - AppSettings.VIDEO_WIDTH ;
			h = AppSettings.VIDEO_HEIGHT ; 
			if( w <= 0 )
			{
				_borderRight.graphics.clear() ; 
				 _borderLeft.graphics.clear() ; 
				 return ; 
			}
			drawBorder( 
				_borderLeft 
				, 0 
				, AppSettings.VIDEO_TOP 
				, w
				, h
			) ; 
			drawBorder( 
				_borderRight 
				, AppSettings.stage.stageWidth - w  
				, AppSettings.VIDEO_TOP  
				, w
				, h
			) ; 
		}
		private function drawBorder( spr : Sprite , pos_x : int , pos_y : int , w : int , h : int ) : void
		{
			spr.graphics.clear();
			spr.graphics.beginFill(0xffffff,1);
			spr.graphics.drawRect(0, 0, w , h );
			spr.x = pos_x ; 
			spr.y = pos_y ; 
		}
		//**RESIZE
		private function onResize( evt : Event = null ) : void
		{
			onDrawBorders() ;
		}
	}
}

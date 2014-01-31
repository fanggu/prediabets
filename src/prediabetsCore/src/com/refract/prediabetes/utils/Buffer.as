package com.refract.prediabetes.utils {
	import com.greensock.TweenLite;
	import com.refract.prediabetes.AppSettings;
	import com.robot.geom.Box;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * @author otlabs
	 */
	public class Buffer extends Sprite 
	{
		private var _l : int = 5 ; 
		private var _d : int = 10 ; 
		private var _cont : Sprite ;
		private var _spacer : int;
		public function Buffer() 
		{
			addEventListener( Event.ADDED_TO_STAGE, init ) ; 
		}
		private function init( evt : Event = null ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init ) ; 
			_cont = new Sprite() ; 
			addChild( _cont ) ; 
			
			_spacer = 10 ;
			if( AppSettings.RETINA ) 
			{
				_d = _d * 2 ; 
				_spacer = _spacer * 2  ; 
			}
			createDots() ; 
			_cont.x = - _cont.width * .5 ; 
		}
		private function createDots() : void
		{
			if( visible )
			{
				var i : int ; 
				for( i = 0 ; i < _l ; i ++ )
				{
					 createB( i  ) ; 
				}
				setTimeout(createDots , 1300 ) ;
			}
		}
		private function createB( iter : int) : void
		{
			var b : Box = new Box( _d , _d , 0xffffff) ; 
			_cont.addChild( b ) ; 
			b.x = (_d  + _spacer)*iter ;
			createTween( b , iter*0.1 ) ; 
			b.alpha = 0 ;
		}
		
		private function bInit( b : Box ) : void
		{
			b.alpha = 1; 
		}
		private function bEnd( b : Box ) : void
		{
			_cont.removeChild( b ) ; 
		}
		private function createTween( b : Box , d : Number ) : void
		{
			TweenLite.to( b , 1.3 , 
				{ 
					alpha : 0  
					, delay : d  
					, onInit : bInit 
					, onInitParams : [ b ]
					, onComplete : bEnd
					, onCompleteParams : [ b ]
				}) ;
		}

		public function set off( value : Boolean ) : void
		{
			if( value && visible )
			{
				visible = false ; 
			}
			else if( !visible )
			{
				visible = true ; 
				createDots() ;
			}
		}
 	}
}

package com.refract.prediabetes.stateMachine {
	import flash.utils.getTimer;
	/**
	 * @author robertocascavilla
	 */
	public class SMVars 
	{
		private static var _me : SMVars ; 
		
		public var nsStreamTime : Number ; 
		public var nsStreamTimeAbs : Number ;
		public var tempTotChoice : int ; 
		public var maxButtonSize : Number ; 
		
		private var paused : Boolean ; 
		private var _totPauseTime : Number = 0 ; 
		private var _initFreezeTime : Number ; 
		
		public function SMVars() {}
		
		public static function get me() : SMVars
		{
			if ( _me == null ) 
			{
				reset() ; 
			}
			return _me ;
		}
		public function initValues() : void
		{
			_me.nsStreamTime = 0 ; 
			_me.tempTotChoice = 0 ; 
			_me.maxButtonSize = 0 ; 
		}
		public function freezeTime() : void
		{
			paused = true ; 
			_initFreezeTime = getTimer() ; 
		}
		public function unFreezeTime() : void
		{
			paused = false ; 
			_totPauseTime = _totPauseTime + ( getTimer() - _initFreezeTime) ; 
		}
		public function getSMTimer() : Number 
		{
			var value : Number = getTimer() - _totPauseTime ; 
			return value ;  
		}
		
		public function updateMaxButtonSize( value : Number ) : void
		{
			if( value > maxButtonSize )
			{
				maxButtonSize = value ; 
			}
		}

		public static function reset() : void
		{
			_me = new SMVars() ; 
			_me.initValues() ; 

		}
	}
}

package com.refract.prediabets.stateMachine {
	import flash.utils.getTimer;
	/**
	 * @author robertocascavilla
	 */
	public class SMVars 
	{
		private static var _me : SMVars ; 
		
		public var nsStreamTime : Number ; 
		public var qp_counter : int ; 
		public var qp_timer : int ; 
		public var qp_accuracy : int ;
		public var latest_accuracy : int ; 
		public var nrCpR : int ; 
		public var tempTotChoice : int ; 
		public var maxButtonSize : Number ; 
		public var accelerometerAble : Boolean ; 
		public var QP_PRE_RUN : Boolean ; 
		public var accelerometerErrorCopy : Boolean ; 
		public var PAUSED : Boolean ; 
		public var mobile : Boolean = false ; 
		
		private var _tooSlowCounter : int ; 
		private var _tryAgainCounter : int ; 
		
		
		 
		
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
			_me.tooSlowCounter = 0 ;
			_me.tryAgainCounter = 0 ; 
			_me.nsStreamTime = 0 ; 
			
			_me.qp_counter = 0 ; 
			_me.qp_timer = 0 ;  
			_me.qp_accuracy = 0 ; 
			_me.latest_accuracy = 0 ;  
			_me.nrCpR = 0 ; 
			_me.accelerometerErrorCopy = false ; 
		
			_me.tempTotChoice = 0 ; 
			_me.maxButtonSize = 0 ; 
			
			_me.accelerometerAble = true ; 
		}
		public function freezeTime() : void
		{
			PAUSED = true ; 
			//_totPauseTime = 0 ; 
			_initFreezeTime = getTimer() ; 
		}
		public function unFreezeTime() : void
		{
			PAUSED = false ; 
			_totPauseTime = _totPauseTime + ( getTimer() - _initFreezeTime) ; 
		}
		public function getSMTimer() : Number 
		{
			var value : Number = getTimer() - _totPauseTime ; 
			return value ; // - _totPauseTime ) ; 
		}
		
		
		
		
		public function updateMaxButtonSize( value : Number ) : void
		{
			if( value > maxButtonSize )
			{
				maxButtonSize = value ; 
			}
		}
		
		public function get tooSlowCounter( ) : int 
		{
			return _tooSlowCounter ;
		}
		public function set tooSlowCounter( value : int ) : void
		{
			_tooSlowCounter = value ;
			if( _tooSlowCounter > 3) _tooSlowCounter = 0 ; 
		}
		
		public function get tryAgainCounter( ) : int 
		{
			return _tryAgainCounter;
		}
		public function set tryAgainCounter( value : int ) : void
		{
			_tryAgainCounter = value ;
			if( _tryAgainCounter > 3) _tryAgainCounter = 0 ; 
		}
		
		
		public static function reset() : void
		{
			_me = new SMVars() ; 
			_me.initValues() ; 

		}
	}
}

package com.refract.prediabetes.stateMachine {
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;
	/**
	 * @author robertocascavilla
	 */
	public class SMScore 
	{
		private static var _me : SMScore ; 
		
		private var _valueLiveChoice : int = 0 ;
		private var _valueTotal : int = 0 ;  
		private var _totChoice : int= 0 ;
		private var _totCorrectChoice : int = 0 ; 
		private var _addStar : int = 0 ;
		private var _iterTotSpeed : int = 0;
		private var _totSpeed : Number = 0;
		private var _tempRightSpeed : Number = 0 ;
		private var _valueSlowTime : Number = 0;
		public function SMScore() 
		{
			resetValues() ;
		}
		
		public static function get me() : SMScore
		{
			if ( _me == null ) 
			{
				reset() ; 
			}
			return _me ;
		}
		private function resetValues() : void
		{
			_valueLiveChoice = 0 ;
			_valueTotal = 0 ;  
			_totChoice = 0 ;
			_totCorrectChoice = 0 ; 
			_addStar = 0 ;
			_iterTotSpeed = 0;
			_totSpeed  = 0;
			_tempRightSpeed = 0 ;
			_valueSlowTime = 0;
		}
		
		public function updateState( stateObject : Object ) : void
		{
			if
			( 
				stateObject.interactions[0].interaction_type == Flags.CHOICE 
				|| 	stateObject.interactions[0].interaction_type == Flags.CHOICE_IMG
				|| 	stateObject.interactions[0].interaction_type == Flags.CHOICE_TARGET		
			)
			{
				if( SMVars.me.tempTotChoice > 1 ) _totChoice ++ ; 
			}
			
			
			_valueLiveChoice = 0 ; 
		}
		public function insertCoin( obj : Object) : void
		{
			if( obj.wrong )
			{
				if( _valueLiveChoice == 0)
				{
					DispatchManager.dispatchEvent( new StateEvent( Flags.TEXT_FEEDBACK , '-1')) ; 
					_valueLiveChoice = -1  ;	
				}
			}
			else
			{
				if( _valueLiveChoice == 0)
				{
					DispatchManager.dispatchEvent( new StateEvent( Flags.TEXT_FEEDBACK , '+1')) ; 
					_valueLiveChoice = 1;
				}
			}
			
			if( _valueLiveChoice == 1)
			{
				if( SMVars.me.tempTotChoice > 1 ) _totCorrectChoice = _totCorrectChoice + 1 ; 
				_valueTotal = _valueTotal + _valueLiveChoice ;
				if( _valueTotal >= 10)
				{
					if( averageSpeed < 2 ) 
					{
						_addStar = 1 ; 
						_valueTotal = 0 ;
					}
					//_valueTotal = 0 ;
				}
			}
			else
			{
				_valueTotal = 0 ; 
				_tempRightSpeed = 10 ;
			}
			sendScore() ;
			_valueSlowTime = 0 ; 
		}
		public function updateSlowTime() : void
		{
			if( isNaN( _valueSlowTime ) ) _valueSlowTime = 0 ; 
			
			_addStar = 0 ;
			
			_valueSlowTime ++ ;
			  
			if( _valueSlowTime > 1 ) 
			{
				_valueSlowTime = 0 ;
				_addStar = -1 ;
			}
			sendScore() ; 
		}
		public function updateResuscitation() : void
		{
			_addStar = 0 ; 	
			sendScore() ; 
		}
		public function addStarAfterDie() : void
		{
			_addStar = 1 ;
			sendScore() ; 
		}
		public function pSendScore() : void
		{
			sendScore() ; 
		}
 		
		public function addStarOnSceneSelect() : void
		{
			var scoreObj : Object = new Object() ; 
			if( isNaN( _totChoice ) ) _totChoice = 0 ;
			scoreObj.totChoices = _totChoice ; 
			
			if( isNaN( _totCorrectChoice ) ) _totCorrectChoice = 0 ;
			scoreObj.totCorrectChoices = _totCorrectChoice ; 
			
			scoreObj.addStar = 1 ; 
			
			if( isNaN( _valueTotal ) ) _valueTotal = 0 ;
			scoreObj.valueTotal = _valueTotal ; 
			
			scoreObj.avgSpeed = averageSpeed ; 
			DispatchManager.dispatchEvent( new ObjectEvent( Flags.UPDATE_SCORE, scoreObj )) ; 
		}
		private function sendScore() : void
		{
			
			
		
			var scoreObj : Object = new Object() ; 
			scoreObj.totChoices = _totChoice ; 
			scoreObj.totCorrectChoices = _totCorrectChoice ; 
			scoreObj.addStar = _addStar ; 
			scoreObj.valueTotal = _valueTotal ; 
			
			var tempSpeed :Number= 0 ;
			if( !isNaN( averageSpeed ) ) tempSpeed = averageSpeed ; 
			scoreObj.avgSpeed = tempSpeed ; 
			DispatchManager.dispatchEvent( new ObjectEvent( Flags.UPDATE_SCORE, scoreObj )) ; 
			
			_addStar = 0 ; 
		}
		
		
		public function addTotSpeed( value : Number ) : void
		{
			_iterTotSpeed ++ ;
			if( !isNaN( value))
			{
				_totSpeed = _totSpeed + value ; 
			}
		}
		
		public function get averageSpeed() : Number
		{
			return (_totSpeed / _iterTotSpeed) ; 
		}
		
		
		public static function reset() : void
		{
			_me = new SMScore() ; 
		}
	}
}

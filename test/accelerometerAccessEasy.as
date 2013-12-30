package com.unit9.lifesaver.android.stateMachine.view.interactions {
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.sensors.Accelerometer;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
  
 
	/**
	 * Adds accelerometer functionality for various types of accelerometer events.
 	 * 
	 * @author		Ryan Boyajian
	 * @version		1.0.0 :: Apr 13, 2011
	 */
	public class AccelerometerAccess 
	{
		private static const SHAKE_THRESHOLD :Number = .266;
		
		private var _acc :Accelerometer;
		private var _lastX :Number = NaN;
		private var _lastY :Number = NaN;
		private var _lastZ :Number = NaN;
		private var _isSupported :Boolean = false;
		private var _isMuted : Boolean = true;
		
		private var _iterFrame : int ; 
		public var viewRef : * ;
		private var _norm : Number;
		private var _normYZ : Number;
		private var avgNorm : Number ; 
		private var avgNormYZ : Number ; 
		
		public function AccelerometerAccess()
		{
			
		}
 
/*
 * API
**************************************************************************************************** */
		
		public function init( $requestedUpdateInterval :Number = NaN ) :void
		{
			_iterFrame = 0 ; 
			_norm = 0 ; 
			_normYZ = 0 ; 
			avgNorm = 0 ; 
			avgNormYZ = 0 ; 
			
			if( Accelerometer.isSupported ) {
				_isSupported = true;
				_acc = new Accelerometer();
				if( !_acc.muted ) {
					_isMuted = false;
					if( !isNaN( $requestedUpdateInterval ) ) _acc.setRequestedUpdateInterval( $requestedUpdateInterval );
					start();
				}
			}
			
			testTimerInit() ; 
		}
		
		private function testTimerInit() : void
		{
			var timer : Timer = new Timer( 1500  , 10 ) ; 
			timer.addEventListener(TimerEvent.TIMER, timerListener);
			//timer.start() ; 
			
			
		}
		
		private function timerListener (e:TimerEvent):void
		{
			fakeUpdateAccelerometer() ;
		}
		
		/**
		 * Starts listening to the accelerometer event.
		 */
		public function start() :void
		{
			if( isSupportedAndNotMuted ) _acc.addEventListener( AccelerometerEvent.UPDATE, updateAccelerometer );
		}
		
		/**
		 * Stops listening to the accelerometer event.
		 */
		public function stop() :void
		{ 	
			if( isSupportedAndNotMuted ) _acc.removeEventListener( AccelerometerEvent.UPDATE, updateAccelerometer );
		}
		
		public function get isSupportedAndNotMuted() :Boolean
		{
			return _isSupported && !_isMuted;
		}
		
		public function toString() :String 
		{
			return 'com.oakley.ocp.utils.AccelerometerAccess';
		}
 
/*
 * INTERNAL
**************************************************************************************************** */
 		
		
		private function accRound( value : Number ) : Number
		{
			value = value * 100 ;
			value = Math.floor( value ) ; 
			return value ; 
		}
		/**
		 * Receives the event from the device if supported and not muted.
		 */
		private function updateAccelerometer( $e :AccelerometerEvent = null ) :void
		{
			var x:Number = Math.floor($e.accelerationX * 1000 ) / 1000 ;
			var y:Number = Math.floor($e.accelerationY * 1000 ) / 1000;
			var z:Number = Math.floor($e.accelerationZ * 1000) /1000 ;

			var norm:Number = accRound( Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2) + Math.pow(z - 1, 2)) ) ;
			var normYZ : Number = accRound( Math.pow(y, 2) + Math.pow(z - 1, 2) ) ; 
			
			//trace(' norm ' , norm , ' $X : ' , x , ' =Y= ' , y , ' =Z= ' , z ) 
			
			var str : String = 'NORM  ' + norm + ' NORM YZ : ' + normYZ ; 
			viewRef.printValues( str )
			
			_iterFrame++ ;
			_norm = _norm + norm ; 
			_normYZ = _normYZ + normYZ ; 
			if( _iterFrame > 10)
			{
				avgNorm = _norm / 10 ;
				avgNormYZ = _normYZ / 10 ; 
				_iterFrame = 0 ;
				_norm = norm ;
				_normYZ = normYZ ; 
			}
			if( avgNorm )
			{
				if( norm > ( avgNorm + 50 ))
				{
					viewRef.onShakeBubble() ; 
				}
			}
	/*
			if( $e.accelerationZ > 1.2)
			{
				
				
//				DispatchManager.dispatchEvent( new Event( IOSFlags.SHAKE_BUBBLE) ) ; 
//				setTimeout( start, 200 ) ; 
//				
//				stop() ; 
			}
			// set initially if they are NaN
			if( isNaN( _lastX ) || isNaN( _lastY ) || isNaN( _lastZ ) ) resetLastValues( $e );
			// get the change since last update
			var dx :Number = abs( _lastX - $e.accelerationX );
			var dy :Number = abs( _lastY - $e.accelerationY );
			var dz :Number =  _lastZ - $e.accelerationZ ;
			// determine shake only if two axis are past the threshold
			//if( ( dz > SHAKE_THRESHOLD && dz< 1.5 && dy < 0.2) )
			
			
			trace('dz :' , dz)
			if( dz > SHAKE_THRESHOLD  ) 
			{
				
				trace('$e.accelerationZ :' , $e.accelerationZ)
				trace('dz :' , dz)
				trace('DY :' , dy)
				trace('DX :' , dx)
				
				if( $e.accelerationZ > 0.1)
				{
					trace('-->>>>>> --- : ' , dy)
					DispatchManager.dispatchEvent( new Event( 'SHAKE_BUBBLE' ) ) ; 
					setTimeout( start, 200 ) ; 
					stop() ;
				}
			}
			
			resetLastValues( $e );
			 * 
			 */
		}
		
		private function fakeUpdateAccelerometer() : void
		{
			DispatchManager.dispatchEvent( new Event( 'SHAKE_BUBBLE') ) ; 
			setTimeout( start , 200 ); 
				
				stop() ; 
		}
		/**
		 * Resets the previous values of x, y, and z.
		 */
		private function resetLastValues( $e :AccelerometerEvent ) :void
		{
			_lastX = $e.accelerationX;
			_lastY = $e.accelerationY;
			_lastZ = $e.accelerationZ;
		}
		
		private function abs( $value :Number ) :Number
		{
			return ( $value < 0 ) ? $value * -1 : $value;
		}
	}
}
package com.unit9.lifesaver.android.stateMachine.view.interactions {
	import flash.system.Capabilities;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quint;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Circle;

	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.sensors.Accelerometer;
	import flash.system.System;
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
		private var _vect : Array ;
		private var _avgArray : Array ; 
		private var _vectNumber : Array ; 
		private var _normLagrange : Number;
		private var _mainIter : Number;
		private var _iterPush : Number;
		private var _prevPushValue : int;
		private var _initNormY : Number;
		private var _activate : Boolean;
		private var _maxAvg : Number = 4 ;
		
		public function AccelerometerAccess()
		{
			
		}
 
/*
 * API
**************************************************************************************************** */
		
		public function init( $requestedUpdateInterval :Number = NaN ) :void
		{
			trace('>> version ' , Capabilities.version )
			  
			for( var mc : * in Capabilities)
			{
				trace('MC :' , mc )
			}
			_activate = true ; 
			_mainIter = 0 ; 
			_iterFrame = 0 ; 
			_norm = 0 ; 
			_normYZ = 0 ; 
			avgNorm = 0 ; 
			avgNormYZ = 0 ; 
			
			_avgArray = new Array() ; 
			var i : int ; 
			for( i = 0 ; i < _maxAvg; i ++)
			{
				_avgArray.push( 0 ) ; 
			}

			/*
			_avgArray.push( 0 ) ; 
			_avgArray.push( 0 ) ; 
			_avgArray.push( 0 ) ; 
			_avgArray.push( 0 ) ; 
			_avgArray.push( 0 ) ; 
			_avgArray.push( 0 ) ; 
			 * 
			 */
			
			_vect = new Array( ) ;   
			_vect.push( 0 ) ; 
			_vect.push( 0 ) ;
			_vect.push( 0 ) ;
			_vect.push( 0 ) ; 
			//_vect.push( 0 ) ; 
			//_vect.push( 0 ) ; 
			//_vect.push( 0 ) ; 
			
			_vectNumber = new Array()  ;
			_vectNumber.push( 0 ) ;
			_vectNumber.push( 1 ) ;
			_vectNumber.push( 2 ) ;
			_vectNumber.push( 3 ) ;
			//_vectNumber.push( 4 ) ;
			//_vectNumber.push( 5 ) ;
			//_vectNumber.push( 6 ) ;
			
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
		
		private function resetActivate( ) : void
		{
			_activate = true ; 
		}
		
		public function shakeBubble( ) : void 
		{
			
			var circBack : Circle = new Circle( 20 , 0xff0099 ) ;
			viewRef.addChild( circBack ) ;
			
			circBack.x = 502 ; 
			circBack.y = 374; 
			
			TweenMax.to( circBack , 1 , { scaleX : 3 , scaleY : 3 , ease : Elastic.easeOut} );
			TweenMax.to( circBack , .5 , { alpha: 0  , delay : .5 ,  ease : Quint.easeOut} );
			TweenMax.to( circBack , .5 , { y: circBack.y-100  , delay : .5 ,  ease : Quint.easeOut} );
		}
		
		private var _tempZ : Number = 0; 
		private var _prevZ : Number = 0 ; 
		private function calibrateAccelerometer( $e : AccelerometerEvent = null ) : void
		{
			var diff : Number = $e.accelerationZ - _prevZ ;
			if( diff < 0.1)
			{
				trace('In In')
				if( _iterFrame > 20)
				{
					trace('CALIBER X :' , $e.accelerationX)
					trace('CALIBER Y :' , $e.accelerationY)
					trace('CALIBER Z :' , $e.accelerationZ)
					if( isSupportedAndNotMuted ) _acc.removeEventListener( AccelerometerEvent.UPDATE, calibrateAccelerometer );
					if( isSupportedAndNotMuted ) _acc.addEventListener( AccelerometerEvent.UPDATE, updateAccelerometer );
					_iterFrame = 0 ;
				}
			}
			_prevZ = $e.accelerationZ ; 
			_iterFrame++ ;
		}
		
		
		
		private var kFileringFactor : Number = 0.1 ;
		private var gravity_x : Number = 0;
		private var gravity_y : Number = 0;
		private var gravity_z : Number = 0; 
		private var gravityNorm : Number ; 
		private var filteredAcceleration_x : Number ; 
		private var filteredAcceleration_y : Number ; 
		private var filteredAcceleration_z : Number ; 
		private function updateAccelerometer4( e : AccelerometerEvent = null ) : void
		{
			
			
			//Isolating gravity vector
			gravity_x = e.accelerationX * kFileringFactor + gravity_x * (1.0 - kFileringFactor);
			gravity_y = e.accelerationY * kFileringFactor + gravity_y * (1.0 - kFileringFactor);
			gravity_z = e.accelerationZ * kFileringFactor + gravity_z * (1.0 - kFileringFactor);
			gravityNorm = Math.sqrt(gravity_x * gravity_x + gravity_y * gravity_y + gravity_z * gravity_z);
			
			filteredAcceleration_x = e.accelerationX - gravity_x / gravityNorm;
			filteredAcceleration_y = e.accelerationY - gravity_y / gravityNorm;
			filteredAcceleration_z = e.accelerationZ - gravity_z / gravityNorm;
			
			//trace(' y :' , filteredAcceleration_y , ' z:' , filteredAcceleration_z)
			if( filteredAcceleration_z < -0.5)
			{
				trace("yes? :" , filteredAcceleration_z)
			}
		}
		
		private var  gravity_0 : Number = 0 ; 
		private var  gravity_1 : Number = 0 ; 
		private var  gravity_2 : Number = 0 ;
		private function updateAccelerometer( e :AccelerometerEvent = null ) :void
		{
			var ki :Number = 0.1;

          	gravity_0 = ki * gravity_0 + (1 - ki) * e.accelerationX ;
          	gravity_1 = ki * gravity_1 + (1 - ki) * e.accelerationY ;
          	gravity_2 = ki * gravity_2 + (1 - ki) * e.accelerationZ ; 
			
			var accX : Number = e.accelerationX - gravity_0 ;
			var accY : Number = e.accelerationY - gravity_1 ;
			var accZ : Number = e.accelerationZ - gravity_2 ;
			var newAccZ : Number = Math.floor( accZ*1000 ) ;
			var newAccY : Number = Math.floor( accY*1000 ) ;
			
			var storyNewAccZ : Number = calcLagrangeNorm( newAccZ) ;
			var storyNewAccY : Number = calcAverageNorm( newAccY) ;//calcAverageNorm( newAccZ) ;
			trace(newAccZ,',',storyNewAccZ)
			if( newAccZ > 100 && _activate)
			{
				if( storyNewAccZ > -25 ) 
				{
					if( Math.abs(newAccY) < 50)
					{
						shakeBubble() ;
						_activate = false ;
						setTimeout(resetActivate, 300) ; 
					}
				}
				//trace('MORE THAN 100 :' , storyNewAccZ)
			}
			if( newAccZ < -50)
			{
				//trace('** << ** ')
			}
		}
		
		private var _prevprevZ : Number = 0; 
		private var _xx : int = 0 ;
		private function updateAccelerometer6( e :AccelerometerEvent = null ) :void
		{
			var x:Number = Math.floor(e.accelerationX * 1000 ) / 100 ;
			var y:Number = Math.floor(e.accelerationY * 1000 ) / 100 ;
			var z:Number = Math.floor(e.accelerationZ * 1000) / 100 ;
			
			
			
			var newZ : Number = calcAverageNorm( z ) ; 
			//trace( newZ ,',',z)
			
			trace( z)
			
			if( z < 0)
			{
				//_xx++ ;
				//if( (newZ - _prevprevZ ) > 0.5)\
				//if( _xx > 2 )
				//{ 
					shakeBubble() ;
					trace('PUSH')
				//}
			}
			_prevprevZ = newZ ; 
		}
		
		private var _xf :Number = 0;
		private var _yf :Number = 0;
		private var _zf :Number = 0;
		private function updateAccelerometer5( e :AccelerometerEvent = null ) :void
		{
			//var tempYF : Number
			var ki: Number = 0.1;
    		_yf = ki * e.accelerationY + (1.0 - ki) * _yf;
    		_xf = ki * e.accelerationX + (1.0 - ki) * _xf;
			_zf = ki * e.accelerationZ + (1.0 - ki) * _zf ;
			
			if( _zf < 0.65 ) //&& _yf < 0.5)
			{
				//trace('YEAH YEAH')
			}
			//trace(' zf ' , _zf , ' yf :' , _yf , ' xf :' , _xf)
			//trace(' xf ' , _xf)
			
			var moveZ : Number = e.accelerationZ - _zf ;
			var moveY : Number = e.accelerationY - _yf ;
			
			moveZ = moveZ*100 ;
			moveY = moveY*100 ;
			if( moveZ  < -50 && moveY < -5)
			{
				trace('XXX')
				//trace('GIU')
			}
			if( moveY < -50)
			{
				//trace('AVANTI')
			}
			
			
			var testY : Number = calcAverageNorm( moveY ) ;
			//trace('test Y ' , testY)
			//trace(' move y ' , moveY)
			
		}
		
		private function updateAccelerometer2( $e :AccelerometerEvent = null ) :void
		{
			var x:Number = Math.floor($e.accelerationX * 1000 ) / 1000 ;
			var y:Number = Math.floor($e.accelerationY * 1000 ) / 1000 ;
			var z:Number = Math.floor($e.accelerationZ * 1000) / 1000 ;
			
			var norm:Number = accRound( Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2) + Math.pow(z - 1, 2)) ) ;
			var normYZ : Number = accRound( Math.pow(y, 2) + Math.pow(z - 1, 2) ) ;
			var normZ : Number = accRound(  Math.pow(z , 2) ) ;
			var normY : Number = accRound(  Math.pow(y, 2) ) ;
			//var avgNorm : Number = calcAverageNorm(norm ) ; 
			
			var yz : Number = normY + normZ ; 
			//trace( avgNorm +',' + norm)
			var str : String = 'nYZ : ' + yz + ' -nX:' + normY + ' -nZ:' + normZ ; 
			viewRef.printValues( str ) ; 
			
			 //NEW AVERAGE WITH ARRAY
			 _avgArray.shift() ;
			 _avgArray[3] = normYZ ;
			 
			 var i : int = 0 ; 
			 var tempTotNorm : Number = 0 ;
			 for( i = 0 ; i < 4 ; i++)
			 {
				tempTotNorm = tempTotNorm + _avgArray[i] ;
			 }
			  var avgNormNew : Number = tempTotNorm / 4 ; 
			  //trace(normYZ , ',' ,  avgNormNew  ) ;
			  	_iterFrame = 0 ; 
				
				
				if( yz > 200)
				{
//					if( $e.accelerationZ > -0.5)
//					{
//						trace('OH YES')
//					}
					trace(' Y :' , $e.accelerationY)
					trace(' Z :' , $e.accelerationZ)
					trace(' X :' , $e.accelerationX)
					
					if( isSupportedAndNotMuted ) _acc.removeEventListener( AccelerometerEvent.UPDATE, updateAccelerometer );
					setTimeout( restart, 500) ;
					
					
					if($e.accelerationZ > 0.5)
					{
						shakeBubble() ;
						trace('yes yesyes')
					}
//					if( y < 0.3)
//					{
//						trace('PU*MP')
//					}
					//trace('$e.accZ :' , $e.accelerationZ)
					
				}
				
		}
		private function restart() : void
		{
			if( isSupportedAndNotMuted ) _acc.addEventListener( AccelerometerEvent.UPDATE, updateAccelerometer );
		}
		
		private function updateAccelerometerxx( $e :AccelerometerEvent = null ) :void
		{
			var x:Number = Math.floor($e.accelerationX * 100 )  ;
			var y:Number = Math.floor($e.accelerationY * 100 ) ;
			var z:Number = Math.floor($e.accelerationZ * 100) ;

			var norm:Number = accRound( Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2) + Math.pow(z - 1, 2)) ) ;
			var normYZ : Number = accRound( Math.pow(y, 2) + Math.pow(z - 1, 2) ) ;
			var normZ : Number = accRound(  Math.pow(z , 2) ) ;
			var normY : Number = accRound(  Math.pow(y, 2) ) ;
			//var normX : Number = accRound(  Math.pow(x, 2) ) ;    
			var normXY : Number = accRound( Math.pow( x , 2) + Math.pow(y,2)) ; 
			
			
			var accX : Number = z*000.1 ;
			var accY : Number = y*000.1 ;
			var accZ : Number = z*000.1 ; 
			var magnitudo : Number = Math.sqrt( Math.pow( x,2) + Math.pow( y,2 ) + Math.pow( z , 2) ) ; 
			
			/*
			var rotateX : Number = accX / magnitudo ; 
			var rotateY : Number = accY / magnitudo ;
			trace('rotate Y ' , rotateY )
			 * 
			 */
			 
			 
			 _iterFrame++
			 if( _iterFrame > 10)
			 {
				_iterFrame =0 ;
			 	//trace('magnitudo ' , magnitudo)
			 }
			
			 
			 //trace("$e.accelerationZ " , $e.accelerationZ)
			 //trace(' _prevZ :' , _prevZ)
			 //trace("diffo " , )
			 
			 var diffo : Number = ( $e.accelerationZ - _prevZ) ;
			 
			 trace('d :' , diffo , ' magnitudo :' , magnitudo)
			 if( _activate)
			 {
				//trace("$e.accelerationZ " , $e.accelerationZ)
				if( magnitudo > 100 )
			 	{
					//trace('PREV Z :' , z)
					if( diffo  > 1)
					{
						_activate = false ;
						trace('magnitudo'  , magnitudo)
						trace('z '  , z)	
						trace('NORM Z :' , normZ)
						setTimeout( resetActivate, 300 ) ; 
					}
			 	}
			 }
			 
//{
//
//rotate_X=acos(acceleration_X/force_vector);
//return rotate_X;
//}
			/*
			//trace(' norm ' , norm , ' $X : ' , x , ' =Y= ' , y , ' =Z= ' , z ) 
			var totyz : int = normY + normZ//calcAverageNorm( (normY + normZ) ) ;
			var str : String = 'nY : ' + totyz //+ ' -nZ:' + normZ + ' -y:' + y + ' -z:' + z  ; 
			viewRef.printValues( str ) ; 
			
			//trace('str ' , str)
			var absZ : int = z / Math.abs(z) ;
			if( totyz > 210 && _activate)
			{
				//if( _iterPush == 0)
				//{
					//_initNormY = normY ;
				//}
				//_iterPush++ ;
				//if( _iterPush > 0)
				//{
					//_iterPush = 0 ; 
					//if( (normY - _initNormY ) < 10 ) 
					//{
					trace('abs Z ' , absZ)
						if( absZ  > 0 )
						{
							_activate = false ;
							setTimeout(resetActivate, 300 ) ;
							trace('YEAH')
							
//							_avgArray = new Array() ; 
//			_avgArray.push( 0 ) ; 
//			_avgArray.push( 0 ) ; 
//			_avgArray.push( 0 ) ; 
//			_avgArray.push( 0 ) ; 
			
							shakeBubble() ;
						}
					//}
				//}
			}
//			else
//			{
//				_iterPush = 0 ; 
//			}
 * 
 * 
 * 
 */
			/*
			var pushValueY : int = calcLagrangeNorm( normY ) ; //calcAverageNorm(norm ) ; //
			var pushValueZ : int = calcLagrangeNorm( normZ ) ; //calcAverageNorm(norm ) ; //
			//trace(':: pushValueY :' , pushValueY)
			//trace(':: pushValueZ :' , pushValueZ)
			//trace(' x ' , x , ' y ' , y , ' z ' , z)
			//if( _prevPushValue ) trace('>> _prevPushValue :' , _prevPushValue)
			var absZ : int = z / Math.abs(z) ; 
			if( _prevPushValue  )
			{
				if( pushValueZ > _prevPushValue && pushValueZ > 100 )
				{
					_iterPush++ ;
					//trace(': _iterPush :' , _iterPush)
					if( _iterPush > 2)
					{
						_iterPush = 0 ;
						if( absZ < 0 ) trace('**PUSH  ' , z , ' abs Z:' , absZ)
					}
				}
				else
				{
					_iterPush = 0 ;
				}
			}
			_prevPushValue = pushValueZ
			 * 
			 */
			
			/*
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
				
				trace(norm , ',' ,  avgNorm  ) ;
			}
			if( avgNorm )
			{
				//trace(norm , ',' ,  avgNorm  ) ;
			}
			 * 
			 * 
			 * 
			 */
			 
			 
			 /*
			 _iterFrame++ ;
			 //if( _iterFrame > 10)
			 //{
			 
			 //NEW AVERAGE WITH ARRAY
			 _avgArray.shift() ;
			 _avgArray[3] = normYZ ;
			 
			 var i : int = 0 ; 
			 var tempTotNorm : Number = 0 ;
			 for( i = 0 ; i < 4 ; i++)
			 {
				tempTotNorm = tempTotNorm + _avgArray[i] ;
			 }
			  var avgNormNew : Number = tempTotNorm / 4 ; 
			  trace(norm , ',' ,  avgNormNew  ) ;
			  	_iterFrame = 0 ; 
			 //}
			  */
			  
			  
			  
			  
			  /*
			  _iterFrame++ ;
			 
			 //if( _iterFrame > 10 )
			 //{
				  _vect.shift() ; 
				  _vect[3] = normYZ  ;
				  _iterFrame = 0 ; 
				  applyLagrangeNewtown()  ;  
				  _mainIter++ ;
				  trace(norm , ',' ,  _normLagrange  ) ; 
			 //}
			  */
			 
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
		
		private function calcAverageNorm( value : Number ) : Number
		{
			 _avgArray.shift() ;
			 _avgArray[( _maxAvg -1)] = value ; 
			 
			 var i : int = 0 ; 
			 var tempTotNorm : Number = 0 ;
			 for( i = 0 ; i < _maxAvg ; i++)
			 {
				tempTotNorm = tempTotNorm + _avgArray[i] ;
			 }
			 var avgNormNew : Number = tempTotNorm / _maxAvg ; 
			 return avgNormNew ; 
		}
		private function calcLagrangeNorm( value : Number ) : int
		{
			_vect.shift() ; 
			_vect[3] = value  ;
			_iterFrame = 0 ; 	  
			return applyLagrangeNewtown()  ; 
		}
		private function applyLagrangeNewtown() : int
		{
			
			var i : int ;
			var l : int = _vect.length ; 
			var totValue : Number = 0 ;
			
			
			//tempArray = _vect.concat( _vectNumber ) ; 
			
			for( i = 0 ; i < l ; i++)
			{	
				var tempArray : Array = new Array( ) ;
				var ll : int = i+1 ;
				var j : int = 0 ;
				for( j = 0 ; j < ll ; j++)
				{
					tempArray.push( _vect[j]) ;
				}
				for( j = 0 ; j < ll ; j++)
				{
					tempArray.push(  j ) ;
				}
				//trace('TEMP ARRAY :' , tempArray)
				totValue = totValue + (this['f'+i] as Function).apply( this , tempArray  ) 
				_normLagrange = totValue ; 
			}
			
			//trace(':: LA GRANGE ::' , totValue , norm ,  )
			//trace(':: norm ::' , norm  + ' i ' , _iter)
			return totValue ; 
			
		}
		
		protected function f0( a : Number , ...rest) : Number
		{
			//trace(' F0 : ' , a)
			return a ; 
		}
		private function f1( a : Number  , b : Number , i :int , j : int , ...rest) : Number
		{
			//trace(' F1 : a :' , a  , ' :b: ' , b , ' :i:' , i , ' :j: ' , j)
			var value : Number ;
			value = ( a-b)/(i-j) ;
			return value ; 
		}
		private function f2( a : Number , b : Number  , c:Number , i : int , j : int   , k : int , ...rest) : Number 
		{
			//trace(' F2 : a :' , a  , ' :b: ' , b , ' :c: ' , c ,  ' :i: ' , i , ' :j: ' , j , ' :k: ' , k)
			var value : Number ;
			value = ( f1( a , b , i , j) - f1( b , c , j , k ) ) / ( i - k ) ;
			return value ;
		}
		protected function f3( a : Number , b : Number , c : Number , d : Number , i : int , j : int , k : int , m : int , ...rest) : Number 
		{
			//trace(' F3 : a :' , a  , ' :b: ' , b , ' :c: ' , c , ' :d: ' , d ,  ' :i: ' , i , ' :j: ' , j , ' :k: ' , k, ' :m: ' , m)
			var value : Number ; 
			value = ( f2( a,b,c , i , j , k ) - f2( b , c , d , j , k , m ) ) / ( i - m ) ; 
			return value ; 
		}
		protected function f4( a : Number , b : Number , c : Number , d : Number , e : Number ,  i : int , j : int , k : int , m : int , n : int ,  ...rest) : Number 
		{
			//trace(' F3 : a :' , a  , ' :b: ' , b , ' :c: ' , c , ' :d: ' , d ,  ' :i: ' , i , ' :j: ' , j , ' :k: ' , k, ' :m: ' , m)
			var value : Number ; 
			value = ( f3( a,b,c , d,i , j , k ,m) - f3( b , c , d ,e, j , k , m , n ) ) / ( i - n ) ; 
			return value ; 
		}
		protected function f5( a : Number , b : Number , c : Number , d : Number , e : Number , f:Number, i : int , j : int , k : int , m : int , n : int , p:int , ...rest) : Number 
		{
			//trace(' F3 : a :' , a  , ' :b: ' , b , ' :c: ' , c , ' :d: ' , d ,  ' :i: ' , i , ' :j: ' , j , ' :k: ' , k, ' :m: ' , m)
			var value : Number ; 
			value = ( f4( a,b,c , d, e , i , j , k ,m , n) - f4( b , c , d ,e, f , j , k , m , n , p) ) / ( i - p ) ; 
			return value ; 
		}
		protected function f6( a : Number , b : Number , c : Number , d : Number , e : Number , f:Number, g : Number , i : int , j : int , k : int , m : int , n : int , p:int ,q : int ,  ...rest) : Number 
		{
			//trace(' F3 : a :' , a  , ' :b: ' , b , ' :c: ' , c , ' :d: ' , d ,  ' :i: ' , i , ' :j: ' , j , ' :k: ' , k, ' :m: ' , m)
			var value : Number ; 
			value = ( f5( a,b,c , d, e , f ,i , j , k ,m , n , p) - f5( b , c , d ,e, f , g ,j , k , m , n , p , q ) ) / ( i - q ) ; 
			return value ; 
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
package com.refract.air.shared.lifesaver.stateMachine.view.interactions {
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quint;
	import com.refract.prediabets.stateMachine.SMVars;
	import com.robot.geom.Circle;

	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.sensors.Accelerometer;
	import flash.utils.setTimeout;
  
 
	/**
	 * Adds accelerometer functionality for various types of accelerometer events.
 	 * 
	 * @author		Ryan Boyajian
	 * @version		1.0.0 :: Apr 13, 2011
	 */
	public class AccelerometerAccess 
	{	
		public var viewRef : * ;
		
		private var _acc :Accelerometer;
		
		private var _isSupported :Boolean = false;
		private var _isMuted : Boolean = true;
		private var _activate : Boolean;
		
		//**arrays for avg and lagrange
		private var _vect : Array ;
		private var _avgArray : Array ; 
		
		//init values
		private var _maxLagrangeGrade : int = 4 ; 
		private var _maxAvg : Number = 10 ;
		
		private var  gravity_0 : Number = 0 ; 
		private var  gravity_1 : Number = 0 ; 
		private var  gravity_2 : Number = 0 ;
		
		private var _initPeakValue : int = 40 ; 
		private var _dynamicPeakValue : int = 0 ;
		
		public function AccelerometerAccess()
		{
			
		}

		
		public function init( $requestedUpdateInterval :Number = NaN ) :void
		{
			_activate = true ; 
			_dynamicPeakValue = _initPeakValue ; 
			
			initAvgValueArray() ; 
			initLagrangeArray() ; 
			
			if( Accelerometer.isSupported ) {
				_isSupported = true;
				_acc = new Accelerometer();
				if( !_acc.muted ) {
					_isMuted = false;
					if( !isNaN( $requestedUpdateInterval ) ) _acc.setRequestedUpdateInterval( $requestedUpdateInterval );
					start();
				}
			}
			
			viewRef.addEventListener( Event.ENTER_FRAME , run ) ;
		}
		private function run( evt : Event ) : void
		{
			//Logger.log(Logger.STATE_MACHINE,'**')
		}
		
		
		public function start() :void
		{
			if( isSupportedAndNotMuted ) _acc.addEventListener( AccelerometerEvent.UPDATE, updateAccelerometer );
		}

		public function stop() :void
		{ 	
			if( isSupportedAndNotMuted ) _acc.removeEventListener( AccelerometerEvent.UPDATE, updateAccelerometer );
		}
		
		public function get isSupportedAndNotMuted() :Boolean
		{
			return _isSupported && !_isMuted;
		}

		
		
		/**
		 * Receives the event from the device if supported and not muted.
		 */
		
		private function resetActivate( ) : void
		{
			_activate = true ; 
		}
		 
		private var _iterFrame : int = 0 ; 
		private function updateAccelerometer( e :AccelerometerEvent = null ) :void
		{
			if( !SMVars.me.PAUSED )
			{
				var ki :Number = 0.1 ; //0.1;
				_iterFrame ++ ; 
	          	//gravity_0 = ki * gravity_0 + (1 - ki) * e.accelerationX ;
	          	gravity_1 = ki * gravity_1 + (1 - ki) * e.accelerationY ;
	          	gravity_2 = ki * gravity_2 + (1 - ki) * e.accelerationZ ; 
				
				var accY : Number = Math.floor( (e.accelerationY - gravity_1)*1000 )  ;
				var accZ : Number = Math.floor( (e.accelerationZ - gravity_2)*1000 )  ;
				
				//Logger.log(Logger.STATE_MACHINE,accZ + '\t' + accY + '\t0\t' + _dynamicPeakValue);
				//detect peak
			//	Logger.log(Logger.STATE_MACHINE,accZ + '\t' + accY + '\t0\t' + _dynamicPeakValue);
				if(accZ > _dynamicPeakValue && _activate && _iterFrame>10 ) 
				{
					if( abs(accY) < 50)
					{
						//shakeBubble() ;
						_activate = false ;
						setTimeout(resetActivate, 100) ;
	
						
						//Logger.log(Logger.STATE_MACHINE,accZ + '\t' + accY + '\t1\t' + _dynamicPeakValue);
						viewRef.accelerometerPump() ; 
	
					}
				}
				var avgInitPeak : int = calcAverageNorm( _dynamicPeakValue ) ; 
				if( accZ > _initPeakValue )
				{
					adjustPeak( accZ ) ;
				}
			}
		}
		
		private function adjustPeak( accZ : Number) : void
		{
			var diffPeakValue : Number = accZ - _dynamicPeakValue ; 
			if( diffPeakValue > 0)
			{
				diffPeakValue = diffPeakValue / 10 ; 
			}
			else
			{
				diffPeakValue = diffPeakValue / 3 ;
			}
			_dynamicPeakValue = _dynamicPeakValue + diffPeakValue ; 

			//Logger.log(Logger.STATE_MACHINE,_dynamicPeakValue)

//			Logger.log(Logger.STATE_MACHINE,_dynamicPeakValue)

		}
		
		private function easingValue( prop : String , endValue : Number ) : void
		{
			var dif:Number = endValue - this[prop];
			var difeasing:Number = dif/10;
			this[prop] += difeasing;
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
			return applyLagrangeNewtown()  ; 
		}
		private function applyLagrangeNewtown() : int
		{			
			var i : int ;
			var l : int = _vect.length ; 
			var totValue : Number = 0 ;

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
				totValue = totValue + (this['f'+i] as Function).apply( this , tempArray  ) 
			}
			return totValue ; 
		}
		
		protected function f0( a : Number , ...rest) : Number
		{
			//Logger.log(Logger.STATE_MACHINE,' F0 : ' , a)
			return a ; 
		}
		private function f1( a : Number  , b : Number , i :int , j : int , ...rest) : Number
		{
			//Logger.log(Logger.STATE_MACHINE,' F1 : a :' , a  , ' :b: ' , b , ' :i:' , i , ' :j: ' , j)
			var value : Number ;
			value = ( a-b)/(i-j) ;
			return value ; 
		}
		private function f2( a : Number , b : Number  , c:Number , i : int , j : int   , k : int , ...rest) : Number 
		{
			//Logger.log(Logger.STATE_MACHINE,' F2 : a :' , a  , ' :b: ' , b , ' :c: ' , c ,  ' :i: ' , i , ' :j: ' , j , ' :k: ' , k)
			var value : Number ;
			value = ( f1( a , b , i , j) - f1( b , c , j , k ) ) / ( i - k ) ;
			return value ;
		}
		protected function f3( a : Number , b : Number , c : Number , d : Number , i : int , j : int , k : int , m : int , ...rest) : Number 
		{
			//Logger.log(Logger.STATE_MACHINE,' F3 : a :' , a  , ' :b: ' , b , ' :c: ' , c , ' :d: ' , d ,  ' :i: ' , i , ' :j: ' , j , ' :k: ' , k, ' :m: ' , m)
			var value : Number ; 
			value = ( f2( a,b,c , i , j , k ) - f2( b , c , d , j , k , m ) ) / ( i - m ) ; 
			return value ; 
		}
		protected function f4( a : Number , b : Number , c : Number , d : Number , e : Number ,  i : int , j : int , k : int , m : int , n : int ,  ...rest) : Number 
		{
			//Logger.log(Logger.STATE_MACHINE,' F3 : a :' , a  , ' :b: ' , b , ' :c: ' , c , ' :d: ' , d ,  ' :i: ' , i , ' :j: ' , j , ' :k: ' , k, ' :m: ' , m)
			var value : Number ; 
			value = ( f3( a,b,c , d,i , j , k ,m) - f3( b , c , d ,e, j , k , m , n ) ) / ( i - n ) ; 
			return value ; 
		}
		protected function f5( a : Number , b : Number , c : Number , d : Number , e : Number , f:Number, i : int , j : int , k : int , m : int , n : int , p:int , ...rest) : Number 
		{
			//Logger.log(Logger.STATE_MACHINE,' F3 : a :' , a  , ' :b: ' , b , ' :c: ' , c , ' :d: ' , d ,  ' :i: ' , i , ' :j: ' , j , ' :k: ' , k, ' :m: ' , m)
			var value : Number ; 
			value = ( f4( a,b,c , d, e , i , j , k ,m , n) - f4( b , c , d ,e, f , j , k , m , n , p) ) / ( i - p ) ; 
			return value ; 
		}
		protected function f6( a : Number , b : Number , c : Number , d : Number , e : Number , f:Number, g : Number , i : int , j : int , k : int , m : int , n : int , p:int ,q : int ,  ...rest) : Number 
		{
			//Logger.log(Logger.STATE_MACHINE,' F3 : a :' , a  , ' :b: ' , b , ' :c: ' , c , ' :d: ' , d ,  ' :i: ' , i , ' :j: ' , j , ' :k: ' , k, ' :m: ' , m)
			var value : Number ; 
			value = ( f5( a,b,c , d, e , f ,i , j , k ,m , n , p) - f5( b , c , d ,e, f , g ,j , k , m , n , p , q ) ) / ( i - q ) ; 
			return value ; 
		}

		
		private function shakeBubble( ) : void 
		{
			
			var circBack : Circle = new Circle( 10 , 0xff0099 ) ;
			viewRef.addChild( circBack ) ;
			
			circBack.x = 502 ; 
			circBack.y = 374; 
			
			TweenMax.to( circBack , 1 , { scaleX : 3 , scaleY : 3 , ease : Elastic.easeOut} );
			TweenMax.to( circBack , .5 , { alpha: 0  , delay : .5 ,  ease : Quint.easeOut} );
			TweenMax.to( circBack , .5 , { y: circBack.y-100  , delay : .5 ,  ease : Quint.easeOut} );
		}
		
		
		private function initAvgValueArray() : void
		{
			_avgArray = new Array() ; 
			var i : int ; 
			for( i = 0 ; i < _maxAvg; i ++)
			{
				_avgArray.push( _initPeakValue ) ; 
			}
			
		}
		private function initLagrangeArray() : void
		{
			var i : int ; 
			_vect = new Array( ) ;
			for( i = 0 ; i < _maxLagrangeGrade ; i++)
			{
				_vect.push( 0 ) ; 
			}
		}
		
		private function accRound( value : Number ) : Number
		{
			value = value * 100 ;
			value = Math.floor( value ) ; 
			return value ; 
		}
		private function abs( $value :Number ) :Number
		{
			return ( $value < 0 ) ? $value * -1 : $value;
		}
		
		
		public function dispose() : void
		{
			//_acc.
			stop() ; 
				
				
		}
	}
}
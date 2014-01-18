package com.refract.prediabetes.stateMachine.timer {
	import com.refract.prediabetes.stateMachine.view.interactions.Interaction;

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * @author robertocascavilla
	 */
	public class SMTimer extends Timer 
	{
		private var _lastTime : Number;
		private var _thisTime : Number = 0;
		private var _normalTimerDelay : Number;
		private var _setToNormalDelay : Boolean;
		private var _totLastTime : Number ;
		private var _paused : Boolean = false;
		private var _pauseTime : Number ; 
		
		public var totalCounter : int ;
		public var interaction : Interaction ;

		public function SMTimer(delay : Number, repeatCount : int = 0) 
		{
			_totLastTime = 0 ;
			_pauseTime = 0 ; 
			totalCounter = repeatCount ;
			_normalTimerDelay = delay;
			super(delay, repeatCount);
			super.addEventListener(TimerEvent.TIMER, onTimerInterval, false, 0, true);
		}

		private function onTimerInterval(e : TimerEvent) : void {
			if (_setToNormalDelay) {
				super.delay = _normalTimerDelay;
				_setToNormalDelay = false;
			}
			_totLastTime = _totLastTime + _normalTimerDelay ;
			_lastTime = getTimer();
		}

		// / Starts the timer, if it is not already running. If paused will just call resume.
		override public function start() : void {
			if (_paused) 
			{
				resume();
			} else {
				_lastTime = getTimer();
				super.start();
			}
		}

		/**
		 * if you need the standard timer delay. if paused it will not reflect standard delay time
		 * use this.delay to get the standard amount of delay time.
		 */
		public function get superTimerDelay() : Number {
			return super.delay;
		}

		// need to note keep track of the user set dealy
		override public function get delay() : Number {
			return _normalTimerDelay;
		}

		override public function set delay(value : Number) : void {
			_lastTime = getTimer();
			super.delay = value;
			_normalTimerDelay = value;
		}

		// for seeing if this timer is paused.
		public function get paused() : Boolean {
			return _paused;
		}

		/**
		 * will pause the timer, with out reseting the current delay tick
		 */
		public function pause() : void {
			_paused = true;

			super.stop();
			_thisTime = getTimer() - _lastTime;
			_pauseTime = getTime() ; 
		}

		/**
		 * will continue the timers delay tick from where it was paused.
		 */
		public function resume() : void {
			_paused = false;

			if (_thisTime > super.delay) {
				_thisTime = super.delay;
			}

			super.delay = super.delay - _thisTime;
			_lastTime = getTimer();
			_setToNormalDelay = true;
			super.start();

			_thisTime = 0;
		}

		public function getTime() : Number {
			var thisTime : Number = getTimer() - _lastTime + _totLastTime + _pauseTime;
			return thisTime ;
		}
	}
}



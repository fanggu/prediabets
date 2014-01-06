package com.refract.air.shared.prediabetes.stateMachine.view.interactions {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.logger.Logger;
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.stateMachine.view.StateTxtView;
	import com.refract.prediabetes.stateMachine.view.interactions.InteractionQP;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Box;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	/**
	 * @author robertocascavilla
	 */
	public class MobileInteractionQP extends InteractionQP {
		private var _activated : Boolean;
		private var _accelerometer : AccelerometerAccess;
		private var _stateTxtView : StateTxtView;
		
		private var _touch_1 : Box ;
		private var _touch_2 : Box ;
		private var _t1_released : Boolean;
		private var _t2_released : Boolean;
		
		private var _endAlphaTouch : Number = 0.3 ; 
		public function MobileInteractionQP(interactionObject : Object) 
		{
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			super(interactionObject);
		}
		override protected function init( evt : Event ) : void
		{
			_activated = false ; 
			stage.focus = this;
			//_counterOn = false ; 
			removeEventListener(Event.ADDED_TO_STAGE, init) ;
			
			AppSettings.stage.addEventListener( Event.RESIZE , onResize ) ; 
			DispatchManager.addEventListener(Flags.FADEOUT, onFadeOut );
			
			initValues() ;  
			
			if( SMVars.me.accelerometerAble && !SMVars.me.QP_PRE_RUN )
			{
				SMVars.me.QP_PRE_RUN = true ; 
				initCopy() ; 
				initAccelerometer() ; 
			}
			else
			{
				//SMVars.me.accelerometerAble = false ; trace
				initSecondCopy() ; 
				initTouchAction() ; 
				
				DispatchManager.addEventListener( Event.ENTER_FRAME, preRun ) ; 
			}

		}
		
		override protected function preRun( evt : Event ) : void
		{
			callKey() ;
		}
		/*
		override protected function start_cpr_standard() : void
		{
			super.start_cpr_standard() ;
			DispatchManager.removeEventListener( Event.ENTER_FRAME,  run ) ;	
		}
		 * 
		 */
		 override protected function callKey() : void
		 {
			if( !SMVars.me.accelerometerAble )
			{
				if (  !_q_released && !_p_released && _t1_released && _t2_released) 
				{
					DispatchManager.removeEventListener( Event.ENTER_FRAME, preRun ) ;
					
					
					_t1_released = false ; 
					_t2_released = false ;
					
					TweenMax.killTweensOf( _touch_1 ) ;
					_touch_1.alpha = 0 ;
					TweenMax.to( _touch_1 , .3 , { alpha : _endAlphaTouch} ) ; 
					
					TweenMax.killTweensOf( _touch_2 ) ;
					_touch_2.alpha = 0 ;
					TweenMax.to( _touch_2 , .3 , { alpha : _endAlphaTouch} ) ; 
						
					accelerometerPump() ;  
					//	super.pump() ; 
				}
						 
			}
				
		 }
		
		
		
		private function initSecondCopy() : void
		{
			createStateText() ; 
		}
		private function initTouchAction() : void
		{
			_touch_1 = new Box( 100 , 100 , 0xffffff ) ;
			_touch_2 = new Box( 100 , 100 , 0xffffff ) ;  
			
			
			addChild( _touch_1 ) ;
			addChild( _touch_2 ) ;
			
			_q_released = true ;
			_p_released = true ;
			
			_t1_released = true ; 
			_t2_released = true ;
			
			_touch_1.addEventListener(TouchEvent.TOUCH_BEGIN , touch1Begin) ;
			_touch_2.addEventListener(TouchEvent.TOUCH_BEGIN, touch2Begin) ;
			
			_touch_1.addEventListener(TouchEvent.TOUCH_END, touch1End) ;
			_touch_2.addEventListener(TouchEvent.TOUCH_END , touch2End) ;
			
			_touch_1.alpha = _touch_2.alpha = _endAlphaTouch ; 
			
			onResize() ; 
		}

		private function touch2End(event : Event) : void 
		{
			_q_released = true ;
			_t2_released = true ;
		}

		private function touch1End(event : Event) : void 
		{
			_p_released = true ;
			_t1_released = true ; 
		}

		private function touch1Begin(event : Event) : void 
		{
			Logger.log(Logger.STATE_MACHINE,"T1");
			_q_released = false ; 
		}

		private function touch2Begin(event : Event) : void 
		{
			Logger.log(Logger.STATE_MACHINE,"T2");
			_p_released = false ;
		}
		
		private function createStateText() : void
		{	
			//accelerometer_error
			var stateObjectText : Object = new Object() ; 
			var myCopy : String ; 
			var copyFixPosition : int = 0 ; 
			if( !SMVars.me.accelerometerErrorCopy)
			{
				myCopy = SMController.me.model.accelerometer_error_copy ; 
				SMVars.me.accelerometerErrorCopy = true ; 
				
			}
			else
			{
				myCopy = interaction.copy.alt ; 
				copyFixPosition = -15 * ( AppSettings.RATIO /2 )  ; 
			}
			stateObjectText.state_txt = myCopy ; //"Sorry we can't track your device motion.\nPlease just press the two pads below,\nat the same time,two times a second",
			stateObjectText.state_txt_x = interaction.choice_x;
			stateObjectText.state_txt_y = interaction.choice_y + copyFixPosition;
			if( _stateTxtView )
			{
				stateTxtDevastate() ; 
			}
			_stateTxtView  = new StateTxtView( stateObjectText , 36 ) ; 
			addChild( _stateTxtView ) ; 
		}
		public function accelerometerPump( ) : void
		{
			if( !_activated )
			{
				//VideoLoader.i.stopVideo() ; 
				_activated = true ; 
				DispatchManager.removeEventListener( Event.ENTER_FRAME , preRun);
				start() ; 
				
				if( _stateTxtView )
				{
					stateTxtDevastate() ; 
				}
			}
			else
			{
				super.pump() ; 
			}
			
		}
		
		override protected function stateTxtDevastate( ) : void
		{
			super.stateTxtDevastate() ;
			
			if( _stateTxtView)
			{
				if( _stateTxtView.parent)
				{	
					_stateTxtView.dispose() ; 
					removeChild( _stateTxtView );
					_stateTxtView = null ; 
				}
			}
		}
		private function initAccelerometer() : void
		{
			_accelerometer  = new AccelerometerAccess() ; 
			_accelerometer.viewRef = this ; 
			_accelerometer.init( 1 ) ; 
		}
		
		override public function dispose() : void
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			if(_touch_1){
				_touch_1.removeEventListener(MouseEvent.MOUSE_DOWN , touch1Begin) ;
				_touch_1.removeEventListener(MouseEvent.MOUSE_UP , touch1End) ;
			}
			if(_touch_2){
				_touch_2.removeEventListener(MouseEvent.MOUSE_UP , touch2End) ;
				_touch_2.removeEventListener(MouseEvent.MOUSE_DOWN , touch2Begin) ;
			}
			if( _accelerometer)
			{
				_accelerometer.dispose() ; 
				_accelerometer = null ;
			} 
			_activated = false ; 
			super.dispose() ;
		}
		
		override protected function onResize( evt : Event = null ) : void
		{
			if( _touch_1)
			{
				var MARGIN_SPACE_W : Number = AppSettings.VIDEO_WIDTH / 12 ;
				var MARGIN_SPACE_H : Number = MARGIN_SPACE_W ; //AppSettings.VIDEO_HEIGHT / 12 ;
				_touch_1.width = _touch_1.height = AppSettings.VIDEO_WIDTH / 4 ; 
			 	_touch_2.width = _touch_2.height = AppSettings.VIDEO_WIDTH / 4 ;
			 
			 	_touch_1.x = AppSettings.VIDEO_LEFT + MARGIN_SPACE_W ;//+ _touch_1.width;
			 	_touch_1.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT - MARGIN_SPACE_H - _touch_2.height ;
			 
			 	_touch_2.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH - MARGIN_SPACE_W - _touch_1.width; ;
			 	_touch_2.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT - MARGIN_SPACE_H - _touch_2.height ;
			}
			super.onResize() ; 
		}
		
	}
}

package com.refract.prediabetes.stateMachine.view.buttons 
{
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.sections.utils.PrediabetesButton;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.VO.CoinVO;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
 com.refract.prediabetes.AppSettings;

	/**
	 * @author robertocascavilla
	 */
	public class ButtonChoice extends PrediabetesButton 
	{
		private var _interaction : Object;
		private var _value : Boolean  ;
		private var _txtBalloon : Sprite;
		private var _txtField : TextField;
		private var _usePos : Boolean ; 
		public function ButtonChoice(
			copyID:String
			, props:Object = null
			, w:Number = 0
			, h:Number = 0
			, useArrow:Boolean = false
			, usePos:Boolean = false
			) 
		{
			_usePos = usePos ;
			super( copyID , props , w , h *AppSettings.RATIO , useArrow);
		}
		public function setButton( interaction : Object ) : void
		{
			DispatchManager.addEventListener(Flags.FADEOUT, onFadeOut ); 
			
			_interaction = interaction ; 
			
			text = interaction.copy.main ;
			name = interaction.iter ; 
			if( _usePos)
			{
				 AppSettings.stage.addEventListener( Event.RESIZE , onResize) ;
				 onResize() ;  
			}
			buttonAlpha = 0.15 ;
			
			var values : String = interaction.interaction_meta ;
			var regExp : RegExp =  /-?[a-z]+/g;
			var arr : Array = values.match( regExp );	
			var tempValue : String = arr[1] ; 
			
			if( tempValue == 'true') _value = true ; 
			else _value = false ; 
			
			
			addEventListener(MouseEvent.CLICK, btPressed); 
			addEventListener(MouseEvent.ROLL_OVER, btRollOver); 

			
			if(  _interaction.deactivate)
			{
				deActivate() ; 
			}
		}

		override public function deActivate() : void
		{
			super.deActivate();	
		}

		private function btRollOver(event : MouseEvent) : void 
		{
			DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , SMSettings.QUESTIONS_ROLLOVER) );
		}
		
		private function onFadeOut( evt : Event ) : void
		{
			TweenMax.to( this , SMSettings.FADE_OUT_TIME , { alpha : 0 , delay : SMSettings.BUTTON_FADE_DELAY , onComplete : destroy, canBePaused:true } ) ;  	
			
			removeEvents() ; 
			removeEventListener(MouseEvent.CLICK, btPressed); 
		}
		
		private function btPressed( evt : MouseEvent ) : void
		{
			var btObj : CoinVO = new CoinVO() ; 
			btObj.btName = name ; 
			btObj.timeChoiceFadeOut = (SMSettings.FADE_OUT_TIME * 1000 )  ; 
			
			
			if( _value ) 
			{ 
				deActivate() ;
			}
			else
			{
				activate() ; 
			}			
			DispatchManager.dispatchEvent(new ObjectEvent(Flags.INSERT_COIN, btObj));
		}
		
		
		public function onResize( evt : Event = null ) : void
		{
			x = ( _interaction.choice_x * AppSettings.VIDEO_WIDTH) / 100 - width/2 + AppSettings.VIDEO_LEFT;
			y = ( _interaction.choice_y * AppSettings.VIDEO_HEIGHT) / 100 + AppSettings.VIDEO_TOP;
		}
		
		override public function destroy() : void
		{
			super.destroy() ; 
			DispatchManager.removeEventListener(Flags.FADEOUT, onFadeOut );  
		}

		public function dispose() : void
		{
			DispatchManager.removeEventListener(Flags.FADEOUT, onFadeOut );  
			AppSettings.stage.removeEventListener( Event.RESIZE , onResize) ;
			if( _txtField ) if( _txtField.parent ) _txtField.parent.removeChild( _txtField ) ;
			if( _txtBalloon ) if( _txtBalloon.parent ) _txtBalloon.parent.removeChild( _txtBalloon ) ;
			_txtBalloon = null ; 
			super.destroy() ; 
		}
	}
}

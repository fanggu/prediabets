package com.refract.prediabetes.stateMachine.view.buttons 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quint;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.LSButton;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.VO.CoinVO;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.events.OverlayEvent;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Circle;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
 com.refract.prediabetes.AppSettings;

	/**
	 * @author robertocascavilla
	 */
	public class ButtonChoice extends LSButton 
	{
		private var _interaction : Object;
		private var _value : Boolean  ;
		private var _txtBalloon : Sprite;
		private var _txtField : TextField;
		public function ButtonChoice(copyID:String, props:Object = null, w:Number = 0,h:Number = 0, useArrow:Boolean = false) 
		{
			super( copyID , props , w , h *AppSettings.RATIO , useArrow);
		}
		public function setButton( interaction : Object ) : void
		{
			AppSettings.stage.addEventListener( Event.RESIZE , onResize) ; 
			DispatchManager.addEventListener(Flags.FADEOUT, onFadeOut ); 
			
			_interaction = interaction ; 
			
			text = interaction.copy.main.toUpperCase() ;
			
			name = interaction.iter ; 
			onResize() ; 
			
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
		
		
		private function onTextFeedback( evt : StateEvent ) : void
		{
			if( evt.stringParam == '-1' && activated == -1 )
			{
				createText( evt.stringParam ) ; 
			}
			if( evt.stringParam == '+1' && activated == 1 )
			{
				createText( evt.stringParam ) ; 
			}
			
		}
		private function createText( str : String ) : void
		{
			var colorCircle : uint ; 
			
			if( str == '+1') colorCircle = SMSettings.GREEN_BUTTON ; 
			else colorCircle = SMSettings.DEEP_RED ; 
			_txtBalloon  = new Sprite ;
			var circleSize : Number = 20 *AppSettings.RATIO ; 
			var circBack : Circle = new Circle( circleSize , colorCircle ) ; 
			var style:Object = 
			{ 
				fontSize:24   
				, multiline: true
				, wordWrap : false
				, width : 300
			} ; 

			_txtField  = TextManager.makeText( SMSettings.FONT_COUNTDOWN , null , style) ;
			_txtField.text = str ; 
			_txtField.textColor = 0xffffff ;
			
			_txtBalloon.addChild( circBack ) ;
			_txtBalloon.addChild( _txtField ) ; 
			_txtField.x = - _txtField.width/2 ;
			_txtField.y = - _txtField.height/2 ;
			circBack.alpha = .7 ;
			addChild( _txtBalloon ) ;
			
			_txtBalloon.scaleX = _txtBalloon.scaleY = 0 ; 
			_txtBalloon.y = AppSettings.stage.mouseY ;
			_txtBalloon.x = AppSettings.stage.mouseX ;
			
			TweenMax.killTweensOf( _txtBalloon ) ;
			TweenMax.to( _txtBalloon , 2 , { y : AppSettings.stage.mouseY-100 , ease : Quint.easeOut , onComplete : devastate , onCompleteParams : [_txtField] , canBePaused:false} ) ; 
			//TweenMax.to( txtBalloon , .1 , { alpha : 0 ,  delay : .8 , yoyo:true , repeat : 4} ) ;
			TweenMax.to( _txtBalloon , .7 , { scaleX : 1 , scaleY:1  ,delay :0 , ease : Elastic.easeOut , canBePaused:true } ) ;
			TweenMax.to( _txtBalloon , .2 , { scaleX : 0 , scaleY:0  ,delay :.7 , ease : Quint.easeOut , canBePaused:true } ) ;
			
			DispatchManager.dispatchEvent(  new OverlayEvent( OverlayEvent.DRAW_BALLOON , _txtBalloon ) ) ; 
		} 
		
		public function onResize( evt : Event = null ) : void
		{
			x = ( _interaction.choice_x * AppSettings.VIDEO_WIDTH) / 100 - width/2 + AppSettings.VIDEO_LEFT;
			y = ( _interaction.choice_y * AppSettings.VIDEO_HEIGHT) / 100 + AppSettings.VIDEO_TOP;
		}
		
		override public function destroy() : void
		{
			super.destroy() ; 
			AppSettings.stage.removeEventListener( Event.RESIZE , onResize) ; 
			DispatchManager.removeEventListener(Flags.FADEOUT, onFadeOut );  
		}
		
		private function devastate( obj : TextField ) : void
		{
			if( obj.parent ) obj.parent.removeChild( obj ) ; 
		}
		
		public function dispose() : void
		{
			AppSettings.stage.removeEventListener( Event.RESIZE , onResize) ; 
			DispatchManager.removeEventListener(Flags.FADEOUT, onFadeOut );  
			
			if( _txtField ) if( _txtField.parent ) _txtField.parent.removeChild( _txtField ) ;
			if( _txtBalloon ) if( _txtBalloon.parent ) _txtBalloon.parent.removeChild( _txtBalloon ) ;
			_txtBalloon = null ; 
			super.destroy() ; 
		}
	}
}

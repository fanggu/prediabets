package com.refract.prediabetes.stateMachine.view.buttons 
{
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.PrediabetesButton;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.VO.CoinVO;
	import com.refract.prediabetes.stateMachine.events.ObjectEvent;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.events.Event;
	import flash.events.FullScreenEvent;
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
			super( copyID , props , w , h , useArrow);
		}
		public function setButton( interaction : Object ) : void
		{
			if( id != Flags.BACK_TO_VIDEO_BUTTON)
				DispatchManager.addEventListener(Flags.FADEOUT, onFadeOut ); 
			_interaction = interaction ; 
			text = interaction.copy.main ;
			name = interaction.iter ; 
			
			onFullScreenChange() ;  
			
			if( _usePos)
			{
				 AppSettings.stage.addEventListener( Event.RESIZE , onResize) ;
				 onResize() ;  
			}
			buttonAlpha = 1 ; 
			
			var values : String = interaction.interaction_meta ;
			var regExp : RegExp =  /-?[a-z]+/g;
			var arr : Array = values.match( regExp );	
			var tempValue : String = arr[1] ; 
			
			
			if( tempValue == 'true') _value = true ; 
			else _value = false ; 
			
			if( !_interaction.external )
			{
				addEventListener(MouseEvent.CLICK, btPressed);	
			}
			 
			addEventListener(MouseEvent.ROLL_OVER, btRollOver); 

			
			if(  _interaction.deactivate)
			{
				//deActivate() ; 
			}
			
		}
		public function onFullScreen() : void
		{
			onFullScreenChange() ; 
		}
		private function onAppFullScreen( evt : Event ) : void
		{
			onFullScreenChange() ; 
		}
		private function onFullScreenChange ( evt : FullScreenEvent = null ) : void
		{
			var style:Object = {};
			style.fontSize = SMSettings.CHOICE_FONT_SIZE  ;
			style.align = "left";
			var temp : String = textfield.text ; 
			TextManager.styleText( SMSettings.FONT_BUTTON , textfield , style) ; 
			minW = SMSettings.CHOICE_BUTTON_WIDTH ;  
			minH = SMSettings.CHOICE_BUTTON_HEIGHT ; 
			text = temp ; 
		}
		
		override protected function onMouseEvent(ev:MouseEvent):void{
			switch(ev.type){
				case(MouseEvent.CLICK):
					playSound("SndGeneralClick");
					break;
				case(MouseEvent.MOUSE_OVER):
					playSound("SndGeneralRollover");
					//TweenMax.to(_body,0.4,{tint:overColor});
					
					if(_bkgBorder)	TweenMax.to(_bkgBorder,0.1,{tint : SMSettings.CHOICE_BACK_COLOR });
					if( _bkg ) TweenMax.to( _bkg , 0.1 , {tint : SMSettings.CHOICE_BORDER_COLOR } ) ;
				break;
				default:
					//TweenMax.to(_body,0.2,{tint:null});
					//if(_bkgBorder) TweenMax.to(_bkgBorder,0.4,{alpha:0});
					if( _bkg ) TweenMax.to( _bkg , 0.3 , {tint : null} ) ;
					if( _bkgBorder ) TweenMax.to( _bkgBorder , 0.3 , {tint : null} ) ;
			}
		}
		
		override public function deActivate() : void
		{
			super.deActivate();	
		}

		private function btRollOver(event : MouseEvent) : void 
		{
			//DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , SMSettings.QUESTIONS_ROLLOVER) );
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
			//**exception for overweight button
			if( _interaction[SMSettings.INTERACTION_INTERNAL])
			{
				btObj.interaction_internal  = true ; 
				btObj.btName = Flags.OVERWEIGHT ; 
				
			}
			DispatchManager.dispatchEvent(new ObjectEvent(Flags.INSERT_COIN, btObj));
		}
		
		
		public function onResize( evt : Event = null ) : void
		{
			x = ( _interaction[SMSettings.JSON_CHOICE_X] * AppSettings.VIDEO_WIDTH) / 100 - width/2 + AppSettings.VIDEO_LEFT;
			y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT - this.height * 2 ; //( _interaction[SMSettings.JSON_CHOICE_Y] * AppSettings.VIDEO_HEIGHT) / 100 + AppSettings.VIDEO_TOP;
		}
		
		override public function destroy() : void
		{
			super.destroy() ; 
			DispatchManager.removeEventListener(Flags.FADEOUT, onFadeOut ); 
			DispatchManager.removeEventListener( Flags.APP_FULLSCREEN, onAppFullScreen ) ;  
		}

		public function dispose() : void
		{
			DispatchManager.removeEventListener( Flags.APP_FULLSCREEN, onAppFullScreen ) ; 
			AppSettings.stage.removeEventListener( FullScreenEvent.FULL_SCREEN , onFullScreenChange ) ;
			DispatchManager.removeEventListener(Flags.FADEOUT, onFadeOut );  
			AppSettings.stage.removeEventListener( Event.RESIZE , onResize) ;
			if( _txtField ) if( _txtField.parent ) _txtField.parent.removeChild( _txtField ) ;
			super.destroy() ; 
		}
	}
}

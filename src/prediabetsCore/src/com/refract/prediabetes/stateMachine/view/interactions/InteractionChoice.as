package com.refract.prediabetes.stateMachine.view.interactions {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.sections.utils.LSButton;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.stateMachine.view.buttons.ButtonChoice;
	import com.robot.comm.DispatchManager;

	import flash.events.Event;

	/**
	 * @author robertocascavilla
	 */
	public class InteractionChoice extends Interaction 
	
	{
		protected var _btChoice : ButtonChoice;
		
		protected var _nameStyleChoice:Object = { fontSize:32  };
		protected var _nameStyleChoiceTarget:Object = { fontSize:32  };
		protected var _nameStyleChoiceImage:Object = { fontSize:24  };
		
		public function InteractionChoice( interactionObject : Object) 
		{
			interaction = interactionObject ; 
			addEventListener(Event.ADDED_TO_STAGE, create);
			DispatchManager.addEventListener( Flags.UPDATE_SIZE_BUTTON , onUpdateSizeButton ) ;
			
		}
//		
	
		protected function onUpdateSizeButton(event : Event) : void 
		{
			if( _btChoice )
			{
				 _btChoice.minW = SMVars.me.maxButtonSize ; 
				 _btChoice.onResize() ; 
			}
		}

		protected function create(event : Event) : void 
		{
			var bt : LSButton ;
			if( interaction.interaction_type == Flags.CHOICE)
			{
				_btChoice = new ButtonChoice("buttonFont", _nameStyleChoice, SMSettings.MIN_BUTTON_SIZE, 70  , true);
				addChild( _btChoice ) ; 
				_btChoice.setButton( interaction ) ; 
			}
			
			
			if( _btChoice ) SMVars.me.updateMaxButtonSize(	_btChoice.width ) ; 
			showButtons() ; 
		}

		protected function showButtons() : void
		{
			var l : int = this.numChildren ;
			var i : int ; 
			for( i = 0 ; i < l ; i++)
			{
				var bt : * = this.getChildAt(i) ; 
				if( bt ) 
				{
					bt.alpha = 0 ;
					var dd: Number = SMSettings.SHOW_DELAY + (interaction.iter)* SMSettings.SHOW_DELAY ; 
					TweenMax.to( bt , .25 , {alpha : 1 , ease : Linear.easeNone , delay : dd, canBePaused:true } ) ;
				}
			}
		}

		
		
		public function dispose() : void
		{
			DispatchManager.removeEventListener( Flags.UPDATE_SIZE_BUTTON , onUpdateSizeButton ) ;
			
			var l : int = this.numChildren ;
			var i : int ; 
			for( i = 0 ; i < l ; i++)
			{ 
				var bt : * = this.getChildAt( 0 )  ;
				if( bt ) 
				{
					if( bt is ButtonChoice)
						bt.dispose() ; 
						
					if( bt.parent ) bt.parent.removeChild( bt ) ; 
 				}
			}
			
			if( this.parent ) this.parent.removeChild( this ) ; 
			
			DispatchManager.dispatchEvent( new Event( Flags.FAST_CLEAR_SOUNDS  ) ) ; 
		}
	}
}

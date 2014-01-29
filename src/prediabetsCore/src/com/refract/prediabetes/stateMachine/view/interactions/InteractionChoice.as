package com.refract.prediabetes.stateMachine.view.interactions {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.sections.utils.PrediabetesButton;
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
		protected var _nameStyleChoice:Object ;
		public var myY : Number ;  
		
		public var iter : int ; 
		
		public function InteractionChoice( interactionObject : Object) 
		{
			_nameStyleChoice = { fontSize:SMSettings.CHOICE_FONT_SIZE  };
			
			interaction = interactionObject ; 
			iter = interaction.iter ; 
			addEventListener(Event.ADDED_TO_STAGE, create);
	//		DispatchManager.addEventListener( Flags.UPDATE_SIZE_BUTTON , onUpdateSizeButton ) ;
			
		}
//		
	
//		protected function onUpdateSizeButton(event : Event) : void 
//		{
//			if( _btChoice )
//			{
//				 _btChoice.minW = SMSettings.CHOICE_BUTTON_WIDTH ; 
//				 _btChoice.minH = SMSettings.CHOICE_BUTTON_HEIGHT ;   
//			}
//		}
		
		public function onFullScreen( ) : void
		{
			_btChoice.onFullScreen() ; 
		}
		protected function create(event : Event) : void 
		{
			var bt : PrediabetesButton ;
			if( interaction.interaction_type == Flags.CHOICE)
			{
				_nameStyleChoice.interaction = true ; 
				_btChoice = new ButtonChoice
				(
					SMSettings.FONT_BUTTON 
					, _nameStyleChoice
					, SMSettings.CHOICE_BUTTON_WIDTH
					, SMSettings.CHOICE_BUTTON_HEIGHT
					, true
				);
				
				addChild( _btChoice ) ; 
				_btChoice.setButton( interaction ) ; 
			}
			
			
			//if( _btChoice ) SMVars.me.updateMaxButtonSize(	_btChoice.width ) ; 
			//showButton() ; 
		}

		protected function showButton() : void
		{
			var bt : * = this.getChildAt( 0 ) ; 
			bt.alpha = 0 ;
			var oldY : int = bt.y ; 
			bt.y = bt.y + 100  ;
			var dd: Number = SMSettings.SHOW_DELAY + (interaction.iter)* SMSettings.SHOW_DELAY ; 
			TweenMax.to( bt , .25 , {alpha : 1 , y : oldY ,  ease : Linear.easeNone , delay : dd, canBePaused:true } ) ;
			
		}

		
		
		public function dispose() : void
		{
			//DispatchManager.removeEventListener( Flags.UPDATE_SIZE_BUTTON , onUpdateSizeButton ) ;
			
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

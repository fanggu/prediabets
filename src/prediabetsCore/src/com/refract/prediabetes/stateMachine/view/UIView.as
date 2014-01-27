package com.refract.prediabetes.stateMachine.view {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.stateMachine.view.interactions.InteractionChoice;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author robertocascavilla
	 */
	public class UIView extends Sprite 
	{ 
		private var _interactionCont : Sprite ; 
		private var _liveInteractions : Array ;
		
		public var stateTxtHeight : int ; 
		
		public function UIView() 
		{
			_interactionCont = new Sprite() ; 
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}

		private function onAddedToStage(event : Event) : void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			//stage.addEventListener(Event.RESIZE,onResize);
			//if( AppSettings.DEVICE != AppSettings.DEVICE_TABLET)
				//AppSettings.stage.addEventListener( FullScreenEvent.FULL_SCREEN , callFullScreen , false , 0 ) ;
			if( AppSettings.DEVICE != AppSettings.DEVICE_TABLET)
				DispatchManager.addEventListener( Flags.APP_FULLSCREEN, callFullScreen ) ;
		}
		private function callFullScreen( evt : Event ) : void
		{
			if( _liveInteractions ) var len : int = _liveInteractions.length; 
			var i : int ; 
			
			for( i = 0 ; i < len ; i++)
			{
				var interaction : InteractionChoice = _liveInteractions[i] ; 
				interaction.onFullScreen() ; 
			}
			posButtons() ; 
		}

		
		
		public function cleanUI() : void
		{	
			if( _liveInteractions ) var len : int = _liveInteractions.length; 
			var i : int ; 
			var child : *;
			
			for( i = 0 ; i < len ; i++)
			{
				var interaction : InteractionChoice = _liveInteractions[i] ; 
				interaction.dispose() ; 
				if( interaction.parent ) interaction.parent.removeChild( interaction ) ; 
			}
			
			len = this.numChildren ;
			 
			for( i= 0 ; i < len ; i++)
			{
				child = this.getChildAt(0);
				try{child.dispose()}catch(e:*){};
				if( child.parent ) this.removeChild( child ) ;
			}	
			_liveInteractions = null ; 
		}
		

		public function createChoice( interaction : Object , stateTxtViewHeight : int  ) : void
		{
			if( !_liveInteractions ) _liveInteractions = new Array() ; 
			var interactionChoice : InteractionChoice = new ClassFactory.INTERACTION_CHOICE( interaction ) ; 
			addChild( interactionChoice ) ; 
			interactionChoice.alpha = 0 ; 
			_liveInteractions.push( interactionChoice ) ; 
		}
		
		
		public function posButtons(evt : Event = null ) : void
		{ 
			if( _liveInteractions )
			{
				var i : int = 0 ; 
				var l : int = _liveInteractions.length ; 
				for( i = 0 ; i < l ; i ++ )
				{
					var interactionChoice : InteractionChoice = _liveInteractions[ i ] ; 
					interactionChoice.x = -interactionChoice.width / 2 ; 
					interactionChoice.myY = SMSettings.CHOICE_BUTTON_SPACE * 2 + stateTxtHeight + interactionChoice.iter* (SMSettings.CHOICE_BUTTON_HEIGHT  + SMSettings.CHOICE_BUTTON_SPACE ) ;
					TweenMax.killTweensOf( interactionChoice ) ; 
					interactionChoice.y = interactionChoice.myY ;
					interactionChoice.alpha = 1 ; 
				}
			}
		}
		public function animateIn( ) : void
		{ 
			if( _liveInteractions )
			{
				var i : int = 0 ; 
				var l : int = _liveInteractions.length ; 
				for( i = 0 ; i < l ; i ++ )
				{
					var interactionChoice : InteractionChoice = _liveInteractions[ i ] ; 
					interactionChoice.y = interactionChoice.myY + 40  ; 
					interactionChoice.alpha = 0  ; 
					var dd: Number = SMSettings.SHOW_DELAY + i* SMSettings.SHOW_DELAY ; 
					TweenMax.to( interactionChoice , .5 , {alpha : 1 ,  ease : Quint.easeOut, delay : dd, canBePaused:true } ) ;
					TweenMax.to( interactionChoice , .6 , {y : interactionChoice.myY  ,  ease : Quint.easeOut , delay : dd, canBePaused:true } ) ;
				}
			}
		}
	}
}

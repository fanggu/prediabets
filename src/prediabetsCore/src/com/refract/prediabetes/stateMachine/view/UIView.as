package com.refract.prediabetes.stateMachine.view {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.view.interactions.InteractionChoice;
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
			stage.addEventListener(Event.RESIZE,onResize);
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
			
			_liveInteractions.push( interactionChoice ) ; 
		}
		
		
		public function onResize(evt : Event = null ) : void
		{ 
			if( _liveInteractions )
			{
				var i : int = 0 ; 
				var l : int = _liveInteractions.length ; 
				for( i = 0 ; i < l ; i ++ )
				{
					var interactionChoice : InteractionChoice = _liveInteractions[ i ] ; 
					interactionChoice.x = -interactionChoice.width / 2 ; 
					interactionChoice.y = stateTxtHeight + interactionChoice.iter* SMSettings.CHOICE_BUTTON_HEIGHT ;
				}
			}
			
			//**Example how to change buttons space
			/*
			var w : Number = AppSettings.stage.stageWidth ; 
			if( w < 800 ) w = 800 ; 
			if( w > 1440 ) w = 1440 ; 
			var w_clean  : Number = w - 800 ; 
			
			var w_clean_max  : Number = 1440 - 800 ; 
			var test : Number = ( w_clean * 10 ) / w_clean_max ; 
			trace('test ' , test)
			var final_test : Number = 30 + test ; 
			trace('final_test :' , final_test )
			SMSettings.CHOICE_BUTTON_HEIGHT = final_test ; 
			 * 
			 */
			
		}
	}
}

package com.refract.prediabetes.stateMachine.view {
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.stateMachine.view.interactions.InteractionChoice;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author robertocascavilla
	 */
	public class UIView extends Sprite 
	{
		private var _myChoiceTimer : TextField ; 
		private var _interactionCont : Sprite ; 
		
		private var _liveInteractions : Array ;
		
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
				//**call dispose if available
//				if( child is Interaction)
//				{
					try{child.dispose()}catch(e:*){};
					if( child.parent ) this.removeChild( child ) ;
//				}
//				else
//				{
				//**removing is still possible
					//try{child.dispose()}catch(e:*){};
					//if( child.parent ) this.removeChild( child ) ;
					//try{this.removeChild( child);}catch(e:*){}
//				}
			}	

			_myChoiceTimer = null ; 
			_liveInteractions = null ; 
		}
		

		public function createChoice( interaction : Object ) : void
		{
			if( !_liveInteractions ) _liveInteractions = new Array() ; 
			var interactionChoice : InteractionChoice = new ClassFactory.INTERACTION_CHOICE( interaction ) ; 
			addChild( interactionChoice ) ; 
			
			_liveInteractions.push( interactionChoice ) ; 
		}
		
		
		

		
		public function createMessageBox( message : String ) : void
		{
			/*
			var cont : Sprite = new Sprite() ; 
			addChild( cont ) ; 
			
			var square : Sprite = createSquare( 0xff0099 , 1400 , 50 , .4 );
			cont.addChild( square );
			
			if( message.substring(0, 1) == '{')
			{
				var my_date:Date = new Date();
				message = String( my_date );
			}
			
			var myT : TextField = createText( message , 'buttonFont' , 20 );
			square.addChild(myT);

			cont.y = 1220 ;
			cont.x = 630 ;  
			
			TweenMax.to( cont , 1 , { y : 500 , ease : Quint.easeOut ,canBePaused:true} );
			 * 
			 */
		}
		
		
		private function createSquare( color : uint , w : int , h : int  , alpha : Number = 1 , corner_w : Number = 1 , corner_h : Number = 1) : Sprite
		{
			/*
			var spr:Sprite = new Sprite();
			spr.graphics.lineStyle( 0 , color ) ;
			spr.graphics.beginFill( color );
			spr.graphics.drawRect( 0, 0, w, h );
			spr.graphics.endFill( );
			spr.alpha = alpha ; 
			spr.x = -spr.width/2 ;
			spr.y = -spr.height/2;
			return spr ; 
			 * 
			 */
			
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(color);
			spr.graphics.drawRoundRect(0 , 0 , w , h , corner_w , corner_h );
			spr.graphics.endFill( );
			spr.alpha =  alpha ; 
			spr.x = -spr.width/2 ;
			spr.y = -spr.height/2;
			return spr ; 
		}
		private function createText
		( 
			str : String 
			, type:String 
			, size : int = 20 
			, setAutoSize : String = TextFieldAutoSize.LEFT
			, align : String = 'left'
			, wordWrap : Boolean = false
			, width : int = 0
			, height : int = 0
		) : TextField
		{
			var id : String = type ; 
			
			var style:Object = 
			{ 
				fontSize:size  
				, align:align 
				, autoSize : setAutoSize 
				, multiline: true
				, wordWrap : wordWrap
				, width : width
				, height : height
			} ; 

			var txtField : TextField = TextManager.makeText( id , null , style) ;
			txtField.text = str ; 
			return txtField ; 	
		}
		
	
		
		private function onResize(evt : Event = null ) : void
		{ 
			if( _myChoiceTimer ) 
				_myChoiceTimer.x = AppSettings.VIDEO_WIDTH/2 -  _myChoiceTimer.width / 2 ; 
		}
	}
}

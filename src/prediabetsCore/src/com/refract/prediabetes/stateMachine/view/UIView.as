package com.refract.prediabetes.stateMachine.view {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.ClassFactory;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.view.interactions.InteractionChoice;
	import com.refract.prediabetes.stateMachine.view.interactions.InteractionQP;
	import com.refract.prediabetes.stateMachine.view.interactions.InteractionSlide;
	import com.robot.comm.DispatchManager;

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
		private var _initTime : Number;
		private var _totTime : Number;
		private var _bar : Sprite;
		private var _endWidthBar : int;
		private var _countDownCont : Sprite;
		
		private var _interactionCont : Sprite ; 
		
		private var _liveInteractions : Array ;
		
		public function UIView() 
		{
			_bar = createSquare( 0xc45252  , 1 , 8) ; 
			_interactionCont = new Sprite() ; 
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}

		private function onAddedToStage(event : Event) : void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			stage.addEventListener(Event.RESIZE,onResize);
		}
	
		public function setCountDownContainer( container : Sprite ) : void
		{
			_countDownCont = container ; 
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
			var lenCountDown : int = _countDownCont.numChildren ;
			for( i = 0 ; i < lenCountDown ; i++)
			{
				child = _countDownCont.getChildAt(0);
				//**removing is still possible
				try{_countDownCont.removeChild( child);}catch(e:*){}	
			}
			TweenMax.to( _countDownCont, 0 , { tint:null , canBePaused:true} );
			TweenMax.killTweensOf(_countDownCont);	
			_myChoiceTimer = null ; 
			
			_liveInteractions = null ; 
		}
		

		public function createSlide( interaction:Object ) : void
		{
			var slide : InteractionSlide = new InteractionSlide( interaction ) ;
			addChild( slide ) ;   
		}
		

		
		
		public function createQPInteraction( interaction : Object ) : void
		{
			var interactionQP : InteractionQP = new ClassFactory.INTERACTION_QP( interaction ) ; 
			addChild( interactionQP ) ; 
		}
		
		public function createChoice( interaction : Object ) : void
		{
			if( !_liveInteractions ) _liveInteractions = new Array() ; 
			var interactionChoice : InteractionChoice = new ClassFactory.INTERACTION_CHOICE( interaction ) ; 
			addChild( interactionChoice ) ; 
			
			_liveInteractions.push( interactionChoice ) ; 
		}
		
		
		public function showBarTimer( totTimerCount : String ) : void
		{
			_initTime = SMVars.me.getSMTimer() ;
			_totTime = int( totTimerCount ) * 1000 ;
			
			_countDownCont.addChild( _bar ) ;  
			
			_bar.x = 0 ; 
			_bar.y = 0 ; 
			
			_bar.width = 0 ; 
			_endWidthBar = AppSettings.VIDEO_WIDTH ; 
			DispatchManager.addEventListener( Event.ENTER_FRAME , barRun) ; 
		}
		
		
		private function barRun( evt : Event ) : void
		{
			var diffTime : Number = SMVars.me.getSMTimer() - _initTime ; 
			
			var percTime : Number = (diffTime * 100) / _totTime ; 
			
			_bar.width = ( percTime * _endWidthBar ) / 100 ;
			if( diffTime >= _totTime)
			{
				DispatchManager.removeEventListener( Event.ENTER_FRAME , barRun) ; 
				
			}
		}
		
		public function updateBarRemove() : void
		{
			DispatchManager.removeEventListener( Event.ENTER_FRAME , barRun) ; 
			stage.removeEventListener(Event.RESIZE,onResize);
		}
		
		private function createMyChoiceTimer() : void 
		{
			_myChoiceTimer = createText( "00:00" , 'countDown' , 48 ) ;
			_myChoiceTimer.textColor = 0xc45252 ;  
		}
		
//		
//		public function createStateText( stateObjectText : Object) : void
//		{
//			if( _stateTxtView )
//			{
//				if( _stateTxtView.parent)
//					removeChild( _stateTxtView );
//				 _stateTxtView = null ; 
//			}
//			_stateTxtView  = new StateTxtView( stateObjectText ) ; 
//			addChild( _stateTxtView ) ;   
//		}

		
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
			_endWidthBar = AppSettings.VIDEO_WIDTH ; 
			if( _myChoiceTimer ) 
				_myChoiceTimer.x = AppSettings.VIDEO_WIDTH/2 -  _myChoiceTimer.width / 2 ; 
		}
	}
}

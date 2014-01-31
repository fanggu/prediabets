package com.refract.prediabetes.stateMachine.view.messageBox {
	import avmplus.getQualifiedClassName;

	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.view.StateTxtView;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MessageBoxView extends Sprite 
	{
		private var _valueObject : Object ;
		private var _interaction_meta : String ; 
		private var _enter : Boolean;
		private var _stateTxtView : StateTxtView;
		public function MessageBoxView( valueObject : Object , interaction_meta : String  ) 
		{
			_valueObject = valueObject ;
			_interaction_meta = interaction_meta ;
			addEventListener( Event.ADDED_TO_STAGE , init ) ; 
		}
		private function init( evt : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE , init ) ;
			
			 
			_enter = false ;	 
			var stateObjectText : Object = new Object() ; 
			stateObjectText.state_txt = _valueObject.copy ; 
			stateObjectText.state_txt_x = 50 ;
			stateObjectText.state_txt_y = 50 ;
			
			mouseEnabled = false ; 
			mouseChildren = false ; 
			this.parent.mouseEnabled = false ; 
			this.parent.mouseChildren = false ; 
			//stage.addEventListener(MouseEvent.CLICK, onClick);
			_stateTxtView  = new StateTxtView( stateObjectText ,  true ) ; 
			addChild( _stateTxtView ) ; 
			_stateTxtView.visible = false ; 
			DispatchManager.addEventListener( Event.ENTER_FRAME, run ) ;
		}
		/*
		function onClick(event:MouseEvent):void
		{
			trace('clicktarget: ', event.target.name, getQualifiedClassName(event.target));
		}
		 * 
		 */
		
		private function run( evt : Event ) : void
		{
			if( SMVars.me.nsStreamTime > _valueObject.enter && SMVars.me.nsStreamTime < _valueObject.exit && !_enter ) 
			{
				_enter = true ;
				show() ;
			}
			if( SMVars.me.nsStreamTimeAbs > _valueObject.exit || SMVars.me.nsStreamTimeAbs < _valueObject.enter )
			{
				if( _enter )
				{
					_enter = false ;
					hide() ; 
				}
			}
		}
		
		private function show() : void
		{
			_stateTxtView.visible = true ; 
			_stateTxtView.alpha = 0 ; 
			TweenMax.to( _stateTxtView , .5 , { alpha : 1 , ease : Linear.easeNone , canBePaused:true} ) ; 
		}
		private function hide() : void
		{
			TweenMax.to( _stateTxtView , .5 , { alpha : 0 , ease : Linear.easeNone , onComplete : null , canBePaused:true } ) ; 
			//DispatchManager.removeEventListener( Event.ENTER_FRAME, run ) ; 
		}
		
		
		public function dispose() : void
		{
			DispatchManager.removeEventListener( Event.ENTER_FRAME, run ) ; 
			if( _stateTxtView)
				if( _stateTxtView.parent)
					_stateTxtView.parent.removeChild( _stateTxtView ) ;
					
			_stateTxtView = null ; 
			
			if( this.parent ) this.parent.removeChild( this ) ; 	
		}
	}
}

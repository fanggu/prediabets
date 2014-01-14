package com.refract.prediabetes.stateMachine.view.messageBox {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.view.StateTxtView;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author robertocascavilla
	 */
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
			_enter = false ;
			//setTimeout( delayRunTime , 100 ) ; 	 
			
			DispatchManager.addEventListener( Event.ENTER_FRAME, run ) ;
		}
		
		private function delayRunTime() : void
		{
			DispatchManager.addEventListener( Event.ENTER_FRAME, run ) ;		
		}
		
		private function run( evt : Event ) : void
		{
			if( SMVars.me.nsStreamTime > _valueObject.enter && !_enter ) 
			{
				_enter = true ;
				show() ;
			}
			if( SMVars.me.nsStreamTime > _valueObject.exit)
			{
				hide() ; 
			}
		}
		
		private function show() : void
		{
			var stateObjectText : Object = new Object() ; 
			stateObjectText.state_txt = parseCopy() ; 
			stateObjectText.state_txt_x = 50 ;
			stateObjectText.state_txt_y = 70;
			
			_stateTxtView  = new StateTxtView( stateObjectText , 30 ) ; 
			_stateTxtView.updateColor( _valueObject.color ) ; 
			addChild( _stateTxtView ) ; 
			
			_stateTxtView.alpha = 0 ; 
			TweenMax.to( _stateTxtView , .5 , { alpha : 1 , ease : Linear.easeNone , canBePaused:true} ) ; 
		}
		private function hide() : void
		{
			TweenMax.to( _stateTxtView , .5 , { alpha : 0 , ease : Linear.easeNone , onComplete : dispose , canBePaused:true } ) ; 
			DispatchManager.removeEventListener( Event.ENTER_FRAME, run ) ; 
		}
		
		
		private function parseCopy() : String
		{
			var copy : String = _valueObject.copy ;
			var loadVarsIndexOf : int = _interaction_meta.indexOf('load_vars') ; 
			if( loadVarsIndexOf >= 0)
			{
				var pattern:RegExp = /-?[A-Z]+/g;
				var arr : Array = _interaction_meta.match(pattern);
				var i : int = 0 ; 
				var l : int = arr.length ; 
				var tempRegExp : RegExp ; 
				var tempString : String ; 
						
				for( i = 0 ; i < l ; i++)
				{
					tempString = '{' + arr[i] + '}' ; 
					tempRegExp =  new RegExp(tempString);
							
					switch( arr[i])
					{
						case 'XX' : 
							copy = copy.replace( tempRegExp , String( SMVars.me.qp_counter )) ; 
						break ;
						case 'YY' :
							copy = copy.replace( tempRegExp , String( SMVars.me.qp_timer )) ;
						break ; 
						
						case 'DATE' :
						
							var today_date:Date = new Date();
							var thismonth:uint = today_date.getMonth();
							//var today_time;
							var currentTime:Date = new Date();
							var minutes : Number = currentTime.getMinutes();
							//var seconds : Number = currentTime.getSeconds();
							//var hours : Number = currentTime.getHours() * 30 + currentTime.getMinutes() / 2;
							var minutesString : String = String( minutes );
							if( minutes < 10) minutesString = '0'+minutesString ;
							var mnth:Array = new Array('January','February','March','April','May','June','July','August','September','October','November','December');
							copy = (today_date.getDate()+ ' ' + mnth[thismonth]+  ' '+today_date.getFullYear()+" "+ currentTime.getHours() + ':' + minutesString ); 
							
						break ;
					}
				}
			}
			return copy ; 
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

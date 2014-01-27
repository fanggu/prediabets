package com.refract.prediabetes.stateMachine 
{
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.stateMachine.VO.HistoryVO;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * @author robertocascavilla
	 */
	public class SMModel 
	{
		private var _dictStates : Dictionary ; 
		private var _dictStatesNumber : Dictionary ; 
		private var _dictAnswers : Dictionary ; 
		private var _dictQuestions : Dictionary ;
		private var _dictPreQuestions : Dictionary ; 
		private var _dictVideoNames: Dictionary ; 
		private var _arrHistory : Array ; 
		
		public var arrLoadInitRequest : Array ; 
		public var selectedState : String ; 
		public var selectedInteraction : int ;
		public var startState : String ;
		public var initButtonStateAddress : String ;
		public var endState : String ;
		public var slowStates : Array ; 
		public var initButtonState : Object ; 
		public var closeButtonState : Object ; 
		 
		public function SMModel()
		{
			
		}
		
		private function getJsonObject( ) : Object
		{
			var bytes : ByteArray = AssetManager.getEmbeddedAsset( "AppDataJson" ) as ByteArray;
			var jsonString : String = bytes.readUTFBytes( bytes.length) ;
			var jsonObject : Object = JSON.parse(jsonString );
			return jsonObject ; 
		}
		public function init( ) : void
		{
			var jsonObject : Object = getJsonObject( ) ; 
			
			_dictStates = new Dictionary( true );
			_dictStatesNumber= new Dictionary( true );
			_dictAnswers = new Dictionary( true ) ; 
			_dictPreQuestions = new Dictionary( true ) ; 
			_dictQuestions = new Dictionary( true ) ; 
			_dictVideoNames = new Dictionary( true ) ; 

			startState = jsonObject.data.meta.start_state ; 
			initButtonStateAddress = jsonObject.data.meta.init_button_state_address ;
			endState = jsonObject.data.meta.end_state ; 
			
			slowStates = jsonObject.data.slow_down_states ; 
			arrLoadInitRequest = jsonObject.data.meta.load_init_request ; 
			for( var state :String in jsonObject.data.states)
			{
				_dictStates[state] = jsonObject.data.states[state];
				if( _is_q( state ) )
				{
					_dictQuestions[ state ] = true ; 
				}
				if( _is_pre_q( jsonObject.data.states[state] ) )
				{
					_dictPreQuestions[ state ] = true ; 
				}
				
			}
			for( var videoName :String in jsonObject.data.clip_length)
			{
				_dictVideoNames[videoName] = jsonObject.data.clip_length[ videoName ] ; 
			}
			
			var stateSlow : Object = jsonObject.data[ SMSettings.STATE_SLOW ] ; 
			_dictStates[ SMSettings.STATE_SLOW ] = stateSlow ; 
			
			var stateNone : Object = jsonObject.data[ SMSettings.STATE_NONE ] ; 
			_dictStates[ SMSettings.STATE_NONE ] = stateNone ; 
			
			initButtonState = jsonObject.data.init_button_state ; 
			initButtonState.iter = Flags.INIT_BUTTON ; 
			
			closeButtonState = jsonObject.data.close_button_state ; 
			closeButtonState.iter = Flags.BACK_TO_VIDEO_BUTTON ; 
			
			
			resetHistory() ; 
		}
		public function storeHistory( historyVO : HistoryVO ) : void
		{
			if( _arrHistory.length > 0  ) 
				var lastEl : String = _arrHistory[ _arrHistory.length-1 ].state ;
			if( historyVO.state != lastEl && historyVO.state != SMSettings.STATE_SLOW )
				_arrHistory.push( historyVO ) ;
			
			if( _arrHistory.length > 1 )
				DispatchManager.dispatchEvent( new Event( Flags.ACTIVE_BACK ) ) ; 
		}

		public function getHistory( iter : int ) : HistoryVO
		{
			var historyVO : HistoryVO = _arrHistory[ _arrHistory.length - iter ] ; 
			_arrHistory.splice( _arrHistory.length -iter  , iter ) ; 
			
			if( _arrHistory.length < 1)
				DispatchManager.dispatchEvent( new Event( Flags.INACTIVE_BACK ) ) ;
			
			return historyVO; 
		}
		public function getHistoryPrev() : HistoryVO
		{
			var historyVO : HistoryVO ; 
			
			if( _arrHistory.length > 2 )
			{
				historyVO = _arrHistory[ _arrHistory.length - 2 ] ; 
				
			}
			return historyVO ; 
		}
		public function resetHistory() : void
		{
			_arrHistory = [] ; 
			DispatchManager.dispatchEvent( new Event( Flags.INACTIVE_BACK ) ) ; 
		}
		public function getVideoLength( videoName : String ) : int 
		{
			return _dictVideoNames[ videoName ] ; 
		}
		public function setAnswer( value : Boolean , address : String ) : void
		{
			if( _dictAnswers[address] == null)
			{
				_dictAnswers[address] = value ; 
			}
		}
		public function getCorrectAnswer( ) : void
		{
			var iter : int = 0 ; 
			for( var address : String in _dictAnswers)
			{
				if( _dictAnswers[address]) iter ++ ;
			}
		}
		
		
		public function setState( value : Object , address : String) : void
		{
			_dictStates[address] = value ; 
		}
		public function get state() : Object
		{
			var stateObject : Object = _dictStates[selectedState] ; 
			stateObject.name = selectedState ; 
			return _dictStates[selectedState];
		}
		
		public function get dictState() : Dictionary
		{
			return _dictStates ; 
		}
		
		/*
		public function get progress() : int
		{
			var value : int = ( _dictStatesNumber[selectedState] * 100 ) / (totStates-1) ; 
			return value ; 
		}
		 * 
		 */
		public function getState( address:String ) : Object
		{
			return _dictStates[address] ;  
		}
		public function getInteraction( address:String , iterInteraction: int ) : Object
		{
			return _dictStates[address].interactions[iterInteraction] ;
		}
		
		public function get interaction() : Object
		{
			var obj : Object = _dictStates[selectedState].interactions[selectedInteraction] ; 
			obj.iter = selectedInteraction;
			
			return obj;
		}
		public function set interaction( interaction : Object) : void
		{
			_dictStates[selectedState].interactions[selectedInteraction] = interaction; 
			
		}
		
		public function getInteractionIter( iter : int ) : Object
		{
			var obj : Object = _dictStates[selectedState].interactions[iter] ; 
			obj.iter = iter;
			return _dictStates[selectedState].interactions[iter] ;
		}
		
		
		public function getNextTriggerEvent() : Number
		{
			return Number(_dictStates[selectedState].interactions[selectedInteraction].next_event_trigger_timecode) ; 
		}
		public function getMBoxTriggerEvent() : Number
		{
			var nr : Number = Number(_dictStates[selectedState].interactions[selectedInteraction].mbox_trigger_timecode) ;
			return nr; 
		}
		
		
		
		private function _is_pre_q( obj : Object ) : Boolean
		{
			var finalState : String = obj.interactions[0].final_state ;
			if( _is_q( finalState ) )
			{
				return true ; 
			}
			else
			{
				return false ;
			}
		}
		private function _is_q( address : String ) : Boolean
		{
			if( address.indexOf( SMSettings._Q)  != -1)
			{
				return true ;
			}
			else
			{
				return false ; 
			}
		}
		public function is_q( address : String ) : Boolean 
		{
			if( _dictQuestions[address ])
				return true ;
			else 
				return false ; 
		}
		public function is_pre_q( address : String ) : Boolean 
		{
			if( _dictPreQuestions[address ])
				return true ;
			else 
				return false ; 
		}
		public function state_no_q( address : String ) : String
		{
			var i : int = address.indexOf( SMSettings._Q) ;
			if( i  != -1) 
			{
				return address.substr( 0 , address.length - i + 1 ) ;  
			}
			else
			{
				return address ; 
			}
		}
		
	
	}
}

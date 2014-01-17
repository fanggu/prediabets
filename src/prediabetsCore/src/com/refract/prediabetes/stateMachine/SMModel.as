package com.refract.prediabetes.stateMachine 
{
	import com.refract.prediabetes.assets.AssetManager;

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
		
		public var selectedState : String ; 
		public var selectedInteraction : int ;
		public var initState : String ;
		public var initButtonState : String ;
		public var endState : String ;
		public var slowStates : Array ; 
		 
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

			initState = jsonObject.data.meta.start_state ; 
			initButtonState = jsonObject.data.meta.init_button_state ;
			endState = jsonObject.data.meta.end_state ; 
			
			slowStates = jsonObject.data.meta.slow_down_states ; 
			for( var state :String in jsonObject.data.states)
			{
				_dictStates[state] = jsonObject.data.states[state];
				//trace('state ' , state)
			}
			
			var stateSlow : Object = {} ; 
			var interaction : Object = {} ; 
			interaction.final_state = '' ; 
			interaction.interaction_type = 'none' ;
			interaction.video_name = '' ;
			interaction.trigger = -1  ;  
			stateSlow.interactions = [interaction] ;

			_dictStates[ SMSettings.STATE_SLOW ] = stateSlow ; 
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
		
		
		
	
	}
}

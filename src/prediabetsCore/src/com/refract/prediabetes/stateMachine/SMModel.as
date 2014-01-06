package com.refract.prediabetes.stateMachine 
{
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.stateMachine.flags.Flags;

	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * @author robertocascavilla
	 */
	public class SMModel 
	{
		/*
		[Embed(source="../../../../../bin/data/flv/laptop_intro.flv" , mimeType="application/octet-stream")] private var LaptopVideo:Class;
	    [Embed(source="../../../../../bin/data/flv/cheetah.flv" , mimeType="application/octet-stream")] private var CheetahVideo:Class;
		[Embed(source="../../../../../bin/data/flv/ls_test1.flv" , mimeType="application/octet-stream")] private var LSVideo:Class;
		[Embed(source="../../../../../bin/data/flv/ls_test1_400.flv" , mimeType="application/octet-stream")] private var LS_400_Video : Class;
		*/
		
		
		private var _dictStates : Dictionary ; 
		private var _dictStatesNumber : Dictionary ; 
		private var _dictAnswers : Dictionary ; 
		
		public var sceneSelect : Array ; 
		public var greyStates : Array ; 
		public var captions : Object ; 
		public var accelerometer_error_copy : String ; 
		
		public var selectedState : String ; 
		public var selectedInteraction : int ;
		public var initState : String ;
		public var endState : String ;
		public var totStates : int ; 
		public var totQuestions : int ;
		public var selectedModule : int ; 
		public var deathVideo : String ; 
		public var death_message_box : Array ;
		public var scoreTot : int ; 
		
		private var _newModule : Boolean ; 
		
		private var _activatedStates : Dictionary ;
		 
		public function SMModel()
		{
			
		}
		
		protected function getJsonObject( module : int  ) : Object
		{
			var bytes : ByteArray = AssetManager.getEmbeddedAsset( "SM" + module + 'Json' ) as ByteArray;
			var jsonString : String = bytes.readUTFBytes( bytes.length) ;
			var jsonObject : Object = JSON.parse(jsonString );
			return jsonObject ; 
		}
		public function init( module : int ) : void
		{
			var jsonObject : Object = getJsonObject( module) ; 
			
			_newModule = false ; 
			if( module != selectedModule)
			{
				_newModule = true ; 
				selectedModule = module ;
			}
			_dictStates = new Dictionary( true );
			_dictStatesNumber= new Dictionary( true );
			_dictAnswers = new Dictionary( true ) ; 
			
			
			
			initState = jsonObject.data.meta.start_state ; 
			
			accelerometer_error_copy = jsonObject.data.meta.accelerometer_error ; 
			deathVideo = jsonObject.data.meta.death_video ;
			scoreTot = jsonObject.data.meta.score_tot ; 
			if( deathVideo != 'false' )
			{
				endState = jsonObject.data.meta.state_dict[jsonObject.data.meta.state_dict.length -1 ] ; 
				death_message_box = jsonObject.data.meta.death_video_message_box ; 
			}
			totStates =  jsonObject.data.meta.state_dict.length;
			totQuestions = jsonObject.data.meta.tot_questions ;
			sceneSelect=  jsonObject.data.meta.scene_select ;
			captions = jsonObject.data.meta.captions ; 
			greyStates= jsonObject.data.meta.grey_states ; 
			 
			var i : int ;
			for( i = 0 ; i < totStates ; i++)
			{
				var nameState : String = jsonObject.data.meta.state_dict[i] ;
				_dictStatesNumber[ nameState ] = i ;
			}
			for( var state :String in jsonObject.data.states)
			{
				_dictStates[state] = jsonObject.data.states[state];
			}
			
			
			if( _newModule ) createActivatedStatesDictionary() ; 
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
		
		private function createActivatedStatesDictionary() : void
		{
			_activatedStates = new Dictionary( true ) ; 
		}
		public function stateActivate( address : String  ) : void
		{
			_activatedStates[ address ] = true ;  
		}
		public function get statesActivatedDict() : Dictionary
		{
			return _activatedStates ;
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
		
		public function get progress() : int
		{
			var value : int = ( _dictStatesNumber[selectedState] * 100 ) / (totStates-1) ; 
			return value ; 
		}
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

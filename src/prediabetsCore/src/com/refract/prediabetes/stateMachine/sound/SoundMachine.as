package com.refract.prediabetes.stateMachine.sound {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	/**
	 * @author robertocascavilla
	 */
	public class SoundMachine 
	{
		private var _dict : Dictionary;
		private var _dictLoop : Dictionary ;
		private var _frozen : Boolean;
		
		public function SoundMachine() 
		{
			init() ;
		}
		private function init() : void
		{	
			DispatchManager.addEventListener( Flags.STATE_MACHINE_START, onStart ) ;
			DispatchManager.addEventListener( Flags.STATE_MACHINE_END, onEnd ) ;
			createListeners() ; 	 
		}

		private function onStart( event : Event ) : void 
		{
			_frozen = false ; 
			
			_dict = new Dictionary(true) ; 
			_dictLoop = new Dictionary(true) ; 
			
		}
		private function onEnd( event : Event ) : void 
		{
			removeListeners() ; 
		}
		
		private function createListeners() : void
		{
			DispatchManager.addEventListener( Flags.UPDATE_SOUND, onUpdateSound ) ; 
			DispatchManager.addEventListener( Flags.UPDATE_BUTTON_SOUND, onUpdateButtonSound ) ; 
			DispatchManager.addEventListener( Flags.UPDATE_FX_SOUND, onUpdateFXSound ) ; 
			DispatchManager.addEventListener( Flags.UPDATE_LOOP_SOUND, onUpdateLoopSound ) ; 
			
			
			DispatchManager.addEventListener( Flags.CLEAR_SOUNDS, onClearSounds ) ;
			DispatchManager.addEventListener( Flags.FAST_CLEAR_SOUNDS, onFastClearSounds ) ; 
			
			DispatchManager.addEventListener( Flags.FREEZE, onFreeze) ; 
			DispatchManager.addEventListener( Flags.UN_FREEZE, onUnFreeze) ;
			
			DispatchManager.addEventListener( Flags.FREEZE_SOUNDS, onFreeze) ; 
			DispatchManager.addEventListener( Flags.UN_FREEZE_SOUNDS, onUnFreeze) ;
		}
		private function removeListeners() : void
		{
		/*	DispatchManager.removeEventListener( Flags.UPDATE_SOUND, onUpdateSound ) ; 
			DispatchManager.removeEventListener( Flags.UPDATE_BUTTON_SOUND, onUpdateButtonSound ) ; 
			DispatchManager.removeEventListener( Flags.UPDATE_FX_SOUND, onUpdateFXSound ) ; 
			DispatchManager.removeEventListener( Flags.UPDATE_LOOP_SOUND, onUpdateLoopSound ) ; 
			
			DispatchManager.removeEventListener( Flags.CLEAR_SOUNDS, onClearSounds ) ; 
			DispatchManager.removeEventListener( Flags.FAST_CLEAR_SOUNDS, onFastClearSounds ) ; 
			
			DispatchManager.removeEventListener( Flags.FREEZE, onFreeze) ; 
			DispatchManager.removeEventListener( Flags.UN_FREEZE, onUnFreeze) ;
			
			DispatchManager.removeEventListener( Flags.FREEZE_SOUNDS, onFreeze) ; 
			DispatchManager.removeEventListener( Flags.UN_FREEZE_SOUNDS, onUnFreeze) ; */
		}
		
	
		private function onUnFreeze(event : Event) : void 
		{
			if( _frozen)
			{
				
				_frozen = false ; 
				var sVO : SoundVO;
				var address : String ; 
				for( address in _dict)
				{
					sVO = _dict[ address ] ; 
					if( sVO.soundChannel ) 
					{
						sVO.soundChannel = sVO.sound.play( sVO.pausePoint) ; 
						sVO.isPlaying = true ; 
					}
				}
				for( address in _dictLoop)
				{
					sVO = _dictLoop[ address ] ; 
					if( sVO.soundChannel ) 
					{
						sVO.soundChannel = sVO.sound.play( 0 , int.MAX_VALUE) ; 
						sVO.isPlaying = true ; 
					}
				}
			}
		}

		private function onFreeze(event : Event) : void 
		{
			
			if( !_frozen)
			{
				
				_frozen = true ; 
				var sVO : SoundVO;
				var address : String ; 
				for( address in _dict)
				{
					sVO = _dict[ address ] ; 
					if( sVO.soundChannel ) 
					{
						sVO.pausePoint = sVO.soundChannel.position ;
						sVO.soundChannel.stop() ; 
						sVO.isPlaying = false ; 
					} 
				}
				for( address in _dictLoop)
				{
					sVO = _dictLoop[ address ] ; 
					if( sVO.soundChannel ) 
					{
						sVO.pausePoint = sVO.soundChannel.position ;
						sVO.soundChannel.stop() ; 
						sVO.isPlaying = false ; 
					} 
				}
			}
		}


		private function onUpdateSound(event : StateEvent) : void 
		{
			onClearSounds() ; 
			var address : String = event.stringParam ; 
			var sVO : SoundVO = new SoundVO() ; 
			if( _dict[ address ])
			{
				sVO = _dict[ address ];
				TweenMax.killTweensOf( sVO.soundChannel );
				if (sVO.soundChannel ) 
					sVO.soundChannel.stop() ; 
				
			}
			
			sVO.sound = AssetManager.getEmbeddedAsset( address ) ; 
			sVO.soundChannel = sVO.sound.play() ; 
			sVO.isPlaying = true ; 
			sVO.pausePoint = 0 ; 
			
			_dict[address] = sVO ; 
		}
		
		private function onUpdateButtonSound( event : StateEvent ) : void
		{
			var address : String = event.stringParam ; 
			var sound : Sound = AssetManager.getEmbeddedAsset( address ) ; 
			var soundChannel : SoundChannel = sound.play() ; 
			soundChannel ; 
		}
		private function onUpdateFXSound( event : StateEvent ) : void
		{
			var address : String = event.stringParam ; 
			var sound : Sound = AssetManager.getEmbeddedAsset( address ) ; 
			var soundChannel : SoundChannel = sound.play() ; 
			soundChannel ; 
		}
		private function onUpdateLoopSound( event : StateEvent ) : void
		{
			
			var address : String = event.stringParam ; 
			var sVO : SoundVO = new SoundVO() ; 
			sVO.sound = AssetManager.getEmbeddedAsset( address ) ; 
			sVO.soundChannel = sVO.sound.play( 0  , int.MAX_VALUE) ; 
			sVO.isPlaying = true ; 
			sVO.pausePoint = 0 ; 
			
			_dictLoop[address] = sVO ; 
		}
		
		private function onClearSounds( evt : Event = null ) : void
		{
			/*
			var sVO : SoundVO ;
			var address:String ;
			for( address in _dict)
			{
				sVO = _dict[ address ] ; 
				if( sVO.soundChannel)
					TweenMax.to( sVO.soundChannel, .3 , { volume : 0 , onComplete: devastateSound , onCompleteParams:[sVO.soundChannel , address ] , canBePaused:true} ) ;
			}
			
			for( address in _dictLoop)
			{
				sVO = _dictLoop[ address ] ; 
				if( sVO.soundChannel)
					devastateLoopSound( sVO.soundChannel , address ) ;
					//TweenMax.to( sVO.soundChannel, .3 , { volume : 0 , onComplete: devastateLoopSound , onCompleteParams:[sVO.soundChannel , address ] , canBePaused:true} ) ;
			}
			*/
			onFastClearSounds() ; 
		}
		private function onFastClearSounds( evt : Event = null ) : void
		{
			var sVO : SoundVO ;
			var address:String ;
			for( address in _dict)
			{
				sVO = _dict[ address ] ; 
				if( sVO.soundChannel)
					devastateSound( sVO.soundChannel , address ) ;
			}
			
			for( address in _dictLoop)
			{
				sVO = _dictLoop[ address ] ; 
				if( sVO.soundChannel)
				{
					sVO.soundChannel.stop() ;
					devastateLoopSound( sVO.soundChannel , address ) ;
				}
			}	
		}
		private function devastateSound( sound : SoundChannel , address : String ) : void
		{
			sound.stop() ; 
			_dict[address] = null ;  
			delete _dict[address] ; 
			
		}
		private function devastateLoopSound( sound : SoundChannel , address : String ) : void
		{
			sound.stop() ;
			_dictLoop[address] = null ;  
			delete _dictLoop[address] ; 
		}
	}
}

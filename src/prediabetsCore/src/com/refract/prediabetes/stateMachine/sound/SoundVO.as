package com.refract.prediabetes.stateMachine.sound {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * @author robertocascavilla
	 */
	public class SoundVO 
	{
		public var soundChannel : SoundChannel ;
		public var sound : Sound ; 
		public var isPlaying : Boolean ; 
		public var pausePoint : Number ; 
		
		public function SoundVO(){}
	}
}

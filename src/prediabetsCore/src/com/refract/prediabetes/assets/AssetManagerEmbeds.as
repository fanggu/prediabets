package com.refract.prediabetes.assets {
	public dynamic class AssetManagerEmbeds {
		//**Json
		[Embed(source="../../../../../assets/json/PrediabetesData.json",mimeType="application/octet-stream")]
		private var AppDataJson : Class;
		
		[Embed(source="../../../../../assets/json/copy_en.json",mimeType="application/octet-stream")] private var CopyJSON : Class;
		
		//**GENERIC
		[Embed(source="../../../../../assets/img/politeloader.png")] private var PoliteLoader : Class;
		[Embed(source="../../../../../assets/img/logo.jpg")] private var Logo : Class;
		[Embed(source="../../../../../assets/img/logo_retina.jpg")] private var LogoRetina : Class;
		[Embed(source="../../../../../assets/img/logo_dnz.png")] private var LogoDNZ : Class;
		[Embed(source="../../../../../assets/img/logo_dnz_retina.png")] private var LogoDNZRetina : Class;
		
		[Embed(source="../../../../../assets/swf/library.swf", symbol="Green_Play")] private var GreenPlay : Class;
		[Embed(source="../../../../../assets/swf/library.swf", symbol="Red_Pause")] private var RedPause : Class;
		
		[Embed(source="../../../../../assets/swf/library.swf", symbol="FullScreenOnOff")] private var FullScreen : Class;

		[Embed(source='../../../../../assets/swf/library.swf' , symbol='GeneralClick')] private var SndGeneralClick :Class ;//
		[Embed(source='../../../../../assets/swf/library.swf' , symbol='GeneralRollover')] private var SndGeneralRollover :Class ;//

		
		[Embed(source='../../../../../assets/sound/BUTTON_SOUND_GOOD.mp3')] private var BUTTON_SOUND_GOOD :Class ;
		[Embed(source='../../../../../assets/sound/BUTTON_SOUND_WRONG.mp3')] private var BUTTON_SOUND_WRONG :Class ;
		[Embed(source='../../../../../assets/sound/Questions_Fade-Up.mp3')] private var Questions_Fade_Up :Class ;
		[Embed(source='../../../../../assets/sound/Questions_Rollover.mp3')] private var Questions_Rollover :Class ;
/*
		[Embed(source="../../../../../assets/img/pause_retina.png")] private var Pause : Class;
		[Embed(source="../../../../../assets/img/play_retina.png")] private var Play : Class;
		[Embed(source="../../../../../assets/img/audio/audio_on_retina.png")] private var AudioOn : Class;
		[Embed(source="../../../../../assets/img/audio/audio_off_retina.png")] private var AudioOff : Class;
		[Embed(source="../../../../../assets/img/backward_retina.png")] private var BackwardButton : Class;
*/
		[Embed(source="../../../../../assets/img/pause.png")] private var Pause : Class;
		[Embed(source="../../../../../assets/img/play.png")] private var Play : Class;
		[Embed(source="../../../../../assets/img/audio/audio_on.png")] private var AudioOn : Class;
		[Embed(source="../../../../../assets/img/audio/audio_off.png")] private var AudioOff : Class;
		[Embed(source="../../../../../assets/img/backward.png")] private var BackwardButton : Class;
		
		[Embed(source="../../../../../assets/img/social/facebook.png")] public var Facebook : Class;
		[Embed(source="../../../../../assets/img/social/twitter.png")] public var Twitter : Class;
		[Embed(source="../../../../../assets/img/social/googleplus.png")] public var GooglePlus : Class;
		
		[Embed(source="../../../../../assets/img/preloaderbkg.jpg")] public var BKG : Class;

		public function AssetManagerEmbeds(){
			
		}
		
		public function getClass(className:String):Class {
			if(this[className] != null){
				return this[className] as Class;
			}else{
				return null;
			}
		}
		
	}
}

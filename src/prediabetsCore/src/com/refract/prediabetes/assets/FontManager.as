package com.refract.prediabetes.assets {
	/**
	 * @author robertocascavilla
	 */
	public class FontManager 
	{
		public static const FONT_NEXABOLD:String = "NEXABOLD";
		public static const FONT_NEXALIGHT:String = "NEXALIGHT";
		
		[Embed(	source="fonts/Nexa_Free_Bold.otf", 
				fontName = "NEXABOLD", 
    			mimeType = "application/x-font", 
    			fontWeight="normal", 
    			fontStyle="normal", 
				fontFamily="NexaBold",
    			//unicodeRange="englishRange", 
    			advancedAntiAliasing="true", 
    			embedAsCFF="false"
		)]
		private var NexaBold : Class;
		
		[Embed(	source="fonts/Nexa_Free_Light.otf", 
				fontName = "NEXALIGHT", 
    			mimeType = "application/x-font", 
    			fontWeight="normal", 
    			fontStyle="normal", 
				fontFamily="NexaLight",
    			//unicodeRange="englishRange", 
    			advancedAntiAliasing="true", 
    			embedAsCFF="false"
		)]
		private var NexaLight : Class;
		
		public function FontManager(){
			//new BebasNeue() ;
			//new AkzidenzGroteskBoldCond() ;
		}
	}
}

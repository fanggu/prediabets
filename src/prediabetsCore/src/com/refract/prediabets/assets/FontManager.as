package com.refract.prediabets.assets {
	/**
	 * @author robertocascavilla
	 */
	public class FontManager 
	{
		public static const FONT_BEBASNEUE:String = "bebas";
		public static const FONT_AKZIDENZG_BOLD_CONDENSED:String = "FONT_AKZIDENZG_BOLD_CONDENSED";
		public static const FONT_AKZIDENZG_CONDENSED:String = "FONT_AKZIDENZG_CONDENSED";
		public static const FONT_AKZIDENZG_MEDIUM:String = "FONT_AKZIDENZG_MEDIUM";
		public static const FONT_AKZIDENZG_MEDIUM_CONDENSED_ALT:String = "FONT_AKZIDENZG_MEDIUM_CONDENSED_ALT";
		
		[Embed(	source="fonts/BebasNeue.otf", 
				fontName = "bebas", 
    			mimeType = "application/x-font", 
    			fontWeight="normal", 
    			fontStyle="normal", 
				fontFamily="BebasNeue",
    			//unicodeRange="englishRange", 
    			advancedAntiAliasing="true", 
    			embedAsCFF="false"
		)]
		private var BebasNeue : Class;
		
		[Embed(	source="fonts/AkzidenzGrotesk-BoldCond.otf", 
				fontName = "FONT_AKZIDENZG_BOLD_CONDENSED", 
    			mimeType = "application/x-font", 
    			fontWeight="bold", 
    			fontStyle="normal", 
				fontFamily="AkzidenzGroteskBoldCondensed",
    			//unicodeRange="englishRange", 
    			advancedAntiAliasing="true", 
    			embedAsCFF="false"
		)]
		private var AkzidenzGroteskBoldCond:Class;
		
		[Embed(	source="fonts/AkzidenzGrotesk-Cond.otf", 
				fontName = "FONT_AKZIDENZG_CONDENSED", 
    			mimeType = "application/x-font", 
    			fontWeight="normal", 
    			fontStyle="normal", 
				fontFamily="AkzidenzGroteskCondensed",
    			//unicodeRange="englishRange", 
    			advancedAntiAliasing="true", 
    			embedAsCFF="false"
		)]
		private var AkzidenzGroteskCond:Class;
		
		[Embed(	source="fonts/AkzidenzGrotesk-Medium.otf", 
				fontName = "FONT_AKZIDENZG_MEDIUM", 
    			mimeType = "application/x-font", 
    			fontWeight="normal", 
    			fontStyle="normal", 
				fontFamily="AkzidenzGroteskMedium",
    			//unicodeRange="englishRange", 
    			advancedAntiAliasing="true", 
    			embedAsCFF="false"
		)]
		private var AkzidenzGroteskMedium:Class;
		
		[Embed(	source="fonts/AkzidenzGrotesk-MediumCondAlt.otf", 
				fontName = "FONT_AKZIDENZG_MEDIUM_CONDENSED_ALT", 
    			mimeType = "application/x-font", 
    			fontWeight="normal", 
    			fontStyle="normal", 
				fontFamily="AkzidenzGroteskMediumCondensedAlt",
    			//unicodeRange="englishRange", 
    			advancedAntiAliasing="true", 
    			embedAsCFF="false"
		)]
		private var AkzidenzGroteskMediumCondAlt:Class;
		
		public function FontManager(){
			new BebasNeue() ;
			new AkzidenzGroteskBoldCond() ;
		}
	}
}

package com.refract.prediabetes {
	import com.refract.prediabetes.nav.Footer;
	import com.refract.prediabetes.nav.Header;
	import com.refract.prediabetes.nav.Nav;
	import com.refract.prediabetes.sections.findoutmore.FindOutMore;
	import com.refract.prediabetes.sections.intro.Intro;
	import com.refract.prediabetes.sections.legal.Legal;
	import com.refract.prediabetes.sections.social.Share;
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.SMModel;
	import com.refract.prediabetes.stateMachine.SMView;
	import com.refract.prediabetes.stateMachine.view.interactions.InteractionChoice;
	import com.refract.prediabetes.video.VideoLoader;

	public class ClassFactory {
		
		public static var APP_CONTROLLER:Class = AppController;
		
		public static var NAV:Class = Nav;
		public static var INTRO:Class = Intro;
		public static var VIDEO_LOADER:Class = VideoLoader;
		public static var LEGAL : Class = Legal;
		public static var SHARE : Class = Share;		
		public static var FIND_OUT_MORE : Class = FindOutMore;
		
		public static var FOOTER : Class = Footer;
		public static var HEADER : Class = Header;
		
		
		//**STATE MACHINE
		public static var INTERACTION_CHOICE : Class = InteractionChoice ; 
		public static var SM_VIEW : Class = SMView ; 
		public static var SM_MODEL : Class = SMModel ; 
		public static var SM_CONTROLLER : Class = SMController ; 

	}
}

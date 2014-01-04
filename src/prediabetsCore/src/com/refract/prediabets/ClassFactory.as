package com.refract.prediabets {
	import com.refract.prediabets.nav.Footer;
	import com.refract.prediabets.nav.Header;
	import com.refract.prediabets.nav.Nav;
	import com.refract.prediabets.sections.bookacourse.BookACourse;
	import com.refract.prediabets.sections.feedback.FeedBack;
	import com.refract.prediabets.sections.intro.Intro;
	import com.refract.prediabets.sections.legal.Legal;
	import com.refract.prediabets.sections.social.Share;
	import com.refract.prediabets.stateMachine.SMController;
	import com.refract.prediabets.stateMachine.SMModel;
	import com.refract.prediabets.stateMachine.SMView;
	import com.refract.prediabets.stateMachine.view.StateTxtView;
	import com.refract.prediabets.stateMachine.view.interactions.InteractionChoice;
	import com.refract.prediabets.stateMachine.view.interactions.InteractionQP;
	import com.refract.prediabets.video.VideoLoader;
	/**
	 * @author kanish
	 */
	public class ClassFactory {
		
		public static var APP_CONTROLLER:Class = AppController;
		
		public static var NAV:Class = Nav;
		public static var INTRO:Class = Intro;
		public static var VIDEO_LOADER:Class = VideoLoader;
		public static var LEGAL : Class = Legal;
		public static var FEEDBACK: Class = FeedBack;
		public static var SHARE : Class = Share;		
		public static var BOOK_A_COURSE : Class = BookACourse;
		
		public static var FOOTER : Class = Footer;
		public static var HEADER : Class = Header;
		
		
		//**STATE MACHINE
		public static var INTERACTION_QP : Class = InteractionQP ; 
		public static var INTERACTION_CHOICE : Class = InteractionChoice ; 
		public static var SM_VIEW : Class = SMView ; 
		public static var SM_MODEL : Class = SMModel ; 
		public static var STATE_TXT_VIEW : Class = StateTxtView ;
		public static var SM_CONTROLLER : Class = SMController ; 

	}
}

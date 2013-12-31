package com.refract.prediabets {
	import com.refract.prediabets.components.about.About;
	import com.refract.prediabets.components.bookacourse.BookACourse;
	import com.refract.prediabets.components.credits.Credits;
	import com.refract.prediabets.components.emergencyinfo.EmergencyInfo;
	import com.refract.prediabets.components.emergencyinfo.EmergencyInfoChoking;
	import com.refract.prediabets.components.emergencyinfo.EmergencyInfoCollapsed;
	import com.refract.prediabets.components.emergencyinfo.EmergencyInfoLanding;
	import com.refract.prediabets.components.feedback.FeedBack;
	import com.refract.prediabets.components.gettheapp.GetTheApp;
	import com.refract.prediabets.components.intro.Intro;
	import com.refract.prediabets.components.legal.Legal;
	import com.refract.prediabets.components.login.Login;
	import com.refract.prediabets.components.login.Logout;
	import com.refract.prediabets.components.medicalquestions.MedicalQuestions;
	import com.refract.prediabets.components.nav.Footer;
	import com.refract.prediabets.components.nav.Header;
	import com.refract.prediabets.components.nav.Nav;
	import com.refract.prediabets.components.nav.menu.MenuButton;
	import com.refract.prediabets.components.profile.Profile;
	import com.refract.prediabets.components.profile.ProfileButton;
	import com.refract.prediabets.components.results.Results;
	import com.refract.prediabets.components.sceneselector.SceneSelector;
	import com.refract.prediabets.components.sceneselector.SceneSelectorButton;
	import com.refract.prediabets.components.sceneselector.SceneSelectorQuestions;
	import com.refract.prediabets.components.social.Share;
	import com.refract.prediabets.stateMachine.SMController;
	import com.refract.prediabets.stateMachine.SMModel;
	import com.refract.prediabets.stateMachine.SMView;
	import com.refract.prediabets.stateMachine.view.StateTxtView;
	import com.refract.prediabets.stateMachine.view.interactions.InteractionChoice;
	import com.refract.prediabets.stateMachine.view.interactions.InteractionQP;
	import com.refract.prediabets.user.ModuleModel;
	import com.refract.prediabets.video.VideoLoader;
	/**
	 * @author kanish
	 */
	public class ClassFactory {
		
		public static var APP_CONTROLLER:Class = AppController;
		
		public static var NAV:Class = Nav;
		public static var INTRO:Class = Intro;
		public static var VIDEO_LOADER:Class = VideoLoader;
		public static var SIGN_UP:Class = Login;
		public static var ABOUT:Class = About;
		public static var CREDITS : Class = Credits;
		public static var LEGAL : Class = Legal;
		public static var MEDICAL_QUESTIONS : Class = MedicalQuestions;
		public static var RESULTS : Class  = Results;
		public static var FEEDBACK: Class = FeedBack;
		public static var GET_THE_APP : Class = GetTheApp;
		public static var SHARE : Class = Share;
		public static var SCENE_SELECTOR : Class = SceneSelector;
		public static var SCENE_SELECTOR_QUESTIONS : Class = SceneSelectorQuestions;
		public static var SCENE_SELECTOR_BUTTON : Class = SceneSelectorButton;		
		public static var BOOK_A_COURSE : Class = BookACourse;
		public static var EMERGENCY_INFO : Class = EmergencyInfo;
		public static var EMERGENCY_INFO_LANDING : Class = EmergencyInfoLanding;
		public static var EMERGENCY_INFO_COLLAPSED : Class = EmergencyInfoCollapsed;
		public static var EMERGENCY_INFO_CHOKING : Class = EmergencyInfoChoking;
		public static var LOGIN : Class = Login;
		public static var PROFILE : Class = Profile;
		public static var LOGOUT : Class = Logout;
		
		public static var FOOTER : Class = Footer;
		public static var HEADER : Class = Header;
		
		/*
		 * Modules
		 */
		public static var MODULE_MODEL:Class = ModuleModel;
		public static var MENU_BUTTON:Class = MenuButton;
		public static var PROFILE_BUTTON : Class = ProfileButton;
		
		//**STATE MACHINE
		public static var INTERACTION_QP : Class = InteractionQP ; 
		public static var INTERACTION_CHOICE : Class = InteractionChoice ; 
		public static var SM_VIEW : Class = SMView ; 
		public static var SM_MODEL : Class = SMModel ; 
		public static var STATE_TXT_VIEW : Class = StateTxtView ;
		public static var SM_CONTROLLER : Class = SMController ; 

	}
}

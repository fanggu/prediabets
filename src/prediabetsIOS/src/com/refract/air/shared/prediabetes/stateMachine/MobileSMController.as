package com.refract.air.shared.prediabetes.stateMachine {
	import com.refract.prediabetes.stateMachine.SMController;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.video.VideoLoader;
	import com.robot.comm.DispatchManager;

	import flash.events.Event;
	import flash.events.NetStatusEvent;

	/**
	 * @author robertocascavilla
	 */
	public class MobileSMController extends SMController {
		public function MobileSMController() 
		{
			super();
		}
		
		
		override public function questionSelected( id : int ) : void
		{ 
			super.questionSelected( id ) ;
			DispatchManager.dispatchEvent( new Event( Flags.ADD_LS6_CLOSE_BUTTON ) ) ;   
			DispatchManager.addEventListener( Flags.CLOSE_QUESTIONS, onQuestionsCloseButton);
		}
		override protected function updateState( address : String , cleanUI : Boolean = true) : void
		{
			super.updateState( address , cleanUI ) ;
			if( address == 'LS2_p51')
			{
				SMVars.me.accelerometerAble = true ; 
				SMVars.me.QP_PRE_RUN = false ; 
			}
		}
		
		/*
		override protected function setVideoBack() : void
		{
			Logger.log(Logger.STATE_MACHINE,"CALLING SET VIDEO BACK")
			//DispatchManager.dispatchEvent( new Event( Flags.UPDATE_CUT_BLACK_SUPER_LONG ) ) ; 
			VideoLoader.i.setBlackOn() ; 
			super.setVideoBack();
			DispatchManager.dispatchEvent( new Event( Flags.UPDATE_CUT_BLACK_SUPER_LONG ) ) ; 
		}
		 * 
		 */
		private function onQuestionsCloseButton( evt : Event ) : void
		{
			if( VideoLoader.i ) VideoLoader.i.resetURL() ;
			DispatchManager.removeEventListener( Flags.CLOSE_QUESTIONS, onQuestionsCloseButton);
			DispatchManager.removeEventListener( Event.ENTER_FRAME , scheduler) ;
		    DispatchManager.removeEventListener( NetStatusEvent.NET_STATUS,onNetStatus);
			updateState( "menu") ;
						
		}
	}
}

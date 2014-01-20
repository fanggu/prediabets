package com.refract.air.shared.prediabetes.stateMachine {
	import com.refract.prediabetes.stateMachine.SMController;

	/**
	 * @author robertocascavilla
	 */
	public class MobileSMController extends SMController {
		public function MobileSMController() 
		{
			super();
		}
		
		override protected function updateState( address : String , cleanUI : Boolean = true) : void
		{
			super.updateState( address , cleanUI ) ;
		}
	}
}

package com.refract.air.shared.lifesaver.stateMachine.view.interactions {
	import com.refract.prediabets.stateMachine.view.interactions.InteractionChoice;
	/**
	 * @author kanish
	 */
	public class MobileInteractionChoice extends InteractionChoice {
		public function MobileInteractionChoice(interactionObject : Object) {
			super(interactionObject);
			_nameStyleChoice.fontSize = 20;
			_nameStyleChoiceTarget.fontSize = 20;
			_nameStyleChoiceImage.fontSize = 16;
		}
	}
}

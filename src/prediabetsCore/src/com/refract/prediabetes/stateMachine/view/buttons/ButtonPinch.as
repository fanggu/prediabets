package com.refract.prediabetes.stateMachine.view.buttons {
	import com.robot.comm.DispatchManager;

	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author robertocascavilla
	 */
	public class ButtonPinch extends Button 
	{
		public var buttonFriend : ButtonPinch;
		public var centerPoint : Point  ; 
		private var _offsetX : Number ;
		private var _offsetY : Number ; 
		public var iter : int ; 
		public function ButtonPinch() 
		{
//			_offsetX = Math.abs() 
		}
		public function activate() : void
		{
			DispatchManager.addEventListener( Event.ENTER_FRAME , run ) ; 	
		}
		override public function deActivate() : void
		{
			DispatchManager.removeEventListener( Event.ENTER_FRAME , run ) ;
		}
		
		private function run( evt : Event ) : void
		{
			buttonFriend.x = (centerPoint.x - x) + centerPoint.x  ; 
			buttonFriend.y = (centerPoint.y - y) + centerPoint.y  ; 
		}
	}
}

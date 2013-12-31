package com.refract.prediabets.components.sceneselector {
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.ClassFactory;
	import com.refract.prediabets.components.events.SceneSelectorEvent;
	import com.refract.prediabets.stateMachine.SMController;
	import com.refract.prediabets.user.UserModel;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @author kanish
	 */
	public class SceneSelector extends Sprite {
		private var _story:int;
		
		public function SceneSelector() {
			_story = AppController.i.nextStory;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var tempDict : Dictionary = SMController.me.model.statesActivatedDict ;
			
			var btn:SceneSelectorButton;
			for (var i:int= 0; i < 4; ++i){
				for(var j:int = 0; j< 4; ++j){
					addChild(btn = new ClassFactory.SCENE_SELECTOR_BUTTON(4*i+j,true));
					
					
					var address : String = SMController.me.model.sceneSelect[ btn.id] ;
					if( tempDict[address] || UserModel.getModuleStats(_story).isComplete)
					{
						btn.addEventListener(MouseEvent.CLICK, onButtonClick);
					}
					else
					{
						btn.deActivate() ;	
					}
				}
			}
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		
		private function onButtonClick(evt:MouseEvent):void{
			var id:int = SceneSelectorButton(evt.currentTarget).id;
			DispatchManager.dispatchEvent(new SceneSelectorEvent(SceneSelectorEvent.BUTTON_SELECTED,id));
		}

		private function onResize(evt : Event = null) : void {
			x = AppSettings.VIDEO_LEFT;
			y = AppSettings.VIDEO_TOP;
		}
		
		
		
		public function destroy() : void {
			var chillens:int = numChildren;
			var btn:SceneSelectorButton;
			for(var i:int = 0; i < chillens; ++i){
				btn = SceneSelectorButton(getChildAt(0));
				btn.removeEventListener(MouseEvent.CLICK, onButtonClick);
				btn.destroy();
				removeChildAt(0);
			}
		}
	}
}

package com.utils {
	import flash.display.*;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	//import flash.utils.flash_proxy;
	
	/**
	 * The KeyObject class recreates functionality of
	 * Key.isDown of ActionScript 1 and 2
	 *
	 * Usage:
	 * var key:KeyObject = new KeyObject(stage);
	 * if (key.isDown(key.LEFT)) { ... }
	 */
	dynamic public class KeyObject{// extends Proxy {
		
		private static var stage:Stage;
		private static var keysDown:Object;
		
		private var _anyResidentObject:DisplayObject ;
		
		private var keyCodeReleased:uint ; 
		
		public function KeyObject( anyResidentObject:DisplayObject) {
			construct( anyResidentObject );
		}
		
		public function construct( anyResidentObject:DisplayObject ):void {
			keysDown = new Object();
			_anyResidentObject = anyResidentObject ; 
			anyResidentObject.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			anyResidentObject.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		/*
		flash_proxy override function getProperty(name:*):* {
			return (name in Keyboard) ? Keyboard[name] : -1;
		}
		*/
		public function isDown(keyCode:uint):Boolean {
			return Boolean(keyCode in keysDown);
		}
		public function isUp(keyCode:uint):Boolean {
			var returnValue:Boolean = Boolean(keyCode == keyCodeReleased);
			keyCodeReleased = 0 ; 
			return returnValue;
		}
		
		public function deconstruct():void {
			_anyResidentObject.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			_anyResidentObject.stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			keysDown = new Object();
		}
		
		private function keyPressed(evt:KeyboardEvent):void {
			keysDown[evt.keyCode] = true;
		}
		
		private function keyReleased(evt:KeyboardEvent):void 
		{
			keyCodeReleased = evt.keyCode ; 
			delete keysDown[evt.keyCode];
		}
	}
}
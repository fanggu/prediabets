package com.refract.air.shared.components.nav.sidemenu {
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.refract.prediabets.AppSections;
	import com.refract.prediabets.components.events.FooterEvent;
	import com.refract.prediabets.components.events.MenuEvent;
	import com.refract.prediabets.components.nav.Header;
	import com.refract.prediabets.components.shared.LSButton;
	import com.refract.prediabets.stateMachine.events.StateEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.refract.prediabets.video.VideoLoader;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * @author kanish
	 */
	public class SideMenu extends Sprite {
		
		public static const SHOW_TIME:Number = 0.2;
		
		public function get shown():Boolean {return _shown;}
		private var _shown:Boolean = false;
		
		private var _bodyContainer:Sprite;
		
		private var _bodyWidth:Number;
		private var _bodyHeight:Number;
		
		private var _buttons:Array;
		
		public function SideMenu(){
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_bodyWidth =  stage.stageWidth >> 1;
			_bodyHeight = 80;
			
			_buttons = [];
			
			_bodyContainer = new Sprite();
			addChild(_bodyContainer);
			
			addEvents();
			
			addContent();
			
			drawBkgLayer();
			
		}
		
		private function addContent():void{
			
			var style:Object = {fontSize:32,align:"left"};
			
			var lastButton:SideMenuButton;
			
			var lsButton:SideMenuButton = new SideMenuButton("footer_00_lslogo",style,_bodyWidth,_bodyHeight+10);
			lsButton.buttonAlpha = 0;
			_bodyContainer.addChild(lsButton);
			lsButton.id = Header.LS_LOGO;
			_buttons[lsButton.id] = lsButton;
			lastButton = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK,onButtonClick);
			
			style.fontSize = 20;
			
			lsButton = new SideMenuButton("footer_11_profile",style,_bodyWidth,_bodyHeight);
			_bodyContainer.addChild(lsButton);
			lsButton.id = AppSections.PROFILE;
			_buttons[lsButton.id] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK,onButtonClick);
			lsButton.y = lastButton.y + lastButton.height;
			lastButton = lsButton;
			
			/* BREAK */
			
			lsButton = new SideMenuButton("footer_01_med_questions",style,_bodyWidth,_bodyHeight);
			_bodyContainer.addChild(lsButton);
			lsButton.id = AppSections.MEDICAL_QUESTIONS;
			_buttons[lsButton.id] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK,onButtonClick);
			lsButton.y = lastButton.y + lastButton.height*2;
			lastButton = lsButton;
			
			lsButton = new SideMenuButton("footer_02_emergency_info",style,_bodyWidth,_bodyHeight);
			_bodyContainer.addChild(lsButton);
			lsButton.id = AppSections.EMERGENCY_INFO;
			_buttons[lsButton.id] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK,onButtonClick);
			lsButton.y = lastButton.y + lastButton.height;
			lastButton = lsButton;
			
			lsButton = new SideMenuButton("footer_03_book_a_course",style,_bodyWidth,_bodyHeight);
			_bodyContainer.addChild(lsButton);
			lsButton.id = AppSections.BOOK_A_COURSE;
			_buttons[lsButton.id] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK,onButtonClick);
			lsButton.y = lastButton.y + lastButton.height;
			lastButton = lsButton;
			
			lsButton = new SideMenuButton("footer_12_feedback",style,_bodyWidth,_bodyHeight);
			_bodyContainer.addChild(lsButton);
			lsButton.id = AppSections.FEEDBACK;
			_buttons[lsButton.id] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK,onButtonClick);
			lsButton.y = lastButton.y + lastButton.height;
			lastButton = lsButton;
			
			/* BREAK */
			
			lsButton = new SideMenuButton("footer_05_about",style,_bodyWidth,_bodyHeight);
			_bodyContainer.addChild(lsButton);
			lsButton.id = AppSections.ABOUT;
			_buttons[lsButton.id] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK,onButtonClick);
			lsButton.y = lastButton.y + lastButton.height*2;
			lastButton = lsButton;
			
			lsButton = new SideMenuButton("footer_06_credits",style,_bodyWidth,_bodyHeight);
			_bodyContainer.addChild(lsButton);
			lsButton.id = AppSections.CREDITS;
			_buttons[lsButton.id] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK,onButtonClick);
			lsButton.y = lastButton.y + lastButton.height;
			lastButton = lsButton;
			
			lsButton = new SideMenuButton("footer_08_legal",style,_bodyWidth,_bodyHeight);
			_bodyContainer.addChild(lsButton);
			lsButton.id = AppSections.LEGAL;
			_buttons[lsButton.id] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK,onButtonClick);
			lsButton.y = lastButton.y + lastButton.height;
			lastButton = lsButton;
			
			lsButton = new SideMenuButton("footer_09_share",style,_bodyWidth,_bodyHeight);
			_bodyContainer.addChild(lsButton);
			lsButton.id = AppSections.SHARE;
			_buttons[lsButton.id] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK,onButtonClick);
			lsButton.y = lastButton.y + lastButton.height;
			lastButton = lsButton;
		}
		
		private function onButtonClick(evt:MouseEvent):void{
			if(_didSwipe){
				_didSwipe = false;
				clearTimeout(_didSwipeTimeout);
			}else{
				var thisGuy:String = (evt.currentTarget as LSButton).id;
				DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.FOOTER_CLICKED,{value:thisGuy}));
				hide();
			}
		}
		
		private function drawBkgLayer():void{
			_bodyContainer.graphics.beginFill(0x222222,1);
			_bodyContainer.graphics.drawRect(0, 0, _bodyWidth, _bodyContainer.height);
			_bodyContainer.x = -_bodyContainer.width;
		}
		
		private function addEvents():void{
			stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
		}
		
		
		private var _didSwipe:Boolean = false;
		private var _didSwipeTimeout:uint;
		
		private function onSwipe(evt:TransformGestureEvent):void{
		//	Logger.general(this,evt.localX);
			_didSwipe = true;
			if(evt.offsetX == 1 && !shown && evt.stageX < 50){//swipe left to right when hidden
				show();
			}else if (evt.offsetX == -1 && shown){//swipe right to left when shown
				evt.stopImmediatePropagation();
				hide();
			}else if(evt.offsetY == 1 && shown){ //swipe top to bottom when shown
				pageDown();
			}else if(evt.offsetY == -1 && shown){//swipe bottom to top when shown
				pageUp();
			}
			// if shown don't let the event propogate to other listeners
			// (eg to stop a scroll pane behind the menu from scrolling
			// when the menu is being interacted with
			if(shown){ 
				evt.stopImmediatePropagation();
			}
			_didSwipeTimeout = setTimeout(resetDidSwipe, 500);
		}
		
		private function resetDidSwipe():void{
			_didSwipe = false;
		}
		
		private function onClick(evt:MouseEvent):void{
			if(_shown){
				if(evt.stageX > _bodyContainer.width){
					hide();
					evt.stopImmediatePropagation();
				}
			}
		}
		
		
		public function hide():void{
			if(_shown){
				_shown = false;
			//	VideoLoader.i.activateClickPause();
				stage.removeEventListener(MouseEvent.CLICK,onClick);
			//	DispatchManager.dispatchEvent(new Event(MenuEvent.MENU_HIDE));
				dispatchEvent(new Event(MenuEvent.MENU_HIDE));
				DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndMenuDown") );	
				TweenMax.killTweensOf(_bodyContainer);
				TweenMax.to(_bodyContainer,SHOW_TIME,{x:-_bodyContainer.width,onComplete:VideoLoader.i.activateClickPause});
			}
		}
		
		public function show():void{
			if(!_shown){
				_shown = true;
				for(var i:int = 0; i < _bodyContainer.numChildren ; ++i){
					(_bodyContainer.getChildAt(i) as SideMenuButton).removeTint();
				}
				VideoLoader.i.deactivateClickPause();
			//	DispatchManager.dispatchEvent(new Event(MenuEvent.MENU_SHOW));
				dispatchEvent(new Event(MenuEvent.MENU_SHOW));
				DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndMenuUp") );	
				TweenMax.killTweensOf(_bodyContainer);
				_bodyContainer.y = _bodyContainer.y > 0 ? 
										0 
										: _bodyContainer.y < -(_bodyContainer.height - stage.stageHeight) ? 
												-(_bodyContainer.height - stage.stageHeight) 
												: _bodyContainer.y;
				TweenMax.to(_bodyContainer,SHOW_TIME,{x:0,onComplete:stage.addEventListener,onCompleteParams:[MouseEvent.CLICK,onClick]});
			}
		}
		
		private function pageUp():void{
			//flash rounds height to 1dp, so overscroll doesn't work without - 1
			if(_bodyContainer.y -1 > - (_bodyContainer.height - stage.stageHeight)){
				if(_bodyContainer.y - stage.stageHeight < - (_bodyContainer.height - stage.stageHeight)){
					TweenMax.to(_bodyContainer,0.5,{y: -(_bodyContainer.height - stage.stageHeight), ease:Back.easeOut});
				}else{
					TweenMax.to(_bodyContainer,0.5,{y: _bodyContainer.y - stage.stageHeight});
				}
			}else{
				_bodyContainer.y = -(_bodyContainer.height - stage.stageHeight);
				TweenMax.to( _bodyContainer, 0.2,{y: _bodyContainer.y  - stage.stageHeight/8, repeat:1,yoyo:true});
			}
		}
		
		private function pageDown():void{
			if(_bodyContainer.y < 0){
				if(_bodyContainer.y + stage.stageHeight > 0){
					TweenMax.to(_bodyContainer,0.5,{y: 0, ease:Back.easeOut});
				}else{
					TweenMax.to(_bodyContainer,0.5,{y: _bodyContainer.y + stage.stageHeight});
				}
			}else{
				_bodyContainer.y = 0;
				TweenMax.to( _bodyContainer, 0.2,{y: stage.stageHeight/8, repeat:1,yoyo:true});
			}
		}
		
	}
}

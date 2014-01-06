package com.refract.prediabetes.nav {
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.refract.prediabetes.AppSections;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.nav.events.FooterEvent;
	import com.refract.prediabetes.nav.footer.FullScreenButton;
	import com.refract.prediabetes.nav.footer.PlayPauseButton;
	import com.refract.prediabetes.nav.footer.SoundButton;
	import com.refract.prediabetes.sections.utils.LSButton;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author kanish
	 */
	public class Footer extends Sprite {
		
		//Middle
		public static const PLAY_PAUSE:String = "PLAY_PAUSE";
		
		public static const SOUND:String = "SOUND";
		public static const FULL_SCREEN:String = "FULL_SCREEN";
		
		public static const BACK_TO_VIDEO : String = "BACK_TO_VIDEO";
		public static const MENU : String = "MENU";
		
		protected var _buttonSpace:int = 12;
		protected var _buttonY:int = 12;
		
		protected var _leftSide:Sprite;
		protected var _rightSide:Sprite;
		protected var _center:Sprite;
		protected var _topMiddle : Sprite ; 
		
		protected var _footerButtons:Array;
		
		protected var _protectedButtons:Array = [PLAY_PAUSE, SOUND, FULL_SCREEN, BACK_TO_VIDEO, MENU];
		
		protected var _progressBar:Sprite;
		public function get progressBar():Sprite { return _progressBar; } 
		
		public function Footer() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_buttonSpace = AppSettings.PLATFORM == AppSettings.PLATFORM_PC ? _buttonSpace : 0;//AppSettings.FONT_SCALE_FACTOR*_buttonSpace;
			_buttonY = AppSettings.FONT_SCALE_FACTOR*_buttonY;
			
			_footerButtons = [];
			
			addLeftSide();
			addRightSide();
			addCenter();
			
			_progressBar = new Sprite();
			addChild(_progressBar);
				
			stage.addEventListener(Event.RESIZE,onResize);
			DispatchManager.addEventListener(FooterEvent.FLASH_FOOTER, onFlashFooter);
			DispatchManager.addEventListener(FooterEvent.ADD_FOOTER_ITEM, addFooterItem);
			DispatchManager.addEventListener(FooterEvent.REMOVE_FOOTER_ITEM, removeFooterItem);
			DispatchManager.addEventListener(FooterEvent.HIGHLIGHT_BUTTON, highlightFooterButton);
			DispatchManager.addEventListener(Flags.SHOW_FOOTER_PLAY_PAUSE, togglePauseShown);
			DispatchManager.addEventListener(Flags.HIDE_FOOTER_PLAY_PAUSE, togglePauseShown);
			
			onResize();
		}
		
		protected function togglePauseShown(evt:Event):void{
			switch(evt.type){
				case(Flags.SHOW_FOOTER_PLAY_PAUSE):
					TweenMax.to(_footerButtons[PLAY_PAUSE],0.5,{autoAlpha:1});
				break;
				default:
					TweenMax.to(_footerButtons[PLAY_PAUSE],0.5,{autoAlpha:0});
			}
		}
		
		
		protected function highlightFooterButton(evt:FooterEvent):void{
			var id:String = evt.info.buttonID;
			for(var s:String in _footerButtons){
				TweenMax.to(_footerButtons[s],0.5,{tint:null});
			}
			if(_footerButtons[id]){
				TweenMax.to(_footerButtons[id],0.5,{tint:AppSettings.WHITE});
			}
		}
		
		
		
	/*	protected function onMouseMove(evt:MouseEvent):void{
			TweenMax.killTweensOf(_leftSide);
			TweenMax.to(_leftSide,_footerFadeOutTime,{autoAlpha:0,delay:_footerFadeDelay,onStart:hideAllBtns});
		} */
		
		public function hideAllBtns(_footerFadeOutTime:Number = 2):void{
		//	this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverForAutoHide);
		//	TweenMax.killTweensOf(_leftSide);
			for(var i:int = 0, len:int = _leftSide.numChildren; i < len ; ++i){
				if(_protectedButtons.indexOf(_leftSide.getChildAt(i)["id"]) == -1){
					TweenMax.killTweensOf(_leftSide.getChildAt(i));
					TweenMax.to(_leftSide.getChildAt(i),_footerFadeOutTime,{autoAlpha: 0});	
				}
			}
			for(i = 0, len = _rightSide.numChildren; i < len; ++i){
				if(_protectedButtons.indexOf(_rightSide.getChildAt(i)["id"]) == -1){
					TweenMax.killTweensOf(_rightSide.getChildAt(i));
					TweenMax.to(_rightSide.getChildAt(i),_footerFadeOutTime,{autoAlpha: 0});	
				}
			}
			for(i = 0, len = _center.numChildren; i < len; ++i){
				if(_center.getChildAt(i).hasOwnProperty("id") && _protectedButtons.indexOf(_center.getChildAt(i)["id"]) == -1){
					TweenMax.killTweensOf(_center.getChildAt(i));
					TweenMax.to(_center.getChildAt(i),_footerFadeOutTime,{autoAlpha: 0});	
				}
			}
		}
		
		public function showAllBtns(_footerFadeInTime:Number = 0.5):void{
		//	this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverForAutoHide);
		//	this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOutForAutoHide);
		//	TweenMax.to(_leftSide,_footerFadeInTime,{autoAlpha:1});
		
			for(var i:int = 0, len:int = _leftSide.numChildren; i < len ; ++i){
				if(_protectedButtons.indexOf(_leftSide.getChildAt(i)["id"]) == -1){
					TweenMax.killTweensOf(_leftSide.getChildAt(i));
					TweenMax.to(_leftSide.getChildAt(i),_footerFadeInTime,{autoAlpha: 1});	
				}
			}
			for(i = 0, len = _rightSide.numChildren; i < len; ++i){
				if(_protectedButtons.indexOf(_rightSide.getChildAt(i)["id"]) == -1){
					TweenMax.killTweensOf(_rightSide.getChildAt(i));
					TweenMax.to(_rightSide.getChildAt(i),_footerFadeInTime,{autoAlpha: 1});	
				}
			}
			for(i = 0, len = _center.numChildren; i < len; ++i){
				if(_center.getChildAt(i).hasOwnProperty("id") && _protectedButtons.indexOf(_center.getChildAt(i)["id"]) == -1){
					TweenMax.killTweensOf(_center.getChildAt(i));
					TweenMax.to(_center.getChildAt(i),_footerFadeInTime,{autoAlpha: 1});	
				}
			}
		}
		/*
		protected function onMouseOutForAutoHide(evt:MouseEvent = null):void{
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutForAutoHide);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverForAutoHide);
			startShowHandler();
		}
		*/
		
		
		protected function addFooterItem(evt:FooterEvent):void{
			switch(evt.info.position){
				
				case(FooterEvent.BOTTOM_LEFT):
					break;
				case(FooterEvent.BOTTOM_MIDDLE):
					_center.addChild(evt.info.button as DisplayObject);
					evt.info.button.x = -evt.info.button.width/2;
					evt.info.button.y = _buttonY;
	//				evt.info.button.scaleX = 40;
//					evt.info.button.scaleY = 40;
					break;
				case(FooterEvent.BOTTOM_RIGHT):
					break;
				case(FooterEvent.TOP_MIDDLE):
					
					_topMiddle.addChild(evt.info.button as DisplayObject);
					evt.info.button.x = -evt.info.button.width/2;
					
					break;
				default:
			}
			onResize();
		}
		
		protected function removeFooterItem(evt:FooterEvent):void{
			switch(evt.info.position){
				case(FooterEvent.BOTTOM_LEFT):
					break;
				case(FooterEvent.BOTTOM_MIDDLE):
					if(_center.contains(evt.info.button)) _center.removeChild(evt.info.button);
					break;
				case(FooterEvent.BOTTOM_RIGHT):
					break;
				case(FooterEvent.TOP_MIDDLE):
					
					var disObj : DisplayObject = evt.info.button as DisplayObject ;
					if( disObj)
						if( disObj.parent)
							disObj.parent.removeChild( disObj) ;
					
					break;
				default:
			}
			onResize();
		}
		
		protected function onResize(evt:Event = null) : void {
			graphics.clear();
			graphics.beginFill(0x000000,1);
			graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight - AppSettings.VIDEO_BOTTOM);
			_center.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;// - _center.width/2;
			if(AppSettings.VIDEO_IS_STAGE_WIDTH){
				this.y = AppSettings.VIDEO_BOTTOM;//stage.stageHeight/2 + AppSettings.VIDEO_HEIGHT/2;
				_leftSide.x = _progressBar.x = 0;
				_rightSide.x = stage.stageWidth - _rightSide.width - 15;
			}else{
				this.y = stage.stageHeight - AppSettings.RESERVED_FOOTER_HEIGHT;
				_leftSide.x =  _progressBar.x = stage.stageWidth/2 - AppSettings.VIDEO_WIDTH/2;
				_rightSide.x = stage.stageWidth/2 + AppSettings.VIDEO_WIDTH/2 - _rightSide.width - 30;
			}
			_topMiddle.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;// - _center.width/2;
			_topMiddle.y = -AppSettings.VIDEO_HEIGHT - 25 ;
		}
		
		protected function onFlashFooter(evt:FooterEvent):void{
			var target:String = evt.info.target;
			if(_footerButtons[target]){
				TweenMax.to(_footerButtons[target],3,{repeat:1,yoyo:true,tint:0xffffff,ease:Quint.easeOut});
			}
		}
		
		protected function addLeftSide():void{
			_leftSide = new Sprite();
			addChild(_leftSide);
			
			var lastButton:Sprite;
			var lsButton:LSButton;
			var style:Object = {fontSize:AppSettings.FOOTER_FONT_SIZE,align:"left"};
			
			
			lsButton = new LSButton("footer_menu",style);
			_leftSide.addChild(lsButton);
			lsButton.x = 20;
			lsButton.y = _buttonY;
			_footerButtons[MENU] = lsButton;
			lsButton.id = MENU;
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
			
			lsButton = new LSButton("footer_01_med_questions",style);
			_leftSide.addChild(lsButton);
		//	lsButton.x = 20;
			lsButton.x = lastButton.x + lastButton.width + _buttonSpace;
			lsButton.y = _buttonY;
			
			
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
			
			
			lsButton = new LSButton("footer_02_emergency_info",style);
			_leftSide.addChild(lsButton);
			lsButton.x = lastButton.x + lastButton.width + _buttonSpace;
			lsButton.y = _buttonY;
			
			
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
			
			lsButton = new LSButton("footer_03_book_a_course",style);
			_leftSide.addChild(lsButton);
			lsButton.x = lastButton.x + lastButton.width + _buttonSpace;
			lsButton.y = _buttonY;
			lsButton.id = AppSections.BOOK_A_COURSE;
			_footerButtons[AppSections.BOOK_A_COURSE] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
			
			lsButton = new LSButton("footer_12_feedback",style);
			_leftSide.addChild(lsButton);
			lsButton.x = lastButton.x + lastButton.width + _buttonSpace;
			lsButton.y = _buttonY;
			lsButton.id = AppSections.FEEDBACK;
			_footerButtons[AppSections.FEEDBACK] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
			
		}
		protected function addRightSide():void{
			_rightSide = new Sprite();
			addChild(_rightSide);
			var lastButton:Sprite;
			
			var style:Object = {};
			style.fontSize = AppSettings.FOOTER_FONT_SIZE;
			style.align = "left";
			/*
			var lsButton:LSButton = new LSButton("footer_04_get_the_app",style);
			_rightSide.addChild(lsButton);
		//	lsButton.x = - 90; // - lsButton.width;
			lsButton.y = _buttonY;
			lsButton.id = GET_THE_APP;
			_footerButtons[GET_THE_APP] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
			
			lsButton = new LSButton("footer_05_about",style);
			_rightSide.addChild(lsButton);
			lsButton.x = lastButton.x + lastButton.width + _buttonSpace;
			lsButton.y = _buttonY;
			lsButton.id = ABOUT;
			_footerButtons[ABOUT] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
			*/
			
			var lsButton:LSButton;
			
			if(AppSettings.DEVICE != AppSettings.DEVICE_PC){
				lastButton = _footerButtons[AppSections.FEEDBACK];
				_rightSide.addChild(lastButton);
				lastButton.x = 0;
			}else if(AppSettings.ITUNES_LINK != "" || AppSettings.PLAY_LINK != "" || AppSettings.ITUNES_TAB_LINK != "" || AppSettings.PLAY_TAB_LINK != ""){
				lsButton = new LSButton("footer_04_get_the_app",style);
				_rightSide.addChild(lsButton);
				lsButton.x = lastButton ? lastButton.x + lastButton.width + _buttonSpace : 0;
				lsButton.y = _buttonY;
				
				_footerButtons[lsButton.id] = lsButton;
				lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
				lastButton = lsButton;
			}
			
			lsButton = new LSButton("footer_05_about",style);
			_rightSide.addChild(lsButton);
			lsButton.x = lastButton ? lastButton.x + lastButton.width + _buttonSpace : 0;
			lsButton.y = _buttonY;
			
			
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
			
			lsButton = new LSButton("footer_06_credits",style);
			_rightSide.addChild(lsButton);
			lsButton.x = lastButton.x + lastButton.width + _buttonSpace;
			lsButton.y = _buttonY;
			
			
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
			
			
			lsButton = new LSButton("footer_08_legal",style);
			_rightSide.addChild(lsButton);
			lsButton.x = lastButton.x + lastButton.width + _buttonSpace;
			lsButton.y = _buttonY;
			lsButton.id = AppSections.LEGAL;
			_footerButtons[AppSections.LEGAL] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
			
			lsButton = new LSButton("footer_09_share",style);
			_rightSide.addChild(lsButton);
			lsButton.x = lastButton.x + lastButton.width + _buttonSpace;
			lsButton.y = _buttonY;
			lsButton.id = AppSections.SHARE;
			_footerButtons[AppSections.SHARE] = lsButton;
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
			
			if(AppSettings.DEVICE == AppSettings.DEVICE_PC){
				var snd:SoundButton = new SoundButton();
				_rightSide.addChild(snd);
				snd.x = lastButton.x + lastButton.width + _buttonSpace;
				snd.y = _buttonY + 6;
				snd.id = SOUND;
				_footerButtons[SOUND] = snd;
				lastButton = snd;
				
				var fsb:FullScreenButton = new FullScreenButton();
				_rightSide.addChild(fsb);
				fsb.x = lastButton.x + lastButton.width + _buttonSpace;
				fsb.y = _buttonY + 4;
				fsb.id = FULL_SCREEN;
				_footerButtons[FULL_SCREEN] = fsb;
				lastButton = fsb;
			}else{
				//dispatch to add share to header
				DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.ADD_FOOTER_ITEM,{position:FooterEvent.TOP_RIGHT,button:_footerButtons[AppSections.SHARE]}));
			}
			
		}
		
		protected function addCenter():void{
			_center = new Sprite();
			addChild(_center);
			
			_topMiddle = new Sprite() ;
			addChild( _topMiddle );
			
			var ppb:PlayPauseButton = new PlayPauseButton();
			_center.addChild(ppb);
			ppb.x = -ppb.width/2;
			ppb.y = _buttonY + 2;
			ppb.id = PLAY_PAUSE;
			_footerButtons[PLAY_PAUSE] = ppb;
			ppb.alpha = 0;
			ppb.visible = false;
			
			
		}
		
		/*
		 * 
		 * CLICKS
		 * 
		 */
		 
		
		protected function footerButtonClick(evt:MouseEvent):void{
			var thisGuy:String = (evt.currentTarget as LSButton).id;
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.FOOTER_CLICKED ,{value:thisGuy}));
		}
		
		
		public function destroy():void{
			removeChildren();
			stage.removeEventListener(Event.RESIZE, onResize);
			_leftSide = null;
			_rightSide = null;
			_center = null;
		}
		
	}
}

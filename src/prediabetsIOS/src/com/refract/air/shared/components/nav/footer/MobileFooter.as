package com.refract.air.shared.components.nav.footer {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.nav.Footer;
	import com.refract.prediabets.nav.events.FooterEvent;
	import com.refract.prediabets.sections.utils.LSButton;
	import com.refract.prediabets.stateMachine.events.ObjectEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author kanish
	 */
	public class MobileFooter extends Footer {
		
		public static const FILMS:String = "FILMS";
		
		
		private var _scoreBar : HeaderScoreBar;
		private var _scoreVisible:Boolean = false;
		
		public function MobileFooter() {
			super();
		}
		
		override protected function init(evt:Event):void{
			_buttonY = 0;
			super.init(evt);
			
			
			DispatchManager.addEventListener(UserModel.MODULE_STATS_UPDATED, onSMEvent);
			DispatchManager.addEventListener(Flags.STATE_MACHINE_START, onSMEvent);
			DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onSMEvent);
			DispatchManager.addEventListener(Flags.SM_RESET, onSMEvent);
			DispatchManager.addEventListener(Flags.SM_ACTIVE, onSMEvent);
			DispatchManager.addEventListener(Flags.SM_NOT_ACTIVE, onSMEvent);
		}
		
		override protected function onResize(evt:Event = null) : void {
			super.onResize(evt);
			
			graphics.clear();
			graphics.beginFill(0x000000,1);
			graphics.drawRect(0,0,stage.stageWidth,AppSettings.RESERVED_FOOTER_HEIGHT);
			
			this.y = stage.stageHeight - AppSettings.RESERVED_FOOTER_HEIGHT;// - this.height;
			_rightSide.x = AppSettings.VIDEO_RIGHT - _rightSide.width;
			
			_topMiddle.y = 0;
			_topMiddle.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2;// - _center.width/2;
		}
		
		override protected function addFooterItem(evt:FooterEvent):void{
			super.addFooterItem(evt);
			if(evt.info.position == FooterEvent.BOTTOM_MIDDLE && _scoreBar.visible){
				_scoreBar.visible = false;	
			}
			
		}
		
		override protected function removeFooterItem(evt:FooterEvent):void{
			super.removeFooterItem(evt);
			if(_scoreVisible && evt.info.position == FooterEvent.BOTTOM_MIDDLE && ! AppController.i.nav.overlayShown){
				_scoreBar.visible = true;	
			}
		}
		
		override protected function addLeftSide():void{
			_leftSide = new Sprite();
			addChild(_leftSide);
			
			var lastButton:Sprite;
			var lsButton:LSButton;
			var style:Object = {fontSize:AppSettings.FOOTER_FONT_SIZE,align:"left"};
			
			lsButton = new LSButton("footer_menu",style,0,0,true);
			lsButton.arrowAsset = "MenuIcon";
			_leftSide.addChild(lsButton);
			_footerButtons[MENU] = lsButton;
			lsButton.id = MENU;
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
		}
		
		override protected function addRightSide():void{
			_rightSide = new Sprite();
			addChild(_rightSide);
			var lastButton:Sprite;
			var lsButton:LSButton;
			var style:Object = {fontSize:AppSettings.FOOTER_FONT_SIZE,align:"left"};
			
			lsButton = new LSButton("footer_films",style,0,0,true);
			lsButton.arrowAsset = "FilmsIcon";
			_rightSide.addChild(lsButton);
			_footerButtons[FILMS] = lsButton;
			lsButton.id = FILMS;
			lsButton.addEventListener(MouseEvent.CLICK, footerButtonClick);
			lastButton = lsButton;
		}
		
		override protected function addCenter():void{
			_center = new Sprite();
			addChild(_center);
			
			
			_scoreBar = new HeaderScoreBar(_buttonY);
			_scoreBar.visible = false;
			_scoreBar.alpha = 0;
			_center.addChild(_scoreBar);
			_scoreBar.x = -_scoreBar.width >> 1;
			
			
			_topMiddle = new Sprite() ;
			addChild( _topMiddle );
		}
		
		public function hideCenter():void{
			_center.visible = false;
			_topMiddle.visible = false;
		}
		
		public function showCenter():void{
			_center.visible = true;
			_topMiddle.visible = true;
		}
		
		
		private function onSMEvent(evt:Event):void{
			switch(evt.type){
				case(Flags.STATE_MACHINE_START):
					_scoreBar.reset();
					break;
				case(UserModel.MODULE_STATS_UPDATED):
					TweenMax.to(_scoreBar,0.5,{autoAlpha:1});
					_scoreBar.setScore(ObjectEvent(evt).object.module as ModuleModel);	
					_scoreVisible = true;
					break;
				case(Flags.SM_RESET):
				case(Flags.STATE_MACHINE_END):
				case(Flags.SM_ACTIVE):	
				default:
					TweenMax.to(_scoreBar,0.5,{autoAlpha:0});
					_scoreVisible =false;
			}
		}
		
		
		override public function hideAllBtns(_footerFadeOutTime:Number = 2):void{}
		override public function showAllBtns(_footerFadeInTime:Number = 0.5):void{}
		override protected function togglePauseShown(evt:Event):void{}
	}
}

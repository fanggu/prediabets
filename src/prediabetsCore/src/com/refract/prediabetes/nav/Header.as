package com.refract.prediabetes.nav 
{
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.nav.events.FooterEvent;
	import com.refract.prediabetes.sections.utils.LSButton;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;


	public class Header extends Sprite 
	{
		public static const LS_LOGO:String = "LS_LOGO";
		public static const PROGRESS:String = "PROGRESS";
		
		protected const _buttonSpace:int = 12;
		protected const _buttonY:int = 14;
		protected var _headerButtons:Array;
		
		private var _leftSide:Sprite;
		private var _middle:Sprite;
		
		protected var _rightSide:Sprite;
		protected var _textStyle : Object = {fontSize:13, align:"left"};
		
		public function Header() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_headerButtons = [];
			
			_textStyle.fontSize = AppSettings.FOOTER_FONT_SIZE;
			
			addLeftSide();
			addMiddle();
			addRightSide();
			
			DispatchManager.addEventListener(Flags.STATE_MACHINE_START, onSMEvent);
			DispatchManager.addEventListener(Flags.STATE_MACHINE_END, onSMEvent);
			DispatchManager.addEventListener(Flags.SM_RESET, onSMEvent);
			DispatchManager.addEventListener(Flags.SM_ACTIVE, onSMEvent);
			DispatchManager.addEventListener(Flags.SM_NOT_ACTIVE, onSMEvent);
			DispatchManager.addEventListener(FooterEvent.HIGHLIGHT_BUTTON, highlightHeaderButton);
			
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}
		
		
		private function highlightHeaderButton(evt:FooterEvent):void{
			var id:String = evt.info.buttonID;
			for(var s:String in _headerButtons){
				TweenMax.to(_headerButtons[s],0.5,{tint:null});
			}
			if(_headerButtons[id]){
				TweenMax.to(_headerButtons[id],0.5,{tint:AppSettings.WHITE});
			}
		}
		
		

		
		public function hideAllBtns(_headerFadeOutTime:Number = 2):void{
		//	this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOverForAutoHide);
		//	TweenMax.killTweensOf(_headerButtons[LS_LOGO]);
		//	TweenMax.to(_headerButtons[LS_LOGO],_headerFadeOutTime,{tint:AppSettings.GREY});
		}
		
		public function showAllBtns(_headerFadeInTime:Number = 0.5):void{
		//	TweenMax.killTweensOf(_headerButtons[LS_LOGO]);
		//	TweenMax.to(_headerButtons[LS_LOGO],_headerFadeInTime,{tint:null});
		}
		
		private function addLeftSide():void{
			_leftSide = new Sprite();
			addChild(_leftSide);
			
			 var logo : Bitmap = AssetManager.getEmbeddedAsset("Logo");
			 _leftSide.addChild( logo ) ; 
		}
		
		private function addMiddle():void{
			_middle = new Sprite();
			addChild(_middle);
			
			_middle.visible = false;
			_middle.alpha = 0;
			
		}
		
		protected function addRightSide():void{
			_rightSide = new Sprite();
			addChild(_rightSide);
			
			var style:Object = 
			{ 
				fontSize: AppSettings.HEADER_FONT_SIZE
				, align:TextFormatAlign.CENTER 
				, autoSize : TextFieldAutoSize.CENTER 
				, multiline: true
				, wordWrap : true
				, width : 200 
				, border : false
			} ; 
			
			var headerCopy : TextField = TextManager.makeText('headerRight', this , style);
			_rightSide.addChild( headerCopy ) ; 
		}
		
		protected function headerButtonClick(evt:MouseEvent):void{
			var thisGuy:String = (evt.currentTarget as LSButton).id;
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.FOOTER_CLICKED,{value:thisGuy}));
		}


		private function onSMEvent(evt:Event):void{
			switch(evt.type){
				case(Flags.STATE_MACHINE_START):
					
					break;
				case(Flags.SM_RESET):
				case(Flags.STATE_MACHINE_END):
					TweenMax.to(_middle,0.5,{autoAlpha:0});
					break;
			
				case(Flags.SM_ACTIVE):
					TweenMax.to(_middle,0.5,{autoAlpha:0});
					break;				
				default:
					TweenMax.to(_middle,0.5,{autoAlpha:0});
			}
		}
		

		private function onResize(evt:Event = null) : void {
			graphics.clear();
			graphics.beginFill(0x808000,1);
			graphics.drawRect(0,0,stage.stageWidth,AppSettings.RESERVED_HEADER_HEIGHT);
			if(AppSettings.VIDEO_IS_STAGE_WIDTH){
				this.y = AppSettings.VIDEO_TOP - AppSettings.RESERVED_FOOTER_HEIGHT ;//stage.stageHeight/2 + AppSettings.VIDEO_HEIGHT/2;
				_rightSide.x = stage.stageWidth - _rightSide.width ; //- 30;
			}else{
				this.y = AppSettings.VIDEO_TOP - AppSettings.RESERVED_FOOTER_HEIGHT ;//stage.stageHeight - AppSettings.RESERVED_FOOTER_HEIGHT;
				_rightSide.x = AppSettings.VIDEO_RIGHT - _rightSide.width ; //- 30;
			}
			_leftSide.x = AppSettings.VIDEO_LEFT + 20;
			_middle.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2 - _middle.width/2;
		}
	}
}

package com.refract.prediabets.components.sceneselector {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.ClassFactory;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.events.FooterEvent;
	import com.refract.prediabets.components.events.SceneSelectorEvent;
	import com.refract.prediabets.components.shared.LSButton;
	import com.refract.prediabets.stateMachine.SMSettings;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Box;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class SceneSelectorQuestions extends Sprite {
		protected var _story : int;
		protected var _back : Box;
		protected var _grid : Sprite;
		protected var _coverBt : LSButton;
		protected var _tempSprite : Sprite;
		
		
		public function SceneSelectorQuestions() {
			_story = AppController.i.nextStory;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_back = new Box( 10 , 10 , 0x000000 ) ;
			addChild( _back ) ;
			var btn:SceneSelectorButton;
			for (var i:int= 0; i < 3; ++i){
				for(var j:int = 0; j< 4; ++j)
				{
					addChild(btn = new ClassFactory.SCENE_SELECTOR_BUTTON(4*i+j,true , 3));
					btn.addEventListener(MouseEvent.CLICK, onButtonClick);
				}
			}
			
			stage.addEventListener(Event.RESIZE, onResize);
			
			createGrid() ;
			
			var style:Object = {};
			style.fontSize = 13;
			style.align = "left";
			
			var style2:Object = {};
			style2.fontSize = 20 ;
			style2.align = "left";
			
			_coverBt = new LSButton("buttonFont",style);	
			addChild(_coverBt);
			_coverBt.text = '';
			_coverBt.useHandCursor = false ;
			_coverBt.graphics.beginFill(0x000000 , 1 ) ;
			_coverBt.graphics.drawRect(0,0,120,120);
			removeChild(_coverBt);
			
			var text1 : TextField = TextManager.makeText('footer_01_med_questions' , this , style );
			var text2 : TextField = TextManager.makeText('footer_01_med_questions' , this , style );
			var text3 : TextField = TextManager.makeText('footer_01_med_questions' , this , style );
			var text_nr1 : TextField = TextManager.makeText('footer_01_med_questions' , this , style2 );
			var text_nr2 : TextField = TextManager.makeText('footer_01_med_questions' , this , style2 );
			text1.htmlText = SMSettings.REAL_STORIES ;
			text2.htmlText= SMSettings.OF ;
			text3.htmlText = SMSettings.WATCHED ;
			
			//text_nr1.htmlText = String(AppController.i.nrQuestionSelected) ;
			text_nr2.htmlText = '12' ;
			
			_tempSprite = new Sprite() ; 
			_tempSprite.addChild( text1 ) ;
			_tempSprite.addChild( text_nr1 ) ;
			
			text_nr1.x = text1.width + 1 ; 
			text_nr1.y = -5 ;
			
			_tempSprite.addChild(text2) ; 
			text2.x = text_nr1.x + text_nr1.width + 1 ; 
			text_nr2.y = -5 ;
			
			_tempSprite.addChild(text_nr2);
			text_nr2.x = text2.x + text2.width + 1 ;
			
			_tempSprite.addChild(text3);
			text3.x = text_nr2.x + text_nr2.width + 1 ; 
			
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.ADD_FOOTER_ITEM ,{position:FooterEvent.BOTTOM_MIDDLE,button:_coverBt}));
			
			
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.ADD_FOOTER_ITEM ,{position:FooterEvent.TOP_MIDDLE,button:_tempSprite}));
			
			onResize();
			DispatchManager.dispatchEvent( new Event( Flags.FREEZE ) ) ; 
			
			DispatchManager.dispatchEvent( new Event( Flags.SM_NOT_ACTIVE ) ) ; 
			
			if( AppSettings.RATIO > 1.2)
			{
				_tempSprite.y = -AppSettings.RATIO * 10 ; 
			}
		}
		protected function createGrid() : void
		{
			
			_grid = new Sprite() ;
			var i : int = 0 ; 
			var l : int = 5 ;
			var grid : Box ;
			for( i = 0 ; i < l ; i ++ )
			{
				grid = new Box( 3 , 3 , 0x000000 ) ;
				_grid.addChild( grid) ;
			}
			addChild( _grid) ; 
		}

		
		protected function onButtonClick(evt:MouseEvent):void
		{
			var id:int = SceneSelectorButton(evt.currentTarget).id;
			DispatchManager.dispatchEvent( new SceneSelectorEvent(SceneSelectorEvent.QUESTION_SELECTED , id)) ; 
		}

		protected function onResize(evt : Event = null) : void {
			x = AppSettings.VIDEO_LEFT;
			y = AppSettings.VIDEO_TOP;
			
			if( _back)
			{
				_back.width = AppSettings.VIDEO_WIDTH ;
				_back.height = AppSettings.VIDEO_HEIGHT ;
			}
			
			if( _grid )
			{
				var i : int = 0 ; 
				var l : int = 5 ;
				var dividendo : Number ; 
				var grid : Box ;
				for (i= 0; i < l; i++) 
				{
					grid = _grid.getChildAt( i ) as Box ;
					if( i < 2)
					{
						dividendo = AppSettings.VIDEO_HEIGHT / 3 ;
						var pos_y : Number = (i+1)*dividendo ; 
						grid.y = pos_y ;
						grid.width = AppSettings.VIDEO_WIDTH ;
					}
					else
					{
						dividendo = AppSettings.VIDEO_WIDTH / 4 ;
						var pos_x : Number = (i-1)*dividendo ; 
						grid.x = pos_x ;
						grid.height = AppSettings.VIDEO_HEIGHT;
					}
				}
			}
			
		}
		
		
		
		public function destroy() : void 
		{
			stage.removeEventListener(Event.RESIZE, onResize);
			var chillens:int = numChildren;
			//var btn:SceneSelectorButton;
			for(var i:int = 0; i < chillens; ++i){
				var btn : SceneSelectorButton = (getChildAt(0)) as SceneSelectorButton;
				if( btn)
				{
					btn.removeEventListener(MouseEvent.CLICK, onButtonClick);
					btn.destroy();
					removeChildAt(0);
				}
			}
			i=0;
			var l : int = 5 ; 
			var grid : Box ;
			if(_grid){
				for (i= 0; i < l; i++) 
				{
					grid = _grid.getChildAt( 0 ) as Box ;
					_grid.removeChild( grid ) ;
				}
				removeChild( _grid ) ;
			}
			removeChild( _back ) ;
			
			DispatchManager.dispatchEvent(new FooterEvent(FooterEvent.REMOVE_FOOTER_ITEM ,{position:FooterEvent.TOP_MIDDLE,button:_tempSprite}));
			
			TweenMax.to(_coverBt,0.5,{autoAlpha:0,onComplete:DispatchManager.dispatchEvent,onCompleteParams:[new FooterEvent(FooterEvent.REMOVE_FOOTER_ITEM,{position:FooterEvent.BOTTOM_MIDDLE,button:_coverBt})]});
		}
	}
}

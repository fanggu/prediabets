package com.refract.prediabets.stateMachine.view.buttons 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quint;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.stateMachine.SMSettings;
	import com.refract.prediabets.stateMachine.VO.CoinVO;
	import com.refract.prediabets.stateMachine.events.ObjectEvent;
	import com.refract.prediabets.stateMachine.events.OverlayEvent;
	import com.refract.prediabets.stateMachine.events.StateEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;
	import com.robot.geom.Circle;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
 com.refract.prediabets.AppSettings;

	/**
	 * @author robertocascavilla
	 */
	public class ButtonTarget extends Sprite 
	{
		protected var activated : int ;
		private var _interaction : Object;
		private var _value : Boolean  ;
		public var img : Bitmap ;
		private var _txtField : TextField;
		private var _btTarget : Bitmap;
		
		private var _txtBalloon : Sprite;
		
		
		public function ButtonTarget() 
		{
			activated = 0 ;
			
			addEvents() ; 
		}
		public function setButton( interaction : Object ) : void
		{
			AppSettings.stage.addEventListener( Event.RESIZE , onResize) ; 
			DispatchManager.addEventListener(Flags.FADEOUT, onFadeOut ); 
			DispatchManager.addEventListener(Flags.TEXT_FEEDBACK , onTextFeedback); 
			DispatchManager.addEventListener( Flags.CHOICE_SELECTED , onChoiceSelected) ;
			
			useHandCursor = true ;
			buttonMode = true ; 
			
			_btTarget = AssetManager.getEmbeddedAsset("ChoiceTarget") ;
			addChild( _btTarget ) ; 
			_btTarget.scaleX = _btTarget.scaleY = AppSettings.RATIO ; 
				
			_interaction = interaction ; 
			name = interaction.iter ; 
			onResize() ; 
			
			
			var values : String = interaction.interaction_meta ;
			var regExp : RegExp =  /-?[a-z]+/g;
			var arr : Array = values.match( regExp );	
			var tempValue : String = arr[1] ; 
			
			if( tempValue == 'true') _value = true ; 
			else _value = false ; 
			
			addEventListener(MouseEvent.CLICK, btPressed); 

		}
		
		private function onChoiceSelected( evt : Event ) : void
		{ 
			deActivate();
		}
		
		private function onFadeOut( evt : Event ) : void
		{
			TweenMax.to( this , .3 , { alpha : 0 , delay : SMSettings.BUTTON_FADE_DELAY , onComplete : destroy ,canBePaused:true } ) ; 
		}
		
		private function btPressed( evt : MouseEvent ) : void
		{
			var bt : Sprite = evt.currentTarget as Sprite ;
			var btObj : CoinVO = new CoinVO() ; 
			btObj.btName = bt.name ; 
			btObj.wrong = _value ; 
			
			if( _value ) 
			{
				//var infoObject : Object =new Object() ; 
				//infoObject.stateName = _interaction.stateName ; 
				//infoObject.iter = _interaction.iter ; 
				//DispatchManager.dispatchEvent(new ObjectEvent(Flags.DEACTIVATE_BUTTON, infoObject)); 
				deActivate() ;
			}
			else
			{
				activate() ; 
				DispatchManager.dispatchEvent( new Event(Flags.CHOICE_SELECTED ) ) ; 
			}
			
			
			DispatchManager.dispatchEvent(new ObjectEvent(Flags.INSERT_COIN, btObj));
		}
		private function onTextFeedback( evt : StateEvent ) : void
		{
			if( evt.stringParam == '-1' && activated == -1 )
			{
				createText( evt.stringParam ) ; 
			}
			if( evt.stringParam == '+1' && activated == 1 )
			{
				createText( evt.stringParam ) ; 
			}
			
		}
		private function createText( str : String ) : void
		{
			var colorCircle : uint ; 
			
			if( str == '+1') colorCircle = SMSettings.GREEN_BUTTON ; 
			else colorCircle = SMSettings.DEEP_RED ; 
			_txtBalloon  = new Sprite ;
			var circleSize : Number = 20 *AppSettings.RATIO ; 
			var circBack : Circle = new Circle( circleSize , colorCircle ) ; 
			var style:Object = 
			{ 
				fontSize:24   
				, multiline: true
				, wordWrap : false
				, width : 300
			} ; 

			_txtField  = TextManager.makeText( SMSettings.FONT_COUNTDOWN , null , style) ;
			_txtField.text = str ; 
			_txtField.textColor = 0xffffff ;
			//txtField.x = this.width/2 ; 
			
			_txtBalloon.addChild( circBack ) ;
			_txtBalloon.addChild( _txtField ) ; 
			//circBack.x = circBack.width/2 - 3 ;
			//circBack.y = circBack.height/2 - 3;
			_txtField.x = - _txtField.width/2 ;
			_txtField.y = - _txtField.height/2 ;
			circBack.alpha = .7 ;
			addChild( _txtBalloon ) ;
			
			_txtBalloon.scaleX = _txtBalloon.scaleY = 0 ; 
			_txtBalloon.y = AppSettings.stage.mouseY ;
			_txtBalloon.x = AppSettings.stage.mouseX ;
			
			TweenMax.killTweensOf( _txtBalloon ) ;
			TweenMax.to( _txtBalloon , 2 , { y : AppSettings.stage.mouseY-100 , ease : Quint.easeOut , onComplete : devastate , onCompleteParams : [_txtField] , canBePaused:false} ) ; 
			//TweenMax.to( txtBalloon , .1 , { alpha : 0 ,  delay : .8 , yoyo:true , repeat : 4} ) ;
			TweenMax.to( _txtBalloon , .7 , { scaleX : 1 , scaleY:1  ,delay :0 , ease : Elastic.easeOut , canBePaused:true } ) ;
			TweenMax.to( _txtBalloon , .2 , { scaleX : 0 , scaleY:0  ,delay :.7 , ease : Quint.easeOut , canBePaused:true } ) ;
			
			DispatchManager.dispatchEvent(  new OverlayEvent( OverlayEvent.DRAW_BALLOON , _txtBalloon ) ) ; 
		} 
		
		public function onResize( evt : Event = null ) : void
		{
			x = ( _interaction.choice_x * AppSettings.VIDEO_WIDTH) / 100 - width/2 + AppSettings.VIDEO_LEFT;
			y = ( _interaction.choice_y * AppSettings.VIDEO_HEIGHT) / 100 + AppSettings.VIDEO_TOP;
			
			if( img )
			{
				img.y = y - SMSettings.CHOICE_IMG_DISTANCE ; 
				img.x = x ;
			}
			
		}
		
		public function deActivate() : void
		{
			activated = -1 ;
			removeEvents() ; 
			
			mouseEnabled = false;
			useHandCursor = false;
			buttonMode = false;
			
			/*
			var tempShape : Shape = new Shape() ; 
			
			tempShape.graphics.clear();
			tempShape.graphics.beginFill( 0xff0000, .5);
			tempShape.graphics.drawRect(0, 0, _bkg.width +1, _bkg.height + 1);
			tempShape.graphics.endFill() ; 
			//tempShape.x = 1 ; tempShape.y = 1 ; 
			addChild(tempShape) ; 
			
			TweenMax.to( tempShape , .1 , { alpha:0 , repeat:3, yoyo:true} );
			 * 
			 */
		}
		public function activate() : void
		{
			activated = 1 ; 
			removeEvents() ; 
			
			mouseEnabled = false;
			useHandCursor = false;
			buttonMode = false;
			
			/*
			var tempShape : Shape = new Shape() ; 
			
			tempShape.graphics.clear();
			tempShape.graphics.beginFill( 0x00ff99, .5);
			tempShape.graphics.drawRect(0, 0, _bkg.width +1, _bkg.height + 1);
			tempShape.graphics.endFill() ; 
			//tempShape.x = 1 ; tempShape.y = 1 ; 
			addChild(tempShape) ; 
			
			TweenMax.to( tempShape , .1 , { alpha:0 , repeat:3, yoyo:true} );
			 * 
			 */
			
		}
		
		private function addEvents():void{
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
		}
		
		private function onMouseEvent(evt:MouseEvent):void{
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
					alpha = .8 ;
					
				break;
				default:
					alpha = 1 ;
					
			}
		}
		
		private function removeEvents():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			removeEventListener(MouseEvent.CLICK, btPressed); 
		}
		
		public function destroy() : void
		{
			AppSettings.stage.removeEventListener( Event.RESIZE , onResize) ; 
			DispatchManager.removeEventListener(Flags.FADEOUT, onFadeOut ); 	
			DispatchManager.removeEventListener(Flags.TEXT_FEEDBACK , onTextFeedback); 
			DispatchManager.removeEventListener( Flags.CHOICE_SELECTED , onChoiceSelected) ;
		}
		
		private function devastate( obj : TextField ) : void
		{
			if( obj.parent ) obj.parent.removeChild( obj ) ; 
		}
		
		public function dispose() : void
		{
			DispatchManager.removeEventListener( Flags.CHOICE_SELECTED , onChoiceSelected) ;
			
			if( _btTarget ) if( _btTarget.parent) _btTarget.parent.removeChild( _btTarget )  ;
			if( _txtField ) if( _txtField.parent) _txtField.parent.removeChild( _txtField )  ;
			
			if( _txtBalloon ) if( _txtBalloon.parent ) _txtBalloon.parent.removeChild( _txtBalloon ) ;
			_txtBalloon = null ; 
			//super.destroy() ; 
		}
	}
}

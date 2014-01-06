package com.refract.prediabetes.stateMachine.view.interactions {
	import com.greensock.TweenMax;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.events.StateEvent;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	/**
	 * @author robertocascavilla
	 */
	public class InteractionSlide extends Interaction 
	{
		
		
		private var _btInit_x : Number ;
		private var _btEnd_x : Number ; 
		private var _btInit_y : Number ; 
		
		private var _interactiveVideo : MovieClip;
		
		private var _slideBt : Sprite ; 
		private var _valueMin : Number ; 
		private var _valueMax : Number ; 
		private var _arrMeta : Array ; 
		private var _direction : String ; 
		private var _txt : TextField ;
		private var _memoryButtonPressed : *;
		private var _iter : int;
		public function InteractionSlide( interactionObject : Object) 
		{
			interaction = interactionObject ; 
			addEventListener(Event.ADDED_TO_STAGE, create);
		}
		
		private function create( evt : Event = null ) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, create);
			
			DispatchManager.dispatchEvent(new Event( Flags.DEACTIVATE_VIDEO_RUN ) ) ; 
			
			createInteractiveVideo() ; 
			var values : String = interaction.interaction_meta ;
			var regExp : RegExp =  /-?[0-9]+/g;
			_iter = 0 ; 
			_arrMeta = values.match( regExp );
			
			if( _arrMeta[0] == 0 ) _direction = 'right' ;
			else _direction = 'left' ; 
				
			_slideBt = new Sprite();
			
			var slideMC : DisplayObject = AssetManager.getEmbeddedAsset('Slide') as DisplayObject ;  
			_slideBt.addChild( slideMC );
			
			
			//_slideBt.x = ( interaction.choice_x * AppSettings.VIDEO_WIDTH ) / 100 ;
			//_slideBt.y = ( interaction.choice_y * AppSettings.VIDEO_HEIGHT ) / 100 ;
				
			var d : Point ;
			
				
				_valueMin = ( _arrMeta[0] * AppSettings.VIDEO_WIDTH ) / 100 ;
				_valueMax = ( _arrMeta[1] * AppSettings.VIDEO_WIDTH ) / 100 ;
				
				slideMC.scaleX = slideMC.scaleY = AppSettings.RATIO ; 
				
				createTxt() ; 
				_txt.x = -5 * AppSettings.RATIO -_txt.width ; 
				//_txt.y = 0 ; //slideMC.height/4 ; //_txt.height/2 ; 
				if( _direction == 'left')
				{
					_txt.x = 0 ;	
					_txt.scaleX = -1 ; 
					_slideBt.scaleX = -1; 
					//_txt.x = -_txt.width ;
				}
				else
				{
					
				}
				
				_slideBt.x = ( interaction.choice_x * AppSettings.VIDEO_WIDTH ) / 100 ;
				_slideBt.addChild( _txt ) ; 
				
				
			

			addChild(  _slideBt );	
			
			_slideBt.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_slideBt.addEventListener(MouseEvent.CLICK, mouseUpHandler);
			
			_slideBt.buttonMode = true ; 
			_slideBt.useHandCursor = true ; 
			
			_btInit_x = _slideBt.x ; 
			_btInit_y = _slideBt.y ; 
			
			DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_LOOP_SOUND , SMSettings.SLIDE_LOOP) );
			
			
			AppSettings.stage.addEventListener( Event.RESIZE , onResize );
			onResize() ;
			//onResize() ;
			
		}
		
		private function createTxt() : void
		{
			var style:Object = 
			{ 
				fontSize: 32
			} ; 
			
			_txt = TextManager.makeText( SMSettings.FONT_BUTTON, null , style) ;
			_txt.htmlText = interaction.copy.main.toUpperCase() ;
		}

		private function mouseMoveRun( evt : Event ) : void
		{
			var endX : Number ;//= mouseX ;- 52; 
			if( _direction == 'left')
			{
				endX = mouseX + 52 ;
				if( endX > _btInit_x)
				{
					endX = _btInit_x + 52 ;
				}
				if( endX < _slideBt.x ) _slideBt.x = endX  ;
			}
			else
			{
				endX = mouseX - 52 ;
				if( endX < _btInit_x)
				{
					endX = _btInit_x - 52;
				}
				
				if( endX > _slideBt.x ) _slideBt.x = endX  ;
			}
			 
			var value : String = 'x' ;
			var btPos : Number = _slideBt[value] - this['_btInit_' + value] ; 
			var btTot : Number = this['_btEnd_' + value] -this['_btInit_' + value] ;
			
			var perc : Number = (btPos * 100 ) /btTot ; 

			var totFrame : int = _interactiveVideo.totalFrames-2 ; 
			 var endFrame: int = (perc*totFrame ) /100 ;
			  
			  if( endFrame > _interactiveVideo.currentFrame) 
			  	_interactiveVideo.gotoAndStop(endFrame);
				
				
			_iter ++ ; 
			checkSlideMovement() ;
			if( _iter > 60 )
				_iter = 0 ;
			
			checkEndSlide() ; 
		}
		private function checkSlideMovement() : void
		{
			if( Math.abs(_memoryButtonPressed - _slideBt.x) > 2 )
			{
				TweenMax.killTweensOf(_txt ) ; 
				TweenMax.to( _txt , .3 , { alpha : 0 , canBePaused:true} ) ;  
			}
			else
			{
				//TweenMax.killTweensOf(_txt ) ;
				TweenMax.to( _txt , .3 , { alpha : 1 , delay : 2 , canBePaused:true} ) ;  
			}
			_memoryButtonPressed = _slideBt.x ;
		}
		private function checkSlideStop() : void
		{
			if( Math.abs(_memoryButtonPressed - _slideBt.x) < 3 )
			{
				TweenMax.killTweensOf(_txt ) ;
				TweenMax.to( _txt , .3 , { alpha : 1 , canBePaused:true } ) ;  
			}	
			_memoryButtonPressed = _slideBt.x ;
		}

		private function createInteractiveVideo() : void 
		{
			 _interactiveVideo = AssetManager.getEmbeddedAsset(interaction.video_name) ; 
			 addChild( _interactiveVideo);
			 _interactiveVideo.getChildByName("video")["smoothing"] = true;
			 _interactiveVideo.stop() ;   
			 
			 //scaleToFit( _interactiveVideo );
			 //onResize() ;
		}
		
		public function scaleToFit(disp:DisplayObject):void{
			var ww:Number = stage.stageWidth;
			var hh:Number = stage.stageHeight;
			
			disp.width = ww;
			disp.height = hh;
			var ratio:Number = 1.777777778; //1280/720
			
			var screenRatio:Number = ww/hh;
			if(screenRatio < ratio){
				disp.width = ww;
				disp.height = ww/ratio;
				disp.x = 0;
				disp.y = hh/2 - disp.height/2;
			}else{
				disp.width = hh*ratio;
				disp.height = hh; 
				disp.x = ww/2 - disp.width/2;
				disp.y = 0;
			}
		}
		
		private function mouseDownHandler(evt:MouseEvent):void
		{
			AppSettings.stage.addEventListener(MouseEvent.CLICK , mouseUpHandler) ; 
			DispatchManager.addEventListener( Event.ENTER_FRAME , mouseMoveRun);
		}
		
		private function mouseUpHandler(evt:MouseEvent):void
		{
			_slideBt.stopDrag();	
			stage.removeEventListener(MouseEvent.CLICK , mouseUpHandler) ; 
			DispatchManager.removeEventListener( Event.ENTER_FRAME , mouseMoveRun);
		}
		
		private function checkEndSlide() : void
		{
			if( _direction == 'left')
			{
				if( _slideBt.x <= (_btEnd_x + 20))
				{
					DispatchManager.dispatchEvent(new StateEvent( Flags.UNLOCK_AFTER_INTERACTION,'0')) ;
					DispatchManager.removeEventListener( Event.ENTER_FRAME , mouseMoveRun);
				}
			}
			else
			{
				if( _slideBt.x >= (_btEnd_x - 20))
				{
					DispatchManager.dispatchEvent(new StateEvent( Flags.UNLOCK_AFTER_INTERACTION,'0')) ;
					DispatchManager.removeEventListener( Event.ENTER_FRAME , mouseMoveRun);
				}
			}	
		}
		
		private function onResize( evt : Event = null ) : void
		{
			if( _slideBt )
			{
				_slideBt.y = AppSettings.VIDEO_TOP + ( interaction.choice_y * AppSettings.VIDEO_HEIGHT ) / 100 ;
			}
			
			
			_valueMin = ( _arrMeta[0] * AppSettings.VIDEO_WIDTH ) / 100 ;
			_valueMax = ( _arrMeta[1] * AppSettings.VIDEO_WIDTH ) / 100 ;	
			
			
			
			var activate : Boolean = false ;
			if( _btEnd_x)
			{
				activate = true ;
				var diffBtInitsPrev : Number = Math.abs( _btEnd_x - _btInit_x );
				var diffBtNowPrev : Number = Math.abs( _slideBt.x - _btInit_x );
			}
			_btInit_x = AppSettings.VIDEO_LEFT + ( interaction.choice_x * AppSettings.VIDEO_WIDTH ) / 100 ;
			if( _direction != 'left' )
			{	
				_btEnd_x = _valueMax + _btInit_x ; 
			}
			else
			{	 
				_btEnd_x = _valueMin + _btInit_x ; 
			}
			
			if( activate )
			{
				var diffBtInits : Number ;
				if( _direction != 'left' )
				{
					diffBtInits  = Math.abs( _btInit_x - _btEnd_x ) ;	
				}
				else
				{
					diffBtInits = Math.abs( _btEnd_x - _btInit_x ) ;
				}
				 
				//var diffBtNow : Number = Math.abs( _slideBt.x - _btInit_x );
				var calcDiffBtNow : Number =  ( diffBtInits * diffBtNowPrev ) /diffBtInitsPrev ;
				var newSlideBt_x : Number ;
				if( _direction != 'left' )
				{
					newSlideBt_x=  calcDiffBtNow + _btInit_x  ;	
				}
				else
				{
					newSlideBt_x=  _btInit_x - calcDiffBtNow  ;
				}
				
				_slideBt.x = newSlideBt_x ; 
			}
			if( _interactiveVideo ) 
			{
				_interactiveVideo.x = AppSettings.VIDEO_LEFT ; 
				_interactiveVideo.y = AppSettings.VIDEO_TOP; 
				_interactiveVideo.width = AppSettings.VIDEO_WIDTH ;
				_interactiveVideo.height = AppSettings.VIDEO_HEIGHT ;
			}
			
			
			_txt.y = _slideBt.height/2 - _txt.height/2; 

		}
		public function dispose() : void
		{
			_slideBt.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_slideBt.removeEventListener(MouseEvent.CLICK, mouseUpHandler);
			_slideBt = null ; 
			
			removeEventListener(Event.ADDED_TO_STAGE, create);
			DispatchManager.removeEventListener( Event.ENTER_FRAME , mouseMoveRun);
			
			AppSettings.stage.removeEventListener( Event.RESIZE , onResize );
			AppSettings.stage.removeEventListener(MouseEvent.CLICK , mouseUpHandler) ;
			if( this.parent ) this.parent.removeChild( this ) ; 
			
			DispatchManager.dispatchEvent( new Event( Flags.FAST_CLEAR_SOUNDS  ) ) ; 
		}
		
	}
}

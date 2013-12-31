package com.refract.prediabets.stateMachine.view.interactions {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.logger.Logger;
	import com.refract.prediabets.stateMachine.SMSettings;
	import com.refract.prediabets.stateMachine.SMVars;
	import com.refract.prediabets.stateMachine.VO.CoinVO;
	import com.refract.prediabets.stateMachine.events.ObjectEvent;
	import com.refract.prediabets.stateMachine.events.StateEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.refract.prediabets.stateMachine.view.StateTxtView;
	import com.refract.prediabets.video.VideoLoader;
	import com.robot.comm.DispatchManager;
	import com.utils.KeyObject;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;

	/**
	 * @author robertocascavilla
	 */
	public class InteractionQP extends Interaction 
	{
		private var _keyObject : KeyObject;
		protected var _p_released : Boolean = true ;
		protected var _q_released : Boolean = true ;
		private var _arrIter : Array ; 
		private var _arrowMC : * ;
		private var _endArrowY : Number;
		private var _ok : Boolean;
		private var _keys : Array;
		private var _stateTxtView : StateTxtView;
		private var _iter : int = 0 ; 
		private var _lastTimer : Number = 0 ;
		private var _initTimer : Number = 0 ; 
		private var _gapMs : int = SMSettings.CPR_GAP_MS ; //120 ; 
		private var _stepMs : int = SMSettings.CPR_STEP_MS ; //500 ;
		private var _pumpIter : int = 0 ; 
		private var _meterCont : Sprite ;
		private var _bkGood : Sprite;
		private var _totPressed : int ; 
		private var _totPressedGood : int ;
		private var _notActiveTimer : Number;
		private var _long : Boolean;
		private var _freezeText : Boolean;
		private var _txt_mc : TextField;
		private var _fakeActiveTimer : Number;
		private var _counterOn : Boolean ;
		
		private var _arrowPath : int ;
		
		protected var videoCreated : Boolean ; 
		
		public function InteractionQP( interactionObject : Object )  
		{
			interaction = interactionObject ; 
			addEventListener(Event.ADDED_TO_STAGE, init ) ;
		}
		protected function init( evt : Event ) : void
		{
			videoCreated = false ; 
			
			stage.focus = this;
			_counterOn = false ; 
			removeEventListener(Event.ADDED_TO_STAGE, init) ;
			
			AppSettings.stage.addEventListener( Event.RESIZE , onResize ) ; 
			DispatchManager.addEventListener(Flags.FADEOUT, onFadeOut );
			
			initValues() ;  
			initCopy() ; 
			initKeyObject() ;
			
			this['create_' + interaction.interaction_type]() ; 
			
			
			DispatchManager.addEventListener(Event.ENTER_FRAME, preRun);
		}
		
		protected function initValues() : void
		{
			_totPressed = 0 ; 
			_totPressedGood = 0 ; 
			_freezeText = false ;  
		}
		protected function initCopy() : void
		{
			if( interaction.copy.main)
				createStateText() ; 
		}
		private function initKeyObject() : void
		{
			_keyObject = new KeyObject(this ) ; 	
		}
		
		protected function preRun( evt : Event ) : void
		{
			if ( _keyObject.isDown(Keyboard[_keys[0]]) && _keyObject.isDown(Keyboard[_keys[1]]) )
			{
				DispatchManager.removeEventListener( Event.ENTER_FRAME , preRun);
				start() ; 
			}
		}
		
		protected function start() : void
		{
			this['start_' + interaction.interaction_type]() ; 
		}
		
		protected function create_oneshot() : void
		{
			var values : String = interaction.interaction_meta ;
			var regExp : RegExp =  /-?[a-z]+/g;
			var arr : Array = values.match( regExp );	
			var valuesKeys : String = arr[1];
			setKeys( valuesKeys ) ; 	
		}
		protected function create_cpr_linear() : void
		{
			setKeys( Flags.QP ) ; 
		}
		protected function create_cpr_standard() : void
		{
			setKeys( Flags.QP ) ;
		}
		protected function create_cpr_long() : void
		{
			_long = true ; 
			create_cpr_linear() ; 
		}
		
		private function setKeys( valuesKeys : String ) : void
		{
			valuesKeys = valuesKeys.toUpperCase() ;
			_keys =  valuesKeys.split('') ;
		}
		
		
		protected function start_cpr_standard() : void
		{
			Logger.log(Logger.STATE_MACHINE,"START CPR STANDARD");
			_initTimer = SMVars.me.getSMTimer() ;
			_notActiveTimer = SMVars.me.getSMTimer() ; 
			SMVars.me.qp_counter = 0 ; 
			SMVars.me.qp_timer = 0 ; 
			
			createInteractiveVideo() ; 
			startVideo() ; 
			createMeter( ) ; 
			removeStateTxt() ; 
			
			DispatchManager.dispatchEvent(new Event( Flags.UPDATE_VIEW_COUNTDOWN_FORCE_REMOVE ) ) ; 
			var btObj : CoinVO = new CoinVO() ; 
			btObj.btName = Flags.CPR; 
			DispatchManager.dispatchEvent(new ObjectEvent(Flags.INSERT_COIN, btObj)); 
			DispatchManager.addEventListener( Event.ENTER_FRAME,  run ) ; 
			//DispatchManager.dispatchEvent( new Event(Flags.FAST_CLEAR_SOUNDS )) ; 
			_counterOn = false ; 
			//Logger.log(Logger.STATE_MACHINE,'SMVars.me.nsStreamTime :' , SMVars.me.nsStreamTime)
			//VideoLoader.i.seek( 0 ) ;
			 
			 
		}
		
		protected function start_cpr_linear() : void
		{
			start_cpr_standard() ;
			VideoLoader.i.resumeVideo() ;
			VideoLoader.i.deactivateClickPause() ;
			
		}
		
		protected function start_cpr_long() : void
		{
			start_cpr_standard() ;
			VideoLoader.i.resumeVideo() ;
			VideoLoader.i.deactivateClickPause() ;
			
			createTimerCprLong() ; 
		}
		protected function start_oneshot() : void
		{
			var coinVO : CoinVO = new CoinVO() ; 
			coinVO.btName = interaction.iter ; 
			coinVO.wrong = false ; 
			coinVO.oneShot = true ; 
			DispatchManager.dispatchEvent(new ObjectEvent(Flags.INSERT_COIN, coinVO ));
			_counterOn = false ; 
		}	
		
		 
		private function createTimerCprLong() : void
		{
			var value : String = createCountDownString( 0) ;
			DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_COUNTDOWN_TIMER_CPR_LONG , value));
			
			
			_counterOn = true ; 
		}
		
		private function createCountDownString( valueReverse : Number ) : String
		{
			var s:Number = valueReverse % 60;
		    var m:Number = Math.floor((valueReverse % 3600 ) / 60);
		    var h:Number = Math.floor(valueReverse / (60 * 60));
		     
		    var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
		    var minuteStr:String = doubleDigitFormat(m) + ":";
		    var secondsStr:String = doubleDigitFormat(s);
		     
		    return hourStr + minuteStr + secondsStr;
		}
		private function doubleDigitFormat($num:uint):String
		{
		    if ($num < 10) 
		    {
		        return ("0" + $num);
		    }
		    return String($num);
		}
		
		protected function run( evt : Event ) : void
		{
			if( _counterOn)
			{
				//var diff : Number = SMVars.me.getSMTimer() - _initTimer ;
				if( SMVars.me.nsStreamTime > 0)
				{
					var value : String = createCountDownString( SMVars.me.nsStreamTime /1000 ) ;//createCountDownString( diff/1000 ) ;
					DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_COUNTDOWN_TIMER_CPR_LONG, value));
				}
			}
			callKey() ; 
				
			
			easing_mc(_arrowMC , _endArrowY , 'y') ; 
			
			_bkGood.height = _arrowPath - _arrowMC.y  ; 
			
			checkTimers() ;
			
		}
		protected function callKey() : void
		{
			if ( _keyObject.isDown(Keyboard.Q) && _keyObject.isDown(Keyboard.P)  && _q_released && _p_released ) 
			{
				_q_released = false ; 
				_p_released = false ;
					pump() ; 
					 
			}
			if( !_keyObject.isDown(Keyboard.Q))
				_q_released = true ;
			if( !_keyObject.isDown(Keyboard.P))
				_p_released = true ;
		}
		
		private function checkTimers() : void
		{
			var diffTimerInactive : Number = SMVars.me.getSMTimer() - _notActiveTimer ; 
			
			if( ( SMVars.me.getSMTimer() - (_fakeActiveTimer + SMSettings.CPR_TRIGGER_PUMP ) ) >= SMSettings.CPR_TRIGGER_PUMP)
			{
				pump( true ) ;
 			}
			
			if( ( diffTimerInactive ) >= SMSettings.CPR_TRIGGER_SLOW)
			{
				VideoLoader.i.pauseVideo() ;
			}
			if( ( diffTimerInactive ) >= SMSettings.CPR_TRIGGER_NOTACTIVE )
			{
				SMVars.me.accelerometerAble = false ; 
				DispatchManager.dispatchEvent( new Event( Flags.CPR_SLOW_TIME ) ) ; 
				dispose( ) ; 
			}
			
			if( ( diffTimerInactive ) >= 500 )
			{
				_endArrowY = _arrowPath ; 
			}
			
			//**LONG
			if( _long )
			{
				if( ( SMVars.me.nsStreamTime ) >= SMSettings.CPR_TRIGGER_LONG )
				{
					_long = false ; 
					_gapMs = SMSettings.CPR_GAP_LONG_MS ; //80 ; 
					_freezeText = true ; 
					callText( SMSettings.PLUS_ACCURACY) ; 
				}
			}
			if( _freezeText )
			{
				if( ( SMVars.me.nsStreamTime ) >= (SMSettings.CPR_TRIGGER_LONG + 1000) )
				{
					_freezeText = false ; 
				}
			}
			
		}

		protected function pump( fake : Boolean = false ) : void
		{
			if( !fake ) _notActiveTimer = SMVars.me.getSMTimer() ;
			_fakeActiveTimer = SMVars.me.getSMTimer() ; 
			_totPressed ++ ;
			var nowTimer : Number = SMVars.me.getSMTimer() ; 
			var diffTimer : Number = nowTimer  - _lastTimer ;
			 
			_ok = false ; 
			var videoGo : Boolean = true ; 
			var diffX : Number = 0 ; 
			var diffStepGap : int = _stepMs - _gapMs ;
			var addStepGap : int = _stepMs + _gapMs ;

			switch( true )
			{
				case ( diffTimer < ( diffStepGap)) :
				
					if(!_freezeText ) callText(SMSettings.TOO_FAST) ;
					_lastTimer = SMVars.me.getSMTimer();
					_endArrowY = _arrowPath ; 
					
				break ;
				
				case( (diffTimer >= ( diffStepGap) ) && diffTimer < ( addStepGap ) ) :
				
					diffX = diffTimer - ( diffStepGap ) ;
					_ok = true ; 
					if(!_freezeText ) callText(SMSettings.OK) ;
					_pumpIter ++ ;
					videoGo = true ; 
					_lastTimer = SMVars.me.getSMTimer() + diffX ; 
					_endArrowY = -_arrowPath ;
					_totPressedGood++ ; 
					
				break ;
					
				case ( diffTimer >= ( addStepGap )) :
				
					if(!_freezeText ) callText(SMSettings.TOO_SLOW) ;
					_pumpIter ++ ;
					videoGo = true ; 
					_lastTimer = SMVars.me.getSMTimer() + diffX ; 
					
					_endArrowY = _arrowPath ;
				break ;
			}

			
			if( !fake )
			{
				if( VideoLoader.i.paused && videoGo) 
				{
					_iter = 0 ; 
					VideoLoader.i.resumeVideo() ; 
				}
			}
		}
		
		
		
		
		
		private function createStateText() : void
		{	
			var stateObjectText : Object = new Object() ; 
			stateObjectText.state_txt = interaction.copy.main;
			stateObjectText.state_txt_x = interaction.choice_x;
			stateObjectText.state_txt_y = interaction.choice_y;
			if( _stateTxtView )
			{
				stateTxtDevastate() ; 
			}
			_stateTxtView  = new StateTxtView( stateObjectText , SMSettings.STATE_TXT_FONT_SIZE ) ; 
			addChild( _stateTxtView ) ; 
		}
		private function removeStateTxt() : void
		{
			if( _stateTxtView ) TweenMax.to( _stateTxtView , .3 , { alpha : 0 , onComplete:stateTxtDevastate , canBePaused:true} ) ;
		}
		protected function stateTxtDevastate( ) : void
		{
			if( _stateTxtView)
			{
				if( _stateTxtView.parent)
				{	
					_stateTxtView.dispose() ; 
					removeChild( _stateTxtView );
					_stateTxtView = null ; 
				}
			}
		}
		private function createInteractiveVideo() : void
		{
			
			//if( SMVars.me.accelerometerAble)
			//{
			//if( !videoCreated )
			//{
				videoCreated = true ; 
				if( VideoLoader.i.videoAddress != interaction.video_name)
				{
					DispatchManager.dispatchEvent(new StateEvent(Flags.UPDATE_VIEW_VIDEO, interaction.video_name));
					//VideoLoader.i.update( interaction.video_name);
					VideoLoader.i.pauseVideo() ; 
				}
			//}
			//}
		}
		
		private function startVideo() : void
		{
			VideoLoader.i.playVideo() ; 
			DispatchManager.addEventListener(NetStatusEvent.NET_STATUS, videoEnd) ; 
		}

		private function videoEnd(event : NetStatusEvent) : void 
		{
			//if( event.info.code == 'NetStream.Buffer.Empty')
			if( event.info.code == 'NetStream.Play.Stop')
			{	
				SMVars.me.qp_timer = ( SMVars.me.getSMTimer() - _initTimer ) /1000  ; 
				SMVars.me.qp_counter = _pumpIter ; 
				SMVars.me.nrCpR++ ; 
				SMVars.me.latest_accuracy= ( _totPressedGood * 100 )  / _totPressed ;
				SMVars.me.qp_accuracy = ( SMVars.me.qp_accuracy + SMVars.me.latest_accuracy ) / SMVars.me.nrCpR ;
				 
				DispatchManager.dispatchEvent(new StateEvent( Flags.UNLOCK_AFTER_INTERACTION,'0')) ; 
				DispatchManager.removeEventListener(NetStatusEvent.NET_STATUS, videoEnd) ; 
				Logger.log(Logger.STATE_MACHINE,'1');
			}
		}
		
		private function callText( str : String ) : void
		{
			var style:Object = 
			{ 
				fontSize:48   
				, align:TextFormatAlign.CENTER 
				, autoSize : TextFieldAutoSize.CENTER 
				, multiline: true
				, wordWrap : false
				, width : 300
			} ; 
			
			if( _txt_mc ) devastate( _txt_mc ) ;
			_txt_mc = TextManager.makeText( SMSettings.FONT_COUNTDOWN , null , style) ;
			_txt_mc.text = str ; 
			addChild( _txt_mc ) ; 
			_txt_mc.textColor = SMSettings.DEEP_RED ; 
			
			//_txt_mc.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2 - _txt_mc.width/2 ;
			//_txt_mc.y = AppSettings.VIDEO_HEIGHT - _txt_mc.height/2 +20;
			//TweenMax.to( txt_mc , 1 , { y : 500  , ease : Quint.easeOut} ) ; 
			TweenMax.to( _txt_mc , .1 , {alpha : 0 , delay : .8 , onComplete:devastate , onCompleteParams:[_txt_mc] , canBePaused:true} ) ; 
			
			onResize() ;
		}
		
		
		private function createMeter() : void
		{
			_arrIter = new Array() ; 
			_meterCont = new Sprite() ; 
			
			
			//Logger.log(Logger.STATE_MACHINE,'DPI ' ,Capabilities.screenDPI )
			//Logger.log(Logger.STATE_MACHINE,'App settings height ' , AppSettings.stage.stageHeight)
			//var stageH75 : Number = (AppSettings.stage.stageHeight * 75 ) / 100 ; 
			//Logger.log(Logger.STATE_MACHINE,'stageH75 ' , stageH75)
			//var ratio : Number = ( ( Capabilities.screenDPI) / 72) ; 
			//if( ratio > 1.2) ratio = ratio / 2 ;
			//var ratioH : Number = AppSettings.VIDEO_HEIGHT / 700 ; 
			//var ratioW : Number = AppSettings.VIDEO_WIDTH / 1024 ; 
			var bkW : Number = 30 * AppSettings.RATIO; 
			var bkH : Number = 450 * AppSettings.RATIO ; 
			bkH = bkH >  AppSettings.VIDEO_HEIGHT ? AppSettings.VIDEO_HEIGHT : bkH;
			
			var bk : Sprite = createSquare( 0xc45252 , bkW , bkH , .3 );
			_bkGood = createSquare( 0xc45252 , bkW , bkH , .3 );
			
			bk.y = -bk.height/2 ; 
			
			
			_bkGood.rotation = 180 ; 
			_bkGood.y = _bkGood.height/2 ;
			_bkGood.x = _bkGood.width/2 ; //15 ; 
			
			_arrowPath = _bkGood.height/2 ;
			
			var textBad : TextField = createText( SMSettings.BAD , 'stateTxt' , 20 );   
			var textGood: TextField = createText( SMSettings.GOOD , 'stateTxt' , 20 ); 
			var textYou: TextField = createText( SMSettings.YOU , 'stateTxt' , 20 );    
			
			textGood.rotation = 90 ; 
			textBad.rotation = 90 ; 
			 
			
			
			textGood.x = textGood.width/2 ; 
			textGood.y = - bk.height/2 - textGood.height - 3*AppSettings.RATIO ;//- 40 ;
			
			textBad.x = textBad.width/2 ; 
			textBad.y = + bk.height/2 + 3*AppSettings.RATIO ; 
			
			  
			 
			addChild( _meterCont ) ; 
			_meterCont.addChild( bk) ;
			_meterCont.addChild( _bkGood) ;
			_meterCont.addChild( textGood) ;
			_meterCont.addChild( textBad) ;
			
			_arrowMC = AssetManager.getEmbeddedAsset("QPArrow") ; 
			addChild( _arrowMC ) ; 
			
			 
			
			_meterCont.addChild( _arrowMC ) ;
			_arrowMC.x = -_arrowMC.width -13*AppSettings.RATIO ;//+ 2*ratio ; 
			_arrowMC.y = -_arrowPath ; 
			
			_arrowMC.addChild( textYou ) ; 
			textYou.x = - textYou.width - 8*AppSettings.RATIO  ; //-37 ;
			textYou.y = - textYou.height/2 ; //-13 ;
			
			_endArrowY = 0 ; 
			
			onResize() ; 
		}
		
		private function easing_mc( mc:* , end_value:Number , value:String):void
		{
			var dif:Number = end_value - mc[value];
			var difeasing:Number = dif/SMSettings.CPR_EASING;
			mc[value] += difeasing;
		}
		
		private function devastate( mc : * ) : void
		{
			if( mc.parent ) mc.parent.removeChild( mc ) ; 
		}
		
		protected function onFadeOut( evt : Event ) : void
		{
			if( _stateTxtView ) TweenMax.to( _stateTxtView , .3 , {alpha : 0 , delay :SMSettings.BUTTON_FADE_DELAY , canBePaused:true} ) ;
		}
		
		public function dispose() : void
		{
			SMVars.me.QP_PRE_RUN = false ; 
			videoCreated = false ; 
			//VideoLoader.i.pauseVideo() ; 
			_keyObject = null ; 
			_counterOn = false ;
			initValues() ; 
			DispatchManager.removeEventListener( Event.ENTER_FRAME,  preRun ) ;
			DispatchManager.removeEventListener( Event.ENTER_FRAME,  run) ; 		
				
			DispatchManager.removeEventListener(Flags.FADEOUT, onFadeOut ); 
			removeEventListener(Event.ADDED_TO_STAGE, init) ; 
			AppSettings.stage.removeEventListener( Event.RESIZE , onResize ) ; 
				
			DispatchManager.removeEventListener(NetStatusEvent.NET_STATUS, videoEnd) ; 
				
			_keyObject = null ; 
			stateTxtDevastate() ;

			var len : int = this.numChildren ;
			var i : int ; 
			var child : *;
			for( i= 0 ; i < len ; i++)
			{
				child = this.getChildAt(0);
				this.removeChild( child ) ; 
			}
			if( _txt_mc) if( _txt_mc.parent ) _txt_mc.parent.removeChild( _txt_mc ) ;
			stateTxtDevastate() ;
			if( this.parent ) this.parent.removeChild( this ) ;
			
			DispatchManager.dispatchEvent( new Event( Flags.FAST_CLEAR_SOUNDS  ) ) ; 
		}
		
		protected function onResize( evt : Event = null ) : void
		{
			if( _meterCont)
			{
				_meterCont.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH - 60 ;  
				_meterCont.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT / 2 ; 
			}
			if( _txt_mc)
			{
				_txt_mc.x = AppSettings.VIDEO_LEFT + AppSettings.VIDEO_WIDTH/2 - _txt_mc.width / 2 ;
				_txt_mc.y = AppSettings.VIDEO_TOP + AppSettings.VIDEO_HEIGHT - _txt_mc.height - 10 ;
			}
			 
		}
	}
}

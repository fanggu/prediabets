package com.refract.prediabets.components.nav.header {
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Quint;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.refract.prediabets.user.ModuleModel;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class HeaderScoreBar extends Sprite {
		
		private static const USE_RATING_TEXT:Boolean = false;
		
		private var _buttonY:int;
		
		private var _scoreText:TextField;
		private var _rightFirstTime:TextField;
		private var _rightFirstTimeSep:TextField;
		private var _rightFirstTimeTotal:TextField;
		private var _avgSpeed:TextField;
		private var _crosses:Sprite;
		private var _rating:TextField;
		
		
		private var _currentRating:int = 0;
		
		private var _extraCross:Bitmap;
		
		private var styleRFT:Object = {fontSize:14};
		private var style:Object = {fontSize:13};
		
		
		public function HeaderScoreBar(buttonY:int = 12) {
			styleRFT.fontSize = AppSettings.FOOTER_FONT_SIZE2;
			style.fontSize = AppSettings.FOOTER_FONT_SIZE2;
			_buttonY = buttonY;
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			
			_rightFirstTime = TextManager.makeText("header_in_module_score",this,styleRFT);
			_rightFirstTime.text = "0";
			
			_rightFirstTimeSep = TextManager.makeText("header_in_module_score",this,styleRFT);
			_rightFirstTimeSep.text = "/";
			
			_rightFirstTimeTotal = TextManager.makeText("header_in_module_score",this,styleRFT);
			_rightFirstTimeTotal.text = "0";
			
			if(AppSettings.DEVICE == AppSettings.DEVICE_MOBILE){
				_scoreText = TextManager.makeText("header_in_module_score_mobile",this,style);
			}else{
				_scoreText = TextManager.makeText("header_in_module_score",this,style);
			}
			//score.text = "6/7" + score.text + "0.13 - ";
			
			_avgSpeed = TextManager.makeText("header_in_module_score",this,styleRFT);
			_avgSpeed.text = "0.00";
			
		//	var crossScale:Number = // 0.5 * AppSettings.GET_FONT_SCALE(styleRFT.fontSize);
			
			_crosses = new Sprite();
			addChild(_crosses);
			var cross:Bitmap;
			for(var i:int = 0; i < 5; ++i){
				cross = AssetManager.getEmbeddedAsset("ResultsCross");
				cross.smoothing = true;
				cross.height = _scoreText.textHeight*0.80; //0.7 is smaller
				cross.scaleX = cross.scaleY ;//= crossScale;
				_crosses.addChild(cross);
				cross.x = cross.width*i + i*3;
				if(i+1 > _currentRating){
					cross.alpha = 0.4;
					TweenMax.to(cross,0,{colorMatrixFilter:{saturation:0}});
				}
			}
			
			_extraCross = AssetManager.getEmbeddedAsset("ResultsCross");
			_extraCross.smoothing = true;
			_extraCross.scaleX = _extraCross.scaleY = cross.scaleY;
			_crosses.addChild(_extraCross);
			if(USE_RATING_TEXT){
				_rating = TextManager.makeText("header_in_module_score_rating1",this,style);
			}
					
			alignX();
			alignY();
			
		}
		
		private function alignX():void{
			
			_rightFirstTimeSep.x = _rightFirstTime.x + _rightFirstTime.textWidth+1;
			_rightFirstTimeTotal.x = _rightFirstTimeSep.x + _rightFirstTimeSep.textWidth+1;
			_scoreText.x = _rightFirstTimeTotal.x + _rightFirstTimeTotal.width;
			_avgSpeed.x = _scoreText.x + _scoreText.textWidth+1;
			_crosses.x = _avgSpeed.x + _avgSpeed.width + 4;//-crosses.width/2;
			if(USE_RATING_TEXT){
				_rating.x = _crosses.x + _crosses.width;
			}
		}
		
		private function alignY():void{
			_rightFirstTime.y = _buttonY-1;
			_rightFirstTimeSep.y = _buttonY-1;
			_rightFirstTimeTotal.y = _buttonY-1;
			_scoreText.y = _buttonY;
			_avgSpeed.y = _buttonY-1;
			_crosses.y = _buttonY+4;	
			if(USE_RATING_TEXT){
				_rating.y = _buttonY;
			}		
		}
		
		public function setScore(obj:ModuleModel):void{
			/*
			 * var scoreObj : Object = new Object() ; 
            scoreObj.totChoices = _totChoice ; 
            scoreObj.totCorrectChoices = _totCorrectChoice ; 
            scoreObj.addStar = _addStar ; 
            scoreObj.valueTotal = _valueTotal ;
			 * 
			 */
			 
			 
			 if(_rightFirstTime.text != String(obj.correct)){
				var oldRightFirstTime:TextField = _rightFirstTime;
				_rightFirstTime = TextManager.makeText("header_in_module_score",this,styleRFT);
			//	_rightFirstTime.alpha = 0;
				_rightFirstTime.text = obj.correctString;
				animateTextField(_rightFirstTime,oldRightFirstTime,_buttonY-1);
			 }
			 if(_rightFirstTimeTotal.text != String(obj.total)){
				var oldRightFirstTimeTotal:TextField = _rightFirstTimeTotal;
				_rightFirstTimeTotal = TextManager.makeText("header_in_module_score",this,styleRFT);
		//		_rightFirstTimeTotal.alpha = 0;
				_rightFirstTimeTotal.text = obj.totalString;
				animateTextField(_rightFirstTimeTotal,oldRightFirstTimeTotal,_buttonY-1);
			 }
			 
			 if(_avgSpeed.text != obj.speedString){
				var oldAvgSpeed:TextField = _avgSpeed;
				_avgSpeed = TextManager.makeText("header_in_module_score",this,styleRFT);
				_avgSpeed.text = obj.speedString;
				animateTextField(_avgSpeed, oldAvgSpeed, _buttonY-1);
			 }
			var newRating:int =  obj.rating; // _currentRating + int(obj.addStar);
		
			if(newRating == 6){
				//do nothing, we don'ts got 6 stars son.
			}else if(newRating == 0 && obj.starBonus != 0 || newRating != _currentRating){
				//	removeChild(_rating);
				if(USE_RATING_TEXT){
					var _oldRatingText:TextField = _rating;
					if(newRating != 0){
						_rating = TextManager.makeText("header_in_module_score_rating"+newRating,this,style);
					}else{
						_rating = TextManager.makeText("header_in_module_score_rating1",this,style);
						DispatchManager.dispatchEvent(new Event(Flags.NO_STARS));
					}
					animateTextField(_rating, _oldRatingText, _buttonY);
				}else{
					if(newRating == 0){
						DispatchManager.dispatchEvent(new Event(Flags.NO_STARS));
					}
				}
				
				var cross:Bitmap;
				var index:int;
				_extraCross.alpha = 0;
				if(newRating > _currentRating){ 
					index = newRating - 1;
					for(var i:int = 0; i < index; ++i){
						TweenMax.to(_crosses.getChildAt(i),0,{alpha:1,colorMatrixFilter:{}});
					}
					cross = _crosses.getChildAt(index) as Bitmap;
					_extraCross.x = cross.x;
					_extraCross.y = -20;
					TweenMax.to(_extraCross,_animTime,{y:0,ease:Quint.easeOut,onComplete:function():void{ TweenMax.to(cross,0,{alpha:1,colorMatrixFilter:{}}); }});
				}else if (newRating != -1){
					index = newRating;
					cross = _crosses.getChildAt(index) as Bitmap;
					_extraCross.x = cross.x;
					_extraCross.y = 0;
					_extraCross.alpha = 1;
					TweenMax.to(_extraCross,_animTime,{y:20,alpha:0,ease:Back.easeIn, easeParams:[2]});
				//	TweenMax.to(cross,0,{alpha:0.4,colorMatrixFilter:{saturation:0}});
					for(var e:int = index; e < _crosses.numChildren - 1; ++e){
						TweenMax.to(_crosses.getChildAt(e),0,{alpha:0.4,colorMatrixFilter:{saturation:0}});
					}
				}
				
				
			//	
			//	for(var i:int = 0; i < 5; ++i){
			//		cross = _crosses.getChildAt(i) as Bitmap;
			//		TweenMax.to(cross,0,{alpha:1,colorMatrixFilter:{}});
			//		if(i+1 > newRating){
			//			TweenMax.to(cross,0,{alpha:0.4,colorMatrixFilter:{saturation:0}});
			//		}
			//	}
				_currentRating = newRating;
			}
		
			alignX();
		}
		
		private var _animTime:Number = 0.5;
		
		private function animateTextField(tf:DisplayObject,oldTF:DisplayObject,endY:int):void{
				tf.alpha = 0;
				TweenMax.fromTo(oldTF, _animTime, {
												alpha:1,
												y:endY,
												rotation:0
											}, {
												alpha:0,
												y:endY+20,
												rotation:20,
												delay:_animTime-0.1,
												ease:Quint.easeOut, 
												onComplete:function():void{removeChild(oldTF);}
											});
				TweenMax.fromTo(tf, _animTime, {
												alpha:0,
												y:-20,
												rotation:-20
											   }, {
												alpha:1,
												y:endY,
												rotation:0,
												ease:Quint.easeIn
											});
		}

		public function reset() : void {
			_currentRating = 0 ; 
			_rightFirstTime.text = "0";
			_rightFirstTimeSep.text = "/";
			_rightFirstTimeTotal.text = "0";
			_avgSpeed.text = "0.00";
			
			var cross:Bitmap;
			for(var i:int = 0; i < 5; ++i){
				cross = _crosses.getChildAt(i) as Bitmap;
				cross.alpha = 0.4;
				TweenMax.to(cross,0,{colorMatrixFilter:{saturation:0}});
			}
			if(USE_RATING_TEXT){
				var tf:TextField = _rating;
				_rating = TextManager.makeText("header_in_module_score_rating1",this,style);
				_rating.x = tf.x;
				_rating.y = tf.y;
				removeChild(tf);
			}
		}
		
	}
}

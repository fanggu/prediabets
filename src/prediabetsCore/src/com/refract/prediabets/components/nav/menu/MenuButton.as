package com.refract.prediabets.components.nav.menu {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppController;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.AssetManager;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.events.MenuEvent;
	import com.refract.prediabets.components.nav.Menu;
	import com.refract.prediabets.components.nav.header.HeaderProgressBar;
	import com.refract.prediabets.components.shared.LSButton;
	import com.refract.prediabets.stateMachine.events.StateEvent;
	import com.refract.prediabets.stateMachine.flags.Flags;
	import com.refract.prediabets.user.UserModel;
	import com.robot.comm.DispatchManager;

	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.utils.ByteArray;

	/**
	 * @author kanish
	 */
	public class MenuButton extends Sprite {
		
		protected var _redOverlay:Shape;
	//	protected var _bkg:Bitmap;
		protected var _bkg:Video;
		protected var _bkgVidStream:NetStream;
		protected var _bkgVidConnection:NetConnection;
		protected var _bkgVidBytes : ByteArray;
		
		public function get bkgHeight():Number {return _bkg.height;}
		protected var _type:String;
		public function get type():String{return _type;}
		protected var _pos:int;
		
		protected var _labelMask:Shape;
		protected var _label:Sprite;
		
		protected var _start:LSButton;
		
		protected var _menu:Menu;
		
		protected var _labelAnimated:Boolean = false;
		
		protected var _isEnabled:Boolean = true;
		public function get enabled():Boolean {return _isEnabled;}
		
		public function MenuButton(type:String,menu:Menu) {
			_pos = int(type) - 1;
			_isEnabled = UserModel.getModuleStats(_pos+1).unlocked;
			_type = type;
			_menu = menu;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(evt:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			
			setProperties();
			addBKG();
			addLabels();
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		protected function addBKG():void{
			
			_bkgVidConnection = new NetConnection();
			_bkgVidConnection.connect(null);
			
			
			_bkg = new Video(319,249);
			_bkgVidBytes = AssetManager.getEmbeddedAsset("IntroFilm"+_type+"Vid");
		
			createNetStream();
			
	//		_bkg = AssetManager.getEmbeddedAsset("IntroFilm"+_type+"Bkg") as Bitmap;
			
			
			addChild(_bkg);
			_bkg.smoothing = true;
			_bkg.alpha = 0.4;
			
			_redOverlay = new Shape();
			addChild(_redOverlay);
			_redOverlay.alpha = 0;
			_redOverlay.graphics.beginFill(0xc45252);
			_redOverlay.graphics.drawRect(0,0,_bkg.width,_bkg.height);
			_redOverlay.blendMode = BlendMode.OVERLAY;
		    _redOverlay.visible = false;
		}
		
		protected function createNetStream():void{
			if(_bkgVidStream){
				_bkgVidStream.removeEventListener(NetStatusEvent.NET_STATUS, videoStatus);
				_bkgVidStream.dispose();
			}
			_bkgVidStream = new NetStream(_bkgVidConnection);
			_bkgVidStream.addEventListener(NetStatusEvent.NET_STATUS, videoStatus);
	        _bkgVidStream.client = {};
			
			_bkg.attachNetStream(_bkgVidStream);
			
			_bkgVidStream.play(null);
			_bkgVidStream.appendBytes(_bkgVidBytes);
			_bkgVidStream.pause();
			
			
			
		}
		
		protected function videoStatus( event : NetStatusEvent ) : void
		{
		//	if(String(event.info.code).indexOf("Notify") == -1) 
			switch (event.info.code) 
		    { 
		        case "NetStream.Buffer.Full": 
		            break; 
				case "NetStream.Play.Stop":
					break;
		        case "NetStream.Buffer.Empty":
				//	createNetStream();
				//	_bkgVidStream.resume();					
		            break; 
				case "NetStream.Play.StreamNotFound":
					break;
				case "NetStream.Seek.InvalidTime":
					break;
				case "NetStream.Buffer.Flush":
					break;
		    } 
		}
		
		protected static var nameStyle:Object = {fontSize:36};
		protected static var labelStyle:Object = { fontSize:16, antiAlias:"normal" };
		
		protected function addLabels():void{
			
			_label = new Sprite();
			_labelMask = new Shape();
			_labelMask.graphics.beginFill(0xff0000);
			_labelMask.graphics.drawRect(0,0,_bkg.width,_bkg.height);
			addChild(_labelMask);
			addChild(_label);
			_label.mask = _labelMask;
			var tf:TextField;
			tf = TextManager.makeText("intro_menu_label"+_type,_label,labelStyle);	
			tf.x += 1;
			
			if(enabled){
				tf = TextManager.makeText("intro_menu_unlocked"+_type,_label,nameStyle);
				
			//	addEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
			//	addEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
				
				if(UserModel.getModuleStats(_pos+1).isDownloaded){
					if(UserModel.getModuleStats(_pos+1).isComplete){
						_start = new LSButton("intro_menu_replay",nameStyle,257,70,true,false);
					}else if(AppController.i.nextStory == _pos+1){
						_start = new LSButton("intro_menu_resume",nameStyle,257,70,true,false);
					}else{
						_start = new LSButton("intro_menu_start_now",nameStyle,257,70,true,false);
					}
				}else{
					_start = new LSButton("intro_menu_download",nameStyle,257,70,true,false);
				}
				_start.minBkgWidthGap = 0;
				_start.buttonAlpha = 0.15;
				_label.addChild(_start);
				TweenMax.to(_start.body,0,{tint:0xffffff});
				_start.y = _start.height + 9;
				
				if(_labelAnimated){
					//everything should be set as above
				}else{//overwrite
					_start.y = _start.height + 9;
					_label.y = _bkg.height - 10 - _label.height;
					
				}
				
				
			}else{
				tf = TextManager.makeText("intro_menu_locked",_label,nameStyle);
			//	buttonMode = false;
			//	mouseEnabled = false;
				useHandCursor = false;
				
			}
			
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
			
			if(!enabled){
				TweenMax.to(_redOverlay,0,{autoAlpha:0});		
				TweenMax.to(_bkg, 0, {alpha: 0.4});
			}else{
				TweenMax.to(_bkg, 0, {alpha: 0.4});
				
			}
			
			tf.y = 15;
		}
		
		public function lockNow():void{
			
		}
		
		public function unlockNow():void{
			
		}
		
		
		public function unlock():void{
				removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
				removeEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
				_isEnabled = true;
				useHandCursor = true;
			
				TweenMax.to(_bkg, 0, {alpha:0.4,canBePaused:false,colorMatrixFilter:{saturation:1}});
				_redOverlay.visible = false;
				
				var lock:MovieClip = AssetManager.getEmbeddedAsset("MenuLock");
				addChild(lock);
				lock.alpha = 0;
				lock.visible = false;
				lock.stop();
				lock.name = "lock";
				lock.addFrameScript(lock.totalFrames-1,function():void{lock.stop();doUnlockRest();});
				TweenMax.to(lock,0.1,{autoAlpha:1,canBePaused:false});
				TweenMax.to(lock,0.1,{autoAlpha:0,delay:0.1,canBePaused:false});
				TweenMax.to(lock,0.1,{autoAlpha:1,delay:0.2,canBePaused:false});
				TweenMax.to(lock,0.1,{autoAlpha:0,delay:0.3,canBePaused:false});
				TweenMax.to(lock,0.2,{autoAlpha:1,delay:0.4,canBePaused:false,onComplete:function():void{
					lock.play();
				}});
				lock.x = this.width/2;
				lock.y = 80;
				
			
				
				var tf:TextField = _label.getChildAt(1) as TextField;
				var tf2:TextField = TextManager.makeText("intro_menu_unlocked"+_type,_label,nameStyle);
				tf2.y = tf.y;
				tf2.alpha = 0;
				TweenMax.to(tf,0.25,{autoAlpha:0,onComplete:_label.removeChild,onCompleteParams:[tf],canBePaused:false});
				TweenMax.to(tf2,0.25,{autoAlpha:1,delay:0.25,canBePaused:false});
				
		}

		protected function doUnlockRest():void{
			
				var lock:MovieClip = getChildByName("lock") as MovieClip;
				TweenMax.to(lock,0.5,{autoAlpha:0,delay:0.2,onComplete:function():void{if(lock && contains(lock)){ removeChild(lock); }},canBePaused:false});
				
				_start = new LSButton("intro_menu_start_now",nameStyle,257,70,true,false);
				_start.minBkgWidthGap = 0;
				_start.buttonAlpha = 0.15;
				_label.addChild(_start);
				onResize();
				TweenMax.to(_start.body,0,{tint:0xffffff,canBePaused:false});
				_start.y = _start.height + 9;
				
				
				onMouseOverOut(new MouseEvent(MouseEvent.MOUSE_OVER));
			//	TweenMax.to(_bkg, 0.5, {alpha: 0.4,colorMatrixFilter:{saturation:1}});
				TweenMax.to(_start,0.5,{y:_start.height,canBePaused:false});
				TweenMax.to(_label,0.5,{y: _bkg.height - 10 - _label.height,canBePaused:false,onComplete:function():void{  
					addEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
					addEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
					onResize();
				}});
				
		}

		public function onMouseOverOut(evt : MouseEvent) : void {
			switch(evt.type){
				case(MouseEvent.MOUSE_OVER):
					
				//	_bkgVidStream.seek(0);
					_bkgVidStream.resume();
					if(!enabled){
						_redOverlay.alpha = 0;
						_redOverlay.visible = true;
						DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndMenuLocked") );	
						TweenMax.to(_redOverlay,0.5,{alpha:1,canBePaused:false});
						TweenMax.to(_bkg, 0.5, {alpha :1, colorMatrixFilter:{saturation:0},canBePaused:false});
						TweenMax.to(_label.getChildAt(1),0.5,{tint:0xffffff,canBePaused:false});
					}else{
						_redOverlay.visible = false;
						DispatchManager.dispatchEvent(new StateEvent( Flags.UPDATE_FX_SOUND , "SndMenuRollover") );	
						TweenMax.to(_bkg, 0.5, {alpha :1,canBePaused:false});
						if(_start) _start.startDancingArrow();
					}
					if(_labelAnimated){
						TweenMax.to(_start,0.3,{y:_start.height,canBePaused:false});
						TweenMax.to(_label,0.3,{y: _bkg.height - 10 - _label.height,canBePaused:false});
					}
					break;
				default:
					_bkgVidStream.pause();
					if(!enabled){
						_redOverlay.visible = true;
						TweenMax.to(_redOverlay,0.5,{alpha:0,canBePaused:false});		
						TweenMax.to(_bkg, 0.5, {alpha: 0.4,colorMatrixFilter:{saturation:1},canBePaused:false});
						TweenMax.to(_label.getChildAt(1),0.5,{tint:null,canBePaused:false});
					}else{
						_redOverlay.visible = false;
						TweenMax.to(_bkg, 0.5, {alpha: 0.4,canBePaused:false});
						if(_start) _start.stopDancingArrow();
						
					}
					if(_labelAnimated){
						TweenMax.to(_start,0.3,{y:_start.height + 9,canBePaused:false});
						TweenMax.to(_label,0.3,{y: _bkg.height - 79,canBePaused:false});		
					}
			}
		}
		
		
		protected function setProperties():void{
			mouseChildren = false;
			mouseEnabled = true;
			useHandCursor = true;
			buttonMode = true;
		}
		
		
		protected function onResize(evt:Event = null):void{
			
			
			_bkg.scaleX = _bkg.scaleY = _redOverlay.scaleX = _redOverlay.scaleY = 
		//	_labelMask.scaleX = _labelMask.scaleY = (AppSettings.VIDEO_WIDTH-3)/(1280-3);
			_labelMask.scaleX = _labelMask.scaleY = (AppSettings.VIDEO_WIDTH+4)/(1280);
			_label.x = 28;
			
			if(_labelAnimated){
				_label.y =_bkg.height - 79;
			}else{
				_label.y = _bkg.height - 10 - _label.height;
			}
			
			graphics.clear();
			graphics.beginFill(0x0,1);
			graphics.drawRect(0,0,_bkg.width+1,_bkg.height);
		//	graphics.drawRect(0,0,_bkg.width,_bkg.height);
			
			if(_start){
				_start.minW = _bkg.width - 63;
				if(!_labelAnimated){
					_start.y = _start.height;
				}
			}
			
			
			this.x = (_bkg.width*_pos);
			this.y = _menu.shown ? -bkgHeight : 0;
		}

		public function destroy() : void {
			stage.removeEventListener(Event.RESIZE,onResize);
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
		//	removeEventListener(Event.ENTER_FRAME,onEnterFrame);	
			
		}

		public function resetVideo() : void {
			onMouseOverOut(new MouseEvent(MouseEvent.MOUSE_OUT));
			
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOverOut);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOverOut);
					
			if(this.getChildByName("lock")){
				removeChild(getChildByName("lock"));
			}
			createNetStream();
			
			var textID:String = "";
			if(UserModel.getModuleStats(_pos+1).isDownloaded){
				if(UserModel.getModuleStats(_pos+1).isComplete){
					textID = "intro_menu_replay";
				}else if(AppController.i.nextStory == _pos+1){
					textID = "intro_menu_resume";
				}else{
					textID = "intro_menu_start_now";
				}
			}else{
				textID = "intro_menu_download";
			}
			
			if(_start && textID != ""){
				_start.text = TextManager.getDataListForId(textID)[textID]["copy_"+AppSettings.LOCALE];
			}
		}
		
		protected var _progress:HeaderProgressBar;
		
		public function listenForDownload() : void {
			
		}
		
		protected function checkDownloadSize():void{
		}

		public function resetState() : void {
		//	onResize();
			if(enabled){
				_start.y = _start.height + 9;
				_label.y = _bkg.height - 10 - _label.height;
			}
		}

	}
}

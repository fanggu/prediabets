package com.refract.prediabets.components.credits {
	import com.greensock.TweenMax;
	import com.refract.prediabets.AppSettings;
	import com.refract.prediabets.assets.TextManager;
	import com.refract.prediabets.components.shared.GeneralOverlay;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author kanish
	 */
	public class Credits extends GeneralOverlay {
		
		protected var _bodyContent:Sprite;
		protected static const _sections:Array = [ 
										{ name:"title", 			sections:["header"] },
										{ name:"pre", 				sections:["titles","names"] },
										{ name:"unit9", 			sections:["header","titles","names"] },
										{ name:"medical_advice",	sections:["header","names"] },
										{ name:"outsider", 			sections:["header","titles","names"] },
										{ name:"cast", 				sections:["header","titles","names"] },
										{ name:"interviewees", 		sections:["header","names"] },
										{ name:"special_thanks",	sections:["header","names"] }
									  ];
		
		
		
		public function Credits(){
			super();
		}
		
		protected function setStyles():void{
			
			_bodyTitleStyle = {fontSize:24, autoSize:"center", selectable:true, wordWrap: false, multiline:false, align: "center", toUpper:true, antiAlias:"normal"};
			_bodySubtitleStyle = {fontSize:24, autoSize:"right", selectable:true, wordWrap: false, multiline:false, align: "right", toUpper:true, antiAlias:"normal"};
			_bodyStyle = {fontSize:24, autoSize:"left", selectable:true, wordWrap: false, multiline:false, align: "left", toUpper:true, antiAlias:"normal"};
			
		}
		
		protected override function createContent():void{
			
			_scrollerWidth = AppSettings.VIDEO_WIDTH;
			_scrollerHeight = AppSettings.VIDEO_HEIGHT;
			_overscroll = true;
			
			setStyles();
			
			_bodyContent = new Sprite();
			_body.addChild(_bodyContent);
			
			var obj:Object;
			var subSections:Array;
			var thisTF:TextField;
			var thisTF2:TextField;
			var lastTF:TextField;
			var spacer:int = 0;
			for (var i:int = 0; i < _sections.length; ++i){
				obj = _sections[i];
				subSections = obj.sections;
				
				if(subSections.indexOf("header") != -1){
					thisTF = TextManager.makeText("page_credits_"+obj.name+"_header",_bodyContent,_bodyTitleStyle);
					thisTF.y = lastTF ? int(lastTF.y + lastTF.height + spacer) : 0;
					thisTF.x = int(-thisTF.width/2);
					lastTF = thisTF;
					spacer = 5;
				}
				
				if(subSections.indexOf("titles") != -1){
					thisTF = TextManager.makeText("page_credits_"+obj.name+"_titles",_bodyContent,_bodySubtitleStyle);
					thisTF2 = TextManager.makeText("page_credits_"+obj.name+"_names",_bodyContent,_bodyStyle);
					thisTF.y = thisTF2.y = lastTF ? int(lastTF.y + lastTF.height + spacer) : 0;
					thisTF.x = int(-thisTF.width - 10);
					thisTF2.x = 10;
					lastTF = thisTF;
					spacer = 5;
				}else if (subSections.indexOf("names") != -1){
					thisTF = TextManager.makeText("page_credits_"+obj.name+"_names",_bodyContent,_bodyTitleStyle);
					thisTF.y = lastTF ? int(lastTF.y + lastTF.height + spacer) : 0;
					thisTF.x = int(-thisTF.width/2);
					lastTF = thisTF;
					spacer = 5;
				}
				
				spacer = 25;
				
			}
		//	_bodyContent.x = int(_scrollerWidth/2);
			super.createContent();
			onResize();
			_scrollbox.autoScroll = true;
		}
		
		override protected function onResize(evt:Event = null,b:Boolean = true):void{
			_bodyContent.x = int(AppSettings.VIDEO_WIDTH/2);
			_bodyContent.y = int(AppSettings.VIDEO_HEIGHT);
			_bodyContent.graphics.clear();
			_bodyContent.graphics.beginFill(0xff00,0);
			_bodyContent.graphics.drawRect(0,-AppSettings.VIDEO_HEIGHT,2,_bodyContent.height + AppSettings.VIDEO_HEIGHT*2);
			super.onResize(evt);
			if(_scrollbox){
				_scrollbox.updateSize(AppSettings.VIDEO_WIDTH,AppSettings.VIDEO_HEIGHT);
			}
			if(b){
				TweenMax.to(this,0.5,{onComplete:onResize,onCompleteParams:[null,false]});
			}
		}
		
		override public function destroy():void{
			_bodyContent.removeChildren();
			super.destroy();
		}
		
	}
}

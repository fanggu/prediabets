package com.refract.prediabetes.stateMachine.view.interactions {
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.refract.prediabetes.AppSettings;
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.assets.TextManager;
	import com.refract.prediabetes.sections.utils.LSButton;
	import com.refract.prediabetes.stateMachine.SMSettings;
	import com.refract.prediabetes.stateMachine.SMVars;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.refract.prediabetes.stateMachine.view.buttons.ButtonChoice;
	import com.refract.prediabetes.stateMachine.view.buttons.ButtonTarget;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author robertocascavilla
	 */
	public class InteractionChoice extends Interaction 
	
	{
		protected var _btChoice : ButtonChoice;
		
		protected var _nameStyleChoice:Object = { fontSize:32  };
		protected var _nameStyleChoiceTarget:Object = { fontSize:32  };
		protected var _nameStyleChoiceImage:Object = { fontSize:24  };
		
		public function InteractionChoice( interactionObject : Object) 
		{
			interaction = interactionObject ; 
			addEventListener(Event.ADDED_TO_STAGE, create);
			DispatchManager.addEventListener( Flags.UPDATE_SIZE_BUTTON , onUpdateSizeButton ) ;
			
		}
//		
	
		protected function onUpdateSizeButton(event : Event) : void 
		{
			if( _btChoice )
			{
				 _btChoice.minW = SMVars.me.maxButtonSize ; 
				 _btChoice.onResize() ; 
			}
		}

		protected function create(event : Event) : void 
		{
			var bt : LSButton ;
			if( interaction.interaction_type == Flags.CHOICE)
			{
				_btChoice = new ButtonChoice("buttonFont", _nameStyleChoice, SMSettings.MIN_BUTTON_SIZE, 70  , true);
				addChild( _btChoice ) ; 
				_btChoice.setButton( interaction ) ; 
			}
			if( interaction.interaction_type == Flags.CHOICE_TARGET)
			{
				/*
				var btCont : Sprite = new Sprite() ; 
				addChild( btCont ) ; 
				var btTarget :Bitmap = AssetManager.getEmbeddedAsset("ChoiceTarget") ;
				btCont.addChild( btTarget ) ; 
				btCont.name = interaction.iter ; 
				btTarget.x = ( interaction.choice_x * stage.stageWidth ) / 100 - btTarget.width/2;
				btTarget.y = ( interaction.choice_y * stage.stageHeight ) / 100 ;
				
				
				btCont.addEventListener(MouseEvent.CLICK, btPressed);
				btCont.useHandCursor = true ; 
				btCont.buttonMode = true ; 
				 * 
				 */
				 var btTarget : ButtonTarget = new ButtonTarget() ; 
				 addChild( btTarget ) ; 
				 btTarget.setButton(interaction) ; 
				 
				 
				 var txt : TextField = TextManager.makeText( SMSettings.FONT_BUTTON, null , _nameStyleChoiceTarget) ;
				 txt.htmlText = interaction.copy.main.toUpperCase() ; 
				 txt.textColor = SMSettings.DEEP_RED ; 
				 txt.x = -txt.width - 10 * AppSettings.RATIO ;
				 txt.y = txt.height/2 ; 
				 btTarget.addChild( txt ) ;
			}
			
			if( interaction.interaction_type == Flags.CHOICE_IMG)
			{
				_btChoice= new ButtonChoice("buttonFont", _nameStyleChoiceImage ,SMSettings.MIN_BUTTON_SIZE ,70 ,true);
				addChild( _btChoice ) ; 
				
				var values : String = interaction.interaction_meta ;

			 	var regexS: String = "src=([^&#]*)";
	    		var regex : RegExp = new RegExp( regexS );
	    		var results : Array = regex.exec( values);
				var regexT : String = ",class=([^&#]*)";
				var regex2 : RegExp = new RegExp( regexT ) ;
				var replaced:String = results[0].replace( regex2, "");
				var replace2 : Array = regex.exec( replaced ) ;
	
				 var imgAddress : String = replace2[1] ; 
				 var imgBmp : Bitmap = AssetManager.getEmbeddedAsset( imgAddress ) ;
				 var img : Sprite = new Sprite() ; 
				 
				 
				 
				 img.addChild( imgBmp ) ; 
				
				
				_btChoice.img = img ; 
				_btChoice.setButton( interaction ) ; 
				 
				addChild( img ) ;
			}
			if( _btChoice ) SMVars.me.updateMaxButtonSize(	_btChoice.width ) ; 
			showButtons() ; 
		}
		/*
		protected function btPressed( evt : MouseEvent ) : void
		{
			var bt : Sprite = evt.currentTarget as Sprite ;
		}
		 * 
		 */
		protected function showButtons() : void
		{
			//if( interaction.interaction_type == 'choice' || interaction.)
			//{
				var l : int = this.numChildren ;
				var i : int ; 
				for( i = 0 ; i < l ; i++)
				{
					var bt : * = this.getChildAt(i) ; //as ButtonChoice ;
					if( bt ) 
					{
						bt.alpha = 0 ;
						var dd: Number = SMSettings.SHOW_DELAY + (interaction.iter)* SMSettings.SHOW_DELAY ; 
						TweenMax.to( bt , .25 , {alpha : 1 , ease : Linear.easeNone , delay : dd, canBePaused:true } ) ;
					}
				}
			//}
		}

		
		
		public function dispose() : void
		{
			DispatchManager.removeEventListener( Flags.UPDATE_SIZE_BUTTON , onUpdateSizeButton ) ;
			
			var l : int = this.numChildren ;
			var i : int ; 
			for( i = 0 ; i < l ; i++)
			{ 
				var bt : * = this.getChildAt( 0 )  ;
				if( bt ) 
				{
					if( bt is ButtonChoice)
						bt.dispose() ; 
					
					if( bt is ButtonTarget)
						bt.dispose() ; 
						
					if( bt.parent ) bt.parent.removeChild( bt ) ; 
 				}
			}
			
			if( this.parent ) this.parent.removeChild( this ) ; 
			
			DispatchManager.dispatchEvent( new Event( Flags.FAST_CLEAR_SOUNDS  ) ) ; 
		}
	}
}

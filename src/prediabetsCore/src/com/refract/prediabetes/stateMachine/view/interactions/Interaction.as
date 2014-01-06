package com.refract.prediabetes.stateMachine.view.interactions {
	import com.refract.prediabetes.assets.TextManager;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author robertocascavilla
	 */
	public class Interaction extends Sprite
	 {
		protected var interaction : Object ; 
		
		protected var rH : int;
		protected var rW : int;
		protected var startY : Number;
		protected var startX : Number;
		
		//protected var buttonPressed : * ; 
		
		public function Interaction() { }
		
		
		protected function createSquare( color : uint , w : int , h : int  , alpha : Number = 1 , corner_w : Number = 1 , corner_h : Number = 1 ) : Sprite
		{
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(color);
			spr.graphics.drawRoundRect(0 , 0 , w , h , corner_w , corner_h );
			spr.graphics.endFill( );
			spr.alpha = alpha ; 
			spr.x = -spr.width/2 ;
			spr.y = -spr.height/2;
			return spr ; 
		}
		protected function createText( str : String , type:String , size : int = 20) : TextField
		{
			var id : String = type ; 
			var style:Object = { fontSize:size , autoSize:TextFieldAutoSize.CENTER};
			var txtField : TextField = TextManager.makeText( id , null , style) ;
			txtField.text = str ; 
			return txtField ; 	
		}
		
	}
}

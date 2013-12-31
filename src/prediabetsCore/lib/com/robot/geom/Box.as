package com.robot.geom 
{
	/*
	 *	@author roboot
	 */
	import flash.display.*;		

	public class Box extends Sprite 
	{
		public var param:*;
		public function Box(w:Number,h:Number,rgb:uint , corner_w:Number = 0, corner_h:Number = 0):void
		{
			//	graphics.lineStyle(0,null,1);
				graphics.beginFill(rgb);
				graphics.drawRoundRect(0 , 0 , w , h , corner_w , corner_h );
				graphics.endFill() ; 
		}
		
	}
	
}



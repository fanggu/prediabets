package com.robot.geom 
{
	/*
	 *	@author roboot
	 */
	import flash.display.*;		

	public class Circle extends Sprite 
	{
		public function Circle(r:Number , rgb:uint ):void
		{
				graphics.lineStyle(0, rgb ,1);
				graphics.beginFill(rgb);
				graphics.drawCircle(0 , 0 , r  );
		}
		
	}
	
}




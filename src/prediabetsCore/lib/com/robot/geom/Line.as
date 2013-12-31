package com.robot.geom {
	import flash.display.*;		

	public class Line extends Sprite 
	{
		public function Line(s_x:Number , s_y:Number , e_x:Number , e_y:Number ,rgb:uint , lineDepth:int ):void
		{
			graphics.lineStyle(lineDepth, rgb , 1 );
			//graphics.beginFill( rgb, 1 );
			graphics.moveTo( s_x , s_y );
			graphics.lineTo( e_x , e_y );
		
		}
		
	}
	
}

package com.refract.prediabetes.stateMachine.view.buttons {
	import com.refract.prediabetes.assets.AssetManager;
	import com.refract.prediabetes.sections.utils.LSButton;
	import com.refract.prediabetes.stateMachine.flags.Flags;
	import com.robot.comm.DispatchManager;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author robertocascavilla
	 */
	public class ButtonPause extends LSButton 
	{
		public var active : Bitmap ;
		public var notActive : Bitmap ;
		
		public var _active : Boolean ; 
		
		public function ButtonPause(copyID:String, props:Object = null, w:Number = 0,h:Number = 0, useArrow:Boolean = false) {
		{
			super( copyID , props , w , h , useArrow);
			//addChild( active ) ;
			//addChild( notActive ) ;
			
			_active = true ;
			toggle() ; 
			
			addEventListener( MouseEvent.CLICK , onClick ) ; 
		}
			
			
		}

		private function onClick(event : MouseEvent) : void 
		{
			if( _active ) 
			{
				DispatchManager.dispatchEvent( new Event( Flags.UN_FREEZE ) ) ; 
			}
			else
			{ 
				DispatchManager.dispatchEvent( new Event( Flags.FREEZE ) ) ;
			}
			toggle() ; 
		}
		
		public function toggle() : void
		{
			if( _active )
			{
				_active = false ; 
				arrowAsset = 'Pause';
				//active.visible = true ; 
				//notActive.visible = false; 
			}
			else
			{
				_active = true ; 
				arrowAsset = 'RedArrow';
				//active.visible = false ; 
				//notActive.visible = true; 
			}
		}
	}
}

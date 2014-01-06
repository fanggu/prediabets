package com.refract.air.shared.prediabetes.stateMachine {
	import com.refract.prediabetes.stateMachine.SMModel;

	import flash.utils.ByteArray;

	/**
	 * @author robertocascavilla
	 */
	public class SMModelMobile extends SMModel
	{
		
		[Embed(source="../assets/SMMobileData1.json",mimeType="application/octet-stream")]
		protected var SM1Json : Class;
		[Embed(source="../assets/SMMobileData2.json",mimeType="application/octet-stream")]
		protected var SM2Json : Class;
		[Embed(source="../assets/SMMobileData3.json",mimeType="application/octet-stream")]
		protected var SM3Json : Class;
		[Embed(source="../assets/SMMobileData6.json",mimeType="application/octet-stream")]
		protected var SM6Json : Class;
		
		override protected function getJsonObject( module : int  ) : Object
		{
			var strModule : String = "SM" + module + 'Json' ;
			 getClass(strModule ) ; 
			var bytes : ByteArray = getClass(strModule ) as ByteArray ; 
			var jsonString : String = bytes.readUTFBytes( bytes.length) ;
			var jsonObject : Object = JSON.parse(jsonString );
			return jsonObject ; 
		
		}
		public function getClass(className:String): * 
		{
			var cl : Class = this[className] as Class;
			return new cl() ; 
		}
		
	}
}

package fw.anim
{	
	import flash.display.BitmapData;

	public class TileSheetHelper
	{
		public function prepareAnimTexture(texture:BitmapData, seqRaw:Object):AnimTextureSheet
		{
			//var seqRaw:Object = JSON.decode( sheetData );
			//var seqRaw:Object =  com.adobe.serialization.json.JSON.decode( sheetData );
			var animData:Array= [];
			
			populateFrameArray(animData, seqRaw.frames);
			
			// Sort
			animData.sortOn("id");
			
			// Create and initialize the tile sheet
			var tileSheet:AnimTextureSheet= new AnimTextureSheet();
			tileSheet.init(texture, animData);
			
			return tileSheet;
		}
		
		private function populateFrameArray(arDest:Array, src:Object):void
		{
			var entry:Object;
			var nameId:String;
			var item:Object;
			
			for(var keyName:String in src) {
				nameId= keyName.substring(0, keyName.lastIndexOf(".png"));
				
				entry= src[keyName];
				
				item = entry.frame;
				item.id = nameId;
				
				item.offX = 0;
				item.offY = 0;
				if (entry.trimmed) {
					item.offX= entry.spriteSourceSize.x;
					item.offY= entry.spriteSourceSize.y;
				}
				
				
				arDest.push(item);
			}
		}
	}
}
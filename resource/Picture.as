package resource
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public class Picture
	{
		private static var m_dPicture:Dictionary;
		private static var m_stLoader:BulkLoader;
		
		public static function Init():void{
			m_dPicture = new Dictionary();
		}
		
		public static function GetPic(srcString:String, idString:String):*{
			if(m_dPicture[srcString]){
				return m_dPicture[srcString];
			}
			
			m_stLoader.add(srcString, {id : idString, type : BulkLoader.TYPE_IMAGE});
			m_stLoader.addEventListener(BulkProgressEvent.COMPLETE, OnAllLoader);
			m_stLoader.start();
			
			return 
		}
		
		protected static function OnAllLoader(e:BulkProgressEvent):void
		{
			// TODO Auto-generated method stub
			var bitmap:Bitmap = new Bitmap();
			
			var res:* = m_stLoader.getContent("100_0.png");
			
			if(res is BitmapData){
				bitmap.bitmapData = res as BitmapData;	
			}else if(res is Bitmap){
				bitmap.bitmapData = (res as Bitmap).bitmapData;
			}
			
		}
	}
}
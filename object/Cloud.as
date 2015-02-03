package object
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class Cloud extends Sprite
	{
		private var m_stLoader	:BulkLoader;
		private var m_strKey	:String;
		
		private var m_iAcLeft	:int;
		private var m_iAcRight	:int;
		private var m_iScaleX	:int;
		private var m_iScaleY	:int;
		private var m_iSpeed	:Number;
		
		public function Cloud(srcString:String, strKey:String, 
							  iAcLeft:int, iAcRight:int, iSpeed:Number)
		{
			m_strKey 		= strKey;
			m_iAcLeft 		= iAcLeft;
			m_iAcRight		= iAcRight;
			m_iSpeed		= iSpeed;
			
			m_stLoader = new BulkLoader(strKey+"Loader");
			m_stLoader.add(srcString, {id:strKey, type : BulkLoader.TYPE_IMAGE});
			m_stLoader.addEventListener(BulkProgressEvent.COMPLETE, OnLoadComplete);
			m_stLoader.start();
		}
		
		protected function OnLoadComplete(e:BulkProgressEvent):void
		{
			// TODO Auto-generated method stub
			var bitmap:Bitmap = new Bitmap();
			
			var res:* = m_stLoader.getContent(m_strKey);
			
			if(res is BitmapData){
				bitmap.bitmapData = res as BitmapData;	
			}else if(res is Bitmap){
				bitmap.bitmapData = (res as Bitmap).bitmapData;
			}
			
			addChild(bitmap);
			
			
			
		}
		
		public function Update():void{
			x -= m_iSpeed;
			if(x <= m_iAcLeft)
				x = m_iAcRight;
		}
	}
}
package random
{
	public class RondonPos
	{
		
		private static var m_iXLeft:int;
		private static var m_iXRight:int;
		private static var m_iWLeft:int;
		private static var m_iWRight:int;
		
		public static function Init(xl:int, xr:int, wl:int, wr:int):void{
			m_iXLeft = xl;
			m_iXRight = xr;
			m_iWLeft = wl;
			m_iWRight = wr;
			
			//trace(m_iXLeft, m_iXRight, m_iWLeft, m_iWRight);
		}
		
		public static function RondonX():int
		{
			// TODO Auto Generated method stub
			return m_iXLeft + Math.random()*(m_iXRight-m_iXLeft);
		}
		
		public static function RondonWidth():int
		{
			// TODO Auto Generated method stub
			return m_iWLeft + Math.random()*(m_iWRight-m_iWLeft);
		}
		
	}
}
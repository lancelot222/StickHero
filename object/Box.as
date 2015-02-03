package object
{
	import flash.display.Sprite;
	import flash.display3D.IndexBuffer3D;

	public class Box extends Sprite
	{
		public var m_backSpeed:Number;
		public var m_backTickLast:int;
		public var m_preMoveTick:int;
		
		public function Box(posX:int, posY:int, width:int, height:int)
		{
			x = posX; y = posY;
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		public function MoveBack(dis:Number, preTick:int, ticks:int = 15):void{
			m_preMoveTick = preTick;
			m_backTickLast = ticks;
			m_backSpeed = dis / m_backTickLast;
		}
	}
}
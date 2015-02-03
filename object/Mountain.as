package object
{
	public class Mountain extends Box
	{
		public function Mountain(posX:int, posY:int, width:int, height:int)
		{
			super(posX, posY, width, height);
		}
		
		public function Update():void{
			if(m_preMoveTick){
				m_preMoveTick--;
			}else if(m_backTickLast){
				m_backTickLast--;
				x -= m_backSpeed;
			}
			
			//trace(m_preMoveTick.toString() + "     Mountains");
		}
		
	}
}
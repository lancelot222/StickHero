package object
{
	import flash.media.SoundChannel;

	public class Stick extends Box
	{
		
		private var m_bIncrOrNot		:Boolean;
		private var m_intRotat			:int;
		private var m_bRotatSound		:Boolean;
		
		private var m_sStickGrow		:SoundStickGrow;
		private var m_cnStickGrow		:SoundChannel;
		
		private var m_sStickDown		:SoundStickDown;
		private var m_cnStickDown		:SoundChannel;
		
		private var m_preDropTick		:int;
		private var m_intDropRot		:int;
		
		public function Stick(posX:int, posY:int, width:int, height:int)
		{
			super(posX, posY, width, height);
			
			m_bIncrOrNot 	= false;
			rotation 		= 180;
			m_bRotatSound 	= false;
			
			m_sStickGrow = new SoundStickGrow();
			m_sStickDown = new SoundStickDown();
		}
		
		public function Update():void{
			
			if(m_bIncrOrNot){
				height += 10;
				//scaleX += 0.1;
			}else if(m_intRotat > 0){
				rotation += 2;
				m_intRotat -= 2;
				
				if(m_intRotat == 0 && m_bRotatSound){
					m_sStickDown.play();
				}
			}else if(m_preMoveTick){
				m_preMoveTick--;
			}else if(m_backTickLast){
				m_backTickLast--;
				x -= m_backSpeed;
			}else if(m_preDropTick){
				m_preDropTick--;
			}else if(m_intDropRot){
				rotation += 15;
				m_intDropRot -= 15;
				
				if(m_intDropRot == 0){
					m_sStickDown.play();
				}
			}
			
			//trace(m_preMoveTick.toString() + "     Stick");
			//trace(rotation);
			//trace(x, y, width, height);
		}
		
		
		public function SetIncrOrNot(icr:Boolean):void{
			m_bIncrOrNot = icr;
			if(icr)
				m_cnStickGrow = m_sStickGrow.play(0, 100);
			else
				m_cnStickGrow.stop();
		}
		
		public function PlayRotat(rotat:int, withSoound:Boolean = true):void{
			m_intRotat = rotat;
			m_bRotatSound = withSoound;
			
			
		}
		
		public function ReDraw(posX:int, posY:int, width:int, height:int):void{
			x = posX; y = posY;
			rotation = 180;
			scaleY = 1;
			
		}
		
		public function DropDown():void{
			m_preDropTick = 120;
			m_intDropRot = 90;
		}
	}
}
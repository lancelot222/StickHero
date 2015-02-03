package object
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	public class Character extends Sprite
	{
		
		private var m_runSpeed:Number;
		private var m_runTickLast:int;
		private var m_preRunTick:int;
		
		private var m_backSpeed:Number;
		private var m_backTickLast:int;
		private var m_preMoveTick:int;
		
		private var m_dropSpeed:Number;
		private var m_dropTickLast:int;
		private var m_preDropTick:int;
		
		private var m_funCallBack:Function;
		
		private var m_stLoader		:BulkLoader;
		private var bitmap			:Bitmap;
		
		private var m_shRun			:HeroRun;
		private var m_shDrop		:HeroDrop;
		private var m_shStand		:HeroStand;
		
		private var m_sAction		:String;
		
		private var m_sHeroKick		:SoundKick;
		private var m_cnHeroKick	:SoundChannel;
		
		private var m_sHeroDrop		:SoundFallStrong;
		private var m_cnHeroDrop	:SoundChannel;
		
		private var m_sHeroDown		:SoundDie;
		private var m_cnHeroDown	:SoundChannel;
		
		private var m_sRollDown			:RollDown;
		
		public function Character(posX:int, posY:int)
		{
			x = posX; y = posY;
			
			//graphics.beginFill(0x000fff);
			//graphics.drawCircle(0, 0, 10);
			//graphics.endFill();
			
			/*m_stLoader = new BulkLoader("hero");
			m_stLoader.add("resources/hero.png", {id:"hero.png", type : BulkLoader.TYPE_IMAGE});
			m_stLoader.addEventListener(BulkProgressEvent.COMPLETE, OnAddedCompleted);
			m_stLoader.start();*/
			
			m_shRun 	= new HeroRun();
			m_shStand 	= new HeroStand();
			m_shDrop	= new HeroDrop();
			
			m_shStand.scaleX = m_shStand.scaleY = 0.1;
			m_shRun.scaleX	 = m_shRun.scaleY 	= 0.1;
			m_shDrop.scaleX  = m_shDrop.scaleY 	= 0.1;
			
			y -= 18;
			x -= 18;
			
			m_sAction = "Stand";
			addChild(m_shStand);
			
			m_preRunTick = 0;
			m_runTickLast = 0;
			
			m_sHeroKick = new SoundKick();
			m_sHeroDrop = new SoundFallStrong();
			m_sHeroDown = new SoundDie();
			m_sRollDown = new RollDown();
		}
		
		/*protected function OnAddedCompleted(e:BulkProgressEvent):void
		{
			// TODO Auto-generated method stub
			bitmap = new Bitmap();
			
			var res:* = m_stLoader.getContent("hero.png");
			
			if(res is Bitmap){
				bitmap.bitmapData = (res as Bitmap).bitmapData;
			}else if(res is BitmapData){
				bitmap.bitmapData = res as BitmapData;
			}
			
			addChild(bitmap);
			scaleX = scaleY = 0.4;
			y -= bitmap.height*scaleY;
			x -= bitmap.width*scaleX;
			
			
			trace(x, y);
		}*/
		
		public function SetPos(posX:int, posY):void{
			x = posX; y = posY;
			//y -= bitmap.height*scaleY;
			//x -= bitmap.width*scaleX;
			y -= 18;
			x -= 18;
			
			/*if(m_sAction == "Drop"){
				m_shDrop.parent.removeChild(m_shDrop);
				addChild(m_shStand);
				m_sAction = "Stand";
			}else if(m_sAction == "Run"){
				m_shRun.parent.removeChild(m_shRun);
				addChild(m_shStand);
				m_sAction = "Stand";
			}*/
				
			
		}
		
		public function Update():void{
			
			if(m_preRunTick){
				m_preRunTick--;	
				if(m_preRunTick == 0)
					m_cnHeroKick = m_sHeroKick.play(0, 100);
			}else if(m_runTickLast){
				if(m_sAction != "Run"){
					m_shStand.parent.removeChild(m_shStand);
					addChild(m_shRun);
					m_sAction = "Run";
				}
				m_runTickLast--;
				if(m_runTickLast == 0){
					m_shRun.parent.removeChild(m_shRun);
					addChild(m_shStand);
					m_sAction = "Stand";
					m_cnHeroKick.stop();
				}
				x += m_runSpeed;
			}else if(m_preMoveTick){
				parent.mouseEnabled = false;
				m_preMoveTick--;
			}else if(m_backTickLast){
				if(m_sAction != "Stand"){
					m_shRun.parent.removeChild(m_shRun);
					addChild(m_shStand);
					m_sAction = "Stand";
				}
				m_backTickLast--;
				x -= m_backSpeed;
				
				if(m_backTickLast == 0){
					m_sRollDown.play();
					parent.mouseEnabled = true;
				}
			}else if(m_preDropTick){
				m_preDropTick--;
				//m_sHeroDrop.play();
				if(m_sAction != "Drop"){
					m_shStand.parent.removeChild(m_shStand);
					addChild(m_shDrop);
					m_sAction = "Drop";
					//m_sHeroDrop.play();
				}
				if(m_preDropTick == 0){
					//m_sHeroDrop.play();
				}
			}else if(m_dropTickLast){
				/*if(m_sAction != "Drop"){
					m_shStand.parent.removeChild(m_shStand);
					addChild(m_shDrop);
					m_sAction = "Drop";
					m_sHeroDrop.play();
				}*/
				y += m_dropSpeed;
				m_dropTickLast--;
				if(m_dropTickLast == 0){
					m_shDrop.parent.removeChild(m_shDrop);
					addChild(m_shStand);
					m_sAction = "Stand";
					
					m_sHeroDown.play();
					m_funCallBack();
				}
			}
			
			//trace(m_preMoveTick.toString() + "     Char");
		}
		
		public function MoveBack(dis:Number, preTick:int, ticks:int = 15):void{
			m_preMoveTick = preTick;
			m_backTickLast = ticks;
			m_backSpeed = dis / m_backTickLast;
		}
		
		public function PlayRun(dis:Number):void
		{
			// TODO Auto Generated method stub
			m_preRunTick = 60;
			m_runTickLast = 90;
			m_runSpeed = (dis-x) / m_runTickLast;
		}
		
		public function DropDown(callBack:Function):void
		{
			// TODO Auto Generated method stub
			m_preDropTick = 30;
			m_dropSpeed = 15;
			m_dropTickLast = 40;
			m_funCallBack = callBack;
			trace(m_funCallBack);
			trace(callBack);
		}
	}
}
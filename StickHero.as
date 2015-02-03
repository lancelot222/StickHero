package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display3D.IndexBuffer3D;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.ReturnKeyLabel;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import button.MyButton;
	
	import object.Box;
	import object.Character;
	import object.Cloud;
	import object.Mountain;
	import object.Stick;
	
	import random.RondonPos;
	
	[SWF(width="600", height="900", frameRate="60")]
	public class StickHero extends Sprite
	{
		
		private var m_sStick		:Stick;
		private var m_mMountainNow	:Mountain;
		private var m_mMountainNext	:Mountain;
		private var m_pChara		:Character;
		private var m_preFreshTick	:int;
		
		private var m_tfTextField	:TextField;
		private var m_tf4Board		:TextField;
		//private var m_tfTest		:TextField;
		private var m_iScore		:int;
		private var m_mbReStartGame	:MyButton;
		
		private var m_stLoader		:BulkLoader;
		
		private var m_bMouseDownEnable	:Boolean;
		private var m_bMouseUpEnable	:Boolean;
		private var m_bDie				:Boolean;
		
		private var m_sButton			:SoundButton;
		private var m_sBackGround		:SoundBG;
		
		private var m_clouds			:Vector.<Cloud>;
		
		private var m_iFBoard			:int;
		
		public function StickHero()
		{
			if(stage){
				OnAdd2Stage(null);
			}else{
				addEventListener(Event.ADDED_TO_STAGE, OnAdd2Stage);
			}
			
			m_preFreshTick = -1;
		}
		
		protected function OnAdd2Stage(e:Event):void
		{
			//m_tfTest = new TextField();
			m_stLoader = new BulkLoader("LoadBg");
			m_stLoader.add("resources/background.png", {id:"background.png", type : BulkLoader.TYPE_IMAGE});
			m_stLoader.addEventListener(BulkProgressEvent.COMPLETE, OnLoadComplete);
			m_stLoader.start();
			
			m_bMouseDownEnable = m_bMouseUpEnable = true;
			m_bDie = false;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			
			m_sButton 		= new SoundButton();
			m_sBackGround 	= new SoundBG(); 
			//InitScore();
			
		}
		
		
		protected function StartGame():void{
			
			var dirSrc:String = "resources/Cloud.png";
			m_clouds = new Vector.<Cloud>(4, false);
			
			//for(var i:int = 0; i < m_clouds.length; i++)
			m_clouds[0] = new Cloud(dirSrc, "000", -250, 650, 1.8);
			m_clouds[1] = new Cloud(dirSrc, "111", -250, 650, 1.2);
			m_clouds[2] = new Cloud(dirSrc, "222", -250, 650, 1);
			m_clouds[3] = new Cloud(dirSrc, "333", -250, 650, 1);
			
			m_clouds[0].scaleY = m_clouds[0].scaleX = 0.4;
			m_clouds[1].scaleY = m_clouds[1].scaleX = 0.3;
			m_clouds[2].scaleY = m_clouds[2].scaleX = 0.2;
			m_clouds[3].scaleY = m_clouds[3].scaleX = 0.2;
			
			m_clouds[0].y = 50; m_clouds[0].x = 500;
			m_clouds[1].y = 50; m_clouds[1].x = 200;
			m_clouds[2].y = 100;m_clouds[2].x = 400;
			m_clouds[3].y = 30; m_clouds[3].x = 40;
			
			
			addChild(m_clouds[3]);
			addChild(m_clouds[2]);
			addChild(m_clouds[1]);
			addChild(m_clouds[0]);
			
			
			m_mbReStartGame = new MyButton(100, 50);
			addChild(m_mbReStartGame);
			m_mbReStartGame.SetName("ReStart");
			
			m_sBackGround.play(0, 100);
			
			m_iScore = 0;
			m_tfTextField = new TextField();
			m_tfTextField.defaultTextFormat = new TextFormat("Consolas");
			m_tfTextField.text = m_iScore.toString();
			m_tfTextField.autoSize = TextFieldAutoSize.LEFT;
			addChild(m_tfTextField);
			//m_tfTextField.x = stage.stageWidth/3*2;
			//m_tfTextField.y = stage.stageHeight/5;
			m_tfTextField.scaleX = m_tfTextField.scaleY = 5;
			m_tfTextField.x = stage.stageWidth/2 - m_tfTextField.width/2;
			m_tfTextField.y = stage.stageHeight/10 + 200;
			
			m_tf4Board = new TextField();
			m_tf4Board.visible = false;
			m_tf4Board.defaultTextFormat = new TextFormat("Consolas");
			m_tf4Board.autoSize = TextFieldAutoSize.LEFT;
			addChild(m_tf4Board);
			
			
			//m_mbReStartGame.visible = false;
			
			m_mbReStartGame.y = m_tfTextField.y + m_tfTextField.height/2;
			m_mbReStartGame.x = stage.stageWidth - 130;
			
			// TODO Auto-generated method stub
			
			//addChild(new Box(100, 100, 100, 100));
			
			RondonPos.Init(300, 550, 20, 150);
			
			m_mMountainNow = new Mountain(20, 500, 100, 400);
			addChild(m_mMountainNow);
			
			m_mMountainNext = new Mountain(RondonPos.RondonX(), 500, RondonPos.RondonWidth(), 400);
			trace(m_mMountainNext.x, m_mMountainNext.width, RondonPos.RondonWidth());
			addChild(m_mMountainNext);
			
			
			m_sStick = new Stick(m_mMountainNow.x+m_mMountainNow.width, 505, 5, 5);
			addChild(m_sStick);
			
			m_pChara = new Character(m_mMountainNow.x+m_mMountainNow.width, 500);
			addChild(m_pChara);
			//trace(m_sStick.x, m_sStick.y);
			
			
			
			stage.addEventListener(Event.ENTER_FRAME, 	  OnEnterFrame    );
			stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseClickDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,	  OnMouseClickUp  );
			
		}
		
		//public var bitmap:Bitmap;
		
		protected function OnLoadComplete(e:Event):void
		{
			
			
			// TODO Auto-generated method stub
			var bitmap:Bitmap = new Bitmap();
			
			var res:* = m_stLoader.getContent("background.png");
			
			if(res is BitmapData){
				bitmap.bitmapData = res as BitmapData;	
			}else if(res is Bitmap){
				bitmap.bitmapData = (res as Bitmap).bitmapData;
			}
			
			addChild(bitmap);
			//bitmap.scaleX = bitmap.scaleY = 0.6;
			//bitmap.x = 100;
			//bitmap.y = 100;
			
			/*m_tfTest.text = bitmap.toString();
			m_tfTest.width = 200;
			m_tfTest.height = 200;
			addChild(m_tfTest);
			addChild(bitmap);*/
			trace("111");
			
			StartGame();
			
		}
		
		protected function OnEnterFrame(event:Event):void
		{
			// TODO Auto-generated method stub
			m_sStick.Update();
			m_pChara.Update();
			
			m_mMountainNow.Update();
			m_mMountainNext.Update();
			
			m_clouds[0].Update(); m_clouds[1].Update();
			m_clouds[2].Update(); m_clouds[3].Update();
			
			Update();
		}
		
		protected function OnMouseClickUp(event:MouseEvent):void
		{
			if(event.target != stage){
				
				return ;
			}
			
			if(!m_bMouseUpEnable) 
				return ;
			
			//m_sStickGrow = new SoundStickGrow();
			
			m_bMouseUpEnable = false;
			
			trace("uuuuuuuuuuuuuuuuup");
			// TODO Auto-generated method stub
			m_sStick.SetIncrOrNot(false);
			//m_pChara.PlayRun(m_sStick.x+m_sStick.height);
			
			
			var dis:int = m_sStick.x+m_sStick.height;
			
			if(  !(dis >= m_mMountainNext.x && dis <= m_mMountainNext.x+m_mMountainNext.width) ){
				trace(dis);
				trace(m_mMountainNext.x, m_mMountainNext.width+m_mMountainNext.x);
				
				//m_sStick.DropDown();
				m_pChara.PlayRun(m_sStick.x+m_sStick.height);
				m_pChara.DropDown(GameOver);
				//GameOver();
				m_sStick.PlayRotat(90, false);
				m_sStick.DropDown();
				
				m_iFBoard = m_iScore;
			}else{
				
				m_pChara.PlayRun(m_mMountainNext.x + m_mMountainNext.width - m_pChara.width/2 - 15);
				m_sStick.PlayRotat(90);
				
				m_sStick.MoveBack(m_mMountainNext.x-m_mMountainNow.x, 200-45);
				m_pChara.MoveBack(m_mMountainNext.x-m_mMountainNow.x, 200-150);
				m_mMountainNext.MoveBack(m_mMountainNext.x-m_mMountainNow.x, 200);
				m_mMountainNow.MoveBack(m_mMountainNext.x-m_mMountainNow.x, 200);
				
				Fresh(260);
			}
			
			//trace(m_mMountainNext.x+m_mMountainNext.width-15);
		}
		
		protected function OnMouseClickDown(event:MouseEvent):void
		{
			if(event.target is SimpleButton)
			{
				trace(m_bDie);
				if(m_bDie == true)
					ReStart();
				
				return ;
			}
			
			if(event.target != stage)
				return ;
			
			if(!m_bMouseDownEnable) 
				return ;
			
			m_bMouseDownEnable = false;
			
			// TODO Auto-generated method stub
			trace(event.target);
			
			/*if(event.target != stage){
			
			return ;
			}*/
			
			
			m_sStick.ReDraw(m_mMountainNow.x+m_mMountainNow.width, 505, 5, 5);
			m_sStick.SetIncrOrNot(true);
		}
		
		private function ReStart():void
		{
			m_bDie = false;
			m_sButton.play();
			m_tf4Board.visible = false;
			
			// TODO Auto Generated method stub
			//m_pChara
			m_sStick.ReDraw(m_mMountainNow.x+m_mMountainNow.width, 405, 5, 5);
			m_sStick.MoveBack(m_mMountainNext.x-m_mMountainNow.x, 1);
			m_pChara.MoveBack(m_mMountainNext.x-m_mMountainNow.x, 1);
			m_mMountainNext.MoveBack(m_mMountainNext.x-m_mMountainNow.x, 1);
			m_mMountainNow.MoveBack(m_mMountainNext.x-m_mMountainNow.x, 1);
			
			m_pChara.SetPos(m_mMountainNext.x+m_mMountainNext.width, 500);
			
			Fresh(1);
			
			m_iScore = -1;
			m_tfTextField.visible = false;
			m_tfTextField.text = m_iScore.toString();
			m_tfTextField.x = stage.stageWidth/2 - m_tfTextField.width/2;
			m_tfTextField.y = stage.stageHeight/10 + 200;
			//m_tfTextField.background = false;
			
			
			//m_mbReStartGame.visible = false
			
		}		
		
		
		private function Fresh(ticks:int = 260):void
		{
			// TODO Auto Generated method stub
			//m_sStickDown.play();
			trace(ticks);
			m_preFreshTick = ticks;
			
		}
		
		private function Update():void{
			//trace(m_preFreshTick.toString() + "  ~~~~~~~~~~~~~~~~ ");
			
			
			//bitmap.x += 1;
			
			
			
			if(m_preFreshTick > 0){
				m_preFreshTick--;
			}else if(m_preFreshTick == 0){
				
				//trace("ddddddddddddddddddddddddddddd");
				if(m_mMountainNow.parent)
				{
					m_mMountainNow.parent.removeChild(m_mMountainNow);
				}
				m_mMountainNow 	= m_mMountainNext;
				m_mMountainNext = new Mountain(RondonPos.RondonX(), 500, RondonPos.RondonWidth(), 400);
				addChild(m_mMountainNext);
				
				m_iScore++;
				m_tfTextField.text = m_iScore.toString();
				if(m_tfTextField.visible == false){
					m_tfTextField.visible = true;
				}
				
				m_preFreshTick = -1;
				
				m_bMouseDownEnable = m_bMouseUpEnable = true;
			}
		}
		
		public function GameOver():void{
			
			m_tfTextField.text = "Game Over!";
			m_tfTextField.x = stage.stageWidth/2 - m_tfTextField.width/2;
			m_tfTextField.y = stage.stageHeight/10;
			m_bDie = true;
			
			//UpdateScore();
			
			
			/*			m_tfTextField.background = true;
			m_tfTextField.backgroundColor = 0xdddddd;*/
			//m_mbReStartGame.visible = true;
			
			//m_mbReStartGame.y = m_tfTextField.y + m_tfTextField.height;
			//m_mbReStartGame.x = m_tfTextField.x + m_tfTextField.width/2;
		}
		
		
		/*private var t_vScores	:Vector.<int>;
		
		private function InitScore():void{
			t_vScores = new Vector.<int>(3, false);
			t_vScores[0] = t_vScores[1] = t_vScores[2] = 0;
			
			var file:File = File.desktopDirectory.resolvePath("board.txt");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.UPDATE);
			trace(stream.bytesAvailable.toString() + "        avavav");
			if(stream.bytesAvailable == 0)
				for(var i:int = 0; i < 3; i++)
					stream.writeInt(t_vScores[i]);
			stream.close();
		}
		
		private function UpdateScore():void
		{
			// TODO Auto Generated method stub
			
			
			
			//var file:File = new File("./resources/board.txt");
			var file:File = File.desktopDirectory.resolvePath("board.txt");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.UPDATE);
			
			for(var i:int = 0; i < 3; i++)
				t_vScores[i] = stream.readInt()
			stream.close();
			
			//var conti:Boolean = true;
			var t_iIndex:int = 0;
			
			while(t_iIndex < 3){
				if(m_iFBoard > t_vScores[t_iIndex]){
					var tmp:int 		= m_iFBoard;
					m_iFBoard 			= t_vScores[t_iIndex];
					t_vScores[t_iIndex] = tmp;
				}
				t_iIndex++;
			}
			
			file = File.desktopDirectory.resolvePath("board.txt");
			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			for(var i:int = 0; i < 3; i++)
				stream.writeInt(t_vScores[i]);
			
			
			
			m_tf4Board.visible = true;
			m_tf4Board.text  = "第一名		" + (t_vScores[0] as int).toString() + "\n";
			m_tf4Board.text += "第二名		" + (t_vScores[1] as int).toString() + "\n";
			m_tf4Board.text += "第三名		" + (t_vScores[2] as int).toString();
			
			m_tf4Board.scaleX = m_tf4Board.scaleY = 2;
			m_tf4Board.x = stage.stageWidth/2 - m_tf4Board.width/2;
			m_tf4Board.y = m_tfTextField.y + m_tfTextField.height + 100;
			
			
			trace(t_vScores[0]);
			trace(t_vScores[1]);
			trace(t_vScores[2]);
			trace(m_iFBoard.toString() + "    BBBBBBBBBBBBB");
		}*/
	}
}
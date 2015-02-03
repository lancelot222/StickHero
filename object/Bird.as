package object
{
	import flash.display.Sprite;

	public class Bird extends Sprite
	{
		private var m_bFlyBird	: Bird;
		
		public function Bird()
		{
			m_bFlyBird = new Bird();
			addChild(m_bFlyBird);
			
		}
	}
}
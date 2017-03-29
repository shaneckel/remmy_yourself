package crop
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import crop.CropControl;
	
	public class CropStateView extends Sprite
	{
		
		private var _cropControl		:CropControl;
		
		public function CropStateView()
		{
			addEventListener(Event.ADDED, setupChildren);
		}
		
		public function getCropRect():Rectangle
		{
			return _cropControl.getCropRect();
		}
		
		public function reset():void
		{
			_cropControl.resetUI();
		}
		
		private function setupChildren(event:Event):void
		{
			removeEventListener(Event.ADDED, setupChildren);
						
			// Create and add the "crop" control
			_cropControl = new CropControl(615, 460);
			_cropControl.x = 40;
			_cropControl.y = 60;
			
			addChild(_cropControl);
		}
		
	}
}
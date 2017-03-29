package Pages 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event; 
	import flash.events.MouseEvent;
	
	public class ErrorPage extends Sprite
	{
		private var assets			:Error_Clip_Assets = new Error_Clip_Assets();
		private var returnChange	:String;
		
		public function ErrorPage() 
		{
			init();
		}
		private function init():void
		{
			addChild(assets);
			returnChange = "UploadPhoto"; 
			
			assets.hit.addEventListener(MouseEvent.CLICK, dispatchChange);
			assets.hit.buttonMode = true; 
		}
		private function dispatchChange(e:MouseEvent):void
		{
			dispatchEvent(new Event("PAGE_CHANGE", false, false)); 
		}
		public function getChange():String
		{
			return returnChange
		}
		
	}

}
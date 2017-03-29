package  Pages
{
	import flash.display.MovieClip;
	import flash.events.Event; 
	import flash.events.MouseEvent;
	
	public class IntroPage extends MovieClip
	{
		//---- Page Vars ----//
		
		private var _activeObject	:Object;
		
		private var _page			:String				= "IntroPage";
		private var _nextPage		:String				= "PickFrame";
		private var _backPage		:String				= null;
		
		private var assets			:Intro_Page_Assets 	= new Intro_Page_Assets();
		
		//---- Custom Vars ----//
		
		public function IntroPage(activeObject:Object) 
		{
			_activeObject = activeObject; 
			
			addChild(assets);
			
			construct();
		}
		private function construct():void
		{
			assets.hitbax.addEventListener(MouseEvent.CLICK, dispatchChange);
			assets.hitbax.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			assets.hitbax.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			assets.hitbax.buttonMode = true; 
		}
		private function dispatchChange(e:MouseEvent):void
		{
			dispatchEvent(new Event("PAGE_CHANGE", false, false)); 
		}
		private function mouseOver(e:MouseEvent):void
		{
			e.target.alpha = .3; 
		}
		private function mouseOut(e:MouseEvent):void
		{
			e.target.alpha = 0; 
		}
		
		
		// Public Variables
		
		public function getNextPage():String 	{ return _nextPage }
		
		public function getPage():String 		{ return _page }
		
		public function getPageObject():Object
		{
			var returnObject:Object = new Object(); 		
			return returnObject			
		}
	}

}
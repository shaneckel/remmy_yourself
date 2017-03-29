package Pages 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event; 
	import flash.events.MouseEvent;
	
	public class FinishRestart extends Sprite
	{
		//---- Page Vars ----//
		
		private var _activeObject	:Object;
		
		private var _page			:String				= "FinishRestart";
		private var _nextPage		:String				= "PickFrame";
		private var _backPage		:String				= "PickFrame";
		
		private var assets			:Finish_Restart_Assets = new Finish_Restart_Assets();
		
		//---- Custom Vars ----//		
		
		public function FinishRestart(activeObject:Object) 
		{
			_activeObject = activeObject; 
			
			addChild(assets);
			
			construct();
		}
		private function construct():void
		{
			assets.start_again.addEventListener(MouseEvent.CLICK, dispatchChange);
			assets.start_again.addEventListener(MouseEvent.MOUSE_OVER, backOver);
			assets.start_again.addEventListener(MouseEvent.MOUSE_OUT, backOut);
			assets.start_again.buttonMode = true; 
			
			assets.buy_tickets.addEventListener(MouseEvent.CLICK, goToTickets);
			assets.buy_tickets.addEventListener(MouseEvent.MOUSE_OVER, backtickOver);
			assets.buy_tickets.addEventListener(MouseEvent.MOUSE_OUT, backtickOut);
			assets.buy_tickets.buttonMode = true; 
		}
		private function goToTickets(e:MouseEvent):void
		{
			trace("go to tickets");
			
		}
		private function dispatchChange(e:MouseEvent):void
		{
			dispatchEvent(new Event("PAGE_CHANGE", false, false)); 
		}
		private function backOver(e:MouseEvent):void
		{
			assets.start_again.bb.alpha = 1;
		}
		
		private function backOut(e:MouseEvent):void
		{
			assets.start_again.bb.alpha = 0;
		}
		
		private function backtickOver(e:MouseEvent):void
		{
			e.target.alpha = .3;
		}
		
		private function backtickOut(e:MouseEvent):void
		{
			e.target.alpha = 0;
		}
		

		// Public Variables
		
		public function getNextPage():String 	{ return _nextPage }
		
		public function getPage():String 		{ return _page }
		
		public function getPageObject():Object
		{
			var returnObject:Object = new Object(); 				
			return returnObject;			
		}

	}

}
package Pages 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event; 
	import flash.events.MouseEvent;
	import caurina.transitions.*; 
	
	import caurina.transitions.properties.ColorShortcuts;
	ColorShortcuts.init();
	
	import caurina.transitions.properties.FilterShortcuts;
	FilterShortcuts.init();
	
	public class PickFrame extends Sprite
	{
		//---- Page Vars ----//
		
		private var _activeObject	:Object;
		
		private var _page			:String				= "PickFrame";
		private var _nextPage		:String				= "UploadPhoto";
		private var _backPage		:String				= null;
		
		private var assets			:Pick_A_Frame_Assets = new Pick_A_Frame_Assets();
		
		//---- Custom Vars ----//
		
		private var selectedFrame	:String				= "none"; 
		
		public function PickFrame(activeObject:Object) 
		{
			_activeObject = activeObject; 
			
			addChild(assets);
			
			construct();
		}
		
		private function construct():void
		{	
			assets.frame_1.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			assets.frame_1.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			assets.frame_1.addEventListener(MouseEvent.CLICK, frameSelect);
			assets.frame_1.buttonMode = true;
			assets.frame_1.alpha = 0; 
			
			assets.frame_2.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			assets.frame_2.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			assets.frame_2.addEventListener(MouseEvent.CLICK, frameSelect);
			assets.frame_2.buttonMode = true;
			assets.frame_2.alpha = 0; 
			
			assets.frame_3.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			assets.frame_3.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			assets.frame_3.addEventListener(MouseEvent.CLICK, frameSelect);
			assets.frame_3.buttonMode = true;
			assets.frame_3.alpha = 0; 
			
			assets.frame_4.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			assets.frame_4.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			assets.frame_4.addEventListener(MouseEvent.CLICK, frameSelect);
			assets.frame_4.buttonMode = true;
			assets.frame_4.alpha = 0; 
			
			assets.frame_5.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			assets.frame_5.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			assets.frame_5.addEventListener(MouseEvent.CLICK, frameSelect);
			assets.frame_5.buttonMode = true;
			assets.frame_5.alpha = 0;
			
			assets.frame_6.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			assets.frame_6.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			assets.frame_6.addEventListener(MouseEvent.CLICK, frameSelect);
			assets.frame_6.buttonMode = true;
			assets.frame_6.alpha = 0;

		}
		
		private function mouseOver(e:MouseEvent):void
		{
			Tweener.addTween (e.currentTarget, { time: .3, alpha: 1, transition: "easeOutCubic" } );
		}
		
		private function mouseOut(e:MouseEvent):void
		{
			Tweener.addTween (e.currentTarget, {time: .3, alpha: 0, transition: "linear"});
		}
		
		private function frameSelect(e:MouseEvent):void
		{
			selectedFrame = e.currentTarget.name; 
			trace("// Selected Frame " + selectedFrame);
			dispatchEvent(new Event("PAGE_CHANGE", false, false)); 
		}
		
		// Public Variables
		
		public function getNextPage():String 	{ return _nextPage }
		
		public function getPage():String 		{ return _page }
		
		public function getPageObject():Object
		{
			var returnObject:Object = new Object(); 
				returnObject.selectedFrame = selectedFrame;
				
			return returnObject;			
		}
		
	}

}
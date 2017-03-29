package  
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class SliderCust extends SliderCustAssets
	{
		private var _title:String;
		private var changeNum:Number;
		
		public function SliderCust(title:String) 
		{
			titleText.text = title;
			
			down.addEventListener(MouseEvent.CLICK, downClick);
			down.buttonMode = true;
			
			up.addEventListener(MouseEvent.CLICK, upClick);
			up.buttonMode = true;
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
			thumb.buttonMode = true;
			
			addEventListener(MouseEvent.MOUSE_UP, catchUp);
			addEventListener(MouseEvent.ROLL_OUT, catchUp);
		}
		
		private function downClick(e:MouseEvent):void
		{			
			thumb.x -= 5; 
			if (thumb.x <= 15) thumb.x = 15;

			dispatchChange();
		}
		
		private function upClick(e:MouseEvent):void
		{
			thumb.x += 5; 
			if (thumb.x >= 145) thumb.x = 145;
			
			dispatchChange();
		}	
		
		private function thumbDown(e:MouseEvent):void
		{
			addEventListener(Event.ENTER_FRAME, thumbMoving); 
		}	
		
		private function thumbMoving(e:Event):void
		{
			thumb.x = mouseX;
			if (thumb.x <= 15) thumb.x = 15;
			if (thumb.x >= 145) thumb.x = 145;
			
			dispatchChange();
		}
		
		private function catchUp(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, thumbMoving); 
		}
		
		private function dispatchChange():void
		{
			changeNum = ((thumb.x -15) / 130);
			dispatchEvent(new Event("SLIDE_CHANGE", true, true)); 
		}
		
		public function changeNumber():Number
		{
			return changeNum;
		}
	}

}
package crop
{
	import fl.controls.Button;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class CropControl extends Sprite
	{
		// ------- Constants -------
		private static const INIT_WIDTH:Number = 200;
		private static const INIT_HEIGHT:Number = 200;
		private static const BUTTON_SIZE:Number = 16;
		private static const HALF_BUTTON_SIZE:Number = BUTTON_SIZE / 2;
		private static const MIN_SIZE:Number = 100;
		
		
		// ------- Child Controls -------
		private var _tl:Button;
		private var _tr:Button;
		private var _bl:Button;
		private var _br:Button;
		
		
		// ------- Private Properties -------
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		private var _cropRect:Rectangle;
		private var _currentBtn:Button;
		
		
		// ------- Constructor -------
		public function CropControl(maxWidth:Number, maxHeight:Number)
		{
			addEventListener(Event.ADDED, setupChildren);
			_maxWidth = maxWidth;
			_maxHeight = maxHeight;
		}
		
		
		// ------- Public Properties -------
		
		
		// ------- Public Methods -------
		public function getCropRect():Rectangle
		{
			return _cropRect.clone();
		}
		
		
		public function resetUI():void
		{
			var initX:Number = (_maxWidth - INIT_WIDTH) / 2;
			var initY:Number = (_maxHeight - INIT_HEIGHT) / 2;
			
			_cropRect.x = initX;
			_cropRect.y = initY;
			_cropRect.width = INIT_WIDTH;
			_cropRect.height = INIT_HEIGHT;
			
			updateUI();
		}
		
		
		// ------- Protected Methods -------
		
		
		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			removeEventListener(Event.ADDED, setupChildren);
			
			var initX:Number = (_maxWidth - INIT_WIDTH) / 2;
			var initY:Number = (_maxHeight - INIT_HEIGHT) / 2;
			
			_cropRect = new Rectangle(initX, initY, INIT_WIDTH, INIT_HEIGHT);
			
			// Create and add the buttons
			_tl = new Button();
			initButton(_tl);
			
			_tr = new Button();
			initButton(_tr);
			
			_bl = new Button();
			initButton(_bl);
			
			_br = new Button();
			initButton(_br);
			
			updateUI();
		}
		
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			_currentBtn = event.target as Button;
			
			addEventListener(Event.RENDER, renderHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var tempRect:Rectangle = _cropRect.clone();
			
			switch (_currentBtn)
			{
				case _tl:
					tempRect.left = mouseX;
					tempRect.top = mouseY;
					break;
				case _tr:
					tempRect.right = mouseX;
					tempRect.top = mouseY;
					break;
				case _bl:
					tempRect.left = mouseX;
					tempRect.bottom = mouseY;
					break;
				case _br:
					tempRect.right = mouseX;
					tempRect.bottom = mouseY;
					break;
			}
			
			if (tempRect.left < 0)
			{
				tempRect.left = 0;
			}
			if (tempRect.right > _maxWidth)
			{
				tempRect.right = _maxWidth;
			}
			if (tempRect.top < 0)
			{
				tempRect.top = 0;
			}
			if (tempRect.bottom > _maxHeight)
			{
				tempRect.bottom = _maxHeight;
			}
			
			var invalid:Boolean = false;
			if (tempRect.width >= MIN_SIZE)
			{
				_cropRect.left = tempRect.left;
				_cropRect.right = tempRect.right;
				invalid = true;
			}
			
			if (tempRect.height >= MIN_SIZE)
			{
				_cropRect.top = tempRect.top;
				_cropRect.bottom = tempRect.bottom;
				invalid = true;
			}
			
			if (invalid)
			{
				stage.invalidate();
			}
		}
		
		
		private function renderHandler(event:Event):void
		{
			updateUI();
		}
		
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			_currentBtn = null;
			
			removeEventListener(Event.RENDER, renderHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		
		// ------- Private Methods -------
		private function initButton(btn:Button):void
		{
			btn.label = "";
			btn.width = BUTTON_SIZE;
			btn.height = BUTTON_SIZE;
			btn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addChild(btn);
		}
		
		
		private function updateUI():void
		{
			positionButtons();
			drawMatte();
		}
		
		
		private function positionButtons():void
		{
			_tl.x = _cropRect.left - HALF_BUTTON_SIZE;
			_tl.y = _cropRect.top - HALF_BUTTON_SIZE;
			_tr.x = _cropRect.right - HALF_BUTTON_SIZE;
			_tr.y = _cropRect.top - HALF_BUTTON_SIZE;
			_bl.x = _cropRect.left - HALF_BUTTON_SIZE;
			_bl.y = _cropRect.bottom - HALF_BUTTON_SIZE;
			_br.x = _cropRect.right - HALF_BUTTON_SIZE;
			_br.y = _cropRect.bottom - HALF_BUTTON_SIZE;
		}
		
		
		private function drawMatte():void
		{
			var fill:uint = 0x000000;
			var fillAlpha:Number = .5;
			
			var g:Graphics = graphics;
			g.clear();
			
			// draw the gray matte
			g.beginFill(fill, fillAlpha);
			g.drawRect(0, 0, _maxWidth, _cropRect.top);
			g.drawRect(0, _cropRect.top, _cropRect.left, _cropRect.height);
			g.drawRect(_cropRect.right, _cropRect.top, (_maxWidth - _cropRect.right), _cropRect.height);
			g.drawRect(0, _cropRect.bottom, _maxWidth, (_maxHeight - _cropRect.bottom));
			g.endFill();
			
			// draw a transparent rectangle over the crop area to serve as a mouse target
			g.beginFill(fill, 0);
			g.drawRect(_cropRect.x, _cropRect.y, _cropRect.width, _cropRect.height);
			g.endFill();
		}
	}
}
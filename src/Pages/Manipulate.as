package Pages 
{
	import com.bumpslide.ui.Slider;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event; 
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.ui.Mouse; 
	
	import caurina.transitions.*;
	import caurina.transitions.properties.ColorShortcuts;
	ColorShortcuts.init();

	public class Manipulate extends Sprite
	{
		//---- Page Vars ----//
		
		private var _activeObject	:Object;
		
		private var _page			:String					= "Manipulate";
		private var _nextPage		:String					= "Share";
		private var _backPage		:String					= "UploadPhoto";
		
		private var assets			:Manipulate_Assets 		= new Manipulate_Assets();
		
		//---- Custom Vars ----//
		
		private var zoomSlider		:SliderCust				= new SliderCust("zoom");
		private var rotateSlider	:SliderCust				= new SliderCust("rotate");
		private var brightSlider	:SliderCust				= new SliderCust("brightness");
		private var colorSlider		:SliderCust				= new SliderCust("color");
		
		private var moveSprite		:Sprite 				= new Sprite(); 
		
		private var manipSprite		:Sprite 				= new Sprite();  
		
		private var mouseCX			:int;
		private var mouseCY			:int;
		
		private var flipHori		:Boolean				= false;
		
		private var frameClip		:DisplayObjectContainer; 
		
		private var finalClip		:Bitmap; 
		
		private var stachContainer	:StachHold				= new StachHold(); 
		
		private var stachH1			:S1H					= new S1H();
		private var stachH2			:S2H					= new S2H();
		private var stachH3			:S3H					= new S3H();
		private var stachH4			:S4H					= new S4H();
		
		private var movingStach		:StachHolder;
		
		private var mustachQuestionMark	:Boolean 			= false;
		
		private var colorTint		:ColorTinter 			= new ColorTinter();
		
		private var mousePOS		:Number; 
		private var mousePOSRot		:Number; 
		private var mouseStretchPOS	:Number; 
		private var mouseStretchScale:Number; 
		
		private var moveX			:Number;
		private var moveY			:Number; 
		
		public function Manipulate(activeObject:Object) 
		{
			_activeObject = activeObject; 
			
			addChild(assets);
			
			construct();
		}
		
		private function construct():void
		{			
			assets.back_hit.addEventListener(MouseEvent.CLICK, backClick); 
			assets.back_hit.addEventListener(MouseEvent.MOUSE_OVER, backOver); 
			assets.back_hit.addEventListener(MouseEvent.MOUSE_OUT, backOut); 
			assets.back_hit.buttonMode = true; 
			
			switch (_activeObject.selectedFrame) 
			{
				//case "frame_1" 	: frameClip = new frame_1_Class() as DisplayObjectContainer;	break;
				case "frame_2" 	: frameClip = new frame_2_Class() as DisplayObjectContainer;	break;
				case "frame_3" 	: frameClip = new frame_3_Class() as DisplayObjectContainer;	break;
				//case "frame_4" 	: frameClip = new frame_4_Class() as DisplayObjectContainer;	break;
				case "frame_5" 	: frameClip = new frame_5_Class() as DisplayObjectContainer;	break;
				case "frame_6" 	: frameClip = new frame_6_Class() as DisplayObjectContainer;	break;
				default 		: frameClip = new frame_2_Class() as DisplayObjectContainer;
			}
			
			assets.hit.addEventListener(MouseEvent.CLICK, dispatchChange);
			assets.hit.addEventListener(MouseEvent.MOUSE_OVER, mouseOver); 
			assets.hit.addEventListener(MouseEvent.MOUSE_OUT, mouseOut); 
			assets.hit.buttonMode = true; 
			
			assets.addChild(zoomSlider);
			zoomSlider.x = 484;
			zoomSlider.y = 184;
			zoomSlider.addEventListener("SLIDE_CHANGE", zoomChange);
			
			assets.addChild(rotateSlider);
			rotateSlider.x = 484;
			rotateSlider.y = 267;
			rotateSlider.addEventListener("SLIDE_CHANGE", rotateChange);
			
			assets.addChild(brightSlider);
			brightSlider.x = 484;
			brightSlider.y = 351;
			brightSlider.addEventListener("SLIDE_CHANGE", brightChange);
			
			assets.addChild(colorSlider);
			colorSlider.x = 484;
			colorSlider.y = 435; 
			colorSlider.addEventListener("SLIDE_CHANGE", colorChange);
			
			var imageMask:MoveImageMask = new MoveImageMask();
				imageMask.x = 30;
				imageMask.y = 45;		
				
				colorTint.x = 30;
				colorTint.y = 45;
				colorTint.mouseChildren = false;
				colorTint.mouseEnabled = false; 
				colorTint.alpha = 0; 
				
			moveSprite.mask = imageMask; 
			
			manipSprite.addChild(_activeObject.selectedBitmap);
		
			manipSprite.getChildAt(0).x = -(355 / 2);
			manipSprite.getChildAt(0).y = -(355 / 2);
			manipSprite.x = (355 / 2);
			manipSprite.y = (355 / 2);
		
			moveSprite.addChild(manipSprite);
			assets.container.addChild(imageMask);

			moveSprite.addEventListener(MouseEvent.MOUSE_DOWN, moveImageMD); 
			moveSprite.addEventListener(MouseEvent.MOUSE_UP, stopMove); 
			moveSprite.x = 40;
			moveSprite.y = 85;
			
			frameClip.x = 30;
			frameClip.y = 64;
			frameClip.mouseChildren = false;
			frameClip.mouseEnabled = false; 
			
			assets.container.addEventListener(MouseEvent.MOUSE_OVER, fadeImageDown); 
			assets.container.addEventListener(MouseEvent.MOUSE_OUT, fadeImageUp); 
			assets.container.addChild(moveSprite);
			assets.container.addChild(colorTint);
			assets.container.addChild(frameClip);
			assets.container.addEventListener(MouseEvent.ROLL_OUT, stopMove); 
			assets.container.addEventListener(MouseEvent.MOUSE_UP, stopMove); 
			
			assets.xFlipContainer.xFlip.alpha = 0; 
			assets.xFlipContainer.buttonMode = true;
			assets.xFlipContainer.addEventListener(MouseEvent.CLICK, flipHorizontal); 

			assets.stachFlipContainer.xFlip.alpha = 0; 
			assets.stachFlipContainer.buttonMode = true;
			assets.stachFlipContainer.addEventListener(MouseEvent.CLICK, startStach); 
			
			// stach setup 
			
			stachContainer.stachBox.stachmouseless.mouseEnabled = false;
			stachContainer.stachBox.stachmouseless.mouseChildren = false;
			
			stachContainer.stachBox.stach_1.buttonMode = true;
			stachContainer.stachBox.stach_1.addEventListener(MouseEvent.MOUSE_OVER, stachHover);
			stachContainer.stachBox.stach_1.addEventListener(MouseEvent.MOUSE_OUT, stachOut);
			stachContainer.stachBox.stach_1.addEventListener(MouseEvent.CLICK, stachselect);
			
			stachContainer.stachBox.stach_2.buttonMode = true;
			stachContainer.stachBox.stach_2.addEventListener(MouseEvent.MOUSE_OVER, stachHover);
			stachContainer.stachBox.stach_2.addEventListener(MouseEvent.MOUSE_OUT, stachOut);
			stachContainer.stachBox.stach_2.addEventListener(MouseEvent.CLICK, stachselect);
			
			stachContainer.stachBox.stach_3.buttonMode = true;
			stachContainer.stachBox.stach_3.addEventListener(MouseEvent.MOUSE_OVER, stachHover);
			stachContainer.stachBox.stach_3.addEventListener(MouseEvent.MOUSE_OUT, stachOut);
			stachContainer.stachBox.stach_3.addEventListener(MouseEvent.CLICK, stachselect);
			
			stachContainer.stachBox.stach_4.buttonMode = true;
			stachContainer.stachBox.stach_4.addEventListener(MouseEvent.MOUSE_OVER, stachHover);
			stachContainer.stachBox.stach_4.addEventListener(MouseEvent.MOUSE_OUT, stachOut);
			stachContainer.stachBox.stach_4.addEventListener(MouseEvent.CLICK, stachselect);
			
			stachContainer.stachBox.cancel.buttonMode = true;
			stachContainer.stachBox.cancel.addEventListener(MouseEvent.CLICK, cancelStach);
		}
		
		private function stachHover(e:MouseEvent):void
		{
			Tweener.addTween(e.target, { alpha: 1, transition: "linear", time: .1 } ); 
		}
		
		private function stachOut(e:MouseEvent):void
		{
			Tweener.addTween(e.target, { alpha: 0, transition: "linear", time: .2 } ); 
		}
		
		private function stachselect(e:MouseEvent):void
		{			
			if (e.target.name == "stach_1") replaceMouseWithStach(stachH1);
			if (e.target.name == "stach_2") replaceMouseWithStach(stachH2);
			if (e.target.name == "stach_3") replaceMouseWithStach(stachH3);
			if (e.target.name == "stach_4") replaceMouseWithStach(stachH4);
			
		}
		private function replaceMouseWithStach(stach:MovieClip):void
		{
			movingStach = new StachHolder();
			
			movingStach.stachClip.addChild(stach);
			
			movingStach.name = "movingStach";
			movingStach.mouseChildren = false;
			movingStach.mouseEnabled = false;
			
			stachContainer.stachMover.addChild(movingStach);
			
			stachContainer.stachBox.alpha = 0;
			stachContainer.stachBox.x = 1200;
			
			//Mouse.hide(); 
			
			stachContainer.stachMover.mouseActivity.addEventListener(MouseEvent.MOUSE_OVER, stachMouseOver );
			stachContainer.stachMover.mouseActivity.addEventListener(MouseEvent.MOUSE_OUT, stachMouseOut );
			stachContainer.stachMover.mouseActivity.addEventListener(MouseEvent.MOUSE_MOVE, stachMouseMove);
			
			movingStach.x = stachContainer.stachMover.mouseActivity.mouseX - (movingStach.width * .5);
			movingStach.y = stachContainer.stachMover.mouseActivity.mouseY - (movingStach.height * .5);		
			
			addEventListener(MouseEvent.MOUSE_UP, confirmStachClick);

		}
		private function stachMouseOver(e:MouseEvent):void {Mouse.hide();}
		private function stachMouseOut(e:MouseEvent):void {Mouse.show();}

		private function stachMouseMove(e:MouseEvent):void
		{
			movingStach.x = stachContainer.stachMover.mouseActivity.mouseX ;//+ (movingStach.width * .5);
			movingStach.y = stachContainer.stachMover.mouseActivity.mouseY ;//+ (movingStach.height * .5);			
		}
		private function confirmStachClick(e:MouseEvent):void
		{
			Mouse.show(); 

			stachContainer.stachMover.mouseActivity.removeEventListener(MouseEvent.MOUSE_OVER, stachMouseOver );
			stachContainer.stachMover.mouseActivity.removeEventListener(MouseEvent.MOUSE_OUT, stachMouseOut );
			stachContainer.stachMover.mouseActivity.removeEventListener(MouseEvent.MOUSE_MOVE, stachMouseMove);
			
			removeEventListener(MouseEvent.MOUSE_UP, confirmStachClick);

			//stachClicks
			
			movingStach.mouseChildren = true;
			movingStach.mouseEnabled = true;
			
			movingStach.stretch.buttonMode = true;
			movingStach.stretch.addEventListener(MouseEvent.MOUSE_DOWN, stretchDown); 
			
			movingStach.spin.buttonMode = true;
			movingStach.spin.addEventListener(MouseEvent.MOUSE_DOWN, spinDown); 
			
			movingStach.stachClip.addEventListener(MouseEvent.MOUSE_DOWN, stachMoverAfter);
			
			//stachClicks
			
			var confirmStach:ConfirmStach = new ConfirmStach();
				confirmStach.x = 400; 
				confirmStach.y = 300;
				
				confirmStach.yes.addEventListener(MouseEvent.CLICK, confirmClick)
				confirmStach.yes.buttonMode = true; 
				
				confirmStach.no.addEventListener(MouseEvent.CLICK, noClick)
				confirmStach.no.buttonMode = true; 
				
				confirmStach.name = "confirmStach"; 
				
			stachContainer.addChild(confirmStach);
		}
		private function confirmClick(e:MouseEvent):void
		{
			assets.stachFlipContainer.xFlip.alpha = 1; 
			mustachQuestionMark = true;
			
			stachContainer.stachMover.removeChild(stachContainer.stachMover.getChildByName("movingStach"));
			
			stachContainer.removeChild(stachContainer.getChildByName("confirmStach"));
			
			removeChild(stachContainer); 
			
			movingStach.name = "movingStach";
			movingStach.x += 16;
			movingStach.y += 40;
			
			assets.container.addChild(movingStach);
		}
		private function spinDown(e:MouseEvent):void 
		{
			mousePOS = mouseY;
			mousePOSRot = movingStach.rotation;
			
			addEventListener(MouseEvent.MOUSE_MOVE, spinMove); 
			addEventListener(MouseEvent.MOUSE_UP, spinUp); 			
		}
		private function spinMove(e:MouseEvent):void
		{			
			var changeNum:Number = mousePOSRot + (-(mouseY -mousePOS)); 
			
			if (changeNum > 50) changeNum = 50;
			if (changeNum < -50) changeNum = -50;
			
			Tweener.addTween( movingStach, { rotation: changeNum, transition: "linear" } ); 
		}
		private function spinUp(e:MouseEvent):void 
		{ 
			removeEventListener(MouseEvent.MOUSE_MOVE, spinMove);
			removeEventListener(MouseEvent.MOUSE_UP, spinUp); 			
		}
		private function stretchDown(e:MouseEvent):void
		{
			mouseStretchPOS = mouseX ; 
			mouseStretchScale = movingStach.stachClip.scaleX; 
			
			addEventListener(MouseEvent.MOUSE_MOVE, stretchMove); 
			addEventListener(MouseEvent.MOUSE_UP, stretchUp); 			
		}
		
		private function stretchMove(e:MouseEvent):void
		{			
			var changeNum:Number = mouseStretchScale + (-( mouseStretchPOS - mouseX)/100); 
			
			if (changeNum > 1.6) changeNum = 1.6;
			if (changeNum < .6) changeNum = .6;
			
			movingStach.stretch.x = (movingStach.stachClip.width * .5) + 2; 
			movingStach.spin.x = -(movingStach.stachClip.width * .5) - 34; 
			
			Tweener.addTween(movingStach.stachClip, { scaleX: changeNum, scaleY: changeNum, transition: "linear" } );
		}
		
		private function stretchUp(e:MouseEvent):void 
		{  
			removeEventListener(MouseEvent.MOUSE_MOVE, stretchMove);
			removeEventListener(MouseEvent.MOUSE_UP, stretchUp); 			
		}		
		private function stachMoverAfter(e:MouseEvent):void
		{
			moveX = movingStach.mouseX;
			moveY = movingStach.mouseY;
			
			addEventListener(MouseEvent.MOUSE_MOVE, moveStachAgain);
			addEventListener(MouseEvent.MOUSE_UP, stopMoveStachAgain);
		}
		private function moveStachAgain(e:MouseEvent):void
		{			
			var ychange:Number = assets.container.mouseY - moveY;
			var xchange:Number = assets.container.mouseX - moveX;
			
			if(ychange > 420) ychange = 420;
			if(ychange < 130) ychange = 130;		
			
			if(xchange > 275) xchange = 275;
			if(xchange < 130) xchange = 130;
			
			movingStach.x = xchange;
			movingStach.y = ychange;
		}
		private function stopMoveStachAgain(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, moveStachAgain);
			removeEventListener(MouseEvent.MOUSE_UP, stopMoveStachAgain);
		}
		private function noClick(e:MouseEvent):void
		{
			mustachQuestionMark = false;
			stachContainer.stachMover.removeChild(stachContainer.stachMover.getChildByName("movingStach"));
			
			stachContainer.removeChild(stachContainer.getChildByName("confirmStach"));
			
			removeChild(stachContainer); 
		}
		private function cancelStach(e:MouseEvent):void
		{
			removeChild(stachContainer); 
		}
		
		private function startStach(e:MouseEvent):void
		{
			if (mustachQuestionMark)
			{
				if (assets.container.getChildByName("movingStach"))
				{
					assets.container.removeChild(assets.container.getChildByName("movingStach"));
				}
				mustachQuestionMark = false;
				assets.stachFlipContainer.xFlip.alpha = 0; 
			}
			else
			{
				mustachQuestionMark = true;
				

				if (assets.container.getChildByName("movingStach"))
				{
					assets.container.removeChild(assets.container.getChildByName("movingStach"));
				}
				
				stachContainer.stachBox.alpha = 1;
				stachContainer.stachBox.x = 54;

				addChild(stachContainer); 
			}
		}		
		private function fadeImageDown(e:MouseEvent):void
		{
			if (movingStach) 
			{
				Tweener.addTween(movingStach.stretch, { alpha : 1, transition: "linear", time: .2 } ); 
				Tweener.addTween(movingStach.spin, { alpha : 1, transition: "linear", time: .2 } ); 
			}
			Tweener.addTween(frameClip, { alpha: .7, time: .2, transition: "linear" } );
		}
		private function fadeImageUp(e:MouseEvent):void
		{
			if (movingStach) 
			{
				Tweener.addTween(movingStach.stretch, { alpha : 0, transition: "linear", time: .2 } ); 
				Tweener.addTween(movingStach.spin, { alpha : 0, transition: "linear", time: .2 } ); 
			}
			Tweener.addTween(frameClip, { alpha: 1, time: .2, transition: "linear" } );
		}
		private function moveImageMD(e:MouseEvent):void
		{
			mouseCX = moveSprite.mouseX;
			mouseCY = moveSprite.mouseY;
			addEventListener(Event.ENTER_FRAME, moveImage);
			
		}
		private function moveImage(e:Event):void
		{
			moveSprite.x = assets.container.mouseX - mouseCX;
			moveSprite.y = assets.container.mouseY - mouseCY;
		}
		private function stopMove(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, moveImage);
		}
		private function dispatchChange(e:MouseEvent):void
		{
			if (movingStach)
			{
				movingStach.stretch.alpha = 0;
				movingStach.spin.alpha = 0;
			}

			var finalBitmapData:BitmapData = new BitmapData(445, 540, false, 0xf36f25); 
				finalBitmapData.draw(assets.container); 
			
			finalClip = new Bitmap(finalBitmapData, PixelSnapping.NEVER, true); 
			
			dispatchEvent(new Event("PAGE_CHANGE", false, false)); 
		}
		
		// Changes
		
		private function flipHorizontal(e:MouseEvent):void
		{
			if (flipHori == true )
			{
				assets.xFlipContainer.xFlip.alpha = 0; 
			}
			if (flipHori == false )
			{
				assets.xFlipContainer.xFlip.alpha = 1; 
			}
			
			flip();
		}
		
		private function flip():void
		{
			manipSprite.scaleX = -manipSprite.scaleX;				
			if (flipHori) { flipHori = false}else{flipHori = true}
		}
		
		private function zoomChange(e:Event):void
		{
			if (flipHori)
			{
				manipSprite.scaleX = -(e.target.changeNumber() * 2);	
			}
			else
			{
				manipSprite.scaleX = (e.target.changeNumber() * 2);
			}
			manipSprite.scaleY = (e.target.changeNumber() * 2);	
		}
		
		private function rotateChange(e:Event):void
		{
			Tweener.addTween(manipSprite, { rotation: ( e.target.changeNumber() -.5) * 90} );
		}
		
		private function brightChange(e:Event):void
		{
			Tweener.addTween(manipSprite, { _brightness: e.target.changeNumber() -.5 } );
		}
		
		private function colorChange(e:Event):void
		{
			Tweener.addTween(manipSprite, { _saturation: e.target.changeNumber() +.5 } );
			Tweener.addTween(colorTint, { alpha: e.target.changeNumber() -.5} ); 
		}
		
		// mouse hit
		
		private function backClick(e:MouseEvent):void
		{
			dispatchEvent(new Event("PAGE_CHANGE_BACK", false, false)); 
		}
		
		private function backOver(e:MouseEvent):void
		{
			assets.back_hit.bb.alpha = 1;
		}
		
		private function backOut(e:MouseEvent):void
		{
			assets.back_hit.bb.alpha = 0;
		}	
		private function mouseOver(e:MouseEvent):void
		{
			e.target.alpha = .7; 
		}
		private function mouseOut(e:MouseEvent):void
		{
			e.target.alpha = 1; 
		}
		
		// Public Variables
		
		public function getNextPage():String 	{ return _nextPage }
		
		public function getPage():String 		{ return _page }

		public function getBackPage():String 	{ return _backPage }
		
		public function getPageObject():Object
		{
			var returnObject:Object = new Object(); 	
				returnObject.finalFrame = finalClip; 
			return returnObject;			
		}
		
	}

}
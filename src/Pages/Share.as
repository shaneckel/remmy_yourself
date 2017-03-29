package Pages 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event; 
	import flash.events.MouseEvent;
    import flash.net.FileReference;
    import flash.net.FileFilter;
	import flash.display.Bitmap;
	import flash.display.BitmapData; 
	import flash.utils.ByteArray; 
	import flash.display.Loader;
	import flash.net.URLRequest; 
	import flash.events.IOErrorEvent;
	import flash.errors.IOError;
	 import flash.display.IBitmapDrawable; 
	 
	import com.adobe.images.JPGEncoder; 
	import com.adobe.images.PNGEncoder; 
	
	import flash.display.PixelSnapping; 
	
	public class Share extends Sprite
	{
		//---- Page Vars ----//
		
		private var _activeObject	:Object;
	
		private var _page			:String			= "Share";
		private var _nextPage		:String			= "FinishRestart";
		private var _backPage		:String			= "Manipulate";

		private var assets			:Share_Assets 	= new Share_Assets();
		
		//---- Custom Vars ----//
		private	var finalImage		:Sprite 		= new Sprite();

	    private var imgFile			:URLRequest;
        private var img				:MovieClip;
        private var imgLoader		:Loader;
        private var file			:FileReference;	
		private var bitmap			:BitmapData; 
		private var finalBitmap		:Bitmap;
		private var dupBitmap		:Bitmap;
		
		public function Share(activeObject:Object) 
		{
			_activeObject = activeObject; 
			
			addChild(assets);
			
			init();
		}
		
		private function init():void
		{							
			finalImage.addChild(_activeObject.finalFrame); 
			
			finalBitmap = _activeObject.finalFrame; 
			
			var bitmapData:BitmapData = new BitmapData( finalImage.width , finalImage.height, true);
				bitmapData.draw( finalImage as IBitmapDrawable );
			
			var dupmap:Bitmap = new Bitmap( bitmapData, PixelSnapping.NEVER, true );
			
			var spriteHold:Sprite = new Sprite();
				spriteHold.addChild(dupmap); 
				
				spriteHold.scaleX = .56;
				spriteHold.scaleY = .56;
				spriteHold.y = 14;
				spriteHold.x = 13;
			
			assets.exportHolder.addChild(spriteHold); 
			
			finalImage.x = 28;
			finalImage.y = 97;
			
			addChild(finalImage); 
			
			assets.back_hit.addEventListener(MouseEvent.CLICK, backClick); 
			assets.back_hit.addEventListener(MouseEvent.MOUSE_OVER, backOver); 
			assets.back_hit.addEventListener(MouseEvent.MOUSE_OUT, backOut); 
			assets.back_hit.buttonMode = true; 
			
			assets.save.addEventListener(MouseEvent.CLICK, saveChange);
			assets.save.addEventListener(MouseEvent.MOUSE_OVER, mouseOver); 
			assets.save.addEventListener(MouseEvent.MOUSE_OUT, mouseOut); 
			assets.save.buttonMode = true; 
			
			assets.share.addEventListener(MouseEvent.CLICK, shareChange);
			assets.share.addEventListener(MouseEvent.MOUSE_OVER, mouseOver); 
			assets.share.addEventListener(MouseEvent.MOUSE_OUT, mouseOut); 
			assets.share.buttonMode = true;			
		
			assets.email.addEventListener(MouseEvent.CLICK, shareChange);
			assets.email.addEventListener(MouseEvent.MOUSE_OVER, mouseOver); 
			assets.email.addEventListener(MouseEvent.MOUSE_OUT, mouseOut); 
			assets.email.buttonMode = true;
		}
		
		private function saveChange(e:MouseEvent):void
		{
            var myBitmapData:BitmapData = new BitmapData(249, 494, true, 0xf26f26);
				myBitmapData.draw(assets.exportHolder);
           
		
			var encoding:PNGEncoder = new PNGEncoder();
			
			var bitdata:ByteArray = PNGEncoder.encode(myBitmapData);
            
			file = new FileReference();
            file.save(bitdata, "Rembrandt_Yourself.png");
			
			file.addEventListener(Event.COMPLETE, saveCompleteHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, saveIOErrorHandler);
        }
		private function saveCompleteHandler(e:Event):void
		{
			trace("sssssaved");
			dispatchEvent(new Event("PAGE_CHANGE", false, false)); 
		}
		private function saveIOErrorHandler(e:IOErrorEvent):void
		{
			trace("Oh shit error. here's the error \n" + e + "\n" );
		}
		private function shareChange(e:MouseEvent):void
		{
			
		}
		
		private function dispatchChange(e:MouseEvent):void
		{
			dispatchEvent(new Event("PAGE_CHANGE", false, false)); 
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
			return returnObject;			
		}
		
	}

}
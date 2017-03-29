package Pages 
{
	import crop.CropStateView;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event; 
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video; 
	import flash.display.BitmapData; 
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import caurina.transitions.*; 
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Point; 
	import flash.ui.Mouse;
	
	import com.bumpslide.util.ImageUtil;
	import caurina.transitions.*;
	import caurina.transitions.properties.FilterShortcuts;
	FilterShortcuts.init();
	public class UploadPhoto extends Sprite
	{
		//---- Page Vars ----//
		
		private var _activeObject	:Object;
		
		private var _page			:String				= "UploadPhoto";
		private var _nextPage		:String				= "Manipulate";
		private var _backPage		:String				= "PickFrame";
		
		private var assets			:Upload_A_Photo_Assets 	= new Upload_A_Photo_Assets();
		
		//---- Custom Vars ----//		
		
		private var videoHold		:Sprite				= new Sprite(); 
		private var frameClip		:DisplayObjectContainer; 
		private var camCoverClip	:CamCover			= new CamCover();
		private	var video			:Video 				= new Video();
		private var bitmapData		:BitmapData;
		private var bitmap			:Bitmap;
		private var bitmapSprite	:Sprite				= new Sprite(); 
		private var faceBox			:FaceSelectBox 		= new FaceSelectBox(); 
			
		private var browserCover	:BrowseCover		= new BrowseCover(); 
		private var mFileReference	:FileReference;
		private var _cropStateView	:CropStateView		= new CropStateView(); 
		private var editRect		:Rectangle			= new Rectangle(40, 60, 615, 460);
		
		private var browseBit		:Bitmap				= new Bitmap(); 
		
		private var bitmapHolder 	:Sprite 			= new Sprite(); 
		
		public function UploadPhoto(activeObject:Object) 
		{
			_activeObject = activeObject; 
			
			addChild(assets);
			
			construct();
		}
		
		private function construct():void
		{	
			
			_cropStateView.name = "cropstateview"; 
			bitmapHolder.name = "bitmapHolder";
			
			assets.BrowseComp.addEventListener(MouseEvent.CLICK, browseCover);
			assets.BrowseComp.addEventListener(MouseEvent.MOUSE_OVER, tryOver);
			assets.BrowseComp.addEventListener(MouseEvent.MOUSE_OUT, tryOut);
			assets.BrowseComp.buttonMode = true;
			
			assets.openWebCam.addEventListener(MouseEvent.CLICK, webCamCover);
			assets.openWebCam.addEventListener(MouseEvent.MOUSE_OVER, tryOver);
			assets.openWebCam.addEventListener(MouseEvent.MOUSE_OUT, tryOut);
			assets.openWebCam.buttonMode = true;
			
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
			
			addChild(frameClip);
			//Tweener.addTween (frameClip, {_DropShadow_alpha: .3 , _DropShadow_blurX: 12 , _DropShadow_blurY: 12, _DropShadow_distance: 4 , _DropShadow_strength: 1});
			
			frameClip.x = 50;
			frameClip.y = 160;
		}
		
			//webcam <--
		
		private function startWebCam():void
		{	
				//faceBox.x = 258;
				//faceBox.y = 477; 
			var videoMask	:VidMask = new VidMask(); 
				videoMask.x = 180; 
				videoMask.y = 155; 
				
			var bitmapMask	:VidMask = new VidMask(); 
				bitmapMask.x = 0; 
				bitmapMask.y = 0; 
				
			var camera		:Camera = Camera.getCamera();
			
			if (!camera) 
			{
                trace("No camera is installed.");
			}
			else
			{
				
				camera.setQuality(0, 100);
                camera.setMode(800, 600, 15)	
				video = new Video();
				video.attachCamera(camera);
				video.width = 480;
				video.height = 350;
				
				//video.height = 355;
				
				video.x = 100; 
				video.y = 155; 
					
				// capture addition
				bitmapData = new BitmapData(355, 355);
				bitmap = new Bitmap(bitmapData, PixelSnapping.NEVER , true);
				bitmap.smoothing = true;

				bitmapSprite.x = 180;
				bitmapSprite.y = 155;
				bitmapSprite.alpha = 0; 
				
				// capture addition
				videoHold.addChild(video); 
				videoHold.addChild(videoMask);
				
				videoHold.mask = videoMask;
				
				camCoverClip.addChild(videoHold);
				
				//bitmapSprite.addChild(bitmap); 
				bitmapSprite.addChild(bitmapMask);
				bitmapSprite.mask = bitmapMask;
				
				camCoverClip.addChild(bitmapSprite);			
		
				camCoverClip.capture.addEventListener(MouseEvent.CLICK, captureImage); 
				camCoverClip.capture.addEventListener(MouseEvent.MOUSE_OVER, tryOver);
				camCoverClip.capture.addEventListener(MouseEvent.MOUSE_OUT, tryOut);
				camCoverClip.capture.buttonMode = true;			
				
				camCoverClip.cancel_capture.addEventListener(MouseEvent.CLICK, cancelCapture); 
				camCoverClip.cancel_capture.buttonMode = true;		
			}
		}
		private function captureImage(e:MouseEvent):void
		{
			var spriteHold	:BrowseBack = new BrowseBack(); 
				spriteHold.name = "background";
				
						
			spriteHold.keep_hold.tryagain.addEventListener(MouseEvent.CLICK, webCamTryAgain);
			spriteHold.keep_hold.tryagain.addEventListener(MouseEvent.MOUSE_OVER, tryOver);
			spriteHold.keep_hold.tryagain.addEventListener(MouseEvent.MOUSE_OUT, tryOut);
			spriteHold.keep_hold.tryagain.buttonMode = true;
			
			spriteHold.keep_hold.keep.addEventListener(MouseEvent.CLICK, dispatchChange);
			spriteHold.keep_hold.keep.addEventListener(MouseEvent.MOUSE_OVER, tryOver);
			spriteHold.keep_hold.keep.addEventListener(MouseEvent.MOUSE_OUT, tryOut);
			spriteHold.keep_hold.keep.buttonMode = true;
			
			//camCoverClip.addChild(faceBox);
			//faceBox.alpha = 1; 

			bitmapSprite.alpha = 1; 
			camCoverClip.image_select.select.alpha = 1; 
			
			var mat:Matrix = new Matrix ();
				mat.translate(-60, -10);
				mat.scale(1.7, 1.7); 
			
			bitmapData.draw(video, mat);
			var maskCover:VidMask = new VidMask();
				maskCover.x = 172;
				maskCover.y = 115; 
			
			var bitMapContainer:Sprite = new Sprite();
				bitMapContainer.x = 172;
				bitMapContainer.y = 115; 
				
				bitMapContainer.mask = maskCover;
				
			bitMapContainer.addChild(bitmap); 
			
			//spriteHold.addChild(bitmap);
			
			spriteHold.addChild(bitMapContainer);
			spriteHold.addChild(maskCover);
			
			addChild(spriteHold);
		}
		private function webCamTryAgain(e:MouseEvent):void
		{
			removeChild(getChildByName("background")); 
		}
		private function hideCamCover():void
		{
			camCoverClip.y = -850;
			camCoverClip.image_select.select.alpha = 0; 
		}
		private function cancelCapture(e:MouseEvent):void
		{
			Tweener.addTween(camCoverClip, { alpha: 0, transition: "linear", time: .4, onComplete: hideCamCover } ); 
			
			if (camCoverClip.faceBox)
			{
				camCoverClip.removeChild(faceBox);
				faceBox.tryagain.removeEventListener(MouseEvent.CLICK, webCamTryAgain);
				faceBox.keep.removeEventListener(MouseEvent.CLICK, dispatchChange);
			}
			bitmapSprite.alpha = 0; 
			camCoverClip.image_select.select.alpha = 0; 
			
			video.attachCamera(null);
		}
		private function webCamCover(e:MouseEvent):void
		{
			camCoverClip.y = 0;
			camCoverClip.alpha = 0;
			camCoverClip.image_select.select.alpha = 0; 
			
			faceBox.alpha = 0; 

			addChild(camCoverClip);
			
			Tweener.addTween(camCoverClip, { alpha: 1, transition: "linear", time: .4, onComplete: startWebCam} ); 
		}		
		
		
		//webcam-->
		
		
		//browse<--
		
		
		private function startBrowse():void
		{
			mFileReference.removeEventListener(Event.SELECT, onFileSelected);						
			mFileReference.addEventListener(Event.COMPLETE, onFileLoaded);
			mFileReference.load();

		}
		private function browseCover(e:MouseEvent):void
		{
			mFileReference = new FileReference();
			mFileReference.addEventListener(Event.SELECT, onFileSelected);
			var fileTypeFilter:FileFilter = new FileFilter("Images: (*.jpeg, *.jpg, *.gif, *.png)", "*.jpeg; *.jpg; *.gif; *.png");
			mFileReference.browse([fileTypeFilter]);			
		}
		private function onFileSelected(e:Event):void
		{
			browserCover.y = 0;
			browserCover.alpha = 0;
			browserCover.image_select.alpha = 0; 
			
			addChild(browserCover);
			
			Tweener.addTween(browserCover, { alpha: 1, transition: "linear", time: .4, onComplete: startBrowse} ); 
		}
		private function onFileLoaded(e:Event):void
		{			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
			loader.loadBytes(mFileReference.data);
			
			
		}
		private function loadBytesHandler(e:Event):void
		{
			var loaderInfo:LoaderInfo = (e.target as LoaderInfo);
				loaderInfo.removeEventListener(Event.COMPLETE, loadBytesHandler);	
			
			showImage(Bitmap(loaderInfo.content));
			
			browserCover.image_select.alpha = 1; 

		}
		private function showImage(bitmap:DisplayObject):void
		{
			bitmapHolder.x = 40;
			bitmapHolder.y = 60;
			
			bitmapHolder.addChild(bitmap);
			
			browserCover.addChild(bitmapHolder);
			browserCover.addChild(_cropStateView); 
			
			_cropStateView.reset();
			
			if (bitmap.width > editRect.width || bitmap.height > editRect.height)
			{
				var hRatio:Number = bitmap.width / editRect.width;
				var vRatio:Number = bitmap.height / editRect.height;
				
				if (hRatio >= vRatio)
				{
					bitmap.width = editRect.width;
					bitmap.scaleY = bitmap.scaleX;
				}
				else
				{
					bitmap.height = editRect.height;
					bitmap.scaleX = bitmap.scaleY;
				}
			}
			
			bitmap.x = (editRect.width - bitmap.width) / 2;
			bitmap.y = (editRect.height - bitmap.height) / 2;
			
			browserCover.crop.addEventListener(MouseEvent.CLICK, catchCrop); 
			browserCover.crop.buttonMode = true;
			browserCover.crop.addEventListener(MouseEvent.MOUSE_OVER, tryOver);
			browserCover.crop.addEventListener(MouseEvent.MOUSE_OUT, tryOut);

			
			browserCover.cancel_capture.addEventListener(MouseEvent.CLICK, noCropFoME); 
			browserCover.cancel_capture.buttonMode = true;
			
		}
		private function hideBrowseCover():void
		{
			browserCover.y = -850;			
		}
		private function noCropFoME(e:MouseEvent):void
		{
			bitmapHolder.removeChildAt(0);			
			
			browserCover.removeChild(browserCover.getChildByName("cropstateview"));
			
			browserCover.removeChild(browserCover.getChildByName("bitmapHolder"));
			
			Tweener.addTween(browserCover, { alpha: 0, transition: "linear", time: .4, onComplete: hideBrowseCover}); 
		}
		private function catchCrop(e:MouseEvent):void
		{						
			var videoMask	:VidMask = new VidMask(); 
				videoMask.x = 2; 
				videoMask.y = 2; 
				
			var spriteHold	:BrowseBack = new BrowseBack(); 
				spriteHold.name = "background";
			
			browserCover.image_select.alpha = 1; 
			
			var cropRect:Rectangle = _cropStateView.getCropRect();
			
			var origData:BitmapData = new BitmapData(cropRect.width, cropRect.height);
				
			var shiftOrigin:Matrix = new Matrix();
				shiftOrigin.translate(-cropRect.x, -cropRect.y);
				origData.draw(bitmapHolder, shiftOrigin);
				
			var origDataBitmap:Bitmap = new Bitmap(origData, PixelSnapping.NEVER, true); 
			
			var	origDataBitmapHold:Sprite = new Sprite(); 		
			
			var bitmapData:BitmapData = origData.clone();
				bitmapData.draw(origDataBitmap); 
				
				bitmap = new Bitmap(bitmapData, PixelSnapping.NEVER, true); 
				bitmap.width = 355;
				bitmap.height = 355; 
		
			var bothHolder:Sprite = new Sprite(); 
				bothHolder.name = "bothhold"; 
			
			var resizeDataBitmapHold:Sprite = new Sprite(); 
			
				bothHolder.addChild(resizeDataBitmapHold);
				bothHolder.addChild(videoMask); 
				bothHolder.x = 170;
				bothHolder.y = 113;
			
			resizeDataBitmapHold.addChild(bitmap);
			
			resizeDataBitmapHold.mask = videoMask;
			
			browserCover.addChild(spriteHold); 
			
			spriteHold.keep_hold.keep.buttonMode = true;
			spriteHold.keep_hold.keep.addEventListener(MouseEvent.CLICK, dispatchChange);
			spriteHold.keep_hold.keep.addEventListener(MouseEvent.MOUSE_OVER, tryOver);
			spriteHold.keep_hold.keep.addEventListener(MouseEvent.MOUSE_OUT, tryOut);
			
			spriteHold.keep_hold.tryagain.buttonMode = true;
			spriteHold.keep_hold.tryagain.addEventListener(MouseEvent.CLICK, tryAgainBrowse);
			spriteHold.keep_hold.tryagain.addEventListener(MouseEvent.MOUSE_OVER, tryOver);
			spriteHold.keep_hold.tryagain.addEventListener(MouseEvent.MOUSE_OUT, tryOut);
			
			browserCover.addChild(bothHolder); 
			
		}

		private function tryAgainBrowse(e:MouseEvent):void
		{
			browserCover.removeChild(browserCover.getChildByName("bothhold")); 
			browserCover.removeChild(browserCover.getChildByName("background")); 
		}
		
		
		//browse-->
		
		
		// Mouse Happenings'
		
		
		private function tryOver(e:MouseEvent):void
		{
			e.target.alpha = .8;
		}

		private function tryOut(e:MouseEvent):void
		{
			e.target.alpha = 1;
		}
		
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
		
		private function dispatchChange(e:MouseEvent):void
		{
			dispatchEvent(new Event("PAGE_CHANGE", false, false)); 
		}
		
		// Public Variables
		
		public function getNextPage():String 	{ return _nextPage }
	
		public function getBackPage():String 	{ return _backPage }
		
		public function getPage():String 		{ return _page }
		
		public function getPageObject():Object
		{
			var returnObject:Object = new Object(); 
				returnObject.selectedBitmap = bitmap; 
			return returnObject;			
		}
		
	}

}
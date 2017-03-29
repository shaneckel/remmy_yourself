package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer; 
	import caurina.transitions.*; 
	
	/**
	 * Rembrandt Yourself - Cleveland Museum of Art
	 * @author shaneckel.com
	 * 
	 * Basically, each page is considered a class. Each Page class is attached to a 
	 * swc class. So all the assets are built in the ide and all the developing 
	 * is done in flash develop. It's an build used for an app and I just became 
	 * comfortable with it. email me at shaneckel ( at ) gmail with questions. 
	 * 
	 **/
	
	public class Main extends MovieClip 
	{
		
		private var activeObject	:Object 				= new Object(); 
		
		private var pageMain		:Class ;
		private var loadCover		:MovieClip;
		
		private var currentPage		:String 				= "IntroPage"; 
		private var	pageContain		:DisplayObjectContainer;
		
		private var pageArray		:Array 					
		private var ps				:PageSelector;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			setup();
		}
		
		private function setup():void
		{
			loadCover = new Load_Cover_Assets(); 
			addChildAt(loadCover, 0); 
			
			ps = new PageSelector(/*pageArray*/);
			
			pageChange()
		}
	
		private function pageChange():void
		{
			trace("/ View Returned " + pageMain); 
			
			if (getChildByName("pageContain")) { trace("/ Removing " + pageMain); removeChild(getChildByName("pageContain")); disableListeners() }
			
			pageMain = ps.returnClass(currentPage); 
			
			pageContain	= new pageMain(activeObject) as DisplayObjectContainer; 
			pageContain.addEventListener("PAGE_CHANGE", catchChange); 
			pageContain.addEventListener("PAGE_CHANGE_BACK", catchChangeBack); 
			
			addChildAt(pageContain, 0);
			pageContain.name = "pageContain"; 
			
			coverPage("Loaded"); 
		}
		
		private function catchChange(e:Event):void
		{
			currentPage = e.target.getNextPage(); 
			pullVariables(e.target.getPage(), e.target.getPageObject()); 
			
			trace("/ Changing to " + currentPage); 
			
			coverPage("Cover"); 
		}		
		
		private function catchChangeBack(e:Event):void
		{
			currentPage = e.target.getBackPage(); 
			pullVariables(null, e.target.getPageObject()); 
			
			trace("\n/ changing back to " + currentPage+ "\n"); 
			
			coverPage("Cover"); 
		}
		
		private function pullVariables(_page:String, _pageObjects:Object):void
		{
			if (_page == "IntroPage")
			{
				trace("\n/--/ IntroPage / It's the Intro... doin nuttin'\n");
			}
			if (_page == "PickFrame")
			{
				trace("\n/--/ PickFrame / Setting Pick Frame Variables\n");
				activeObject.selectedFrame = _pageObjects.selectedFrame;
			}
			if (_page == "UploadPhoto")
			{
				trace("\n/--/ UploadPhoto / Place the 355 x 355 bitmap into Object\n");
				activeObject.selectedBitmap = _pageObjects.selectedBitmap;
			}
			if (_page == "Manipulate")
			{
				trace("\n/--/ Manipulate / Add the final bitmap \n");
				activeObject.finalFrame = _pageObjects.finalFrame;
				activeObject.show = _pageObjects.finalFrame;
			}
		}
		
		private function changeTrigger():void
		{
			pageChange();
		}
		
		private function disableListeners():void
		{
			pageContain.removeEventListener("PAGE_CHANGE", catchChange); 
		}
		
		private function clearLoader():void
		{
			trace("/ Loader Removed");
			removeChild(loadCover);
		}
		
		private function coverPage(status:String):void
		{
			if (status == "Loaded")
			{
				Tweener.addTween(loadCover, { alpha: 0, time: .3, transition: "linear",  onComplete: clearLoader } );
			}
			if (status == "Cover")
			{
				trace("/ Loader Covering");
				addChildAt(loadCover, 1); 
				loadCover.alpha = 0;
				Tweener.addTween(loadCover, { alpha: 1, time: .3, transition: "linear", onComplete: changeTrigger } );
			}
			
		}
		
	}
	
}
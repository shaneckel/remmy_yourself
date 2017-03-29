package  
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.display.DisplayObjectContainer;

	import Pages.*; 	

	public class PageSelector extends Sprite
	{
		private var 	_classArray		:Array 
		
		public function PageSelector(/*classArray:Array*/)
		{
			_classArray = new Array(ErrorPage, FinishRestart, IntroPage, Manipulate, PickFrame, Share, UploadPhoto); 
		}
		public function returnClass(selected_page:String):Class
		{
			var currentClass	:Class;
			var _step			:String		= "[class " + selected_page + "]"; 
			
			//trace("// View Step " + _step);
			
			for (var i:int = 0; i < _classArray.length; i++) 
			{
				//trace(_classArray[i]);
				
				var className:String = String(_classArray[i]);
				if (className == _step) 
				{ 
					//trace("// View Found " + _classArray[i]); 
					currentClass = _classArray[i] as Class;
				}
			}			
			if (currentClass == null) 
			{
				trace("// -!- View Fail --> No Class to Match Step"); 
				trace("// -!- View Default --> " + _classArray[0]); 

				currentClass = _classArray[0];
			}
			else  
			{
				//trace("// View Current " + currentClass); 
			}
			return currentClass;
		}

	}
}

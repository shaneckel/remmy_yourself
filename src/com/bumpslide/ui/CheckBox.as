package com.bumpslide.ui {

	import com.bumpslide.ui.Button;		/**
	 * A checkbox is just a toggle button
	 * 
	 * @author David Knape
	 */
	public class CheckBox extends LabelButton {

		override protected function addChildren():void {
			super.addChildren();
			centerLabel = false;
			toggle = true;
		}
	}
}

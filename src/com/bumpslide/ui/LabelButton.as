/**
 * This code is part of the Bumpslide Library by David Knape
 * http://bumpslide.com/
 * 
 * Copyright (c) 2006, 2007, 2008 by Bumpslide, Inc.
 * 
 * Released under the open-source MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * see LICENSE.txt for full license terms
 */
 package com.bumpslide.ui {
	import flash.events.Event;	
	
	import com.bumpslide.ui.Button;
	import com.bumpslide.util.Align;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;	

	/**
	 * Labeled Button with Background
	 * 
	 * This is an abstract class that assumes label_txt is on the stage.
	 * 
	 * see GenericButton for code-only implementation.
	 * 
	 * @author David Knape
	 */
	public class LabelButton extends Button {

		public var label_txt:TextField;
		protected var _label:String = "";
		
		private var _centerLabel:Boolean = false;

		override protected function addChildren():void {		
			super.addChildren();				
			label_txt.autoSize = TextFieldAutoSize.LEFT;
			label_txt.selectable = false;
			label_txt.mouseWheelEnabled = false;
		}
		
		override protected function render(e:Event=null):void {		
			super.render(e);
			drawLabel();
		}
		
		protected function drawLabel() : void {
			if(label_txt!=null) {
				label_txt.text = label;
				if(centerLabel) {
					Align.center( label_txt, width );
					Align.middle( label_txt, height );
				}
			}
		}
		
		public function get label():String {
			return _label;
		}
		
		public function set label(label:String):void {
			_label = label;
			invalidate();
		}
		
		public function get centerLabel():Boolean {
			return _centerLabel;
		}
		
		public function set centerLabel(centerLabel:Boolean):void {
			_centerLabel = centerLabel;
			invalidate();
		}
	}
}

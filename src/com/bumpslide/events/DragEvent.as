package com.bumpslide.events {
	import flash.geom.Point;	
	import flash.events.Event;
	
	/**
	 * @author David Knape
	 */
	public class DragEvent extends Event {


		public static var EVENT_DRAG_START:String = "bumpslideDragStart";		public static var EVENT_DRAG_MOVE:String = "bumpslideDragMove";		public static var EVENT_DRAG_STOP:String = "bumpslideDragStop";
				public var start:Point;		public var delta:Point;
		
		
		public function DragEvent(type:String, sprite_start:Point, drag_delta:Point) {
			super(type, true, true);
			start = sprite_start;
			delta = drag_delta;
		}
	}
}

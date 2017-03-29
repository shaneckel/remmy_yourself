package com.bumpslide.events {
	import flash.geom.Point;	
	import flash.events.Event;
	
	/**
	 * @author David Knape
	 */
	public class DragEvent extends Event {


		public static var EVENT_DRAG_START:String = "bumpslideDragStart";
		
		
		
		public function DragEvent(type:String, sprite_start:Point, drag_delta:Point) {
			super(type, true, true);
			start = sprite_start;
			delta = drag_delta;
		}
	}
}
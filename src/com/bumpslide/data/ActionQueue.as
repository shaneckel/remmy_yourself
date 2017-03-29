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
package com.bumpslide.data {
	import com.bumpslide.data.Action;
	import com.bumpslide.data.IPrioritizable;
	import com.bumpslide.data.PriorityQueue;
	import com.bumpslide.util.Delegate;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Timer;		

	/**
	 *com.bumpslide.data.ActionQueue Actions are functins to be called.
	 * 
	 * There is no async token or responder interface here.  If your actions are
	 * asynchronous, you need to call queue.remove( action ) once it's complete.
	 * This will advance the queue. see LoaderQueue for an implementation. 
	 * 
	 * Note that this queue cam be 'multi-threaded', but we default to just a
	 * single concurrent action.
	 * 
	 * @author David Knape
	 */
	public class ActionQueue extends PriorityQueue implements IEventDispatcher {

		// actions currently being run
		protected var _currentActions:Array;

		// max numbver of concurrently running actions
		protected var _threads:Number=1;		

		// paused?
		protected var _paused:Boolean=false;
		protected var _complete:Boolean=false;

		protected var _runDelay:Timer;

		protected var _dispatcher:EventDispatcher;

		// trace?
		public var debugEnabled:Boolean=false;

		
		public function ActionQueue() {
			super();
			_currentActions = new Array();
			_dispatcher = new EventDispatcher(this);
		}

		/**
		 * Adds action to the queue and starts running actions
		 */
		override public function enqueue(action:IPrioritizable):void {
			super.enqueue(action);			
			_complete = false;
			run();
		}

		override public function clear():void {
			super.clear();
			_currentActions = new Array();
		}

		/**
		 * If found in the queue, action is removed.  If currently running, it 
		 * is removed from the current list and the queue is instructed to 
		 * continue to the next item. 
		 */
		override public function remove(action:IPrioritizable):Boolean {
			if(action == null) {
				return false;
			} else if(contains(action)) {
				return super.remove(action);	
			} else {
				var i:int;
				if((i = _currentActions.indexOf(action)) != -1) {
					debug('Removing action ' + action);
					_currentActions.splice(i, 1);	
					run();
					return true;
				}	
				return false;			
			}
		}

		public function run():void {
			Delegate.cancel(_runDelay);
			_runDelay = Delegate.callLater(10, doRun);
		}

		public function doRun():void {
			
			debug('doRun');
			
			Delegate.cancel(_runDelay);
			
			if(paused) return;	
			
			//trace( dump() );
				
			//debug('Next (running=' + _currentActions.length + ', enqueued=' + size + ')');	
			while(_currentActions.length < threads && size > 0) {				
				var nextAction:Action=dequeue() as Action;
				debug('Running ' + nextAction);
				_currentActions.push(nextAction);
				nextAction.execute();					
			} 
			if(size == 0) {				
				if(!_complete) {
					debug('All Done.');
					_complete = true;
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}

		public function get paused():Boolean {
			return _paused;
		}

		public function set paused(v:Boolean):void {
			if(_paused == v) return;
			_paused = v;
			run();
		}

		protected function debug(s:String):void {
			if(debugEnabled) trace('[ActionQueue] ' + s);
		}

		public function get threads():Number {
			return _threads;
		}

		public function set threads(threadCount:Number):void {
			_threads = threadCount;
		}

		public function get currentActions():Array {
			return _currentActions;
		}

		static public function Test():void {
			var q:ActionQueue=new ActionQueue();		
			q.debugEnabled = false;
			
			var a1:Action=new Action(function ():void {  
				Delegate.callLater(200, function():void { 
					trace('first'); 
					q.remove(a1); 
				}); 
			}, 1);			var a2:Action=new Action(function ():void {  
				Delegate.callLater(200, function():void { 
					trace('second'); 
					q.remove(a2); 
				}); 
			}, 1);			var a3:Action=new Action(function ():void {  
				Delegate.callLater(200, function():void { 
					trace('third'); 
					q.remove(a3); 
				}); 
			}, 1);
				
			q.enqueue(a1);
			q.enqueue(a2);
			q.enqueue(a3);
		}

		// Let us dispatch some events

		public function dispatchEvent(event:Event):Boolean {
			return _dispatcher.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean {
			return _dispatcher.hasEventListener(type);
		}

		public function willTrigger(type:String):Boolean {
			return _dispatcher.willTrigger(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			_dispatcher.removeEventListener(type, listener, useCapture);
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
	}
}

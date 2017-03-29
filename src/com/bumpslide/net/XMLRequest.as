package com.bumpslide.net {
	import flash.net.URLRequest;	
	
	import com.bumpslide.net.HTTPRequest;
	
	/**
	 * Basic XML RPCrequest, returns result as XML object
	 * 
	 * @author David Knape
	 */
	public class XMLRequest extends HTTPRequest {

		public function XMLRequest(request:URLRequest, responder:IResponder = null) {
			super(request, responder);
		}
		
		override protected function processResult(data:*):void {
			XML.ignoreWhitespace=true;
			try {				
				_result = new XML( data );
			} catch (e:Error) {
				raiseError( e.message );
			}
		}
	}
}

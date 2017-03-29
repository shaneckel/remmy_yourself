package com.bumpslide.net {
	import com.adobe.serialization.json.JSON;
	import com.bumpslide.net.HTTPRequest;

	import flash.net.URLRequest;		

	/**
	 * JSON Request - requires adobe corelib JSON decoder
	 * 
	 * @author David Knape
	 */
	public class JSONRequest extends HTTPRequest {

		public function JSONRequest(request:URLRequest, responder:IResponder = null) {
			super(request, responder);
		}

		override protected function processResult(data:*):void {
			try {
				_result = JSON.decode(data);
			} catch (e:Error) {
				raiseError("Error Parsing JSON");
			}
		}
	}
}

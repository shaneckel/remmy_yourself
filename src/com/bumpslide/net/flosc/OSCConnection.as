package com.bumpslide.net.flosc {
	
	import com.bumpslide.net.SocketConnection;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;		

	/**
	 * Dispatched when an OSC packet incomes
	 * 
	 * @eventType it.h_umus.osc.OSCConnectionEvent.OSC_PACKET_IN
	 **/
	[Event(name="OSCPacketIn", type="flosc.OSCConnectionEvent")]

	/**
	 * Dispatched when an OSC packet outgoes
	 * 
	 * @eventType it.h_umus.osc.OSCConnectionEvent.OSC_PACKET_OUT
	 **/
	[Event(name="OSCPacketOut", type="flosc.OSCConnectionEvent")]

	/**
	 * The OSCConnection object allows "virtual" OSC communication. It makes use
	 * of the Flosc gateway server that translates UDP/OSC packets into TCP/OSC XML-like
	 * packets as defined by the Flosc DTD.
	 * 
	 * <p>The OSCConnection object extends an XMLSocket connection, communicating with 
	 * Flosc server in OSC-XML-Encoded, receiving and sending data. The two main events defined 
	 * by the OSCConnectionEvent allow knowing when an OSC packet is recieved and  implements 
	 * sending methods for just OSCMessages</p>
	 * 
	 * <p>This is David Knape's update to original code found at http://flosc.googlecode.com/.
	 * It now uses the Bumpslide SocketConnection class which supports automatic recconect if
	 * a server connection is lost.</p>
	 * 
	 * @author Ignacio Delgado
	 * @author David Knape
	 * 
	 * @see http://code.google.com/p/flosc
	 * @see http://opensoundcontrol.org
	 * @see flash.net.XMLSocket
	 * @see it.h_umus.osc.OSCConnectionEvent
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9+
	 */
	public class OSCConnection extends EventDispatcher {		

		private var sock:SocketConnection;

		/**
		 * Creates a new OSCConnection. The OSCConnection object is not initially 
		 * connected to any server. You must call the OSCConnection.connect() 
		 * method to connect the object to a server.
		 * 
		 * @param host A fully qualified DNS domain name or an IP address in the 
		 * form aaa.bbb.ccc.ddd. You can also specify null to connect to the host 
		 * server on which the SWF file resides. If the SWF file issuing this call 
		 * is running in a web browser, host must be in the same domain as the SWF file.
		 * 
		 * @param port The TCP port number on the host used to establish a 
		 * connection. The port number must be 1024 or greater, unless a policy 
		 * file is being used.
		 * 
		 * @see flash.net.XMLSocket.connect
		 */		
		public function OSCConnection(host:String = null, port:int = 0) {			
			sock = new SocketConnection();
			sock.host = host;
			sock.port = port;			
			sock.addEventListener(DataEvent.DATA, onXml);			
		}

		/**
		 * Converts the OSCPacket into and XML and sends it to the Flosc server.
		 * @param outPacket
		 * 
		 * Build and send XMLDocument-encoded OSC
		 */		
		public function sendOSCPacket(outPacket:OSCPacket):void {
			sock.send(outPacket.getXML());
			dispatchEvent(new OSCConnectionEvent(OSCConnectionEvent.OSC_PACKET_OUT, outPacket));
		}

		/**
		 * Event handler for incoming XML-encoded OSC packets
		 * 
		 * @private
		 */		
		private function onXml(e:DataEvent):void {
			e.stopImmediatePropagation();
			// parse out the packet information
			try {
				var inXML:XML = new XML(String(e.data));
				if(inXML.localName() == "OSCPACKET")
					parseXml(inXML);
			}
			catch(er:Error) {
			}
		}

		/**
		 * Parse the messages from some XMLDocument-encoded OSC packet.
		 * 
		 * @private
		 */			
		private function parseXml(node:XML):void {
			//trace("OSCConnection.parseXml(node)");
			//trace ("\n"+node+"\n");
			var packet:OSCPacket = new OSCPacket(node.@TIME, node.@ADDRESS, node.@PORT);
			
			for each( var message:XML in node.MESSAGE) {
				var oscMessage:OSCMessage = new OSCMessage(message.@NAME);
				for each( var argumentNode:XML in message.ARGUMENT) {
					var type:String = String(argumentNode.@TYPE);
					var nodeValue:String = String(argumentNode.@VALUE);
					var value:Object = null;
					switch(type) {
						case OSCArgument.T:
							value = true;
							break;
						case OSCArgument.F:
							value = false;
							break;
						case OSCArgument.f:
							value = parseFloat(nodeValue);
							break;
						case OSCArgument.i:
							value = parseInt(nodeValue);
							break;
						case OSCArgument.s:
							value = String(nodeValue);
							break;
						case OSCArgument.h:
							value = Number(nodeValue);
							break;
						default:
							value = null;
					}
					if(value != null)
						oscMessage.addArg(new OSCArgument(type, value));
				}
				packet.addMessage(oscMessage);
			}
			dispatchEvent(new OSCConnectionEvent(OSCConnectionEvent.OSC_PACKET_IN, packet));
		}
	}
}
/**
 * File		: RTMPConnection.as
 * Date		: Jan 21, 2014
 * Owner	: arul
 * Project	: nwrclient
 * Contact	: http://www.arulraj.net
 * Description :
 * History	:
 */

package net.arulraj.feedchat.connection
{
	import net.arulraj.feedchat.models.ConnectionType;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;

	public interface RTMPConnection
	{
		function createConnection(client:Object):void;
		
		function set connectionType(type:ConnectionType):void;
		
		function netConnectionStatus(event:NetStatusEvent):void;
		
		function netConnectionClose(event:NetStatusEvent):void;
		
		function asyncErrorHandler(event:AsyncErrorEvent):void;		
		
	}
}
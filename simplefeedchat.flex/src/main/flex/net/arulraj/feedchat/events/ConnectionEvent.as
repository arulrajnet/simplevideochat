/**
 * File   : ConnectionEvent.as
 * Date   : Jan 21, 2014
 * Owner  : arul
 * Project  : nwrclient
 * Contact  : http://www.arulraj.net
 * Description :
 * History  :
 */

package net.arulraj.feedchat.events
{
	import flash.events.Event;

	public class ConnectionEvent extends Event
	{
		public static const PUBLIC_CONN_CONNECTING:String = "connection.public.connecting";
		public static const VIDEO_CONN_CONNECTING:String = "connection.video.connecting";
		public static const CHAT_CONN_CONNECTING:String = "connection.chat.connecting";
		public static const PLAYER_CONN_CONNECTING:String = "connection.player.connecting";
		
		public static const PUBLIC_CONN_SUCCESS:String = "connection.public.success";
		public static const VIDEO_CONN_SUCCESS:String = "connection.video.success";
		public static const CHAT_CONN_SUCCESS:String = "connection.chat.success";
		public static const PLAYER_CONN_SUCCESS:String = "connection.player.success";
		
		public static const PUBLIC_CONN_FAILED:String = "connection.public.failed";
		public static const VIDEO_CONN_FAILED:String = "connection.video.failed";
		public static const CHAT_CONN_FAILED:String = "connection.chat.failed";
		public static const PLAYER_CONN_FAILED:String = "connection.player.failed";
		
		public static const PUBLIC_CONN_CLOSED:String = "connection.public.closed";
		public static const VIDEO_CONN_CLOSED:String = "connection.video.closed";
		public static const CHAT_CONN_CLOSED:String = "connection.chat.closed";
		public static const PLAYER_CONN_CLOSED:String = "connection.player.closed";

		/**
		 * By Default bubbles are true. Then only we can listen anywhere in the  
		 * application
		 */
		public function ConnectionEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}		
	}
}
/**
 * File   : ChatEvent.as
 * Date   : Jan 25, 2014
 * Owner  : arul
 * Project  : nwrclient
 * Contact  : http://www.arulraj.net
 * Description :
 * History  :
 */

package net.arulraj.feedchat.events
{
	import flash.events.Event;

	public class ChatEvent extends Event
	{
		public static const PARTNER_NOT_AVAILABLE:String = "partner.not.available";
		
		public static const PARTNER_NEW_ARRIVED:String = "partner.new.arrived";
		
		/**
		 * By Default bubbles are true. Then only we can listen anywhere in the  
		 * application
		 */
		public function ChatEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}		
	}
}
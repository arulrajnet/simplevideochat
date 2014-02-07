/**
 * File		: ChatMessage.as
 * Date		: Jan 23, 2014
 * Owner	: arul
 * Project	: simplevchat
 * Contact	: http://www.arulraj.net
 * Description :
 * History	:
 */

package net.arulraj.simplevchat.models
{
	import net.arulraj.simplevchat.utils.AppConstants;
	
	import mx.utils.StringUtil;
	
	[Bindable]
	public class ChatMessage
	{
		/**
		 * Display name of the user 
		 */
		public var from:String;
		
		public var userId:String;
		
		public var message:String;
		
		public var userColor:uint;
		
		public var messageColor:uint = AppConstants.DEFAULT_CHAT_COLOR;
		
		public var date:Date;
		
		public function toString():String {
			return StringUtil.substitute("[class ChatMessage] from {0} userId {1} message {2} userColor {3} messageColor {4} date {5}",from, userId, message, userColor, messageColor, date);
		}
	}
}
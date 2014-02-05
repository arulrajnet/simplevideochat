/**
 * File   : StreamEvent.as
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

	public class StreamEvent extends Event
	{
		public static const VIDEO_PUBLISHED:String = "netstream.video.published";
		public static const AUDIO_PUBLISHED:String = "netstream.audio.published";
		public static const VIDEO_AUDIO_PUBLISHED:String = "video.audio.published";
		
		public static const VIDEO_NOT_AVAILABLE:String = "video.available.false";
		public static const AUDIO_NOT_AVAILABLE:String = "audio.available.false";
		
		/**
		 * Record Stream events
		 */
		public static const RECORD_STREAM_BUFFER_FULL:String = "record.stream.buffer.full";
		public static const RECORD_STREAM_BUFFER_EMPTY:String = "record.stream.buffer.empty";
		
		public static const PREVIEW_STREAM_BUFFER_FULL:String = "preview.stream.buffer.full";
		public static const PREVIEW_STREAM_BUFFER_EMPTY:String = "preview.stream.buffer.empty";
		
		public static const MEDIA_NOT_ALLOWED:String = "media.not.allowed";
		public static const MEDIA_ALLOWED:String = "media.allowed";
		
		/**
		 * By Default bubbles are true. Then only we can listen anywhere in the  
		 * application
		 */
		public function StreamEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}		
	}
}
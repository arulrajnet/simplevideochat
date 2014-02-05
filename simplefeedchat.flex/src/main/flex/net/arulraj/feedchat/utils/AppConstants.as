/**
 * File   : AppConstants.as
 * Date   : Jan 21, 2014
 * Owner  : arul
 * Project  : nwrclient
 * Contact  : http://www.arulraj.net
 * Description :
 * History  :
 */

package net.arulraj.feedchat.utils
{
	import mx.controls.Image;

	[Bindable]
	public class AppConstants
	{
		/*ip addresses*/
		public static var RED5_SERVER:String = "localhost";
		public static var PHP_SERVER:String = "localhost";
		
		/*rtmp constants*/		
		public static var MAIN_APP:String = "vod";
		public static const RTMP_PORT:Number = 1935;
		public static const RTMPT_PORT:Number = 8088;
		public static const HTTP_PORT:Number = 5080;
		public static const IS_SECURE:Boolean = false;
		
		/*shared object constants*/
		public static const CHATSO_PREFIX:String = "chatSO-";
		
		/*video constants*/
		public static const DEFAULT_VIDEO_WIDTH:Number = 320;
		public static const DEFAULT_VIDEO_HEIGHT:Number = 240;
		public static const MEDIUM_VIDEO_WIDTH:Number = 640;
		public static const MEDIUM_VIDEO_HEIGHT:Number = 480;
		public static const VIDEO_WIDTH:Number = 320;
		public static const VIDEO_HEIGHT:Number = 240;		
		public static const ASPECT_MULTIPLIER:Number = 80;
		public static const CHAT_WIDTH:Number = 500;
		public static const LOW_CAMERA_FPS:int = 13;
		public static const MEDIUM_CAMERA_FPS:int = 26;
		public static const HIGH_CAMERA_FPS:int = 29.97;		
		public static const LOW_CAMERA_BANDWIDTH:int = 0; // 1 to ...
		public static const LOW_CAMERA_QUALITY:int = 50;//1 to 100
		public static const MED_CAMERA_BANDWIDTH:int = 0;
		public static const MED_CAMERA_QUALITY:int = 75;	
		public static const HIGH_CAMERA_BANDWIDTH:int = 0;
		public static const HIGH_CAMERA_QUALITY:int = 100;			
		public static const LOW_AUDIO_QUALITY:int = 5;
		public static const MED_AUDIO_QUALITY:int = 7;
		public static const HIGH_AUDIO_QUALITY:int = 10;
		public static const HIGH_AUDIO_RATE:int = 44;
		public static const MED_AUDIO_RATE:int = 22;
		public static const LOW_AUDIO_RATE:int = 11;
		public static const AUDIO_PACKET:int = 2;
		public static const AUDIO_GAIN:int = 50;
		public static const AUDIO_SILENCE_LEVEL:int = 5000;
		public static const DEFAULT_SPEAKER_VOLUME:int = 75;
		public static const RESOLUTION_ARRAY:Array = new Array("320x240","640x480","960x720");
		public static const QUALITY_ARRAY:Array = new Array("Low","Medium","High");
		public static const DEFAULT_QUALITY:int = QUALITY_ARRAY.indexOf(QUALITY_ARRAY[1]);
		public static const LIVE_VIDEO_OPTION:Array = new Array("Publish","Offline");
		
		public static const RECORD_TIME:int = 120;//In seconds
		public static const IS_SINGLE_SREAM:Boolean = true;

		public static const DEFAULT_CHAT_COLOR:uint = 0;

		public static const DEFAULT_CHANNEL:String = "1";
		
		/*Non-member constants*/
		public static const GUEST_ID:String = "Guest";
		public static const ALL:String = "All";
		
	}
}
/**
 * File		: Settings.as
 * Date   : Jan 21, 2014
 * Owner  : arul
 * Project  : nwrclient
 * Contact  : http://www.arulraj.net
 * Description :
 * History  :
 */

package net.arulraj.feedchat.models
{
	import net.arulraj.feedchat.utils.AppConstants;
	
	import flash.media.Camera;
	import flash.media.Microphone;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class Settings
	{
		public var cameraArray:ArrayCollection = new ArrayCollection(Camera.names);
		
		public var micArray:ArrayCollection = new ArrayCollection(Microphone.names);
		
		public var aspectArray:ArrayCollection = new ArrayCollection(AppConstants.RESOLUTION_ARRAY);
		
		public var frameRate:int = AppConstants.MEDIUM_CAMERA_FPS;
		
		public var micVolume:int = AppConstants.AUDIO_GAIN;
		
		public var camSeletedItem:int = 0;
		
		public var micSelectedItem:int = 0;
		
		public var aspectSelectedItem:int = 1;
		
		public var camSelectedName:String;
		
		public var micSelectedName:String;
		
		public var camQuality:int = AppConstants.DEFAULT_QUALITY;
		
		public var micQuality:int = AppConstants.DEFAULT_QUALITY;
		
		public var cameraDetected:Boolean = false;

		public var speakerVolume:int = AppConstants.DEFAULT_SPEAKER_VOLUME;

		public var recordTime:int = AppConstants.RECORD_TIME;

		public function Settings()
		{
		}
	}
}
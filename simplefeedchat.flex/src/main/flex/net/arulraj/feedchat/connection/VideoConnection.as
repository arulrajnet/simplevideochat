/**
 * File   : VideoConnection.as
 * Date   : Jan 21, 2014
 * Owner  : arul
 * Project  : nwrclient
 * Contact  : http://www.arulraj.net
 * Description :
 * History  :
 */

package net.arulraj.feedchat.connection
{
	import flash.display.DisplayObject;
	import flash.events.ActivityEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.events.SyncEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundCodec;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectProxy;
	
	import net.arulraj.feedchat.components.InfoPopup;
	import net.arulraj.feedchat.components.SettingsBox;
	import net.arulraj.feedchat.events.ConnectionEvent;
	import net.arulraj.feedchat.events.StreamEvent;
	import net.arulraj.feedchat.utils.AppConstants;
	
	import spark.components.Application;
	import spark.components.VideoDisplay;
	
	import turbosqel.events.GlobalDispatcher;

	public class VideoConnection extends RTMPConnectionImpl
	{
		private static var LOG:ILogger = Log.getLogger('net.arulraj.feedchat.connection.VideoConnection');
		
		private var videoStream:NetStream = null;
		private var audioStream:NetStream = null;
		private var partnerVStream:NetStream = null;
		private var partnerAStream:NetStream = null;
		private var playbackStreamStatus:PlaybackStreamStatus = null;
		private var liveVideo:Video = null;
		private var partnerVideo:Video = null;
		
		private var camera:Camera = null;
		private var microphone:Microphone = null;
		
		private var maxBufferLength:Number = 0;

		public var chatSO:SharedObject;

		public var uploadingPopup:InfoPopup;
		
		public function VideoConnection()
		{
			super();
		}
		
		public static function get connected():Boolean {
			return connected;
		}		
		
		public function getConnection():void {
			LOG.debug("Creating video connection...");
			GlobalDispatcher.dispatchEvent((new ConnectionEvent(ConnectionEvent.VIDEO_CONN_CONNECTING)));
			super.createConnection(this);
		}
		
		public function onAVSettingsChange(event:PropertyChangeEvent):void {
			LOG.debug("on change audio/video settings "+event.toString());
			LOG.debug("kind "+event.kind);
			LOG.debug("new value "+event.newValue);
			LOG.debug("old value "+event.oldValue);
			LOG.debug("property "+event.property);
			LOG.debug("source "+event.source);
			
			if(event.property == "camSeletedItem") {
				camera = Camera.getCamera(FlexGlobals.topLevelApplication.avSettings.camSeletedItem as String);
				if(camera != null) {
					videoStream.attachCamera(camera);
					liveVideo.attachCamera(camera);
				}
			}
			
			if(event.property == "micSelectedItem") {
				microphone = Microphone.getMicrophone(FlexGlobals.topLevelApplication.avSettings.micSelectedItem);
				if(microphone != null) {
					videoStream.attachAudio(microphone);
				}
			}
			
			if(event.property == "frameRate" || event.property == "aspectSelectedItem" || event.property == "camQuality") {
				var qualityType:String = AppConstants.QUALITY_ARRAY[FlexGlobals.topLevelApplication.avSettings.camQuality];
				if(qualityType == "Low") {
					FlexGlobals.topLevelApplication.avSettings.frameRate = AppConstants.LOW_CAMERA_FPS;
					FlexGlobals.topLevelApplication.avSettings.aspectSelectedItem = 0;
				}else if (qualityType == "Medium") {
					FlexGlobals.topLevelApplication.avSettings.frameRate = AppConstants.MEDIUM_CAMERA_FPS;
					FlexGlobals.topLevelApplication.avSettings.aspectSelectedItem = 1;
				}else if (qualityType == "High") {
					FlexGlobals.topLevelApplication.avSettings.frameRate = AppConstants.HIGH_CAMERA_FPS;
					FlexGlobals.topLevelApplication.avSettings.aspectSelectedItem = 2;
				}				
				changeCameraProperties(FlexGlobals.topLevelApplication.avSettings.aspectSelectedItem, FlexGlobals.topLevelApplication.avSettings.frameRate, FlexGlobals.topLevelApplication.avSettings.camQuality);
			}
			
			if(event.property == "micVolume" || event.property == "micQuality") {
				changeMicrophoneProperties(FlexGlobals.topLevelApplication.avSettings.micVolume, FlexGlobals.topLevelApplication.avSettings.micQuality);
			}
			
			if(event.property == "cameraDetected") {
				if(camera != null) {
					switch(FlexGlobals.topLevelApplication.avSettings.cameraDetected) {
						case true:
							if(videoStream != null)
								videoStream.attachCamera(camera);
							if(liveVideo != null)
								liveVideo.attachCamera(camera);
							break;
						case false:
							unpublish();
							break;
					}
				}
			}

			if(event.property == "speakerVolume") {
				
			}
		}
		
		public function changeCameraProperties(aspectRatio:int, fbs:Number, quality:int=-1):void {
			if(camera == null) {
				return;
			}
			var aspectString:String = AppConstants.RESOLUTION_ARRAY[aspectRatio];
			var aspectArray:Array = aspectString.split("x");
			var camWidth:int = aspectArray[0];
			var camHeight:int = aspectArray[1];
			camera.setMode(camWidth, camHeight, fbs, true);
			var cameraQuality:String = AppConstants.QUALITY_ARRAY[quality];
			if(cameraQuality != null) {
				switch(cameraQuality) {
					case "Low":
						camera.setQuality(AppConstants.LOW_CAMERA_BANDWIDTH, AppConstants.LOW_CAMERA_QUALITY);
						break;
					case "Medium":
						camera.setQuality(AppConstants.MED_CAMERA_BANDWIDTH, AppConstants.MED_CAMERA_QUALITY);
						break;
					case "High":
						camera.setQuality(AppConstants.HIGH_CAMERA_BANDWIDTH, AppConstants.HIGH_CAMERA_QUALITY);
						break;
					default:
						camera.setQuality(AppConstants.MED_CAMERA_BANDWIDTH, AppConstants.MED_CAMERA_QUALITY);
				}
			}
		}
		
		public function changeMicrophoneProperties(gain:int, quality:int=-1):void {
			if(microphone == null) {
				return;
			}
			microphone.gain = gain;
			var micQuality:String = AppConstants.QUALITY_ARRAY[quality];
			if(micQuality != null) {
				switch(micQuality) {
					case "Low":
						microphone.encodeQuality = AppConstants.LOW_AUDIO_QUALITY;
						break;
					case "Medium":
						microphone.encodeQuality = AppConstants.MED_AUDIO_QUALITY;
						break;
					case "High":
						microphone.encodeQuality = AppConstants.HIGH_AUDIO_QUALITY;	
						break;
					default:
						microphone.encodeQuality = AppConstants.MED_AUDIO_QUALITY;
				}
			}
		}	
		
		public function updateMicMeter(event:TimerEvent):void {
			if(microphone != null) {
				var ac:int=microphone.activityLevel;
				if(FlexGlobals.topLevelApplication.videoBox != null) {
					/**
					 * Check whether settings box is enabled or not
					 */
					var settingsBox:SettingsBox = FlexGlobals.topLevelApplication.videoBox.settingsBox;
					if(settingsBox != null) {
						FlexGlobals.topLevelApplication.videoBox.settingsBox.micProgress.setProgress(ac,100);						
					}

					/**
					 * volume bar at the bottom of video
					 */
					var micProgress:DisplayObject = FlexGlobals.topLevelApplication.videoBox.micProgress;
					if(micProgress != null) {
						FlexGlobals.topLevelApplication.videoBox.micProgress.setProgress(ac,100);
					}
				}
			}
		}
		
		/**
		 * Once Page loads Preview their webcam on thaat page
		 *
		 */
		public function previewVideoAudio():void {
			/**
			 * CAMERA - PREVIEW
			 */
			var liveVideoDisplay:VideoDisplay = FlexGlobals.topLevelApplication.videoBox.liveVideoDisplay;
			
			initCamera()
			
			if(camera != null) {
				liveVideo = new Video(liveVideoDisplay.width, liveVideoDisplay.height);
				liveVideo.attachCamera(camera);
				liveVideo.x = 0;
				liveVideo.y = 0;
				liveVideoDisplay.addChild(liveVideo);
			}
			
			/**
			 * MIC - PREVIEW
			 */
			initMicrophone();
			
			if(microphone != null) {
				//TODO
			} else {
				LOG.debug("mic not avilable");
				GlobalDispatcher.dispatchEvent((new StreamEvent(StreamEvent.AUDIO_NOT_AVAILABLE)));
			}
			
			/**
			 * PREPARE STREAMS
			 */
			initStreams();
			
			if(camera != null) {
				videoStream.attachCamera(camera);
			}
			
			if(microphone != null) {
				if(AppConstants.IS_SINGLE_SREAM) {
					videoStream.attachAudio(microphone);
				} else {
					audioStream.attachAudio(microphone);
				}
			}
		}

		public function publishAudioVideo(event:FlexEvent=null):void {
			LOG.info("publishAudioVideo : entered");
			if(camera != null && !AppConstants.IS_SINGLE_SREAM) {
				/*Initialize the camera properties*/
				//camera.setMode(AppConstants.VIDEO_WIDTH, AppConstants.VIDEO_HEIGHT, AppConstants.CAMERA_FPS, true);
				//camera.setQuality(AppConstants.MED_CAMERA_BANDWIDTH, AppConstants.MED_CAMERA_QUALITY);
//				changeCameraProperties(FlexGlobals.topLevelApplication.avSettings.aspectSelectedItem, FlexGlobals.topLevelApplication.avSettings.frameRate, FlexGlobals.topLevelApplication.avSettings.camQuality);
				videoStream.publish(FlexGlobals.topLevelApplication.userId+"_v","live");
			}

			if(microphone != null && !AppConstants.IS_SINGLE_SREAM) {
//				changeMicrophoneProperties(FlexGlobals.topLevelApplication.avSettings.micVolume, FlexGlobals.topLevelApplication.avSettings.micQuality);
				audioStream.publish(FlexGlobals.topLevelApplication.userId+"_a","live");
			}

			if ((microphone != null || camera != null) && AppConstants.IS_SINGLE_SREAM) {
				videoStream.publish(FlexGlobals.topLevelApplication.userId+"_av","live");
			}
		}
		
		public function pauseRecord(event:FlexEvent=null):void {
			videoStream.attachAudio(null);
			videoStream.attachCamera(null);
			audioStream.attachAudio(null);
			audioStream.attachCamera(null);
		}

		public function resumeRecord(event:FlexEvent=null):void {
			if(camera != null) {
				videoStream.attachCamera(camera);
			}

			if(microphone != null) {
				audioStream.attachAudio(microphone);
			}
		}
		
		/**
		 * Until bufferlength to zero. show the uploading popup
		 */
		public function startUpload(event:FlexEvent=null):void {
			videoStream.attachAudio(null);
			videoStream.attachCamera(null);
			audioStream.attachAudio(null);
			audioStream.attachCamera(null);
			maxBufferLength = videoStream.bufferLength;
			maxBufferLength = videoStream.bufferLength;
			FlexGlobals.topLevelApplication.commonTimer.addEventListener(TimerEvent.TIMER, handleBufferCheck, false, 0, true);
			uploadingPopup = InfoPopup(PopUpManager.createPopUp(FlexGlobals.topLevelApplication as Application, InfoPopup, true));
			uploadingPopup.title = "Status";
			uploadingPopup.infoLabel.text = "Uploading...";
			PopUpManager.centerPopUp(uploadingPopup);
		}		

		public function stopRecord(event:FlexEvent=null):void {
			LOG.debug("Stop record...");
			if(videoStream != null) {
				videoStream.attachAudio(null);
				videoStream.attachCamera(null);
				videoStream.close();
				videoStream = null;
			}
			if(audioStream != null) {
				audioStream.attachAudio(null);
				audioStream.attachCamera(null);
				audioStream.close();
				audioStream = null;
			}
			initStreams();
			FlexGlobals.topLevelApplication.videoBox.resetRecordTimer();
			PopUpManager.removePopUp(uploadingPopup);
		}		
		
		/**
		 * Partner functions
		 */
		public function playParnerMedia():void {
			stopPartnerMedia();
			var streamName:String = FlexGlobals.topLevelApplication.partnerId;
			var partnerVDisplay:VideoDisplay = null;
			partnerVDisplay = FlexGlobals.topLevelApplication.videoBox.partnerVideoDisplay;
			if(partnerVStream == null) {
				partnerVStream = new NetStream(this);
				partnerVStream.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
				partnerVStream.addEventListener("status", streamStatus);
				partnerVStream.addEventListener("error", streamError);        
			}
			if(AppConstants.IS_SINGLE_SREAM) {
				partnerVStream.play(streamName+"_av", -1, -1, true);
			} else {
				partnerVStream.play(streamName+"_v", -1, -1, true);
			}
			partnerVideo = new Video(partnerVDisplay.width, partnerVDisplay.height);
			partnerVideo.attachNetStream(partnerVStream);
			partnerVideo.smoothing = true;
			partnerVideo.x = 0;
			partnerVideo.y = 0;
			partnerVDisplay.addChild(partnerVideo);	
			
			LOG.debug("live video stream "+partnerVStream);			
			
		}
		
		public function stopPartnerMedia():void {
			if(partnerVStream != null) {
				partnerVStream.attachAudio(null);
				partnerVStream.attachCamera(null);
				partnerVStream.close();
				partnerVStream = null;
				if(partnerVideo != null) {
					partnerVideo.attachNetStream(null);
					partnerVideo = null;
				}
			}			
		}

		private function handleBufferCheck(e:TimerEvent):void {
			LOG.debug("handleBufferCheck : "+videoStream.bufferLength);
			if(videoStream.bufferLength == 0) {
				stopRecord();
				FlexGlobals.topLevelApplication.commonTimer.removeEventListener(TimerEvent.TIMER, handleBufferCheck);
			}
			var uploadPercent:int = ( (maxBufferLength - videoStream.bufferLength) / maxBufferLength)*100;
			uploadingPopup.infoLabel.text = "Uploading "+zeroPad(uploadPercent,2)+"%...";
		}

		private function zeroPad(number:int, width:int):String {
			var ret:String = ""+number;
			while( ret.length < width )
				ret="0" + ret;
			return ret;
		}		

		private function initCamera():void {
			var cameraName:String;
			var cameraArray:ArrayCollection = FlexGlobals.topLevelApplication.avSettings.cameraArray;
			var camIndex:int = -1;
			
			if(cameraArray != null && cameraArray.length > 0) {
				cameraName = cameraArray.getItemAt(FlexGlobals.topLevelApplication.avSettings.camSeletedItem) as String;
				camIndex = FlexGlobals.topLevelApplication.avSettings.camSeletedItem;
			}
			
			if(camIndex != -1) {
				//camera = Camera.getCamera(camIndex as String);
				camera = Camera.getCamera();
			}
			
			LOG.info("Previewing camera "+cameraName+ "  "+camera);
			LOG.debug("cameraArray "+cameraArray);
			LOG.debug("cameraArray.length "+cameraArray.length);
			LOG.debug("camIndex "+camIndex);
			
			if(camera != null) {
				camera.addEventListener(StatusEvent.STATUS, onCamStatus);
				
				/*Initialize the camera properties*/
				//camera.setMode(AppConstants.VIDEO_WIDTH, AppConstants.VIDEO_HEIGHT, AppConstants.CAMERA_FPS, true);
				//camera.setQuality(AppConstants.MED_CAMERA_BANDWIDTH, AppConstants.MED_CAMERA_QUALITY);
				changeCameraProperties(FlexGlobals.topLevelApplication.avSettings.aspectSelectedItem, FlexGlobals.topLevelApplication.avSettings.frameRate, FlexGlobals.topLevelApplication.avSettings.camQuality);
				camera.addEventListener(ActivityEvent.ACTIVITY, onVideoActivity);
			} else {
				/* Add a black window? */
				LOG.debug("camera not avilable");
				GlobalDispatcher.dispatchEvent((new StreamEvent(StreamEvent.VIDEO_NOT_AVAILABLE)));
			}
		}
		
		private function initMicrophone():void {
			var microphoneName:String;
			var micArray:ArrayCollection = FlexGlobals.topLevelApplication.avSettings.micArray;
			var micIndex:int = -1;
			
			if(micArray != null && micArray.length > 0) {
				microphoneName = micArray.getItemAt(FlexGlobals.topLevelApplication.avSettings.micSelectedItem) as String;
				micIndex = FlexGlobals.topLevelApplication.avSettings.micSelectedItem;
			}
			if(micIndex != -1) {
				//microphone = Microphone.getMicrophone(micIndex);
				microphone = Microphone.getMicrophone();
			}
			
			LOG.info("previewing microphone "+microphoneName+ "  "+microphone);
			if(microphone != null) {
				changeMicrophoneProperties(FlexGlobals.topLevelApplication.avSettings.micVolume, FlexGlobals.topLevelApplication.avSettings.micQuality);
				//microphone.codec = SoundCodec.SPEEX;
				//microphone.encodeQuality = AppConstants.MED_AUDIO_QUALITY;
				microphone.rate = AppConstants.MED_AUDIO_RATE;
				microphone.framesPerPacket = AppConstants.AUDIO_PACKET;
				//microphone.gain = FlexGlobals.topLevelApplication.avSettings.micVolume;
				microphone.setUseEchoSuppression(true); 
				microphone.setLoopBack(false); 
				microphone.setSilenceLevel(2, AppConstants.AUDIO_SILENCE_LEVEL); 
				
				microphone.addEventListener(ActivityEvent.ACTIVITY, this.onMicActivity); 
				microphone.addEventListener(StatusEvent.STATUS, this.onMicStatus); 
				this.addEventListener(Event.ENTER_FRAME, this.updateMicMeter);
				FlexGlobals.topLevelApplication.commonTimer.addEventListener(TimerEvent.TIMER, this.updateMicMeter);
				
				var micDetails:String = '\n'+"Sound input device name: " + microphone.name + '\n'; 
				micDetails += "Gain: " + microphone.gain + '\n'; 
				micDetails += "Rate: " + microphone.rate + " kHz" + '\n'; 
				micDetails += "Muted: " + microphone.muted + '\n';
				micDetails += "Quality: " + microphone.encodeQuality + '\n';
				micDetails += "Frames / Packet: " + microphone.framesPerPacket + '\n';
				micDetails += "Silence level: " + microphone.silenceLevel + '\n'; 
				micDetails += "Silence timeout: " + microphone.silenceTimeout + '\n'; 
				micDetails += "Echo suppression: " + microphone.useEchoSuppression + '\n';
				LOG.info(micDetails);
			}
		}
		
		private function initStreams():void {
			/**
			 * PREPARE STREAMS
			 */
			if(videoStream == null) {
				/**
				 * Initialize the Netstream for your video
				 */
				videoStream = new NetStream(this);
				// Set the buffer time real high so the player doesnt just start dropping frames all over the place
				// to preserve the tiny default .1 buffer
				videoStream.bufferTime = 60;
				videoStream.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
				videoStream.addEventListener("status", streamStatus);
				videoStream.addEventListener("error", streamError);
				videoStream.client = this;
			}
			
			if(audioStream == null) {
				/**
				 * Initiate the Netstream for your audio
				 */
				audioStream = new NetStream(this);
				audioStream.bufferTime = 60;
				audioStream.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
				audioStream.addEventListener("status", streamStatus);
				audioStream.addEventListener("error", streamError);
				audioStream.client = this;
			}

			if(partnerVStream == null) {
				/**
				 * Initialize the Netstream for play the recorded video stream
				 **/
				playbackStreamStatus = new PlaybackStreamStatus(this);
				partnerVStream = new NetStream(this);
				partnerVStream.bufferTime = 1;
				partnerVStream.addEventListener(NetStatusEvent.NET_STATUS, playbackStreamStatus.netStreamStatus);
				partnerVStream.addEventListener("status", playbackStreamStatus.streamStatus);
				partnerVStream.addEventListener("error", playbackStreamStatus.streamError);
				partnerVStream.client = playbackStreamStatus;
			}

			if(partnerAStream == null) {
				/**
				 * Initialize the Netstream for play the recorded video stream
				 **/
				playbackStreamStatus = new PlaybackStreamStatus(this);
				partnerAStream = new NetStream(this);
				partnerAStream.bufferTime = 1;
				partnerAStream.addEventListener(NetStatusEvent.NET_STATUS, playbackStreamStatus.netStreamStatus);
				partnerAStream.addEventListener("status", playbackStreamStatus.streamStatus);
				partnerAStream.addEventListener("error", playbackStreamStatus.streamError);
				partnerAStream.client = playbackStreamStatus;
			}
		}		
		
		public function unpublish():void {
			if(videoStream != null)
				videoStream.attachCamera(null);
			if(audioStream != null)
				audioStream.attachAudio(null);
			if(liveVideo != null)
				liveVideo.attachCamera(null);
			FlexGlobals.topLevelApplication.videoBox.clearVideoDisplay();
		}
		
		public function stopLiveVideo():void {
			if(videoStream != null) {
				videoStream.attachAudio(null);
				videoStream.attachCamera(null);
				videoStream.close();
				videoStream = null;
				if(liveVideo != null) {
					liveVideo.attachNetStream(null);
					liveVideo = null;
				}
			}

			if(audioStream != null) {
				audioStream.attachAudio(null);
				audioStream.attachCamera(null);
				audioStream.close();
				audioStream = null;
			}
		}

		/**
		 * This will created share object on server for every meeting.
		 * SO will be creat once the connection got successfully established.
		 */
		public function createSO(meeingId:String):void {
			chatSO = SharedObject.getRemote(AppConstants.CHATSO_PREFIX+meeingId, this.uri, false);
			chatSO.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
			chatSO.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			chatSO.addEventListener(SyncEvent.SYNC, soSyncEventHandler);
			chatSO.client = this;
			chatSO.connect(this);
		}

		/**
		 * RPC Functions
		 */
		public function receiveGroupMessage(user:String, message:String):void {
			if(FlexGlobals.topLevelApplication.userId != user) {
				FlexGlobals.topLevelApplication.chatBox.receiveMessage(user, message);
			}
		}

		public function receivePrivatemessage(partnerId:String, obj:Object):void {
			var message:ObjectProxy = new ObjectProxy(obj);
			partnerId = message.userId;
		}

		/**
		 *
		 */
		public function sendGroupMessage(value:Object):void {

		}
	}
}

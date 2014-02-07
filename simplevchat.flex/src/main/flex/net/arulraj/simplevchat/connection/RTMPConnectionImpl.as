/**
 * File   : RTMPConnectionImpl.as
 * Date   : Jan 21, 2014
 * Owner  : arul
 * Project  : simplevchat
 * Contact  : http://www.arulraj.net
 * Description :
 * History  :
 */

package net.arulraj.simplevchat.connection
{
	import flash.events.ActivityEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	
	import mx.core.FlexGlobals;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import net.arulraj.simplevchat.events.ConnectionEvent;
	import net.arulraj.simplevchat.events.StreamEvent;
	import net.arulraj.simplevchat.models.ConnectionType;
	import net.arulraj.simplevchat.utils.AppConstants;
	
	import turbosqel.events.GlobalDispatcher;
	
	public class RTMPConnectionImpl extends NetConnection implements RTMPConnection
	{
		private static var LOG:ILogger = Log.getLogger('net.arulraj.simplevchat.connection.RTMPConnectionImpl');
		private var hostname:String;
		private var scope:String;
		private var port:Number;
		private var isHttps:Boolean;
		private var type:ConnectionType;
		private var clientObj:Object;
		
		public function RTMPConnectionImpl()
		{
			super();
			initConnectionVars();
		}
		
		private function initConnectionVars():void {
			hostname = AppConstants.RED5_SERVER;
			port = AppConstants.RTMP_PORT;
			isHttps = AppConstants.IS_SECURE;
			scope = AppConstants.MAIN_APP;
		}
		
		/**
		 * START : Implemnted functions
		 */
		
		public function createConnection(client:Object):void
		{
			initConnectionVars();
			var connectionName:String = "publicConn";
			this.clientObj = client;
			LOG.info("you are connecting to "+this.hostname+"..."+" client object "+clientObj);
			
//			this.objectEncoding = ObjectEncoding.AMF3;
			this.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
			this.addEventListener(Event.CLOSE, netConnectionClose);
			this.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			this.proxyType = "best";			
			this.client = clientObj;
			
			if(clientObj is VideoConnection) {
				connectionName = "videoConn";
			}
			
			if(type == ConnectionType.RTMPT) {
				this.port = AppConstants.RTMPT_PORT;
			}

			var meetingScope:String = scope;

			if (this.isHttps) {
				this.connect(ConnectionType.RTMPS.name+"://" + this.hostname + ":"+this.port+"/"+meetingScope);
			} else {
				this.connect(type.name+"://" + this.hostname + ":"+this.port+"/"+meetingScope);
			}
		}
		
		public function netConnectionStatus(event:NetStatusEvent):void
		{
			LOG.debug("Status : "+event.info.code);
			if (event.info.code == "NetConnection.Connect.Success") {
				
				if (clientObj is VideoConnection) {
					GlobalDispatcher.dispatchEvent((new ConnectionEvent(ConnectionEvent.VIDEO_CONN_SUCCESS)));
				}
				
			} else if (event.info.code == "NetConnection.Connect.Closed") {
			
				if (clientObj is VideoConnection) {
					GlobalDispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.VIDEO_CONN_CLOSED));
				}
				
			} else if (event.info.code == "NetConnection.Connect.Failed" ||
								event.info.code == "NetConnection.Connect.Rejected") {
								
				if (clientObj is VideoConnection) {
					GlobalDispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.VIDEO_CONN_FAILED));
				}
				
			} else if (event.info.code == "NetStream.Play.UnpublishNotify") {
				
			} else if(event.info.code == "NetStream.Play.Start") {
				
			} else if(event.info.code == "NetStream.Publish.Start") {
			
				if (clientObj is VideoConnection) {
					
				}
				
			} else if(event.info.code == "NetStream.Unpublish.Success") {
			
				if (clientObj is VideoConnection) {
				
				}
				
			} else if(event.info.code == "NetStream.Publish.BadName") {
			
				if (clientObj is VideoConnection) {
				
				}
				
			} else if(event.info.code == "NetStream.Play.UnpublishNotify") {
				
			} else if(event.info.code == "NetStream.Record.Stop") {
				
			} else if(event.info.code == "NetStream.Record.Start") {
				if (clientObj is VideoConnection) {
					
				}
			}			
		}
		
		public function netConnectionClose(event:NetStatusEvent):void
		{
			LOG.debug("net Connection close "+event.info);
		}
		
		public function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			LOG.debug(event.text)
		}
		
		public function soSyncEventHandler(event:SyncEvent):void {
			LOG.debug("SO sync Event : "+event);
		}
		
		public function set connectionType(type:ConnectionType):void {
			this.type = type;
		}
		
		public function get connectionType():ConnectionType {
			return type;
		}		
		
		/**
		 * END : Implemnted functions
		 */		
		
		public function streamStatus(evtObject:Object):void {
			
		}
		
		public function streamError(evtObject:Object):void {
			
		}
		
		public function onVideoActivity(event:ActivityEvent):void {
			
		}
		
		public function onMicActivity(event:ActivityEvent):void { 
			
		} 
		
		public function onMicStatus(event:StatusEvent):void { 
			switch(event.code) {
				case "Microphone.Muted":
					GlobalDispatcher.dispatchEvent(new StreamEvent(StreamEvent.MEDIA_NOT_ALLOWED));
					break;
				case "Microphone.Unmuted":

					break;
			}			
		}
		
		public function onCamStatus(event:StatusEvent):void {
			switch(event.code) {
				case "Camera.Muted":
//					FlexGlobals.topLevelApplication.avSettings.cameraDetected = false;
					GlobalDispatcher.dispatchEvent(new StreamEvent(StreamEvent.MEDIA_NOT_ALLOWED));
					break;
				case "Camera.Unmuted":
//					FlexGlobals.topLevelApplication.avSettings.cameraDetected = true;
					GlobalDispatcher.dispatchEvent(new StreamEvent(StreamEvent.MEDIA_ALLOWED));
					break;
			}
		}
		
		public function onBWCheck(...rest):Number
		{ 
			return 0; 
		} 
		
		public function onBWDone(...rest):void
		{ 
			var p_bw:Number; 
			if (rest.length > 0){
				p_bw = rest[0]; 
			}
			LOG.debug("bandwidth = " + p_bw + " Kbps."); 
		}
	}
}
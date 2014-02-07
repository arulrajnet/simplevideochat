package net.arulraj.feedchat.connection
{
	import net.arulraj.feedchat.events.StreamEvent;
	
	import flash.events.NetStatusEvent;
	
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class LiveStreamStatus
	{
		private static var LOG:ILogger = Log.getLogger('net.arulraj.feedchat.connection.PlayStreamStatus');
		
		private var connection:RTMPConnectionImpl;		
		
		public function LiveStreamStatus(connection:RTMPConnectionImpl)
		{
			this.connection = connection;
		}
		
		public function netStreamStatus(event:NetStatusEvent):void
		{
			LOG.debug("Status : "+event.info.code);
			if (event.info.code == "NetStream.Play.UnpublishNotify") {
				
			} else if(event.info.code == "NetStream.Play.Start") {
				
			} else if(event.info.code == "NetStream.Play.Stop") {
				
			} else if(event.info.code == "NetStream.Publish.Start") {
				
			} else if(event.info.code == "NetStream.Unpublish.Success") {
				
			} else if(event.info.code == "NetStream.Publish.BadName") {
				
			} else if(event.info.code == "NetStream.Play.UnpublishNotify") {
				
			} else if(event.info.code == "NetStream.Record.Stop") {
				
			} else if(event.info.code == "NetStream.Record.Start") {
				
			} else if(event.info.code == "NetStream.Buffer.Full") {
				connection.dispatchEvent(new StreamEvent(StreamEvent.PREVIEW_STREAM_BUFFER_FULL));
			} else if(event.info.code == "NetStream.Buffer.Empty") {
				connection.dispatchEvent(new StreamEvent(StreamEvent.PREVIEW_STREAM_BUFFER_EMPTY));
			} else if(event.info.code == "NetStream.Buffer.Flush") {
				
			}
		}
		
		public function streamStatus(evtObject:Object):void {
			
		}
		
		public function streamError(evtObject:Object):void {
			
		}
		
		public function onCuePoint(info:Object):void {
			LOG.debug("cuePoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		
		public function onMetaData(info:Object):void {
			LOG.debug("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
		}		
	}
}
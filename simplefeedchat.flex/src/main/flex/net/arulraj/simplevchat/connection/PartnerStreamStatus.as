package net.arulraj.simplevchat.connection
{
	import flash.events.NetStatusEvent;
	
	import mx.core.FlexGlobals;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import net.arulraj.simplevchat.events.AppEvent;
	import net.arulraj.simplevchat.events.StreamEvent;
	
	import turbosqel.events.GlobalDispatcher;

	public class PartnerStreamStatus
	{
		private static var LOG:ILogger = Log.getLogger('net.arulraj.simplevchat.connection.PartnerStreamStatus');
		
		private var connection:RTMPConnectionImpl;		
		
		public function PartnerStreamStatus(connection:RTMPConnectionImpl)
		{
			this.connection = connection;
		}
		
		public function netStreamStatus(event:NetStatusEvent):void
		{
			LOG.debug("Status : "+event.info.code);
			if (event.info.code == "NetStream.Play.UnpublishNotify") {
				
			} else if(event.info.code == "NetStream.Play.Start") {
				GlobalDispatcher.dispatchEvent(new AppEvent(AppEvent.PARTNER_ARRIVED));
			} else if(event.info.code == "NetStream.Play.Stop") {
				GlobalDispatcher.dispatchEvent(new AppEvent(AppEvent.PARTNER_WENT));
			} else if(event.info.code == "NetStream.Publish.Start") {
				
			} else if(event.info.code == "NetStream.Unpublish.Success") {
				
			} else if(event.info.code == "NetStream.Publish.BadName") {
				
			} else if(event.info.code == "NetStream.Play.UnpublishNotify") {
				GlobalDispatcher.dispatchEvent(new AppEvent(AppEvent.PARTNER_WENT));
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
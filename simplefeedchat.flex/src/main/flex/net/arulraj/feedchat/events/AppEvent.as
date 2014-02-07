package net.arulraj.feedchat.events {
	import flash.events.Event;
	
	import turbosqel.events.DynamicEvent;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel.pl
	 */
	public dynamic class AppEvent extends DynamicEvent {
		
		public static const SHOW_START:String = "showStart";
		
		public static const CONNECT_SCREEN:String = "connectScreen";
		
		public static const CONNECTING_PARTNER:String = "connectingPartner";
		
		public static const MICROPHONE_MUTED:String = "microphoneMuted";
		
		public static const MICROPHONE_UNMUTED:String = "microphoneUnmuted";
		
		public static const PARTNER_ARRIVED:String = "partnerArrived";
		
		public static const PARTNER_WENT:String = "partnerWent";
		
		public static const PARTNER_SPEAKER_MUTED:String = "partnerMuted";

		public static const PARTNER_SPEAKER_UNMUTED:String = "partnerUnmuted";

		// data params : bitmap , hideClick:Boolean
		public static const SHOW_POPUP:String = "showPopup";
		
		public function AppEvent(type:String , data:* = null):void  {
			super(type,data);
		}
		
	}

}
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
		
		public static const SHOW_MALE_LOGIN:String = "maleLogin";
		public static const SHOW_FEMALE_LOGIN:String = "femaleLogin";
		
		
		public static const FEMALE_CONNECTING:String = "femaleApplyCode";
		
		
		// data params : user , pass
		public static const MALE_LOGIN:String = "maleApplyLogin";
		public static const SHOW_REGISTER:String = "register";
		
		
		public static const MALE_CODE:String = "maleGetCode";
		public static const MALE_SERVER:String = "maleServerInit";
		
		// data params : user , pass
		public static const MALE_REGISTER_COMPLETE:String = "maleRegisterComplete";
		
		
		
		public static const SHOW_FORGET_PASS:String = "forgetPass";
		public static const SHOW_PASS_SENT:String = "passSent";
		
		public static const SHOW_MALE_BACK:String = "backFromAction";
		
		public static const MALE_CONNECT:String = "initMaleConnection";
		
		
		// data params : bitmap , hideClick:Boolean
		public static const SHOW_POPUP:String = "showPopup";
		
		public static const SHOW_CODE_POPUP:String = "showCodePopup";
		
		
		public function AppEvent(type:String , data:* = null):void  {
			super(type,data);
		}
		
	}

}
package net.arulraj.simplevchat.models
{
	import mx.utils.StringUtil;
	
	[Bindable]
	public class ConnectionType
	{
		public static const RTMP:ConnectionType = new ConnectionType("rtmp");
		
		public static const RTMPS:ConnectionType = new ConnectionType("rtmps");
		
		public static const RTMPT:ConnectionType = new ConnectionType("rtmpt");
		
		public var name:String;
		
		public function ConnectionType(name:String)
		{
			this.name = name;
		}
		
		public function toString():String {
			return StringUtil.substitute("[Class ConnectionType] name {0}",name);
		}		
	}
}
package utils
{
	import turbosqel.net.bytes.URLoader;
	
	public class AdvancedURLoader extends URLoader
	{
		private var _userData:*;
		
		public function AdvancedURLoader(targetLink:String, dataType:String=null)
		{
			super(targetLink, dataType);
		}
		
		public function set userData(userdate:*):void {
			_userData = userdate;
		}
		
		public function get userData():* {
			return _userData;
		}
	}
}
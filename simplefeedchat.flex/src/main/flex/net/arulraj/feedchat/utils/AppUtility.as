/**
 * @author Arulaj
 */
package net.arulraj.feedchat.utils {
	
	import mx.logging.Log;
	import mx.logging.ILogger;			
	import mx.formatters.DateFormatter;			
	import mx.controls.Spacer;
			
	public class AppUtility {
		
		private static var LOG:ILogger = Log.getLogger('net.arulraj.feedchat.utils.AppUtility');			
		
		public function AppUtility() {
			
		}
		
		public static function addSpace():Spacer {
			var space:Spacer = new Spacer();
			space.percentWidth = 100;
			space.percentHeight = 100;
			return space;
		}
		
		public static function getCurrentTime():String {
			var currentDate:Date = new Date();
			var dateFormat:DateFormatter = new DateFormatter();
			dateFormat.formatString = "HH:NN:SS> ";
			return dateFormat.format(currentDate);			
		}
	}

}
package net.arulraj.simplevchat.utils
{
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;

	public class LogTrace
	{
		public function LogTrace()
		{
			// Create a target.
			var logTarget:TraceTarget = new TraceTarget();
			
			// Log only messages for the following packages
			logTarget.filters=["*","main.mxml","net.arulraj.feedchat.events.*","net.arulraj.feedchat.connection.*",
				"net.arulraj.feedchat.utils.*","net.arulraj.feedchat.view.*","net.arulraj.feedchat.skin.*"];
			
			// Log all log levels.
			logTarget.level = LogEventLevel.ALL;
			
			// Add date, time, category, and log level to the output.
			logTarget.includeDate = true;
			logTarget.includeTime = true;
			logTarget.includeCategory = true;
			logTarget.includeLevel = true;
			
			// Begin logging.
			Log.addTarget(logTarget);			
		}
	}
}
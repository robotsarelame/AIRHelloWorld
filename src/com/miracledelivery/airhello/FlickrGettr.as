package com.miracledelivery.airhello
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	
	public class FlickrGettr
	{
		private var urlToGo:String;
		
		public function FlickrGettr(url:String)
		{
			this.urlToGo = url;
		}
		
		public function parseUrl():void
		{
			var variables:URLVariables = new URLVariables();
			variables.sessionId = new Date().time;
			variables.userLabel = "someTROLOLOlabel";
			
			var request:URLRequest = new URLRequest(urlToGo);
			request.data = variables;
			trace(this +" " + request.url + "?" + request.data);
			try {
				sendToURL(request);
			}
			catch (e:Error) {
				// handle error here
			}
		}
	}
}
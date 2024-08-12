package portfolio {

	import flash.display.MovieClip;
	import flash.events.*;

	// classes for server script connection
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.events.IOErrorEvent;
	
	public class Falcon extends MovieClip {

		public static const VARIABLES:String = "variables";
		public static const TEXT:String = "text";
		public static const BINARY:String = "binary";
		public static const XML_DATA:String = "XML";
		
		private var myRequest:URLRequest;
		private var myVars:URLVariables;
		private var myLoader:URLLoader;
		private var myDataType:String;
		
		public var data:Object;
		public var error:Boolean;

		public function Falcon(theURL:String, theDataType:String=Falcon.VARIABLES, theSendObject:Object=null) {
			
			myDataType = theDataType;
			
			// set up the objects to send and receive data
			
			myVars = new URLVariables(); // this holds variables to send (as dynamic properties)
			if (theSendObject) {
				for (var i in theSendObject) {
					myVars[i] = theSendObject[i];
				}
			} 
			myRequest = new URLRequest();// this prepares the request for the loader
			myRequest.url=theURL;
			myRequest.method=URLRequestMethod.POST;
			myRequest.data=myVars;
			
			
			myLoader = new URLLoader(); // this is the loader that will send and receive			
			if (myDataType != Falcon.XML_DATA) {
				var myLookup:Object = {
					text:URLLoaderDataFormat.TEXT,
					variables:URLLoaderDataFormat.VARIABLES,
					binary:URLLoaderDataFormat.BINARY
				}
				myLoader.dataFormat = myLookup[myDataType];
			}
			myLoader.addEventListener(Event.COMPLETE, getData);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, getError);		
			myLoader.load(myRequest);// this sends the variables and loads new data from php
				
			
		}
		
		private function getData(e:Event) {
			// the data comes into the e.target.data property
			// if the data is of the format URLLoaderDataFormat.TEXT then just use the data
			// if the data is VARIABLES then convert the data into variable form like so:
			
			if (myDataType == Falcon.VARIABLES) {				
				data = new URLVariables(e.target.data);
			} else {
				if (myDataType == Falcon.XML_DATA) {
					data = XML(e.target.data);				
				} else if (myDataType == Falcon.TEXT) {
					data = e.target.data.replace(/\r/g, "");				
				} else {
					data = e.target.data;
				}
			}
			
			error = false;
			dispatchEvent(new Event(Event.COMPLETE));			
		}
		
		private function getError(e:IOErrorEvent) {
			error = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}
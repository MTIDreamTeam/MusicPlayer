package components
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;

	public class saveXML
	{
		import mx.collections.ArrayCollection;
		import mx.rpc.xml.SimpleXMLEncoder;
		import mx.utils.ObjectUtil;
		import mx.utils.XMLUtil;
		
		
		static private function objectToXML(obj:Object):XML 
		{
			var qName:QName = new QName("root");
			var xmlDocument:XMLDocument = new XMLDocument();
			var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
			var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument);
			var xml:XML = new XML(xmlDocument.toString());
			
			return xml;
		}

		static public function saveXMLtoFile(items_:ArrayCollection):void
		{
			trace(objectToXML(items_).toString());
		}
		
		static public function saveRoot(path:String):void
		{
			var file:File = File.applicationDirectory;
			var file:File = new File( File.applicationDirectory.resolvePath("config.cfg").nativePath );
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			trace("path:" + path);
		    fs.writeUTF(path);
			fs.close();
		}
		
		static public function getRoot():String
		{
			var ret:String;
			var file:File = new File( File.applicationDirectory.resolvePath("config.cfg").nativePath );
			trace(file.nativePath);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.UPDATE)
			if (fs.bytesAvailable == 0)
			 	ret = "";
			else
				ret = fs.readUTF();
			fs.close();
			
			return ret;
		}
	}
}
package components
{
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
		
	}
}
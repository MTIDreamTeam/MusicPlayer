package components
{
	import mx.collections.ArrayCollection;

	public class Artiste
	{
		public var name:String;
		public var icon:String = "assets/folder_open.png";
		public var children:ArrayCollection;
		
		public function Artiste(_name:String, _children:ArrayCollection = null){
			this.name = _name;
			if(_children != null)
				this.children = _children;
		}
	}
}
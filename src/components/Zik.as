package components
{
	public class Zik
	{
		public var name:String;
		public var pathName:String;
		public var icon:Class;
		
		public function Zik(zikName:String, _pathName:String, icon_:Class)
		{
			name = zikName;
			pathName = _pathName;
			icon = icon_;
		}
	}
}
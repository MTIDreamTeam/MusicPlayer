package components
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
	public class MusiqueId3
	{
		private var chanson:Sound;
		private var id3:ID3Info;
		private var art:String = null;
		private var artCol:ArrayCollection = null;
		private var zik:Zik = null;
		public var icon:Class;
		
		public function MusiqueId3(path:File, _artCol:ArrayCollection, icon_:Class)
		{
			chanson = new Sound();
			chanson.addEventListener(Event.ID3, id3Handler);
			chanson.load(new URLRequest(path.nativePath));
			zik = new Zik(path.name, path.nativePath, icon_);
			trace(zik.name);
			artCol = _artCol;
			icon = icon_;
			art = "Other";
			addMusique();
		}
		
		
		private function id3Handler(event:Event):void
		{
			id3 = chanson.id3;
			art = "Other";
			if (id3 != null && id3.artist != null && id3.artist != "" && id3.songName != "")
			{
				art = id3.artist;
				zik.name = id3.songName;
				addMusique();
			}			
		}
		
		private function addMusique():void {
			var added:Boolean = false;
			for(var i:Number=0; i < artCol.length; i++)
			{
				if (artCol.getItemAt(i).name == "Other" && art != "Other")
				{
					for (var j:Number = 0; j < artCol.getItemAt(i).children.length; j++)
					{
						if (artCol.getItemAt(i).children.getItemAt(j).pathName == zik.pathName)
							artCol.getItemAt(i).children.removeItemAt(j);
					}
				}
				if (artCol.getItemAt(i).name == art)
				{
					for (var j:Number = 0; j < artCol.getItemAt(i).children.length; j++)
					{
						if (artCol.getItemAt(i).children.getItemAt(j).pathName == zik.pathName)
							added = true;
					}
					if (!added)
						artCol.getItemAt(i).children.addItem(zik);
					added = true;
				}
			}
			if (!added)
				artCol.addItem(new Artiste(art, new ArrayCollection([zik])));
		}
		
	}
}
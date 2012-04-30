package components
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	import mx.collections.ArrayList;
	
	import spark.components.Button;
	import spark.components.HSlider;
	import spark.components.Image;
	import spark.components.List;
	import spark.components.TextArea;
	

	public class Player
	{
		private var positionTimer:Timer;
		private var charge:Boolean = false;
		private var lect:Button;
		private var temps:Number;
		private var decalage:Number;
		private var chanson:Sound;
		private var canal:SoundChannel;
		private var trans:SoundTransform;
		private var fichier:String = "";
		private var progBar:HSlider;
		private var lyricsField:TextArea;
		private var image:Image;
		private var playList:ArrayList;
		private var current:int;
		private var list:List;
		
		public function getCurrent():int{
			return current;
		}
		
		public function getChanson():Sound
		{
			return chanson;	
		}
		
		public function Player(prog:HSlider, lectB:Button, lyrics:TextArea, cover:Image, playList_:ArrayList, list_:List)
		{
			lect = lectB;
			progBar = prog;		
			trans = new SoundTransform();
			lyricsField = lyrics;
			image = cover;
			playList = playList_;
			current = 0;
			list = list_;
		}
			
		
		public function setFile(path:String):void
		{
			fichier = path;
		}
		
		public function getFile():String
		{
			return fichier;
		}
		
		private function positionTimerHandler(event:TimerEvent):void {
			progBar.value = canal.position / chanson.length * 100;
		}
		
		private function completeHandler(event:Event):void {
			trace("completeHandler: " + event);
		}
		
		private function id3Handler(event:Event):void {
			trace("id3Handler: " + event);
			var id3:ID3Info = chanson.id3;
			var urlLyrics:String = "";
			
			lyricsField.text = "Chargement de la pochette et des paroles !";
			image.source = "assets/Cover.jpg";
			
			if (id3.artist != null)
			{
				var chargeur:URLLoader = null;
				var adresse:URLRequest = null;
				if (id3.songName != null)
				{
					urlLyrics += "http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?";
					urlLyrics += "artist=" + id3.artist;
					urlLyrics += "&song=" + id3.songName;
					
					//Code pour charger URL
					chargeur = new URLLoader ();
					adresse = new URLRequest (urlLyrics);
					chargeur.dataFormat = URLLoaderDataFormat.TEXT;
					chargeur.load(adresse);
					
					// définition des évenements de l'objet chargeur
					chargeur.addEventListener(Event.COMPLETE, parseLyrics);
					chargeur.addEventListener(IOErrorEvent.IO_ERROR, indiquerErreur);
					if (lyricsField.text == "Chargement de la pochette et des paroles !")
						lyricsField.text = "Nous n'avons pas pu trouver les paroles de votre musique !";
				}
				else if (id3.album != null)
				{
					//http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=b25b959554ed76058ac220b7b2e0a026&artist=Cher&album=Believe
					
					urlLyrics += "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=b25b959554ed76058ac220b7b2e0a026&artist=";
					urlLyrics += id3.artist;
					urlLyrics += "&album=" + id3.album;
					
					//Code pour charger URL
					chargeur = new URLLoader ();
					adresse = new URLRequest (urlLyrics);
					chargeur.dataFormat = URLLoaderDataFormat.TEXT;
					chargeur.load(adresse);
					
					// définition des évenements de l'objet chargeur
					chargeur.addEventListener(Event.COMPLETE, parseCover);
					chargeur.addEventListener(IOErrorEvent.IO_ERROR, indiquerErreur);
					
					lyricsField.text = "Nous n'avons pas pu trouver les paroles de votre musique !";
				}
				else
					lyricsField.text = "Nous n'avons pas pu trouver des informations concernant votre musique !";
			}
			else
			{
				lyricsField.text = "Nous n'avons pas pu trouver des informations concernant votre musique !";
				image.source = "assets/Cover.jpg";
			}
		}
		
		private function ioErrorHandler(event:Event):void {
			trace("ioErrorHandler: " + event);
			positionTimer.stop();       
		}
		
		private function progressHandler(event:ProgressEvent):void {
		}
		
		public function next():void
		{
			if (canal != null)
			{
				canal.stop();
				positionTimer.stop();
			}
			lect.label = "assets/play.png";
			progBar.value = 0;
			charge = false;
			decalage = 0;
			canal = null;
			chanson = null;
			lyricsField.text = "";
			if (playList.length > current + 1)
			{
				current++;
				fichier = playList.getItemAt(current).pathName;
				lecture();
				lect.label = "assets/pause.png";
			}
		}
		
		
		public function play(index:int):void
		{
			if (canal != null)
			{
				canal.stop();
				positionTimer.stop();
			}
			lect.label = "assets/play.png";
			progBar.value = 0;
			charge = false;
			decalage = 0;
			canal = null;
			chanson = null;
			lyricsField.text = "";
			current = index;
			if (current >= 0 && current < playList.length)
			{
				fichier = playList.getItemAt(current).pathName;
				lecture();
				lect.label = "assets/pause.png";
				list.selectedIndex = current;
			}
			else
				current = 0;
		}
		
		public function previous():void
		{
			if (canal != null)
			{
				canal.stop();
				positionTimer.stop();
			}
			lect.label = "assets/play.png";
			progBar.value = 0;
			charge = false;
			decalage = 0;
			canal = null;
			chanson = null;
			lyricsField.text = "";
			if (current > 0)
			{
				current--;
				fichier = playList.getItemAt(current).pathName;
				lecture();
				lect.label = "assets/pause.png";
				list.selectedIndex = current;
			}
		}
		
		private function soundCompleteHandler(event:Event):void {
			trace("soundCompleteHandler: " + event);
			positionTimer.stop();
			progBar.value = 0;
			lect.label = "assets/play.png";
			charge = false;
			decalage = 0;
			canal = null;
			chanson = null;
			lyricsField.text = "";
			if (playList.length > current + 1)
			{
				current++;
				fichier = playList.getItemAt(current).pathName;
				lecture();
				lect.label = "assets/pause.png";
				list.selectedIndex = current;
			}
		}
		
		
		public function stop():void
		{
			if (canal != null)
			{
				canal.stop();
				decalage = 0;
			}
		}
		
		public function pause():void
		{
			canal.stop();
			decalage = canal.position;
		}
		
		public function adjustTime(percent:Number):void
		{
			if (canal != null)
			{
				canal.stop();
				decalage = percent/100 * chanson.length;
				canal = chanson.play(decalage);
				canal.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				canal.soundTransform = trans;
			}
			else
				progBar.value = 0;
		}
		
		public function setVolume(vol:Number):void
		{
			trans.volume = vol;
			if (canal != null)
			{
				canal.soundTransform = trans;
			}
		}
		
		//On déclare la fonction lecture
		
		public function lecture():void
		{
			if (fichier != "")
			{
			if (charge == false) //Si la chanson n'est pas chargée
			{	
				chanson = new Sound();
				chanson.addEventListener(Event.COMPLETE, completeHandler);
				chanson.addEventListener(Event.ID3, id3Handler);
				chanson.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				chanson.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				chanson.load(new URLRequest(fichier)); //Dans le cas contraire, on charge la chanson
				positionTimer = new Timer(50);
				positionTimer.addEventListener(TimerEvent.TIMER, positionTimerHandler);
				positionTimer.start();
				charge = true;
				decalage = 0;
			}
			canal = chanson.play(decalage);
			canal.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			canal.soundTransform = trans;
			list.selectedIndex = current;
			}
		}

		
		public function parseLyrics(event:Event):void
		{
			var contenu:String = event.target.data;
			var result:XMLDocument = new XMLDocument();
			result.ignoreWhite = true;
			result.parseXML(contenu);
			
			//Obtention des paroles dans le XML
			var nodes:Array = result.firstChild.childNodes;
			trace(result);
			for each(var item:XMLNode in nodes)
			{
				if (item.nodeName == "Lyric")
				{
					if (item.firstChild != null)
						lyricsField.text = htmlUnescape(item.firstChild.toString());
				}
				
				if (item.nodeName == "LyricCovertArtUrl")
				{
					if (item.firstChild != null)
						image.source = new URLRequest(item.firstChild.toString());
				}
			}
		}
		
		public function parseCover(event:Event):void
		{
			var contenu:String = event.target.data;
			var result:XMLDocument = new XMLDocument();
			result.ignoreWhite = true;
			result.parseXML(contenu);
			
			//Obtention des paroles dans le XML
			var nodes:Array = result.firstChild.firstChild.childNodes;
			for each(var item:XMLNode in nodes)
			{
				trace(item.nodeName);
				if (item.nodeName == "image")
				{
					image.source = new URLRequest(item.firstChild.toString());
					trace(item.firstChild.toString());
				}
			}
		}
		
		public function indiquerErreur(event:Event):void
		{
			trace("Erreur url: " + event);
		}
		
		public function htmlUnescape(str:String):String
		{
			return new XMLDocument(str).firstChild.nodeValue;
		}
	}
}
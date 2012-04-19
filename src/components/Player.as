package components
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import spark.components.HSlider;

	public class Player
	{
		private var positionTimer:Timer;
		private var charge:Boolean = false;
		private var temps:Number;
		private var decalage:Number;
		private var chanson:Sound;
		private var canal:SoundChannel;
		private var trans:SoundTransform;
		private var fichier:String;
		private var progBar:HSlider;
		
		public function getChanson():Sound
		{
			return chanson;	
		}
		
		public function Player(prog:HSlider)
		{
			progBar = prog;
			chanson = new Sound();
			trans = new SoundTransform();
			fichier = "D:\\Musique\\Armée rouge\\Le chant des partisans.mp3";
			chanson.addEventListener(Event.COMPLETE, completeHandler);
			chanson.addEventListener(Event.ID3, id3Handler);
			chanson.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			chanson.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		private function positionTimerHandler(event:TimerEvent):void {
			trace("positionTimerHandler: " + canal.position.toFixed(2));
			progBar.value = canal.position / chanson.length * 100;
		}
		
		private function completeHandler(event:Event):void {
			trace("completeHandler: " + event);
		}
		
		private function id3Handler(event:Event):void {
			trace("id3Handler: " + event);
		}
		
		private function ioErrorHandler(event:Event):void {
			trace("ioErrorHandler: " + event);
			positionTimer.stop();       
		}
		
		private function progressHandler(event:ProgressEvent):void {
			trace("progressHandler: " + event);
		}
		
		private function soundCompleteHandler(event:Event):void {
			trace("soundCompleteHandler: " + event);
			positionTimer.stop();
		}
		
		public function stop():void
		{
			canal.stop();
			decalage = 0;
		}
		
		public function pause():void
		{
			canal.stop();
			decalage = canal.position;
		}
		
		public function adjustTime(percent:Number):void
		{
			canal.stop();
			decalage = percent/100 * chanson.length;
			canal = chanson.play(decalage);
			canal.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			canal.soundTransform = trans;
		}
		
		public function setVolume(vol:Number):void
		{
			trans.volume = vol;
			canal.soundTransform = trans;
			
		}
		
		//On déclare la fonction lecture
		
		public function lecture():void
		{
			if (charge == false) //Si la chanson n'est pas chargée
			{			
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
		}
	}
}
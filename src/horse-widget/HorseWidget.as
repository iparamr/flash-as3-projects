package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

	public class HorseWidget extends Sprite {

		public function HorseWidget() {
			//definition of assets
			defineAssets();
			//add events
			addEvents();
		}


		public function fadeOutSound(e:Event):void {
			//channel.stop();

			var transform:SoundTransform=channel.soundTransform;

			if (transform.volume>0) {
				//trace("vol ", transform.volume);
				transform.volume-=.05;
				channel.soundTransform=transform;
			} else {
				this.removeEventListener(Event.ENTER_FRAME, fadeOutSound);
				transform.volume=0;
				channel.soundTransform=transform;
				//trace("remove");
			}

		}

		private var channel:SoundChannel = new SoundChannel();

		public function playSound():void {

			var s:Sound=allAssets[clipIndex][4];
			channel.stop();
			channel=s.play();
		}

		private var angle:Number=- Math.PI/2;
		private const SPEED:Number=.2;
		private const RANGE:int=50;

		private function blurEffect(evt:Event):void {
			var cosine:Number=Math.cos(angle)*RANGE;
			var blurX:int=cosine;
			var filter:BlurFilter=new BlurFilter(blurX,0,BitmapFilterQuality.HIGH);
			var filters_array:Array=new Array();

			filters_array.push(filter);
			blurText.filters=filters_array;

			if (blurX>45) {
				txtLabel.text=allAssets[clipIndex][2];
			}
			if (blurX<0) {
				blurText.removeEventListener(Event.ENTER_FRAME, blurEffect);
				playSound();
			}

			angle+=SPEED;
		}

		public function updateText():void {

			if (isMouseOver) {
				if (isMouseDown) {
					if (txtLabel.text!=allAssets[clipIndex][2]) {
						angle=- Math.PI/2;
						blurText.addEventListener(Event.ENTER_FRAME, blurEffect);
					} else {
						playSound();
					}
				} else {
					txtLabel.text=allAssets[clipIndex][1];
				}
			} else {
				blurText.removeEventListener(Event.ENTER_FRAME, blurEffect);
				blurText.filters=[];
				txtLabel.text="";
				this.addEventListener(Event.ENTER_FRAME, fadeOutSound);
			}
		}

		public function onMouseOver(e:MouseEvent):void {
			var m:MovieClip=e.target as MovieClip;
			m.gotoAndPlay(2);
			clipIndex=m.index;
			isMouseOver=true;
			updateText();
		}

		public function onMouseOut(e:MouseEvent):void {
			var m:MovieClip=e.target as MovieClip;
			m.gotoAndStop(1);
			clipIndex=-1;
			isMouseOver=false;
			isMouseDown=false;
			updateText();
		}

		public function stageMouseDown(e:MouseEvent):void {
			isMouseDown=true;
			updateText();
		}

		public function stageMouseUp(e:MouseEvent):void {
			isMouseDown=false;
			//updateText();
		}


		private var isMouseDown:Boolean=false;
		private var isMouseOver:Boolean=false;
		private var clipIndex:int=-1;

		public function addEvents():void {

			for (var i:int = 0; i < allAssets.length; i++) {
				//trace(hotSpotsStr[i]);
				var m:MovieClip=this[allAssets[i][0]];
				m.buttonMode=true;
				m.mouseChildren=false;
				m.index=i;
				m.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				m.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

				//all sounds
				var ClassRef:Class=getDefinitionByName(allAssets[i][3]) as Class;
				var s:Sound = new ClassRef();
				allAssets[i][4]=s;
			}
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
		}


		private var txtLabel:TextField;
		private var blurText:MovieClip;
		private var allAssets:Array;

		/**
		 * Assets are in the order:
		 * hotspot sprite, english label, stone/native language, sound string, sound object
		 * */

		public function defineAssets():void {

			blurText=this["mcBlurText"];
			txtLabel=blurText["txtShowLabel"];
			txtLabel.text="";

			allAssets = new Array(
			   ["forelock","Forelock", "Norhe Orhnatiya","forelock.mp3"],
			   ["forehead","Forehead","Îtohu","forehead.mp3"],
			   ["muzzle","Muzzle","Pude","muzzle.mp3"],
			   ["cheek","Cheek","Tapû","cheek.mp3"],
			   ["pointOfShoulder","Point of Shoulder","Hiyede","pointofshoulder.mp3"],
			   ["chest","Chest","Mâku","chest.mp3"],
			   ["elbow","Elbow","Îthpathe","elbow.mp3"],
			   ["forearm","Forearm","Ogatha Hûgapa","forearm.mp3"],
			   ["knee","Knee","Tarhâge","knee.mp3"],
			   ["belly","Belly","Tethi","belly.mp3"],
			   ["flank","Flank","Nârhûsî","flank.mp3"],
			   ["stifle","Stifle","Cheja Nen Îtogam Baksisîju","stifle.mp3"],
			   ["hoof","Hoof","Sage","hoof.mp3"],
			   ["fetlock","Fetlock","Thikâ","fetlock.mp3"],
			   ["cannon","Cannon","Cheja","cannon.mp3"],
			   ["tail","Tail","Thîde","tail.mp3"],
			   ["thigh","Thigh","Thichâ","thigh.mp3"],
			   ["buttock","Buttock","Ûthe Soga","buttock.mp3"],
			   ["pointOfRump","Point of Rump","Thichâ Sûmpsû","pointofrump.mp3"],
			   ["dock","Dock","Thîde Hude","dock.mp3"],
			   ["pointOfHip","Point of Hip","Nîde","pointofhip.mp3"],
			   ["back","Back","Tarhpa","back.mp3"],
			   ["shoulder","Shoulder","Hiyede","shoulder.mp3"],
			   ["mane","Mane","Apehî","mane.mp3"]
			   );
		}
	}
}
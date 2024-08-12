package src {
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.media.*;
    import flash.net.*;
	import src.effects.beats.*;
    import src.interfaces.*;

    public class SelfPortrait extends Sprite {
        private var myBeats:BeatMaker;
        private var myPulse:MovieClip;
        private var myShuttle:Shuttle;
        private var myChannel:SoundChannel;
        private var myPicture:Loader;
        private var mySound:Sound;

        public function SelfPortrait() {
            super();
            myPicture = new Loader();
            myPicture.load(new URLRequest("background.jpg"));
            addChild(myPicture);

            mySound = new Sound();
            mySound.load(new URLRequest("music.mp3"));
            myChannel = mySound.play();

            myShuttle = new Shuttle(this, mySound, myChannel);

            var loc1:Class = Pulse;
            var loc2:int = 10;
            var loc3:int = 22;
            var loc4:Array = [false, true, false];
            var loc5:Boolean = false;
            var loc6:Boolean = false;
            var loc7:int = 475;
            var loc8:int = -4;
            var loc9:Array = [new BlurFilter(1)];

            myBeats = new BeatMaker(loc1, loc4, loc2, loc3, loc5, loc6);
            addChild(myBeats);

            myBeats.setBeatObject({
                "clip":[Pulse, Pulse, Pulse, Pulse, Pulse, Pulse, Pulse, Pulse, Pulse, Pulse], 
                "x":[93 + loc8, 117 + loc8, 141 + loc8, 165 + loc8, 189 + loc8, 213 + loc8, 237 + loc8, 261 + loc8, 285 + loc8, 309 + loc8], 
                "y":[loc7, loc7, loc7, loc7, loc7, loc7, loc7, loc7, loc7, loc7], 
                "alpha":[1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 
                "color":[null, null, null, null, null, null, null, null, null, null], 
                "blendMode":["normal", "normal", "normal", "normal", "normal", "normal", "normal", "normal", "normal", "normal"], 
                "filters":[loc9, loc9, loc9, loc9, loc9, loc9, loc9, loc9, loc9, loc9], 
                "beatSize":[loc3, loc3, loc3, loc3, loc3, loc3, loc3, loc3, loc3, loc3], 
                "startSize":[1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            });

            myBeats.setAllBeats("alpha", "1");
            myBeats.setAllBeats("blendMode", "normal");
            myBeats.setBeat("color", 0, 0xFFFFFF);
            myBeats.setBeat("blendMode", 0, "normal");
            myBeats.setBeat("x", 0, 93 + loc8);
            myBeats.setBeat("y", 0, loc7);
            myBeats.toggleDisplay();

            if (stage) {
                stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListener);
            } else {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            }
        }

        private function onAddedToStage(event:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListener);
        }

        private function keyListener(event:KeyboardEvent):void {
            trace("keycode = " + event.keyCode);
            if (event.keyCode == 82 && (event.shiftKey || event.ctrlKey)) {
                myBeats.recordBeat();
            }
        }
    }
}

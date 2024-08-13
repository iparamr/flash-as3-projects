package src {
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.media.*;
    import flash.net.*;
    import src.effects.beats.*;
    import src.interfaces.*;

    public class SelfPortrait extends Sprite {
        private var beatMaker:BeatMaker;
        private var pulseClip:MovieClip;
        private var shuttle:Shuttle;
        private var soundChannel:SoundChannel;
        private var backgroundImage:Loader;
        private var backgroundSound:Sound;

        public function SelfPortrait() {
            super();
            // Load and display the background image
            backgroundImage = new Loader();
            backgroundImage.load(new URLRequest("background.jpg"));
            addChild(backgroundImage);

            // Load and play the sound
            backgroundSound = new Sound();
            backgroundSound.load(new URLRequest("music.mp3"));
            soundChannel = backgroundSound.play();

            // Initialize the Shuttle object
            if (stage) {
                init();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            }
        }

        private function onAddedToStage(event:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            init();
        }

        private function init():void {
            // Create the Shuttle object and pass the stage reference
            shuttle = new Shuttle(stage, backgroundSound, soundChannel);

            // Initialize BeatMaker with various parameters
            var pulseClass:Class = Pulse;
            var beatCount:int = 10;
            var beatSize:int = 22;
            var beatPattern:Array = [false, true, false];
            var loop:Boolean = false;
            var mute:Boolean = false;
            var yPos:int = 475;
            var xOffset:int = -4;
            var blurFilters:Array = [new BlurFilter(1)];

            beatMaker = new BeatMaker(pulseClass, beatPattern, beatCount, beatSize, loop, mute);
            addChild(beatMaker);

            // Set up beat objects with various properties
            beatMaker.setBeatObject({
                "clip":[Pulse, Pulse, Pulse, Pulse, Pulse, Pulse, Pulse, Pulse, Pulse, Pulse], 
                "x":[93 + xOffset, 117 + xOffset, 141 + xOffset, 165 + xOffset, 189 + xOffset, 213 + xOffset, 237 + xOffset, 261 + xOffset, 285 + xOffset, 309 + xOffset], 
                "y":[yPos, yPos, yPos, yPos, yPos, yPos, yPos, yPos, yPos, yPos], 
                "alpha":[1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 
                "color":[null, null, null, null, null, null, null, null, null, null], 
                "blendMode":["normal", "normal", "normal", "normal", "normal", "normal", "normal", "normal", "normal", "normal"], 
                "filters":[blurFilters, blurFilters, blurFilters, blurFilters, blurFilters, blurFilters, blurFilters, blurFilters, blurFilters, blurFilters], 
                "beatSize":[beatSize, beatSize, beatSize, beatSize, beatSize, beatSize, beatSize, beatSize, beatSize, beatSize], 
                "startSize":[1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            });

            // Set additional properties for beats
            beatMaker.setAllBeats("alpha", "1");
            beatMaker.setAllBeats("blendMode", "normal");
            beatMaker.setBeat("color", 0, 0xFFFFFF);
            beatMaker.setBeat("blendMode", 0, "normal");
            beatMaker.setBeat("x", 0, 93 + xOffset);
            beatMaker.setBeat("y", 0, yPos);
            beatMaker.toggleDisplay();

            // Add keyboard event listener
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListener);
        }

        private function keyListener(event:KeyboardEvent):void {
            trace("keycode = " + event.keyCode);
            // Record beat if 'R' key is pressed with Shift or Ctrl
            if (event.keyCode == 82 && (event.shiftKey || event.ctrlKey)) {
                beatMaker.recordBeat();
            }
        }
    }
}

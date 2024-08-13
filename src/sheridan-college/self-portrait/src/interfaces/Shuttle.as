package src.interfaces 
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class Shuttle extends Sprite
    {
        private const KEY_RIGHT:uint = 39;
        private const KEY_LEFT:uint = 37;
        private const KEY_SPACE:uint = 32;

        private var backwardTimer:Timer;
        private var forwardTimer:Timer;
        private var pausePos:Number;
        private var myChannel:SoundChannel;
        private var mySound:Sound;
        private var mySegment:Number;
        private var myJump:Number;

        private var forwardCheck:Boolean = false;
        private var backwardCheck:Boolean = false;
        private var pauseCheck:Boolean = false;

        public function Shuttle(stage:Stage, sound:Sound, channel:SoundChannel, segment:Number = 100, jump:Number = 2000)
        {
            super();
            mySound = sound;
            myChannel = channel;
            mySegment = segment;
            myJump = jump;
            // Add keyboard event listeners
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
        }

        public function dispose():void
        {
            // Clear timers and remove event listeners
            clearTimers();
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
        }

        private function keyDownHandler(event:KeyboardEvent):void
        {
            switch (event.keyCode)
            {
                case KEY_RIGHT:
                    handleDirection(1);
                    break;
                case KEY_LEFT:
                    handleDirection(-1);
                    break;
            }
        }

        private function keyUpHandler(event:KeyboardEvent):void
        {
            if (event.keyCode == KEY_SPACE)
            {
                togglePause();
            }
            else if (event.keyCode == KEY_RIGHT)
            {
                if (forwardTimer) forwardTimer.stop();
                forwardCheck = false;
            }
            else if (event.keyCode == KEY_LEFT)
            {
                if (backwardTimer) backwardTimer.stop();
                backwardCheck = false;
            }
        }

        private function handleDirection(direction:int):void
        {
            // Prevent redundant actions
            if ((direction == 1 && forwardCheck) || (direction == -1 && backwardCheck))
            {
                return;
            }

            // Resume from pause if necessary
            if (pauseCheck)
            {
                pauseCheck = false;
                myChannel = mySound.play(pausePos);
            }

            // Set direction flags
            forwardCheck = (direction == 1);
            backwardCheck = (direction == -1);

            // Clear existing timers and start moving sound
            clearTimers();
            moveSound(direction);
            if (direction == 1)
            {
                forwardTimer = new Timer(mySegment);
                forwardTimer.addEventListener(TimerEvent.TIMER, function():void { moveSound(direction); });
                forwardTimer.start();
            }
            else
            {
                backwardTimer = new Timer(mySegment);
                backwardTimer.addEventListener(TimerEvent.TIMER, function():void { moveSound(direction); });
                backwardTimer.start();
            }
        }

        private function togglePause():void
        {
            // Clear timers and toggle pause state
            clearTimers();
            forwardCheck = false;
            backwardCheck = false;

            if (pauseCheck)
            {
                pauseCheck = false;
                myChannel = mySound.play(pausePos);
            }
            else
            {
                pausePos = myChannel.position;
                pauseCheck = true;
                myChannel.stop();
            }
        }

        private function clearTimers():void
        {
            if (forwardTimer) forwardTimer.stop();
            if (backwardTimer) backwardTimer.stop();
        }

        private function moveSound(direction:int):void
        {
            // Calculate new sound position and play from there
            var soundPos:Number = myChannel.position + myJump * direction;
            myChannel.stop();
            myChannel = mySound.play(Math.max(Math.min(soundPos, mySound.length), 0));
        }
    }
}

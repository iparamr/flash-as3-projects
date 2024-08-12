package src.interfaces 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.utils.*;
    
    public class Shuttle extends flash.display.Sprite
    {
        public function Shuttle(arg1:Object, arg2:flash.media.Sound, arg3:flash.media.SoundChannel, arg4:Number=100, arg5:Number=2000)
        {
            forwardCheck = false;
            backwardCheck = false;
            pauseCheck = false;
            super();
            mySound = arg2;
            myChannel = arg3;
            mySegment = arg4;
            myJump = arg5;
            arg1.stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyDownHandler);
            arg1.stage.addEventListener(flash.events.KeyboardEvent.KEY_UP, keyUpHandler);
            return;
        }

        public function dispose():*
        {
            flash.utils.clearInterval(forwardID);
            flash.utils.clearInterval(backwardID);
            stage.removeEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyDownHandler);
            stage.removeEventListener(flash.events.KeyboardEvent.KEY_UP, keyUpHandler);
            return;
        }

        internal function keyDownHandler(arg1:flash.events.KeyboardEvent):*
        {
            if (arg1.keyCode != 39) 
            {
                if (arg1.keyCode == 37) 
                {
                    if (backwardCheck) 
                    {
                        return;
                    }
                    if (pauseCheck) 
                    {
                        pauseCheck = false;
                        myChannel = mySound.play(pausePos);
                    }
                    backwardCheck = true;
                    forwardCheck = false;
                    flash.utils.clearInterval(forwardID);
                    flash.utils.clearInterval(backwardID);
                    moveSound(-1);
                    backwardID = flash.utils.setInterval(moveSound, mySegment, -1);
                }
            }
            else 
            {
                if (forwardCheck) 
                {
                    return;
                }
                if (pauseCheck) 
                {
                    pauseCheck = false;
                    myChannel = mySound.play(pausePos);
                }
                forwardCheck = true;
                backwardCheck = false;
                flash.utils.clearInterval(forwardID);
                flash.utils.clearInterval(backwardID);
                moveSound(1);
                forwardID = flash.utils.setInterval(moveSound, mySegment, 1);
            }
            return;
        }

        internal function keyUpHandler(arg1:flash.events.KeyboardEvent):*
        {
            if (arg1.keyCode != 39) 
            {
                if (arg1.keyCode != 37) 
                {
                    if (arg1.keyCode == 32) 
                    {
                        flash.utils.clearInterval(backwardID);
                        flash.utils.clearInterval(forwardID);
                        backwardCheck = false;
                        forwardCheck = false;
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
                }
                else 
                {
                    flash.utils.clearInterval(backwardID);
                    backwardCheck = false;
                }
            }
            else 
            {
                flash.utils.clearInterval(forwardID);
                forwardCheck = false;
            }
            return;
        }

        internal function moveSound(arg1:Number):*
        {
            soundPos = myChannel.position + myJump * arg1;
            myChannel.stop();
            myChannel = mySound.play(Math.max(Math.min(soundPos, mySound.length), 0));
            return;
        }

        internal var backwardID:Number;

        internal var forwardCheck:Boolean=false;

        internal var pausePos:Number;

        internal var forwardID:Number;

        internal var myChannel:flash.media.SoundChannel;

        internal var pauseCheck:Boolean=false;

        internal var mySound:flash.media.Sound;

        internal var soundPos:Number;

        internal var backwardCheck:Boolean=false;

        internal var mySegment:Number;

        internal var myJump:Number;
    }
}

package src.effects.beats 
{
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.utils.*;
    
    internal class SoundBeat extends flash.display.Sprite
    {
        public function SoundBeat(arg1:*=8, arg2:*=true, arg3:*=200, arg4:*=10000, arg5:*=true, arg6:*=5)
        {
            beatArray = [];
            ba = new flash.utils.ByteArray();
            normalizeCount = 0;
            super();
            numBumps = arg1 + 1;
            isSpectrum = arg2;
            myAmplitude = arg3;
            myScale = arg3;
            isNormalize = arg5;
            mySensitivity = arg6;
            myThreshhold = arg4;
            startProcess();
            return;
        }

        public function stopProcess():*
        {
            removeEventListener(flash.events.Event.ENTER_FRAME, processSound);
            return;
        }

        public function dispose():*
        {
            removeEventListener(flash.events.Event.ENTER_FRAME, processSound);
            return;
        }

        public function setSpectrum(arg1:Boolean):*
        {
            isSpectrum = arg1;
            return;
        }

        public function startProcess():*
        {
            stopProcess();
            addEventListener(flash.events.Event.ENTER_FRAME, processSound);
            return;
        }

        public function getAmplitude():*
        {
            return myAmplitude;
        }

        internal function processSound(arg1:flash.events.Event):*
        {
            var loc1:*=0;
            var loc2:*=NaN;
            var loc3:*=null;
            var loc4:*=undefined;
            var loc5:*=null;
            var loc6:*=false;
            flash.media.SoundMixer.computeSpectrum(ba, isSpectrum, 0);
            loc1 = Math.floor(256 / numBumps);
            loc2 = 0;
            loc3 = [];
            loc4 = 0;
            while (loc4 < 256) 
            {
                loc2 = loc2 + ba.readFloat();
                if (loc4 % loc1 == 0) 
                {
                    loc3[loc4] = loc2 / loc1;
                    loc2 = 0;
                }
                ++loc4;
            }
            loc5 = [];
            loc4 = 0;
            while (loc4 < 256) 
            {
                loc2 = loc2 + ba.readFloat();
                if (loc4 % loc1 == 0) 
                {
                    if (isSpectrum) 
                    {
                        loc5.push((loc3[loc4] + loc2 / loc1) / 2 * (Math.pow(loc4, 1.2) + 150) / 200);
                    }
                    else 
                    {
                        loc5.push((loc3[loc4] + loc2 / loc1) / 2);
                    }
                    loc2 = 0;
                }
                ++loc4;
            }
            if (isNormalize) 
            {
                var loc7:*;
                normalizeCount++;
                if (normalizeCount % mySensitivity == 0) 
                {
                    loc6 = false;
                    loc4 = 0;
                    while (loc4 < beatArray.length) 
                    {
                        if (beatArray[loc4] > myAmplitude) 
                        {
                            myScale = myScale - myAmplitude / 50;
                            loc6 = true;
                            break;
                        }
                        ++loc4;
                    }
                    if (!loc6) 
                    {
                        myScale = myScale + myAmplitude / 50;
                    }
                }
            }
            beatArray = [];
            loc4 = 1;
            while (loc4 < numBumps) 
            {
                beatArray.push(-Math.max((-Math.round(Math.abs(loc5[loc4] * myScale) * 1000)) / 1000, -myThreshhold));
                ++loc4;
            }
            dispatchEvent(new SoundBeatEvent(SoundBeatEvent.PROCESS_SOUND, beatArray));
            return;
        }

        internal var myScale:Number;

        internal var normalizeCount:Number=0;

        internal var isNormalize:Boolean;

        internal var numBumps:Number;

        internal var isSpectrum:Boolean;

        internal var myAmplitude:Number;

        internal var ba:flash.utils.ByteArray;

        internal var beatArray:Array;

        internal var mySensitivity:Number;

        internal var myThreshhold:Number;
    }
}

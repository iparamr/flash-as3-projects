package src.effects.beats 
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.media.SoundMixer;
    import flash.utils.ByteArray;
    
    internal class SoundBeat extends Sprite
    {
        private var beatValues:Array;
        private var byteArray:ByteArray;
        private var normalizationCounter:int;
        private var numberOfBumps:int;
        private var useSpectrum:Boolean;
        private var amplitude:Number;
        private var scale:Number;
        private var normalize:Boolean;
        private var sensitivity:int;
        private var threshold:Number;

        public function SoundBeat(bumps:int = 8, spectrum:Boolean = true, amp:Number = 200, thresh:Number = 10000, norm:Boolean = true, sens:int = 5)
        {
            super();
            beatValues = [];
            byteArray = new ByteArray();
            normalizationCounter = 0;
            numberOfBumps = bumps + 1;
            useSpectrum = spectrum;
            amplitude = amp;
            scale = amp;
            normalize = norm;
            sensitivity = sens;
            threshold = thresh;
            startProcessing();
        }

        public function stopProcessing():void
        {
            removeEventListener(Event.ENTER_FRAME, processSound);
        }

        public function dispose():void
        {
            stopProcessing();
        }

        public function setSpectrum(spectrum:Boolean):void
        {
            useSpectrum = spectrum;
        }

        public function startProcessing():void
        {
            stopProcessing();
            addEventListener(Event.ENTER_FRAME, processSound);
        }

        public function getAmplitude():Number
        {
            return amplitude;
        }

        private function processSound(event:Event):void
        {
            SoundMixer.computeSpectrum(byteArray, useSpectrum, 0);
            var segmentSize:int = Math.floor(256 / numberOfBumps);
            var segmentSum:Number = 0;
            var segmentAverages:Array = [];
            var i:int = 0;

            while (i < 256) 
            {
                segmentSum += byteArray.readFloat();
                if (i % segmentSize == 0) 
                {
                    segmentAverages[i] = segmentSum / segmentSize;
                    segmentSum = 0;
                }
                i++;
            }

            var processedValues:Array = [];
            i = 0;
            while (i < 256) 
            {
                segmentSum += byteArray.readFloat();
                if (i % segmentSize == 0) 
                {
                    if (useSpectrum) 
                    {
                        processedValues.push((segmentAverages[i] + segmentSum / segmentSize) / 2 * (Math.pow(i, 1.2) + 150) / 200);
                    }
                    else 
                    {
                        processedValues.push((segmentAverages[i] + segmentSum / segmentSize) / 2);
                    }
                    segmentSum = 0;
                }
                i++;
            }

            if (normalize) 
            {
                normalizationCounter++;
                if (normalizationCounter % sensitivity == 0) 
                {
                    var adjustmentNeeded:Boolean = false;
                    for (i = 0; i < beatValues.length; i++) 
                    {
                        if (beatValues[i] > amplitude) 
                        {
                            scale -= amplitude / 50;
                            adjustmentNeeded = true;
                            break;
                        }
                    }
                    if (!adjustmentNeeded) 
                    {
                        scale += amplitude / 50;
                    }
                }
            }

            beatValues = [];
            for (i = 1; i < numberOfBumps; i++) 
            {
                beatValues.push(-Math.max((-Math.round(Math.abs(processedValues[i] * scale) * 1000)) / 1000, -threshold));
            }

            dispatchEvent(new SoundBeatEvent(SoundBeatEvent.PROCESS_SOUND, beatValues));
        }
    }
}

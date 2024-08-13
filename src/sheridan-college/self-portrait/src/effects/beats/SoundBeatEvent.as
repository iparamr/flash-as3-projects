package src.effects.beats 
{
    import flash.events.Event;
    
    internal class SoundBeatEvent extends Event
    {
        public static const PROCESS_SOUND:String = "processsound";

        public var processArray:Array;

        public function SoundBeatEvent(type:String, processArray:Array, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.processArray = processArray;
        }

        public override function clone():Event
        {
            return new SoundBeatEvent(type, processArray, bubbles, cancelable);
        }

        public override function toString():String
        {
            return formatToString("SoundBeatEvent", "type", "processArray", "bubbles", "cancelable", "eventPhase");
        }
    }
}

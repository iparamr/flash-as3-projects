package src.effects.beats 
{
    import flash.events.*;
    
    internal class SoundBeatEvent extends flash.events.Event
    {
        public function SoundBeatEvent(arg1:String, arg2:Array, arg3:Boolean=false, arg4:Boolean=false)
        {
            t = arg1;
            b = arg3;
            c = arg4;
            super(t, b, c);
            processArray = arg2;
            return;
        }

        public override function clone():flash.events.Event
        {
            return new SoundBeatEvent(t, processArray, b, c);
        }

        public override function toString():String
        {
            return formatToString("SoundBeatEvent", "type", "theArray", "bubbles", "cancelable", "eventPhase");
        }

        public static const PROCESS_SOUND:String="processsound";

        internal var b:Boolean;

        internal var c:Boolean;

        public var processArray:Array;

        internal var t:String;
    }
}

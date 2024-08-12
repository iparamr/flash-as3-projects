package src.effects.beats 
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.utils.*;
    import src.utilities.*;
    
    public class BeatMaker extends flash.display.Sprite
    {
        public function BeatMaker(arg1:Class, arg2:Array, arg3:Number=1, arg4:Number=100, arg5:Boolean=true, arg6:Boolean=true)
        {
            var loc1:*=undefined;
            var loc2:*=0;
            var loc3:*=undefined;
            var loc4:*=undefined;
            beatArray = [];
            menuArray = [];
            bList = ["clip", "x", "y", "alpha", "color", "blendMode", "filters", "beatSize", "startSize"];
            super();
            myClip = arg1;
            myNumBeats = arg3;
            mySize = arg4;
            myType = arg2;
            myFrequency = arg5;
            myDragable = arg6;
            myHolder = new flash.display.Sprite();
            myBeats = new flash.display.Sprite();
            myMenus = new flash.display.Sprite();
            myHolder.addChild(myBeats);
            myHolder.addChild(myMenus);
            loc1 = 10;
            loc2 = 0;
            while (loc2 < myNumBeats) 
            {
                loc3 = new myClip();
                loc4 = new myClip();
                loc3.x = loc1 * loc2;
                loc4.x = loc1 * loc2;
                loc4.alpha = 0;
                beatArray.push(loc3);
                menuArray.push(loc4);
                myBeats.addChild(loc3);
                myMenus.addChild(loc4);
                if (myDragable) 
                {
                    loc4.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, drag);
                    loc4.addEventListener(flash.events.MouseEvent.MOUSE_UP, drop);
                    loc4.buttonMode = true;
                    loc4.mate = loc3;
                }
                loc3.num = loc2;
                loc4.num = loc2;
                ++loc2;
            }
            setBeatProperties();
            myTimer = new flash.utils.Timer(50, 0);
            myTimer.addEventListener(flash.events.TimerEvent.TIMER, follow);
            addChild(myHolder);
            myBeat = new SoundBeat(myNumBeats, myFrequency, mySize, mySize + 10);
            myBeat.addEventListener(SoundBeatEvent.PROCESS_SOUND, processBeat);
            return;
        }

        internal function drag(arg1:flash.events.MouseEvent):*
        {
            var loc1:*=undefined;
            loc1 = arg1.target.parent;
            loc1.setChildIndex(arg1.target, (loc1.numChildren - 1));
            arg1.target.startDrag();
            currentDrag = arg1.target;
            myTimer.start();
            return;
        }

        public function setBeat(arg1:String, arg2:Number, arg3:Object):*
        {
            var loc1:*=undefined;
            if (beatObject[arg1]) 
            {
                if (arg2 < myNumBeats) 
                {
                    beatObject[arg1][arg2] = arg3;
                    if (arg1 == "x" || arg1 == "y") 
                    {
                        beatArray[arg2][arg1] = arg3;
                        menuArray[arg2][arg1] = arg3;
                    }
                    else if (arg1 != "color") 
                    {
                        if (arg1 == "filters" || arg1 == "blendMode" || arg1 == "alpha") 
                        {
                            beatArray[arg2][arg1] = arg3;
                        }
                        else if (arg1 == "clip") 
                        {
                            setClip(arg2, arg3);
                        }
                    }
                    else if (arg3 != null) 
                    {
                        (loc1 = beatArray[arg2].transform.colorTransform).color = uint(arg3);
                        beatArray[arg2].transform.colorTransform = loc1;
                    }
                }
            }
            return;
        }

        public function setBeatObject(arg1:Object):*
        {
            var loc1:*=0;
            var loc2:*=undefined;
            var loc3:*=0;
            var loc4:*=undefined;
            var loc5:*=undefined;
            beatObject = arg1;
            loc1 = 0;
            while (loc1 < bList.length) 
            {
                loc2 = bList[loc1];
                loc3 = 0;
                while (loc3 < myNumBeats) 
                {
                    if ((loc4 = beatObject[loc2][loc3]) !== "") 
                    {
                        if (loc2 == "x" || loc2 == "y") 
                        {
                            beatArray[loc3][loc2] = loc4;
                            menuArray[loc3][loc2] = loc4;
                        }
                        else if (loc2 != "color") 
                        {
                            if (loc2 == "filters" || loc2 == "blendMode" || loc2 == "alpha") 
                            {
                                if (loc4) 
                                {
                                    beatArray[loc3][loc2] = loc4;
                                }
                            }
                            else if (loc2 == "clip") 
                            {
                                setClip(loc3, loc4);
                            }
                        }
                        else if (loc4 != null) 
                        {
                            (loc5 = beatArray[loc3].transform.colorTransform).color = uint(loc4);
                            beatArray[loc3].transform.colorTransform = loc5;
                        }
                    }
                    ++loc3;
                }
                ++loc1;
            }
            return;
        }

        public function recordBeat():*
        {
            var loc1:*=undefined;
            var loc2:*=undefined;
            var loc3:*=0;
            var loc4:*=undefined;
            var loc5:*=undefined;
            loc1 = "myBeats.setBeatObject({\n\t\t\t\t\t";
            loc2 = src.utilities.DynamicObject.copy(beatObject);
            loc3 = 0;
            while (loc3 < myNumBeats) 
            {
                if ((loc4 = beatObject["clip"][loc3].toString().split(" ")).length > 1) 
                {
                    loc4 = loc4[1].substr(0, -1);
                }
                else 
                {
                    loc4 = "";
                }
                loc2["clip"][loc3] = loc4;
                if (beatObject["filters"][loc3]) 
                {
                    if ((loc4 = beatObject["filters"][loc3].toString().split(" ")).length > 1) 
                    {
                        loc4 = "[new " + loc4[1].substr(0, -1) + "()]";
                    }
                    else 
                    {
                        loc4 = "";
                    }
                }
                else 
                {
                    loc4 = "";
                }
                loc2["filters"][loc3] = loc4;
                ++loc3;
            }
            loc3 = 0;
            while (loc3 < bList.length) 
            {
                if ((loc5 = bList[loc3]) != "blendMode") 
                {
                    loc1 = loc1 + (loc5 + ":[" + loc2[loc5].join(","));
                    loc1 = loc1 + "],\n\t\t\t\t\t";
                }
                else 
                {
                    loc1 = loc1 + (loc5 + ":[\'" + loc2[loc5].join("\',\'"));
                    loc1 = loc1 + "\'],\n\t\t\t\t\t";
                }
                ++loc3;
            }
            loc1 = loc1.substr(0, loc1.length - 7);
            loc1 = loc1 + "\n\t\t\t\t\t});";
            trace(loc1);
            return;
        }

        public function getBeatAt(arg1:Number):*
        {
            return beatArray[arg1];
        }

        public function getBeatObject():*
        {
            return beatObject;
        }

        internal function follow(arg1:flash.events.TimerEvent):*
        {
            currentDrag.mate.x = currentDrag.x;
            currentDrag.mate.y = currentDrag.y;
            arg1.updateAfterEvent();
            return;
        }

        internal function processBeat(arg1:SoundBeatEvent):*
        {
            var loc1:*=NaN;
            var loc2:*=NaN;
            var loc3:*=0;
            var loc4:*=undefined;
            var loc5:*=undefined;
            loc3 = 0;
            while (loc3 < arg1.processArray.length) 
            {
                loc4 = beatObject["startSize"][loc3];
                loc5 = beatObject["beatSize"][loc3] - loc4;
                if (myType[0] && myType[1]) 
                {
                    if (menuArray[loc3].width > menuArray[loc3].height) 
                    {
                        loc1 = menuArray[loc3].width;
                        beatArray[loc3].width = loc4 + arg1.processArray[loc3] * loc5 / mySize;
                        beatArray[loc3].height = menuArray[loc3].height * beatArray[loc3].width / loc1;
                    }
                    else 
                    {
                        loc2 = menuArray[loc3].height;
                        beatArray[loc3].height = loc4 + arg1.processArray[loc3] * loc5 / mySize;
                        beatArray[loc3].width = menuArray[loc3].width * beatArray[loc3].height / loc2;
                    }
                }
                else 
                {
                    if (myType[0]) 
                    {
                        beatArray[loc3].width = loc4 + arg1.processArray[loc3] * loc5 / mySize;
                    }
                    if (myType[1]) 
                    {
                        beatArray[loc3].height = loc4 + arg1.processArray[loc3] * loc5 / mySize;
                    }
                }
                if (myType[2]) 
                {
                    beatArray[loc3].alpha = (loc4 + arg1.processArray[loc3] * loc5) / beatObject["beatSize"][loc3] / mySize;
                }
                ++loc3;
            }
            return;
        }

        public function toggleDisplay():*
        {
            var loc1:*=0;
            if (menuArray[0].alpha) 
            {
                loc1 = 0;
                while (loc1 < menuArray.length) 
                {
                    menuArray[loc1].alpha = 0;
                    ++loc1;
                }
            }
            else 
            {
                loc1 = 0;
                while (loc1 < menuArray.length) 
                {
                    menuArray[loc1].alpha = 0.5;
                    ++loc1;
                }
            }
            return;
        }

        internal function setBeatProperties():*
        {
            var loc1:*=undefined;
            var loc2:*=0;
            loc1 = {};
            loc2 = 0;
            while (loc2 < bList.length) 
            {
                loc1[bList[loc2]] = [];
                ++loc2;
            }
            loc2 = 0;
            while (loc2 < myNumBeats) 
            {
                loc1.clip.push(myClip);
                loc1.x.push(beatArray[loc2].x);
                loc1.y.push(beatArray[loc2].y);
                loc1.alpha.push(1);
                loc1.color.push(null);
                loc1.blendMode.push(null);
                loc1.filters.push([]);
                loc1.beatSize.push(mySize);
                loc1.startSize.push(0);
                ++loc2;
            }
            beatObject = loc1;
            return;
        }

        internal function setClip(arg1:Number, arg2:Object):*
        {
            var loc1:*=undefined;
            var loc2:*=undefined;
            var loc3:*=undefined;
            if (!arg2) 
            {
                return;
            }
            loc1 = beatArray[arg1].transform.matrix;
            loc2 = new arg2();
            loc3 = new arg2();
            if (myDragable) 
            {
                menuArray[arg1].removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, drag);
                menuArray[arg1].removeEventListener(flash.events.MouseEvent.MOUSE_UP, drop);
            }
            myBeats.removeChild(beatArray[arg1]);
            myMenus.removeChild(menuArray[arg1]);
            beatArray[arg1] = loc2;
            menuArray[arg1] = loc3;
            loc2.transform.matrix = loc1;
            loc3.transform.matrix = loc1;
            loc3.alpha = 0;
            myBeats.addChild(loc2);
            myMenus.addChild(loc3);
            if (myDragable) 
            {
                loc3.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, drag);
                loc3.addEventListener(flash.events.MouseEvent.MOUSE_UP, drop);
                loc3.buttonMode = true;
                loc3.mate = loc2;
            }
            loc2.num = arg1;
            loc3.num = arg1;
            return;
        }

        public function setAllBeats(arg1:String, arg2:Object):*
        {
            var loc1:*=0;
            var loc2:*=undefined;
            if (beatObject[arg1]) 
            {
                loc1 = 0;
                while (loc1 < beatArray.length) 
                {
                    beatObject[arg1][loc1] = arg2;
                    if (arg1 == "x" || arg1 == "y") 
                    {
                        beatArray[loc1][arg1] = arg2;
                        menuArray[loc1][arg1] = arg2;
                    }
                    else if (arg1 != "color") 
                    {
                        if (arg1 == "filters" || arg1 == "blendMode" || arg1 == "alpha") 
                        {
                            beatArray[loc1][arg1] = arg2;
                        }
                        else if (arg1 == "clip") 
                        {
                            setClip(loc1, arg2);
                        }
                    }
                    else if (arg2 != null) 
                    {
                        (loc2 = beatArray[loc1].transform.colorTransform).color = uint(arg2);
                        beatArray[loc1].transform.colorTransform = loc2;
                    }
                    ++loc1;
                }
            }
            return;
        }

        internal function drop(arg1:flash.events.MouseEvent):*
        {
            arg1.currentTarget.stopDrag();
            beatObject["x"][currentDrag.num] = currentDrag.x;
            beatObject["y"][currentDrag.num] = currentDrag.y;
            myTimer.stop();
            return;
        }

        internal var myType:Array;

        internal var myFrequency:Boolean;

        internal var myClip:Class;

        internal var myBeats:flash.display.Sprite;

        internal var menuArray:Array;

        internal var beatArray:Array;

        internal var myNumBeats:Number;

        internal var bList:Array;

        internal var myDragable:Boolean;

        internal var currentDrag:Object;

        internal var myHolder:flash.display.Sprite;

        internal var myBeat:SoundBeat;

        internal var beatObject:Object;

        internal var myMenus:flash.display.Sprite;

        internal var mySize:Number;

        internal var myTimer:*;
    }
}

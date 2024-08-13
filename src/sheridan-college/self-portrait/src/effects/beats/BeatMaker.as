package src.effects.beats 
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Matrix;
    import flash.geom.ColorTransform;
    import flash.utils.Timer;
    import src.utilities.DynamicObject;

    public class BeatMaker extends Sprite
    {
        private var myType:Array;
        private var myFrequency:Boolean;
        private var myClip:Class;
        private var myBeats:Sprite;
        private var menuArray:Array;
        private var beatArray:Array;
        private var myNumBeats:Number;
        private var bList:Array;
        private var myDragable:Boolean;
        private var currentDrag:Object;
        private var myHolder:Sprite;
        private var myBeat:SoundBeat;
        private var beatObject:Object;
        private var myMenus:Sprite;
        private var mySize:Number;
        private var myTimer:Timer;

        private static const BEAT_SPACING:Number = 10;

        public function BeatMaker(clipClass:Class, typeArray:Array, numBeats:Number = 1, size:Number = 100, frequency:Boolean = true, dragable:Boolean = true)
        {
            super();
            initializeVariables(clipClass, typeArray, numBeats, size, frequency, dragable);
            createBeats();
            setBeatProperties();
            setupTimer();
            addChild(myHolder);
            setupSoundBeat();
        }

        private function initializeVariables(clipClass:Class, typeArray:Array, numBeats:Number, size:Number, frequency:Boolean, dragable:Boolean):void
        {
            myClip = clipClass;
            myNumBeats = numBeats;
            mySize = size;
            myType = typeArray;
            myFrequency = frequency;
            myDragable = dragable;
            myHolder = new Sprite();
            myBeats = new Sprite();
            myMenus = new Sprite();
            myHolder.addChild(myBeats);
            myHolder.addChild(myMenus);
            beatArray = [];
            menuArray = [];
            bList = ["clip", "x", "y", "alpha", "color", "blendMode", "filters", "beatSize", "startSize"];
        }

        private function createBeats():void
        {
            for (var i:int = 0; i < myNumBeats; i++) 
            {
                var beat:MovieClip = new myClip();
                var menu:MovieClip = new myClip();
                beat.x = BEAT_SPACING * i;
                menu.x = BEAT_SPACING * i;
                menu.alpha = 0;
                beatArray.push(beat);
                menuArray.push(menu);
                myBeats.addChild(beat);
                myMenus.addChild(menu);
                if (myDragable) 
                {
                    setupDragAndDrop(menu);
                }
                beat.num = i;
                menu.num = i;
            }
        }

        private function setupDragAndDrop(menu:MovieClip):void
        {
            menu.addEventListener(MouseEvent.MOUSE_DOWN, drag);
            menu.addEventListener(MouseEvent.MOUSE_UP, drop);
            menu.buttonMode = true;
            menu.mate = beatArray[menu.num];
        }

        private function setupTimer():void
        {
            myTimer = new Timer(50);
            myTimer.addEventListener(TimerEvent.TIMER, follow);
        }

        private function setupSoundBeat():void
        {
            myBeat = new SoundBeat(myNumBeats, myFrequency, mySize, mySize + 10);
            myBeat.addEventListener(SoundBeatEvent.PROCESS_SOUND, processBeat);
        }

        private function drag(event:MouseEvent):void
        {
            var target:Sprite = event.target as Sprite;
            target.parent.setChildIndex(target, target.parent.numChildren - 1);
            target.startDrag();
            currentDrag = target;
            myTimer.start();
        }

        public function setBeat(property:String, index:Number, value:Object):void
        {
            if (beatObject[property]) 
            {
                if (index < myNumBeats) 
                {
                    beatObject[property][index] = value;
                    if (property == "x" || property == "y") 
                    {
                        beatArray[index][property] = value;
                        menuArray[index][property] = value;
                    }
                    else if (property == "color" && value != null) 
                    {
                        var colorTransform:ColorTransform = beatArray[index].transform.colorTransform;
                        colorTransform.color = uint(value);
                        beatArray[index].transform.colorTransform = colorTransform;
                    }
                    else if (property == "filters" || property == "blendMode" || property == "alpha") 
                    {
                        beatArray[index][property] = value;
                    }
                    else if (property == "clip") 
                    {
                        setClip(index, value);
                    }
                }
            }
        }

        public function setBeatObject(beatObj:Object):void
        {
            beatObject = beatObj;
            for (var i:int = 0; i < bList.length; i++) 
            {
                var property:String = bList[i];
                for (var j:int = 0; j < myNumBeats; j++) 
                {
                    var value:Object = beatObject[property][j];
                    if (value !== "") 
                    {
                        if (property == "x" || property == "y") 
                        {
                            beatArray[j][property] = value;
                            menuArray[j][property] = value;
                        }
                        else if (property == "color" && value != null) 
                        {
                            var colorTransform:ColorTransform = beatArray[j].transform.colorTransform;
                            colorTransform.color = uint(value);
                            beatArray[j].transform.colorTransform = colorTransform;
                        }
                        else if (property == "filters" || property == "blendMode" || property == "alpha") 
                        {
                            beatArray[j][property] = value;
                        }
                        else if (property == "clip") 
                        {
                            setClip(j, value);
                        }
                    }
                }
            }
        }

        public function recordBeat():String
        {
            var result:String = "myBeats.setBeatObject({\n\t\t\t\t\t";
            var copiedBeatObject:Object = DynamicObject.copy(beatObject);
            for (var i:int = 0; i < myNumBeats; i++) 
            {
                var clipValue:String = beatObject["clip"][i].toString().split(" ")[1] || "";
                copiedBeatObject["clip"][i] = clipValue.substr(0, clipValue.length - 1);
                if (beatObject["filters"][i]) 
                {
                    var filterValue:String = beatObject["filters"][i].toString().split(" ")[1] || "";
                    copiedBeatObject["filters"][i] = filterValue ? "[new " + filterValue.substr(0, filterValue.length - 1) + "()]" : "";
                }
            }
            for (var j:int = 0; j < bList.length; j++) 
            {
                var property:String = bList[j];
                if (property != "blendMode") 
                {
                    result += property + ":[" + copiedBeatObject[property].join(",") + "],\n\t\t\t\t\t";
                }
                else 
                {
                    result += property + ":[\'" + copiedBeatObject[property].join("\',\'") + "\'],\n\t\t\t\t\t";
                }
            }
            result = result.substr(0, result.length - 7);
            result += "\n\t\t\t\t\t});";
            trace(result);
            return result;
        }

        public function getBeatAt(index:Number):Sprite
        {
            return beatArray[index];
        }

        public function getBeatObject():Object
        {
            return beatObject;
        }

        private function follow(event:TimerEvent):void
        {
            currentDrag.mate.x = currentDrag.x;
            currentDrag.mate.y = currentDrag.y;
            event.updateAfterEvent();
        }

        private function processBeat(event:SoundBeatEvent):void
        {
            for (var i:int = 0; i < event.processArray.length; i++) 
            {
                var startSize:Number = beatObject["startSize"][i];
                var beatSizeDiff:Number = beatObject["beatSize"][i] - startSize;
                if (myType[0] && myType[1]) 
                {
                    if (menuArray[i].width > menuArray[i].height) 
                    {
                        var originalWidth:Number = menuArray[i].width;
                        beatArray[i].width = startSize + event.processArray[i] * beatSizeDiff / mySize;
                        beatArray[i].height = menuArray[i].height * beatArray[i].width / originalWidth;
                    }
                    else 
                    {
                        var originalHeight:Number = menuArray[i].height;
                        beatArray[i].height = startSize + event.processArray[i] * beatSizeDiff / mySize;
                        beatArray[i].width = menuArray[i].width * beatArray[i].height / originalHeight;
                    }
                }
                else 
                {
                    if (myType[0]) 
                    {
                        beatArray[i].width = startSize + event.processArray[i] * beatSizeDiff / mySize;
                    }
                    if (myType[1]) 
                    {
                        beatArray[i].height = startSize + event.processArray[i] * beatSizeDiff / mySize;
                    }
                }
                if (myType[2]) 
                {
                    beatArray[i].alpha = (startSize + event.processArray[i] * beatSizeDiff) / beatObject["beatSize"][i] / mySize;
                }
            }
        }

        public function toggleDisplay():void
        {
            var newAlpha:Number = menuArray[0].alpha ? 0 : 0.5;
            for (var i:int = 0; i < menuArray.length; i++) 
            {
                menuArray[i].alpha = newAlpha;
            }
        }

        private function setBeatProperties():void
        {
            var properties:Object = {};
            for (var i:int = 0; i < bList.length; i++) 
            {
                properties[bList[i]] = [];
            }
            for (var j:int = 0; j < myNumBeats; j++) 
            {
                properties.clip.push(myClip);
                properties.x.push(beatArray[j].x);
                properties.y.push(beatArray[j].y);
                properties.alpha.push(1);
                properties.color.push(null);
                properties.blendMode.push(null);
                properties.filters.push([]);
                properties.beatSize.push(mySize);
                properties.startSize.push(0);
            }
            beatObject = properties;
        }

        private function setClip(index:Number, clipClass:Object):void
        {
            if (!clipClass) 
            {
                return;
            }
            var originalMatrix:Matrix = beatArray[index].transform.matrix;
            var newBeat:MovieClip = new clipClass();
            var newMenu:MovieClip = new clipClass();
            if (myDragable) 
            {
                menuArray[index].removeEventListener(MouseEvent.MOUSE_DOWN, drag);
                menuArray[index].removeEventListener(MouseEvent.MOUSE_UP, drop);
            }
            myBeats.removeChild(beatArray[index]);
            myMenus.removeChild(menuArray[index]);
            beatArray[index] = newBeat;
            menuArray[index] = newMenu;
            newBeat.transform.matrix = originalMatrix;
            newMenu.transform.matrix = originalMatrix;
            newMenu.alpha = 0;
            myBeats.addChild(newBeat);
            myMenus.addChild(newMenu);
            if (myDragable) 
            {
                newMenu.addEventListener(MouseEvent.MOUSE_DOWN, drag);
                newMenu.addEventListener(MouseEvent.MOUSE_UP, drop);
                newMenu.buttonMode = true;
                newMenu.mate = newBeat;
            }
            newBeat.num = index;
            newMenu.num = index;
        }

        public function setAllBeats(property:String, value:Object):void
        {
            if (beatObject[property]) 
            {
                for (var i:int = 0; i < beatArray.length; i++) 
                {
                    beatObject[property][i] = value;
                    if (property == "x" || property == "y") 
                    {
                        beatArray[i][property] = value;
                        menuArray[i][property] = value;
                    }
                    else if (property == "color" && value != null) 
                    {
                        var colorTransform:ColorTransform = beatArray[i].transform.colorTransform;
                        colorTransform.color = uint(value);
                        beatArray[i].transform.colorTransform = colorTransform;
                    }
                    else if (property == "filters" || property == "blendMode" || property == "alpha") 
                    {
                        beatArray[i][property] = value;
                    }
                    else if (property == "clip") 
                    {
                        setClip(i, value);
                    }
                }
            }
        }

        private function drop(event:MouseEvent):void
        {
            event.currentTarget.stopDrag();
            beatObject["x"][currentDrag.num] = currentDrag.x;
            beatObject["y"][currentDrag.num] = currentDrag.y;
            myTimer.stop();
        }
    }
}

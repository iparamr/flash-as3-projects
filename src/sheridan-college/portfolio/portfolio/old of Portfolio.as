package portfolio {
	
	import flash.display.*;
	import flash.events.*;
	import fl.transitions.*;
	import fl.motion.easing.*;
		
	public class Portfolio extends MovieClip
	{
		public function Portfolio()
		{						
			/*tabs.tabAboutMe.addEventListener(MouseEvent.MOUSE_OVER, doTabsOver);
			tabs.tabWebDesign.addEventListener(MouseEvent.MOUSE_OVER, doTabsOver);
			tabs.tabGraphicDesign.addEventListener(MouseEvent.MOUSE_OVER, doTabsOver);
			tabs.tabDevelopment.addEventListener(MouseEvent.MOUSE_OVER, doTabsOver);
			tabs.tabFineArt.addEventListener(MouseEvent.MOUSE_OVER, doTabsOver);
			tabs.tabOther.addEventListener(MouseEvent.MOUSE_OVER, doTabsOver);*/
			
			var maskTabs:MaskTabs = new MaskTabs();
			maskTabs.x = 0;
			maskTabs.y = 54;
			tabs.mask = maskTabs;
			
			for(var i:uint=0; i<tabs.numChildren; i++) {  
				//trace(tabs.getChildAt(i).name);
				
				//for(var j:uint=0; j < tabs[tabs.getChildAt(i).name].numChildren; j++) {
					//trace(tabs[tabs.getChildAt(i).name].getChildAt(tabs[tabs.getChildAt(i).name].numChildren - 1).name);
				//}
				
				tabs[tabs.getChildAt(i).name].getChildAt(tabs[tabs.getChildAt(i).name].numChildren - 1).addEventListener(MouseEvent.MOUSE_OVER, doTabsOver);
				tabs[tabs.getChildAt(i).name].getChildAt(tabs[tabs.getChildAt(i).name].numChildren - 1).addEventListener(MouseEvent.MOUSE_OUT, doTabsOut);
				tabs[tabs.getChildAt(i).name].getChildAt(tabs[tabs.getChildAt(i).name].numChildren - 1).addEventListener(MouseEvent.CLICK, doTabsClick);
			}
		}
		
		private function doTabsOver(e:MouseEvent){
			//trace(e.target.name + " OVER");
			e.target.buttonMode = true;
			e.target.gotoAndStop(2);
			
			//trace(Math.abs(e.target.parent.x - 29));
			//trace(Math.abs(tweenHeight+29));
		}
		
		private function doTabsOut(e:MouseEvent){
			//trace(e.target.name + " OUT");			
			e.target.gotoAndStop(1);
		}
		
		var openTab:String;
		var curPos:Number;
		var myTween:Tween;
		var tweenHeight:Number;
		
		private function doTabsClick(e:MouseEvent){
			trace(e.target.name + " CLICK");
			e.target.gotoAndStop(2);
			
			//--TWEENING--
			//cuz of rotation x is y and y is x in menus
			for (var i:uint = 0; i<tabs.numChildren; i++) {
				//trace("X" + tabs[tabs.getChildAt(i).name].x);
				//trace(i);
				//trace(!(tabs[e.target.parent.name]));
				trace(tabs[tabs.getChildAt(i).name].x);
				trace(tabs[tabs.getChildAt(i).name].width - 29);
				
				if (tabs[tabs.getChildAt(i).name].x == tabs[tabs.getChildAt(i).name].width - 29) {
					
					trace("asfasf9782349423");
					if (tabs[tabs.getChildAt(i).name] == tabs[e.target.parent.name]) {
						//trace("\tcontinue");
						continue;
					}
					//trace("me" + i);
					//trace("##" + tabs[e.target.parent.name]);
					curPos = tabs[tabs.getChildAt(i).name].x - 29;
					myTween = new Tween(tabs[tabs.getChildAt(i).name], "x", Exponential.easeOut, - curPos, 1, .5, true);
				} else {
					//myTween = new Tween(tabs[e.target.parent.name], "x", Exponential.easeOut, 1, - tweenHeight, .5, true);
				}
			}
			
			tweenHeight = tabs[e.target.parent.name].width - 29;			
			if(tweenHeight != tabs[e.target.parent.name].x){
				myTween = new Tween(tabs[e.target.parent.name], "x", Exponential.easeOut, 1, - tweenHeight, .5, true);
			} else {
				
			}
			
					
			//trace(e.target.parent.x);
			
			if(e.target.name == "tabAboutMe"){
				//mnuAboutMe.x = stage.width
			} else if (e.target.name == "tabWebDesign"){
				e.target.gotoAndStop(2);
			}
		}
		
	}
}

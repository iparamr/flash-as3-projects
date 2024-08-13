
package sushi {
	
	import flash.display.MovieClip;	
	import flash.display.Sprite;	
	import flash.text.TextField;
	import flash.events.*;
    import flash.utils.Timer;
	
	public class Sushi extends MovieClip {		
		// Please put your name here: Param Randhawa
		
		// WEB AUTHORING BUILD-IT EXAM - 3HRS
		
		// This is the less complex exam
		// You have all the assets in the FLA with instance names already named
		// 		mySushi has mySushi1, mySushi2, mySushi3, mySushi4, mySushi5 and mySushi6
		// 		mat - is the green thing the sushi is sitting on
		// 		plate has a hitBox clip in it with alpha = 0
		// 		conveyor - is the grey track at the bottom
		//		myText
		
		// You also have the following messages through out
		
		//		1. Well, what are you waiting for Chef, put the sushi on the plate!
		//		2. There are 0 sushi on the plate
		//		   There is 1 sushi on the plate
		//		   There are 2 sushi on the plate, etc.  (should be made with code)
		// 		3. This will feed those hungry students!
		//		4. Great job! Break time!
		
		// Here is what should happen
		
		// ---------- show message 1 ----------- [30]
		// 1. user should be able to drag and drop the sushi
		// 2. make the cursor turn into a finger when you roll over them
		// 3. when the sushi is picked up make it go to frame 2
		// 4. also make it rotate a random amount out of 360 degrees
		// 5. also make it so that it is the highest sushi 
		// 6. also run a method that calculates how many sushi are on the plate
		// 7. this will use a hitTestObject to test if each sushi hits the plate's hitBox
		// 8. and it will display a message of how many are on the plate
		
		// ---------- show messages 2 ----------- [10]
		// 9. when the sushi is dropped run the sushi-on-plate-count method again
		// 10. if the sushi is dropped back on the mat then set its frame back to 1
		// 11. and set its rotation back to 0 (on the mat only)
		// 12. if there are 6 sushi on the plate then show the next message
		
		// ---------- show message 3 ----------- [10]
		// 13. make it so you can't pick up the sushi and the cursor finger does not show
		// 14. make the conveyor, the plate and the sushi animate to the right at conveyorSpeed
		// 15. if the conveyor's x position is greater than -5 then stop the conveyor
		
		// ---------- show message 4 -----------
		// 16. you are done!
				
		
		// hints:
		
		// you can put the drag and drop events right on mySushi rather than each sushi
		// then use the target to find out which sushi was selected
		// In the method that checks how many sushi are hitting the plate's hitBox, 
		// use dynamic targeting to loop through the six sushi otherwise -2 marks
		// remember to animate in a enter frame or timer event function
		
		
		// constructor
		
		private var randRotate:Number;
		private var sushiCount:Number = 0;
		private var myContainer = new Sprite();
		private var animateSpeed:Number = 10;
		var minuteTimer:Timer = new Timer(250, 8);
        		
		public function Sushi() {
			
			mySushi.addEventListener(MouseEvent.MOUSE_DOWN, myMouseDown);
			mySushi.addEventListener(MouseEvent.MOUSE_UP, myMouseUp);
			mySushi.addEventListener(MouseEvent.MOUSE_OVER, myMouseOver);
			stage.addEventListener(Event.ENTER_FRAME, countSushi);
			
		}
		
		private function myMouseOver(e:MouseEvent) {
			
			mySushi[e.target.name].buttonMode = true;
			
		}
		
		private function myMouseDown(e:MouseEvent) {
			
			randRotate = Math.floor(Math.random()*360) + 1;
			mySushi[e.target.name].gotoAndStop(2);
			mySushi[e.target.name].startDrag();
			mySushi[e.target.name].rotation = randRotate;
			mySushi.setChildIndex(Sprite(e.target), mySushi.numChildren-1);	
						
		}
		
		private function myMouseUp(e:MouseEvent) {			
		
			if (plate.hitBox.hitTestObject(mySushi[e.target.name])) {
				
				mySushi[e.target.name].gotoAndStop(2);
				mySushi[e.target.name].stopDrag();
								
			} else {
				mySushi[e.target.name].gotoAndStop(1);
				mySushi[e.target.name].rotation = 0;
				mySushi[e.target.name].stopDrag();
			}
			
			
		}
		
		private function countSushi(e:Event) {			
		
			myText.text = "Well, what are you waiting for Chef, put the sushi on the plate!";
			sushiCount = 0;
			for (var i:uint=1; i<=6; i++){
				
				if (plate.hitBox.hitTestObject(mySushi["mySushi"+i])) {
					
					sushiCount++;
					trace(sushiCount);
					if (sushiCount==1) {
						myText.text = "There is " +  sushiCount + " sushi on the plate.";
					} else {						
						myText.text = "There are " +  sushiCount + " sushis on the plate.";						
					}
					
				} 
				
				if (sushiCount == 6) {
					myText.text = "This will feed those hungry students!";
					/*myContainer.addChild(conveyor);
					myContainer.addChild(plate);
					myContainer.addChild(mySushi);					
					addChild(myContainer);*/
					for (var j:uint=1; j<=6; j++){
				
						mySushi["mySushi"+j].buttonMode = false;
				
					}
					minuteTimer.start();
					minuteTimer.addEventListener(TimerEvent.TIMER, onTick);		
					minuteTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);		
					
					
				} 				
				
			}
		}
		
		private function animate(e:Event) {			
						
			if(conveyor.x < -5){			
			trace(conveyor.x);
			conveyor.x += animateSpeed;
			plate.x += animateSpeed;
			mySushi.x += animateSpeed;				
			} else {
				myText.text = "Great job! Break time!";	
			}
			
		}
		
		public function onTick(event:TimerEvent):void {
			
			mySushi.removeEventListener(MouseEvent.MOUSE_DOWN, myMouseDown);
			mySushi.removeEventListener(MouseEvent.MOUSE_UP, myMouseUp);
			mySushi.removeEventListener(MouseEvent.MOUSE_OVER, myMouseOver);
			
			
        }

		
		        
        public function onTimerComplete(event:TimerEvent):void {			
		
            conveyor.addEventListener(Event.ENTER_FRAME, animate);
			
        }	
		
	}
	
}
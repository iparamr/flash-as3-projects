
package sushi {
	
	import flash.display.MovieClip;

	import flash.text.TextField;
	import flash.events.*;	
	
	public class Sushi extends MovieClip {
		
		// Please put your name here: 
		
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
		
		
		private var conveyorSpeed:Number = 4;
		private var conveyorCheck:Boolean = false;
		

		public function Sushi() {
	
			myText.text = "Well, what are you waiting for Chef, put the sushi on the plate!";
	
			mySushi.addEventListener(MouseEvent.MOUSE_DOWN, liftSushi);
			mySushi.addEventListener(MouseEvent.MOUSE_UP, dropSushi);			
			mySushi.buttonMode = true;
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrameFunction);
		
		}
		
		private function enterFrameFunction(e:Event) {
			if (conveyorCheck == false) {return;}
			if (conveyor.x > -5) {
				myText.text = "Great job! Break time!";
				stage.removeEventListener(Event.ENTER_FRAME, enterFrameFunction);	
				return;
			}
			conveyor.x += conveyorSpeed;
			plate.x += conveyorSpeed;		
			mySushi.x += conveyorSpeed;	
			
		}
		
		function setSushiMessage() {
			var count:Number = 0;
			for (var i:uint = 1; i<=6; i++) {
				if (mySushi["mySushi"+i].hitTestObject(plate.hitBox)) {
					count++;
				}
			}			
			if (count == 6) {
				myText.text = "This will feed those hungry students!";
				conveyorCheck = true;
				mySushi.buttonMode = false;
				return;
			}
			if (count == 1) {
				myText.text = "There is 1 sushi on the plate";
			} else {
				myText.text = "There are "+count+" sushi on the plate";
			}
		}

		private function liftSushi(e:MouseEvent) {
			if (conveyorCheck == true) {return;}
			e.target.startDrag();
			e.target.gotoAndStop(2);
			e.target.rotation = Math.random()*360;
			mySushi.setChildIndex(MovieClip(e.target), mySushi.numChildren-1);
			setSushiMessage();
		}
		
		private function dropSushi(e:MouseEvent) {
			e.target.stopDrag();
			setSushiMessage();
			if (e.target.hitTestObject(mat)) {
				e.target.gotoAndStop(1);
				e.target.rotation = 0;
			}
	
		}
		
	}
	
}
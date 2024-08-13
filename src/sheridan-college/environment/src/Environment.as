
package src {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.*;
	import flash.ui.Keyboard;

	public class Environment extends MovieClip {
		
		// Please put your name here: 
		
		// WEB AUTHORING BUILD-IT EXAM - 3HRS
		
		// This is the complex exam
		// You have all the assets in the FLA with instance names already named
		// 		planter has a wheel1, wheel2, door, window, lift and smoke
		// 		worker
		// 		hole has hitBox (alpha = 0)
		// 		tree has roots which has hitBox (alpha = 0)
		//		myText
		
		// You also have the following messages which should go in an array
		// and then show up in the myText TextField before each stage as outlined below
		
		//		Hello!  Please put your worker into the lift truck
		//		Use the right arrow to drive your truck to the tree
		// 		Use the up arrow to lift the tree and drive to the hole
		//		Now use the down arrow to plant the tree
		//		Thank you for working so hard to plant the tree!				
		
		// Here is what should happen
		
		// ---------- show message 1 ----------- [5]
		// 1. user should be able to drag and drop the worker (the little blue guy)
		// 2. when the worker is dropped on the planter door, make him go off stage
		// 3. make him show up in the planter window by telling the window to go to frame 2
		
		// ---------- show message 2 ----------- [20]
		// 4. now the planter is ready to drive with the left and right arrows (before it was not)
		// 5. make the wheels rotate the right way when the arrows are pressed (rotationSpeed)
		// 6. make the planter move left or right when the arrows are pressed (moveSpeed)
		// 7. make the smoke come out of the planter by telling it to play frame 2
		// 8. when the lift hits the hitBox in the roots of the tree stop the motion and smoke
		
		// ---------- show message 3 -----------  [15]
		// 9. the up and down arrows should move the lift and tree up and down (before they would not)
		// 10. the planter will not move left or right unless the lift is higher than the driveLift variable
		// 11. when the planter hits the hole show the next message
		
		// ---------- show message 4 -----------  [10]
		// 12. when they lower the tree so the hitBox in the roots hits the hitBox in the hole,
		//     make the roots of the tree and the hole go away
		// 13. stop the lift from going up and down but let the planter continue to move left and right
		// 14. make the tree and the planter swapChildren
		
		// ---------- show message 5 ----------- 
		// 15. you are done!		
		
		
		// here are some initial conditions
		// you may want to increase the moveSpeed so you can test the application faster as you go
		
		private var maxLift:Number = -20; // can't raise the lift higher than this y value
		private var minLift:Number = 10; // can't lower the lift lower than this y value
		private var driveLift:Number = -5;  // can't drive unless the lift is higher than this y value
		private var rotationSpeed:Number = 5;  // rotate the wheels this amount per enterframe
		private var moveSpeed:Number = 2;  // move the planter this x amount per enterframe (- && +)
		private var liftSpeed:Number = 1;  // move the lift this y amount per enterframe (- && +)

		private var myArray:Array;
		private var driveCheck:Boolean = false;
		private var animateCheck:Boolean = false;	
		private var smokeCheck:Boolean = false;
		private var liftCheck:Boolean = false;
		private var carryCheck:Boolean = false;
		private var dropCheck:Boolean = false;
		private var animateDirection:Number;
		
		// Hints:

		// you can either add a series of new events as you go and remove the old ones
		// or use the same events and create a series of check variables
		// for instance, I used four different check variables for the various stages
		// then I used an animation check variable to see if the planter should move
		// and a check variable to see if the smoke should play
		// I also kept a direction variable which I set to -1 or 1 depending on direction
		// animate planter movement and wheel rotation in an ENTER_FRAME or TIMER
		// you can animate your lift in the Key event function 
		// remember that hitTestObject works even with visible = false or removeChild()
		// so I would just set the x property to -2000 of anything you want to get rid of
		// save your work often
		
		public function Environment() {
			
			// create an array with the following instructions:
			
			//		Hello!  Please put your worker into the lift truck
			//		Use the right arrow to drive your truck to the tree
			// 		Use the up arrow to lift the tree and drive to the hole
			//		Now use the down arrow to plant the tree
			//		Thank you for working so hard to plant the tree!
	
			myArray = [			
				"Hello!  Please put your worker into the lift truck",
				"Use the right arrow to drive your truck to the tree",
				"Use the up arrow to lift the tree and drive to the hole",
				"Now use the down arrow to plant the tree",
				"Thank you for working so hard to plant the tree!"
			];
			
			myText.text = myArray[0];
			
			worker.buttonMode = true;
			worker.addEventListener(MouseEvent.MOUSE_DOWN, liftWorker);
			worker.addEventListener(MouseEvent.MOUSE_UP, dropWorker);
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrameFunction);			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownFunction);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpFunction);
			
		}
		
		private function enterFrameFunction(e:Event) {
			if (animateCheck == true) {
				if (liftCheck == true) {
					if (carryCheck == false) {return;}
					tree.x += moveSpeed * animateDirection;
				}
				if (smokeCheck == false) {
					planter.smoke.gotoAndPlay(2);
					smokeCheck = true;
				}
				planter.wheel1.rotation += rotationSpeed * animateDirection;
				planter.wheel2.rotation += rotationSpeed * animateDirection;
				planter.x += moveSpeed * animateDirection;				
			}	
			if (planter.lift.hitTestObject(tree.roots.hitBox) && liftCheck == false) {				
				liftCheck = true;		
				animateCheck = false;
				smokeCheck = false;
				planter.smoke.gotoAndStop(1);
				myText.text = myArray[2];
			}
			if (planter.hitTestObject(hole)) {
				myText.text = myArray[3];   
			}
			if (tree.roots.hitBox.hitTestObject(hole.hitBox) && dropCheck == false) {	
				planter.lift.y = 0;
				tree.roots.x = -1000;
				hole.x = -1000;
				dropCheck = true;	
				liftCheck = false;
				carryCheck = false;
				swapChildren(planter, tree);
				//setChildIndex(planter, numChildren-1);
				myText.text = myArray[4];
			}								
															 
		}
		
		private function keyDownFunction(e:KeyboardEvent) {		
			if (driveCheck == false) {return;}			
			if (e.keyCode == Keyboard.RIGHT) {
				if (animateCheck == false) {
					animateCheck = true;
					animateDirection = 1;					
				}
			}
			if (e.keyCode == Keyboard.LEFT) {
				if (animateCheck == false) {
					animateCheck = true;
					animateDirection = -1;					
				}
			}			
			if (liftCheck == false) {return;}		
			if (e.keyCode == Keyboard.UP) {
				if (planter.lift.y < maxLift) {return;}
				if (planter.lift.y < driveLift) {
					carryCheck = true;
				}
				planter.lift.y -= liftSpeed;
				tree.y -= liftSpeed;
			}
			if (e.keyCode == Keyboard.DOWN) {
				if (planter.lift.y > minLift) {return;}
				if (planter.lift.y >= driveLift) {
					carryCheck = false;
				}				
				planter.lift.y += liftSpeed;
				tree.y += liftSpeed;
			}			
			
		}
		
		private function keyUpFunction(e:KeyboardEvent) {				
			if (driveCheck == false) {return;}				
			if (e.keyCode == Keyboard.RIGHT || e.keyCode == Keyboard.LEFT) {
				animateCheck = false;						
				planter.smoke.gotoAndStop(1);
				smokeCheck = false;
			}							
		}		

		private function liftWorker(e:MouseEvent) {
			worker.startDrag();
		}
		
		private function dropWorker(e:MouseEvent) {
			worker.stopDrag();
			if (worker.hitTestObject(planter.door)) {
				worker.visible = false;
				planter.window.gotoAndStop(2);				
				driveCheck = true;
				myText.text = myArray[1];
			}			
		}
		
	}
	
}
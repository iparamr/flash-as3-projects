package mobilink
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.geom.Rectangle;
	
	public class MobiLink extends MovieClip
	{
		public function MobiLink()
		{
			addEvents();
			
		}
		
		private function addEvents()
		{
			btnLogin.buttonMode = true;
			btnOptions.buttonMode = true;
			btnGettingStarted.buttonMode = true;
			btnSignUp.buttonMode = true;
			btnMore.buttonMode = true;
			
			pnlIncorrectLogin.btnClose.buttonMode = true;
			pnlOptions.btnClose.buttonMode = true;
			
			pnlGettingStarted.btnClose.buttonMode = true;
			
			pnlSignUp.btnBack.buttonMode = true;
			pnlSignUp.btnSignUp2.buttonMode = true;
			
			pnlMore.btnBack.buttonMode = true;
			
			btnLogin.addEventListener(MouseEvent.CLICK, doLogin);
			btnOptions.addEventListener(MouseEvent.CLICK, doOptions);
			btnGettingStarted.addEventListener(MouseEvent.CLICK, doGettingStarted);
			btnSignUp.addEventListener(MouseEvent.CLICK, doSignUp);
			btnMore.addEventListener(MouseEvent.CLICK, doMore);
			
			pnlIncorrectLogin.btnClose.addEventListener(MouseEvent.CLICK, doClose);			
			pnlOptions.btnClose.addEventListener(MouseEvent.CLICK, doClose);		
			pnlGettingStarted.btnClose.addEventListener(MouseEvent.CLICK, doClose);		
			
			pnlSignUp.btnBack.addEventListener(MouseEvent.CLICK, doClose);
			pnlSignUp.btnSignUp2.addEventListener(MouseEvent.CLICK, doClose);
			
			pnlMore.btnBack.addEventListener(MouseEvent.CLICK, doClose);
			
			pnlIncorrectLogin.visible = false;
			pnlOptions.visible = false;
			pnlGettingStarted.visible = false;
			pnlSignUp.visible = false;
			pnlMore.visible = false;
			map.visible = false;
			map2.visible = false;
			pnlLinks.visible =  false;
			pnlFriendList.visible = false;	
						
			pnlLinks.btnBack.addEventListener(MouseEvent.CLICK, goBack);
			pnlLinks.btnBack.buttonMode = true;
			
			pnlLinks.btnAdd.addEventListener(MouseEvent.CLICK, doAddFriend);
			pnlLinks.btnAdd.buttonMode = true;
			
			pnlLinks.btnMap.addEventListener(MouseEvent.CLICK, doMap);
			pnlLinks.btnMap.buttonMode = true;
						
			map.addEventListener(MouseEvent.MOUSE_DOWN, doDrag);
			map.addEventListener(MouseEvent.MOUSE_UP, doStopDrag);
			map.addEventListener(MouseEvent.MOUSE_OUT, doStopDrag);
			map.buttonMode = true;
			
			map2.addEventListener(MouseEvent.MOUSE_DOWN, doDrag2);
			map2.addEventListener(MouseEvent.MOUSE_UP, doStopDrag2);
			map2.addEventListener(MouseEvent.MOUSE_OUT, doStopDrag2);
			map2.buttonMode = true;
			
			pnlLinks.btnZoomIn.addEventListener(MouseEvent.CLICK, zoomIn);
			pnlLinks.btnZoomOut.addEventListener(MouseEvent.CLICK, zoomOut);
			pnlLinks.btnZoomIn.buttonMode = true;
			pnlLinks.btnZoomOut.buttonMode = true;
		}
		
		private function doAddFriend(e:MouseEvent)
		{
			pnlFriendList.visible = true;			
			map.visible = false;
		}
		
		private function doMap(e:MouseEvent)
		{
			pnlFriendList.visible = false;			
			map.visible = true;
		}
		
		private function goBack(e:MouseEvent)
		{
			pnlLinks.visible =  false;
			map.visible = false;
			map2.visible = false;
		}
		
		private function zoomIn(e:MouseEvent)
		{
			map2.visible = true;
			map.visible = false;
		}
		
		private function zoomOut(e:MouseEvent)
		{
			map2.visible = false;
			map.visible = true;
		}
		
		private function doDrag(e:MouseEvent)
		{
						
			var startX:Number = stage.stageWidth - map.width;
			var startY:Number = stage.stageHeight - map.height - pnlLinks.height;
			var rect:Rectangle = new Rectangle(startX, startY, -startX, -startY);
			//var rect:Rectangle = new Rectangle(maskThumbs.width - thumbsMaster.width / 2 + 440, 0, maskThumbs.width - thumbsMaster.width, 0);
			map.startDrag(false, rect);
		}
		
		private function doStopDrag(e:MouseEvent)
		{
			map.stopDrag();
		}
		
		private function doDrag2(e:MouseEvent)
		{
						
			var startX:Number = stage.stageWidth - map2.width;
			var startY:Number = stage.stageHeight - map2.height - pnlLinks.height;
			var rect:Rectangle = new Rectangle(startX, startY, -startX, -startY);
			//var rect:Rectangle = new Rectangle(maskThumbs.width - thumbsMaster.width / 2 + 440, 0, maskThumbs.width - thumbsMaster.width, 0);
			map2.startDrag(false, rect);
		}
		
		private function doStopDrag2(e:MouseEvent)
		{
			map2.stopDrag();
		}
		private function doLogin(e:MouseEvent)
		{
			
			if(txtUser.text != "" && txtPassword.text != "")
			{
				trace("login click");
				//gotoAndStop(2);
				pnlLinks.visible =  true;
				map.visible = true;
			}
			else
			{
				pnlIncorrectLogin.visible = true;
			}
		}
		private function doOptions(e:MouseEvent)
		{
			pnlOptions.visible = true;
		}
		private function doGettingStarted(e:MouseEvent)
		{
			pnlGettingStarted.visible = true;
		}
		private function doSignUp(e:MouseEvent)
		{
			pnlSignUp.visible = true;
		}
		private function doMore(e:MouseEvent)
		{
			pnlMore.visible = true;
		}
		private function doClose(e:MouseEvent)
		{
			e.target.parent.visible = false;
		}
	
	}
}
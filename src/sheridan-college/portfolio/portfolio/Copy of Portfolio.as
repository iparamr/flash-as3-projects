package portfolio {
	
	import flash.display.*;
	import flash.events.*;
	import fl.transitions.*;
	import fl.motion.easing.*;
	import flash.utils.Timer;
	
	import flash.text.*;
	
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	
	import flash.display.DisplayObject;
    import flash.geom.Rectangle;
	
	//import fl.data.DataProvider;
	//import flash.utils.ByteArray;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
			
	public class Portfolio extends MovieClip
	{
		private var i:uint;
		private var j:uint;
				
		public function Portfolio()
		{
			var myFalcon:Falcon = new Falcon("data.xml", Falcon.XML_DATA);			
			myFalcon.addEventListener(Event.COMPLETE, doXML);
			tabsAnimate();
			
			pnlThumbsHolder.addChild(thumbsMaster);			
			//thumbsReflect.scaleY *= -1;
			stage.addEventListener(Event.ENTER_FRAME, update);
			pnlThumbsHolder.visible = false;
			pnlDesc.visible = false;
			pnlTitle.visible = false;
			
			pnlWindowZoom.visible = false;
			pnlWindowResume.visible = false;
			pnlWindowContact.visible = false;
			pnlWindowProfile.visible = false;
			pnlWindowServices.visible = false;			
			navDisabler.visible = false;
			
			addArrowsEvents();
			//header events addHeaderEvents(); are added in doXML
			closeBtnEvents();
			
		}
		
		private function closeBtnEvents ():void
		{	
			pnlWindowZoom.btnClose.buttonMode = true;
			pnlWindowResume.btnClose.buttonMode = true;
			pnlWindowContact.btnClose.buttonMode = true;
			pnlWindowProfile.btnClose.buttonMode = true;
			pnlWindowServices.btnClose.buttonMode = true;
			
			pnlWindowZoom.btnClose.addEventListener(MouseEvent.MOUSE_OVER, closeHilight);
			pnlWindowZoom.btnClose.addEventListener(MouseEvent.MOUSE_OUT, closeNormal);
			pnlWindowZoom.btnClose.addEventListener(MouseEvent.CLICK, closeClickZoom);
			
			pnlWindowResume.btnClose.addEventListener(MouseEvent.MOUSE_OVER, closeHilight);
			pnlWindowResume.btnClose.addEventListener(MouseEvent.MOUSE_OUT, closeNormal);
			pnlWindowResume.btnClose.addEventListener(MouseEvent.CLICK, closeClick);
			
			pnlWindowContact.btnClose.addEventListener(MouseEvent.MOUSE_OVER, closeHilight);
			pnlWindowContact.btnClose.addEventListener(MouseEvent.MOUSE_OUT, closeNormal);
			pnlWindowContact.btnClose.addEventListener(MouseEvent.CLICK, closeClick);
			
			pnlWindowProfile.btnClose.addEventListener(MouseEvent.MOUSE_OVER, closeHilight);
			pnlWindowProfile.btnClose.addEventListener(MouseEvent.MOUSE_OUT, closeNormal);
			pnlWindowProfile.btnClose.addEventListener(MouseEvent.CLICK, closeClick);
			
			pnlWindowServices.btnClose.addEventListener(MouseEvent.MOUSE_OVER, closeHilight);
			pnlWindowServices.btnClose.addEventListener(MouseEvent.MOUSE_OUT, closeNormal);
			pnlWindowServices.btnClose.addEventListener(MouseEvent.CLICK, closeClick);
		}
		private function closeHilight(e:MouseEvent)
		{
			e.target.gotoAndStop(2);
		}
		private function closeNormal(e:MouseEvent)
		{
			e.target.gotoAndStop(1);
		}		
		private function closeClick(e:MouseEvent)
		{			
			e.target.parent.visible = false;
			navDisabler.visible = false;
		}
		
		private function addHeaderEvents()
		{
			pnlHeader.btnResume.buttonMode = true;
			pnlHeader.btnContact.buttonMode = true;
			
			pnlHeader.btnResume.addEventListener(MouseEvent.MOUSE_OUT, doHeaderOut);				
			pnlHeader.btnContact.addEventListener(MouseEvent.MOUSE_OUT, doHeaderOut);
			pnlHeader.btnResume.addEventListener(MouseEvent.MOUSE_OVER, doHeaderOver);
			pnlHeader.btnContact.addEventListener(MouseEvent.MOUSE_OVER, doHeaderOver);
			pnlHeader.btnResume.addEventListener(MouseEvent.CLICK, doHeaderClick);
			pnlHeader.btnContact.addEventListener(MouseEvent.CLICK, doHeaderClick);
			
			addResumeWindowEvents();
		}
		
		private function doHeaderOut(e:MouseEvent){
			e.target.gotoAndStop(1);
		}
		private function doHeaderOver(e:MouseEvent){
			e.target.gotoAndStop(2);
		}
		
		private var xmlHTML:String;
		private var xmlCSS:String;		
		private var css:StyleSheet = new StyleSheet();	
		private function doHeaderClick(e:MouseEvent){
			
			xmlCSS = myXML.css;						
			xmlCSS = xmlCSS.split("\t").join("");				
			css.parseCSS(xmlCSS);
			
			if(e.target.name == "btnResume")
			{
				xmlHTML = myXML.resume;
				xmlHTML = xmlHTML.split("\r\n").join("");
				xmlHTML = xmlHTML.split("\t").join("");
				
				pnlWindowResume.con.txtResume.styleSheet = css;
				pnlWindowResume.con.txtResume.htmlText = xmlHTML;
				pnlWindowResume.con.txtResume.autoSize = TextFieldAutoSize.LEFT;
				pnlWindowResume.con.txtResume.y = 0;
				
				//using the SelectionColor class in the portfolio package
				SelectionColor.setFieldSelectionColor(pnlWindowResume.con.txtResume, 0xEEEEEE);
				
				closeTabsTween();
				pnlWindowResume.visible = true;
				navDisabler.visible = true;
				
			}else if (e.target.name == "btnContact")
			{
				xmlHTML = myXML.contact;
				xmlHTML = xmlHTML.split("\r\n").join("");
				xmlHTML = xmlHTML.split("\t").join("");
				
				pnlWindowContact.txtContact.styleSheet = css;
				pnlWindowContact.txtContact.htmlText = xmlHTML;
				pnlWindowContact.txtContact.autoSize = TextFieldAutoSize.LEFT;
				pnlWindowContact.txtContact.y = 64;
				
				//using the SelectionColor class in the portfolio package
				SelectionColor.setFieldSelectionColor(pnlWindowContact.txtContact, 0xEEEEEE);
				
				closeTabsTween();
				pnlWindowContact.visible = true;
				navDisabler.visible = true;
			}
		}
		
		
		private function addResumeWindowEvents()
		{
			pnlWindowResume.btnResumePDF.buttonMode = true;
			pnlWindowResume.btnResumeDOC.buttonMode = true;
			pnlWindowResume.btnResumePDF.addEventListener(MouseEvent.CLICK, doBtnResumePDF);
			pnlWindowResume.btnResumeDOC.addEventListener(MouseEvent.CLICK, doBtnResumeDOC);
			
			addResumeArrowsEvents();
		}
		
		private var resumePDF:String;
		private var resumeDOC:String;		
		private function doBtnResumePDF(e:MouseEvent)
		{
			resumePDF = myXML.resume.@pdf;
			trace(resumePDF);
			navigateToURL(new URLRequest(resumePDF), "_blank");
		}
		private function doBtnResumeDOC(e:MouseEvent)
		{
			resumeDOC = myXML.resume.@doc;
			trace(resumeDOC);
			navigateToURL(new URLRequest(resumeDOC), "_blank");		
		}
		//resume arrows
		private function addResumeArrowsEvents()
		{
			pnlWindowResume.btnTopArrow.buttonMode = true;
			pnlWindowResume.btnBtmArrow.buttonMode = true;
			pnlWindowResume.btnTopArrow.addEventListener(MouseEvent.MOUSE_DOWN, arrowResumeEnable);
			pnlWindowResume.btnBtmArrow.addEventListener(MouseEvent.MOUSE_DOWN, arrowResumeEnable);
			pnlWindowResume.btnTopArrow.addEventListener(MouseEvent.MOUSE_UP, arrowResumeDisable);			
			pnlWindowResume.btnBtmArrow.addEventListener(MouseEvent.MOUSE_UP, arrowResumeDisable);
			pnlWindowResume.btnTopArrow.addEventListener(MouseEvent.MOUSE_OUT, arrowResumeDisable);			
			pnlWindowResume.btnBtmArrow.addEventListener(MouseEvent.MOUSE_OUT, arrowResumeDisable);
			pnlWindowResume.btnTopArrow.addEventListener(MouseEvent.MOUSE_OVER, arrowHilight);			
			pnlWindowResume.btnBtmArrow.addEventListener(MouseEvent.MOUSE_OVER, arrowHilight);
			pnlWindowResume.btnTopArrow.addEventListener(MouseEvent.MOUSE_OUT, arrowNormal);			
			pnlWindowResume.btnBtmArrow.addEventListener(MouseEvent.MOUSE_OUT, arrowNormal);			
		}
		
		private var enableTop:Boolean;
		private var enableBtm:Boolean;
		private var speedResumeTimer:Timer;
		private var resumeSpeed:int;
		
		private function arrowResumeEnable(e:MouseEvent)
		{
			if (e.target.name == "btnTopArrow")
			{
				enableTop = true;
			}
			if (e.target.name == "btnBtmArrow")
			{
				enableBtm = true;
			}
			resumeSpeed = 10;
			speedResumeTimer = new Timer(1000, 1.5);
			speedResumeTimer.start();
			speedResumeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerResumeComplete);
			
		}
		private function arrowResumeDisable(e:MouseEvent)
		{
			enableTop = false;		
			enableBtm = false;
			if (speedResumeTimer)
			{
				speedResumeTimer.reset();
			}
		}
		private function timerResumeComplete(e:TimerEvent):void
		{
			resumeSpeed = resumeSpeed * 2;
		}
		//arrows
		private function addArrowsEvents()
		{
			btnLeftArrow.buttonMode = true;
			btnRightArrow.buttonMode = true;
			btnLeftArrow.addEventListener(MouseEvent.MOUSE_DOWN, arrowEnable);
			btnRightArrow.addEventListener(MouseEvent.MOUSE_DOWN, arrowEnable);
			btnLeftArrow.addEventListener(MouseEvent.MOUSE_UP, arrowDisable);			
			btnRightArrow.addEventListener(MouseEvent.MOUSE_UP, arrowDisable);
			btnLeftArrow.addEventListener(MouseEvent.MOUSE_OUT, arrowDisable);			
			btnRightArrow.addEventListener(MouseEvent.MOUSE_OUT, arrowDisable);
			btnLeftArrow.addEventListener(MouseEvent.MOUSE_OVER, arrowHilight);			
			btnRightArrow.addEventListener(MouseEvent.MOUSE_OVER, arrowHilight);
			btnLeftArrow.addEventListener(MouseEvent.MOUSE_OUT, arrowNormal);			
			btnRightArrow.addEventListener(MouseEvent.MOUSE_OUT, arrowNormal);
		}
		
		private var enableLeft:Boolean;
		private var enableRight:Boolean;
		private var speedTimer:Timer;
		private var speed:int;
		private function arrowEnable(e:MouseEvent)
		{
			if (e.target.name == "btnLeftArrow")
			{
				enableLeft = true;
				closeTabsTween();
			}
			if (e.target.name == "btnRightArrow")
			{
				enableRight = true;
				closeTabsTween();
			}
			speed = 20;
			speedTimer = new Timer(1000, 1.5);
			speedTimer.start();
			speedTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			
		}
		private function arrowDisable(e:MouseEvent)
		{
			enableLeft = false;		
			enableRight = false;
			if (speedTimer)
			{
				speedTimer.reset();
			}
		}
		private function timerComplete(e:TimerEvent):void
		{
			speed = speed * 2;			
		}
		private function arrowHilight(e:MouseEvent):void
		{
			e.target.gotoAndStop(2);
		}
		private function arrowNormal(e:MouseEvent):void
		{
			e.target.gotoAndStop(1);		
		}
		
		private var widthIncr:int = 0;
		private var posRunOnce:int = 0;
		private var loadIntervalChk:int = 0;
		private var refMask:Object = new Object();
		private var blur:BlurFilter = new BlurFilter();
		private var chkThumbsFormat:Boolean = false;
		private var isSmallHolder:Boolean = false;
		//var curWidth:int;
		//var curHeight:int;
		
		private function update(e:Event){
			
			//trace(loadIntervalChk);
			//trace(imageLoadChk/2);
			
			if(enableLeft && !isSmallHolder)
			{
				if (thumbsMaster.x < 0)
				{
					thumbsMaster.x += speed;
				} else
				{
					thumbsMaster.x = 0;
				}
				
			}else if(enableRight && !isSmallHolder)
			{
				//trace("w: "+ -Math.abs(maskThumbs.width - thumbsMaster.width));
				//trace("x: "+ thumbsMaster.x);
				if (thumbsMaster.x > -Math.abs(maskThumbs.width - (thumbsMaster.width - 20)))
				{
					thumbsMaster.x -= speed;
				} else
				{
					thumbsMaster.x = -Math.abs(maskThumbs.width - (thumbsMaster.width - 20));
				}
				
			}else if(enableTop)
			{
				//trace("top");
				if (pnlWindowResume.con.txtResume.y < 0)
				{
					pnlWindowResume.con.txtResume.y += resumeSpeed;
				} else
				{
					pnlWindowResume.con.txtResume.y = 0;
				}
				
			}else if(enableBtm)
			{
				//trace(resumeSpeed);
				if (pnlWindowResume.con.txtResume.y > -Math.abs(pnlWindowResume.con.maskResume.height - (pnlWindowResume.con.txtResume.height - 1)))
				{
					pnlWindowResume.con.txtResume.y -= resumeSpeed;
				} else
				{
					pnlWindowResume.con.txtResume.y = -Math.abs(pnlWindowResume.con.maskResume.height - (pnlWindowResume.con.txtResume.height) );
				}				
			}
			
			if (loadIntervalChk * 2 == imageLoadChk && imageLoadChk != 0)
			{
				loaderHide();
				pnlThumbsHolder.visible = true;
				imageLoadChk = 0;
				loadIntervalChk = 0;
				chkThumbsFormat = true;
				isSmallHolder = false;
			}
			
			thumbsReflect.y = (thumbs.height * 2) + 4 - (thumbs.height / 4);
						
			if (chkThumbsFormat)
			{
				if (thumbs.numChildren != 0)
				{				
					for (i=0; i < thumbs.numChildren; i++)
					{
						//trace(thumbs.getChildAt(i).width);
						if (thumbs.getChildAt(i).width != 0 && posRunOnce == i)
						{
							
							//blur.blurX = 1;
							blur.blurY = 2;
							blur.quality = BitmapFilterQuality.MEDIUM;
							
							refMask[i] = new ReflectionMask();
							thumbsReflect.addChild(refMask[i]);
							
							refMask[i].cacheAsBitmap = true;	
							imgMCRef[i].cacheAsBitmap = true;
							
							refMask[i].width = thumbsReflect.getChildAt(i).width;
							refMask[i].height = thumbsReflect.getChildAt(i).height;
							thumbsReflect.getChildAt(i).mask = refMask[i];
							thumbsReflect.getChildAt(i).filters = [blur];
							
							thumbs.getChildAt(i).x = widthIncr;
							thumbsReflect.getChildAt(i).x = widthIncr;
							refMask[i].x = widthIncr;
						
							widthIncr += thumbs.getChildAt(i).width + 10;
							//(index * 170) + 50;
							thumbs.getChildAt(i).y = (thumbs.height - thumbs.getChildAt(i).height);
							thumbsReflect.getChildAt(i).y = thumbs.getChildAt(i).y;//(thumbsReflect.height - thumbsReflect.getChildAt(i).height);
							refMask[i].y = thumbsReflect.getChildAt(i).y;//(thumbsReflect.height - thumbsReflect.getChildAt(i).height);
							
							posRunOnce++;													
						}
					}
					if(thumbsMaster.width < maskThumbs.width)
					{
						trace("small holder");
						thumbsMaster.x = ((stage.stageWidth/2) - (thumbsMaster.width/2) - 72);
						isSmallHolder = true;
					} else {
						thumbsMaster.x = 0;
					}
				}
				trace("rendered");
				chkThumbsFormat = false;
			}
		}
		
		private function loaderShow()
		{
			loader.visible = true;
		}
		
		private function loaderHide()
		{
			loader.visible = false;
		}
		
		
		private var myXML:XML;		
		private function doXML(e:Event) 
		{			
			myXML = e.target.data;
			myXML.ignoreWhite = true;
			//trace(myXML);
			loaderHide();
			doLinksAddEvents();
			addHeaderEvents();
			
			//the default open page, when it loads the first time
			category = "Graphic Design";
			subCategory = "Digital Art";
			doFillDataArray();
		}
		
		private function doLinksAddEvents()
		{			
			var numChild:int;
			for(i=0; i<tabs.numChildren; i++) {  
				//trace(tabs.getChildAt(i).name);
				//trace(tabs[tabs.getChildAt(i).name].numChildren);
				numChild = tabs[tabs.getChildAt(i).name].numChildren - 1;
				numChild = numChild / 2;
				//trace(numChild);
				for(j=1; j <= numChild; j++) {
					//trace(tabs[tabs.getChildAt(i).name].getChildAt(j).name);
					tabs[tabs.getChildAt(i).name].getChildAt(j).buttonMode = true;
					tabs[tabs.getChildAt(i).name].getChildAt(j).addEventListener(MouseEvent.CLICK, doLinksClick);
				}
				//trace("----------");				
			}
		}
		
		private var subCategory:String;
		private var lnkClicked:String;
		private function doLinksClick(e:MouseEvent)
		{	
			lnkClicked = e.target.name;
			trace(lnkClicked);
				//ABOUT ME
			if (lnkClicked == "btnAbtMeProfile")
			{
				subCategory = "Profile";
				
			} else if (lnkClicked == "btnAbtMeServices")
			{
				subCategory = "Services";
				
			} else if (lnkClicked == "btnAbtMeClients")
			{
				subCategory = "Clients";
				
				//WEB DESIGN
			} else if (lnkClicked == "btnWebDesFlash")
			{
				subCategory = "Flash";
				
			} else if (lnkClicked == "btnWebDesWeb")
			{
				subCategory = "Web";
				
				//GRAPHIC DESIGN
			} else if (lnkClicked == "btnGrphDesDigitalArt")
			{
				subCategory = "Digital Art";
				
			} else if (lnkClicked == "btnGrphDesPrint")
			{
				subCategory = "Print";
				
			} else if (lnkClicked == "btnGrphDesInterfaces")
			{
				subCategory = "Interface";
				
			} else if (lnkClicked == "btnGrphDesLogos")
			{
				subCategory = "Logo";
				
				//DEVELOPMENT
			} else if (lnkClicked == "btnDevFlash")
			{
				subCategory = "Flash";
				
			} else if (lnkClicked == "btnDevWeb")
			{
				subCategory = "Web";
				
			} else if (lnkClicked == "btnDevOther")
			{
				subCategory = "Other";
				
				//FINE ART
			} else if (lnkClicked == "btnFArtPencil")
			{
				subCategory = "Pencil";
				
			} else if (lnkClicked == "btnFArtColour")
			{
				subCategory = "Colour";
				
				//OTHER
			} else if (lnkClicked == "btnOthAnimation")
			{
				subCategory = "Animation";
				
			} else if (lnkClicked == "btnOthVideoEditing")
			{
				subCategory = "Video Editing";
				
			} else if (lnkClicked == "btnOthPhotography")
			{
				subCategory = "Photography";
			}
			
			if (subCategory == "Profile")
			{
				xmlCSS = myXML.css;						
				xmlCSS = xmlCSS.split("\t").join("");				
				css.parseCSS(xmlCSS);
				xmlHTML = myXML.category.(@name==category).subcat.(@name==subCategory);
				xmlHTML = xmlHTML.split("\r\n").join("");
				xmlHTML = xmlHTML.split("\t").join("");
				//trace(xmlHTML);
				
				pnlWindowProfile.txtProfile.styleSheet = css;
				pnlWindowProfile.txtProfile.htmlText = xmlHTML;
				pnlWindowProfile.txtProfile.autoSize = TextFieldAutoSize.LEFT;
				pnlWindowProfile.txtProfile.y = 64;
				
				//using the SelectionColor class in the portfolio package
				SelectionColor.setFieldSelectionColor(pnlWindowProfile.txtProfile, 0xEEEEEE);
				
				pnlWindowProfile.visible = true;
				navDisabler.visible = true;
				
			} else if (subCategory == "Services")
			{
				xmlCSS = myXML.css;						
				xmlCSS = xmlCSS.split("\t").join("");				
				css.parseCSS(xmlCSS);
				xmlHTML = myXML.category.(@name==category).subcat.(@name==subCategory);
				xmlHTML = xmlHTML.split("\r\n").join("");
				xmlHTML = xmlHTML.split("\t").join("");
				//trace(xmlHTML);
				
				pnlWindowServices.txtServices.styleSheet = css;
				pnlWindowServices.txtServices.htmlText = xmlHTML;
				pnlWindowServices.txtServices.autoSize = TextFieldAutoSize.LEFT;
				pnlWindowServices.txtServices.y = 64;
				
				//using the SelectionColor class in the portfolio package
				SelectionColor.setFieldSelectionColor(pnlWindowServices.txtServices, 0xEEEEEE);
				
				pnlWindowServices.visible = true;
				navDisabler.visible = true;
								
			} else
			{
				doFillDataArray();
			}
			
			//close the currently opened tab
			doTabsClick(e);			
		}
				
		private var path:String;
		private var pathCategory:String;
		private var pathSubCat:String;
		private var thumbPath:String;
		private var picturePath:String;
		private function doFillDataArray():void
		{
			if(myXML != "")
			{
				trace(category + " >> " + subCategory);
				
				path = myXML.images.@path;
				pathCategory = myXML.category.(@name==category).@path;
				pathSubCat = myXML.category.(@name==category).subcat.(@name==subCategory).@path;
				thumbPath = myXML.images.@thumb_path;
				picturePath = myXML.images.@picture_path;
				
				trace(path, thumbPath, picturePath);
				
				var myDataProvider:Array = [];
				var title:String; var year:String; var client:String; var picture:String; var description:String;
				for each (var s:XML in myXML.category.(@name==category).subcat.(@name==subCategory).piece) {					
					//trace(s);
					title = s.@title;
					year = s.@year;
					client = s.@client;				
					picture = s.@picture;				
					description = s;
					
					//myDataProvider.push(title, year, client, picture, description);
					myDataProvider.push({title:title, year:year, client:client, picture:picture, description:description});
					//myDataProvider.push({title:[title], year:[year], client:[client], picture:[picture], description:[description]});
					loadIntervalChk++;
					
				}
				trace("---------");
				//trace(myDataProvider[0]["picture"]);
				
				
				//pnlThumbsHolder.removeEventListener(Event.ENTER_FRAME, update);	
				//thumbsMaster.removeChild(thumbs);
				//thumbsMaster.removeChild(thumbsReflect);
				pnlThumbsHolder.removeChild(thumbsMaster);
				
				//trace(newThumbIndex);
				if (thumbRefresh)
				{
					//thumbRefresh.removeChild(mcDescThumbs[newThumbIndex]);
					pnlDesc.removeChild(thumbRefresh);
					thumbRefresh = null;
					pnlDesc.visible = false;
					oldThumbIndex = newThumbIndex = 0;
				}
				
				
				thumbs = new MovieClip();
				thumbsReflect = new MovieClip();
				thumbsMaster = new MovieClip();
				mcDescThumbs = new Object();
				
				//thumbsMaster.addChild(thumbs);
				//thumbsMaster.addChild(thumbsReflect);
				pnlThumbsHolder.addChild(thumbsMaster);
				
				thumbsReflect.scaleY *= -0.75;
				posRunOnce = 0;
				widthIncr = 0;
				
				loaderShow();
				pnlThumbsHolder.visible = false;
								
				//pnlThumbsHolder.addEventListener(Event.ENTER_FRAME, update);	
				
				myDataProvider.forEach(doMakeThumbs);
			} else {
				trace("XML File Blank!!!");
			}
		}
		
		//private var loadThumb:Loader;
		private var imgLoader:Object = new Object();
		private var imgLoaderRef:Object = new Object();
		private var loaderDescThumbs:Object = new Object();
		var imgMC:Object = new Object();
		var imgMCRef:Object = new Object();
		var mcDescThumbs:Object = new Object();
		var thumbs:MovieClip = new MovieClip();
		var thumbsReflect:MovieClip = new MovieClip();
		var thumbsMaster:MovieClip = new MovieClip();
		
		private function doMakeThumbs(element:*, index:int, arr:Array):void {
		
			////mc.dynProperty = index;			
			////circle_mc.addEventListener(MouseEvent.CLICK, onClick);
			
			var urlReq:URLRequest = new URLRequest(path + pathCategory + pathSubCat + thumbPath + element.picture); 
			imgLoader[index] = new Loader();
			imgLoaderRef[index] = new Loader();
			loaderDescThumbs[index] = new Loader();
			imgLoader[index].contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			imgLoaderRef[index].contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			
			imgLoader[index].load(urlReq);
			imgLoaderRef[index].load(urlReq);
			loaderDescThumbs[index].load(urlReq);
			
			imgMC[index] = new MovieClip();
			imgMCRef[index] = new MovieClip();
			mcDescThumbs[index] = new MovieClip();
			
			imgMC[index].buttonMode = true;
			imgMC[index].dynIndex = index;			
			imgMC[index].dynTitle = element.title;
			imgMC[index].dynYear = element.year;
			imgMC[index].dynClient = element.client;
			imgMC[index].dynDescription = element.description;
			imgMC[index].dynPicture = element.picture;
			
			imgMC[index].addEventListener(MouseEvent.CLICK, doThumbsClick);
			//imgMC[index].addEventListener(MouseEvent.MOUSE_DOWN, doThumbsDown);			
			//imgMC[index].addEventListener(MouseEvent.MOUSE_UP, doThumbsUp);
			//imgMC[index].addEventListener(MouseEvent.MOUSE_MOVE, doThumbsMove);
			imgMC[index].addEventListener(MouseEvent.MOUSE_OVER, doThumbsOver);
			imgMC[index].addEventListener(MouseEvent.MOUSE_OUT, doThumbsOut);
			
			imgMC[index].addChild(imgLoader[index]);
			imgMCRef[index].addChild(imgLoaderRef[index]);
			mcDescThumbs[index].addChild(loaderDescThumbs[index]);
			
			thumbsReflect.addChild(imgMCRef[index]);
			thumbs.addChild(imgMC[index]);
			
			thumbsMaster.addChild(thumbsReflect);
			thumbsMaster.addChild(thumbs);
		}

		private var imageLoadChk:int = 0;
		
		private function imgLoaded(e:Event):void
		{
			imageLoadChk++;
		}
	   	
		private var thumbRefresh:MovieClip;
		private var oldThumbIndex:int = 0;
		private var newThumbIndex:int = 0;
		
		private var fullImg:MovieClip;
		private var loaderFullImg:Loader;
		private var myTweenDesc:Tween;
		private function doThumbsClick(e:MouseEvent)
		{
			//trace(e.target.parent.dynIndex);
			//trace(oldThumbIndex, newThumbIndex);
			oldThumbIndex = newThumbIndex;
			newThumbIndex = e.target.parent.dynIndex;
			
			if (thumbRefresh)
			{
				//thumbRefresh.removeChild(mcDescThumbs[oldThumbIndex]);
				pnlDesc.removeChild(thumbRefresh);
				thumbRefresh = null;
			}
			
			thumbRefresh = new MovieClip();
			thumbRefresh.addChild(mcDescThumbs[e.target.parent.dynIndex]);
			pnlDesc.addChild(thumbRefresh);
			
			myTweenDesc = new Tween(pnlDesc.pnlDescText, "x", Exponential.easeOut, pnlDesc.pnlDescText.x, mcDescThumbs[e.target.parent.dynIndex].width + 15, .4, true);
			
			pnlDesc.pnlDescText.x = mcDescThumbs[e.target.parent.dynIndex].width + 15;
			pnlDesc.pnlDescText.title.text = e.target.parent.dynTitle;
			pnlDesc.pnlDescText.year.text = e.target.parent.dynYear;
			pnlDesc.pnlDescText.client.text = e.target.parent.dynClient;
			pnlDesc.pnlDescText.description.text = e.target.parent.dynDescription;
			//pnlDesc.x = stage.stageWidth / 2;
			pnlDesc.visible = true;
			pnlDesc.btnZoom.visible = false;
			
			if(fullImg)
			{
				pnlDesc.removeChild(fullImg);
			}			
			fullImg = new MovieClip();
			
			var urlReqFullImg:URLRequest = new URLRequest(path + pathCategory + pathSubCat + picturePath + e.target.parent.dynPicture);			
			loaderFullImg = new Loader();
						
			loaderFullImg.load(urlReqFullImg);			
			fullImg.addChild(loaderFullImg);
			loaderFullImg.contentLoaderInfo.addEventListener(Event.COMPLETE, imgFullLoaded);
			
			closeTabsTween();
		}
		
		private var bmpData:BitmapData;
		private var fullImageWbig:int;
		private var fullImageHbig:int;
		private var myTweenBtnZoomX:Tween;
		private var myTweenDesc2:Tween;
		private var myTweenWidth:Tween;
		private var myTweenHeight:Tween;
		
		private function imgFullLoaded(e:Event)
		{
			
			if (bmpData)
			{
				bmpData.dispose();
			}
			
			bmpData = new BitmapData(fullImg.width,fullImg.height,false,0xFF000000);
			var bmp:Bitmap = new Bitmap(bmpData);
			bmp.smoothing = true;
			bmpData.draw(fullImg);
			fullImg.addChild(bmp);
			
			fullImg.scaleX *= 0.4; fullImg.scaleY *= 0.4;			
						
			pnlDesc.btnZoom.y = fullImg.height - 17.2;
			zoomBtnEvents();
			myTweenBtnZoomX = new Tween(pnlDesc.btnZoom, "x", Exponential.easeOut, pnlDesc.btnZoom.x, fullImg.width + 17, 0.4, true);
			//var myTweenZoomY:Tween = new Tween(pnlDesc.btnZoom, "y", Exponential.easeOut, pnlDesc.btnZoom.y, fullImg.height - 22, .2, true);
			myTweenDesc2 = new Tween(pnlDesc.pnlDescText, "x", Exponential.easeOut, pnlDesc.pnlDescText.x, fullImg.width + 15, 0.4, true);
			myTweenWidth = new Tween(fullImg, "width", Exponential.easeOut, thumbRefresh.width, fullImg.width, 0.4, true);
			myTweenHeight = new Tween(fullImg, "height", Exponential.easeOut, thumbRefresh.height, fullImg.height, 0.4, true);
			
			fullImageWbig = loaderFullImg.width;
			fullImageHbig = loaderFullImg.height;
			
			fullImg.removeChild(loaderFullImg);
			pnlDesc.addChild(fullImg);
			thumbRefresh.visible = false;
			pnlDesc.btnZoom.visible = true;
			loaderFullImg = null;
		}
		
		
		private function zoomBtnEvents ():void
		{	
			pnlDesc.btnZoom.buttonMode = true;
			pnlDesc.btnZoom.addEventListener(MouseEvent.MOUSE_OVER, zoomHilight);
			pnlDesc.btnZoom.addEventListener(MouseEvent.MOUSE_OUT, zoomNormal);
			pnlDesc.btnZoom.addEventListener(MouseEvent.CLICK, zoomClick);
		}
		
		private function zoomHilight(e:MouseEvent)
		{
			pnlDesc.btnZoom.gotoAndStop(2);
		}
		private function zoomNormal(e:MouseEvent)
		{
			pnlDesc.btnZoom.gotoAndStop(1);
		}
		private var fullImageWsmall:int;
		private var fullImageHsmall:int;
		private var myTweenZoomWidth:Tween;
		private var myTweenZoomHeight:Tween;
		private var myTweenZoomX:Tween;
		private var myTweenZoomY:Tween;
		
		private function zoomClick(e:MouseEvent)
		{
			fullImageWsmall = fullImg.width;
			fullImageHsmall = fullImg.height;
			
			pnlWindowZoom.visible = true;
			navDisabler.visible = true;
			pnlDesc.pnlDescText.visible = false;
			pnlDesc.btnZoom.visible = false;			
			
			myTweenZoomWidth = new Tween(fullImg, "width", Exponential.easeOut, fullImg.width, fullImageWbig, 0.4, true);
			myTweenZoomHeight = new Tween(fullImg, "height", Exponential.easeOut, fullImg.height, fullImageHbig, 0.4, true);
			
			var toX:int = ((stage.stageWidth/2) - (fullImageWbig/2)) - 280;
			var toY:int = (((stage.stageHeight/2) - (fullImageHbig/2)) - 146) + 38;
			
			myTweenZoomX = new Tween(fullImg, "x", Exponential.easeOut, fullImg.x, toX , 0.4, true);
			myTweenZoomY = new Tween(fullImg, "y", Exponential.easeOut, fullImg.y, toY, 0.4, true);
			
			closeTabsTween();
		}
		private function closeClickZoom(e:MouseEvent)
		{			
			pnlWindowZoom.visible = false;
			navDisabler.visible = false;
			
			fullImg.x = fullImg.y = 0;
			fullImg.width = fullImageWsmall;
			fullImg.height = fullImageHsmall;
			pnlDesc.pnlDescText.visible = true;
			pnlDesc.btnZoom.visible = true;	
		}
		
		/*private var dragging:Boolean = false;
		private function doThumbsDown(e:MouseEvent)
		{
			dragging = true;
			var rect:Rectangle = new Rectangle(0, 0, thumbsMaster.width, 0);
			thumbsMaster.startDrag(false, rect);
			
		}
		
		private function doThumbsUp(e:MouseEvent)
		{
			dragging = false;
			thumbsMaster.stopDrag();			
		}
		
		private function doThumbsMove(e:MouseEvent)
		{
			if (dragging)
			{
				thumbsMaster.y = 0;
				trace("x:"+int(thumbsMaster.x + 82), " x:"+int(mouseX), " y:"+thumbsMaster.y, " y:"+mouseY);
			}
		}*/
		
		private function doThumbsOver(e:MouseEvent)
		{
			//trace(e.target.parent.dynTitle);
			pnlTitle.title.text = e.target.parent.dynTitle;
			pnlTitle.titleRef.text = e.target.parent.dynTitle;
			pnlTitle.visible = true;
		}
		
		private function doThumbsOut(e:MouseEvent)
		{
			//trace(e.target.parent.dynTitle);
			//thumbs.stopDrag();
			pnlTitle.title.text = "";
			pnlTitle.titleRef.text = "";
			pnlTitle.visible = false;
		}
				
		/*private var loadThumb:Loader;		
		private function doMakeThumbs(element:*, index:int, arr:Array):void {
		
			loadThumb = new Loader();			
			//trace(path+"graphic_design/digital_art/" + arr[index]["picture"]);
			//trace(element.title + " is found in " + element.year);
			loadThumb.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded);
			loadThumb.load(new URLRequest(path+"graphic_design/digital_art/"+thumbPath + element.picture));
			//(index * 60) + 50;
			var mc:MovieClip = new MovieClip();
			
			mc.addChild(loadThumb);
			
			loadThumb.x = (index * 170) + 50;
			loadThumb.y = 500;
			addChild(mc);
			//mc.dynProperty = index;			
			//circle_mc.addEventListener(MouseEvent.CLICK, onClick);
			
		}
		
		private function imgLoaded(event:Event):void
	   {
			
			//trace(mc.width);
	   }*/
		
		private function tabsAnimate()
		{			
			/*var maskTabs:MaskTabs = new MaskTabs();
			maskTabs.x = 0;
			maskTabs.y = 54;
			tabs.mask = maskTabs*/;
			
			for(i=0; i<tabs.numChildren; i++) {  
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
		}
		
		private var openTabHilight:String;
		private function doTabsOut(e:MouseEvent){
			//trace(e.target.name + " OUT");			
			if (e.target.parent.name != openTabHilight)
			{
				//trace(openTabHilight);
			}
			e.target.gotoAndStop(1);
		}

		
		private var tweenHeight:int;
		private var curPos:int;
		private var openTab:String;
		private var prevOpenTab:String;		
		private var myTween:Tween;
		private var tabClicked:String;
		private var category:String;
		
		private function doTabsClick(e:MouseEvent){
			//trace(e.target.name + " CLICK");
			//e.target.gotoAndStop(2);
			
			prevOpenTab = openTab;	
			openTab = e.target.parent.name;
			tabClicked = e.target.name;
			openTabHilight = openTab;
			
			trace(tabClicked);
			
			if (tabClicked == "tabAboutMe")
			{
				category = "About Me";
				
			} else if (tabClicked == "tabWebDesign")
			{
				category = "Web Design";
				
			} else if (tabClicked == "tabGraphicDesign")
			{
				category = "Graphic Design";
				
			} else if (tabClicked == "tabDevelopment")
			{
				category = "Development";
				
			} else if (tabClicked == "tabFineArt")
			{
				category = "Fine Art";
				
			} else if (tabClicked == "tabOther")
			{
				category = "Other";
			}
			
			//--TWEENING--
			//cuz of rotation x is y and y is x in menus
			
			//close tab
			for (i = 0; i<tabs.numChildren; i++) {
				//trace(Math.abs(Math.floor(tabs[tabs.getChildAt(i).name].width)) - 29 );				
				if (tabs[tabs.getChildAt(i).name].x <= 0 && tabs[tabs.getChildAt(i).name] == tabs[prevOpenTab]) {					
					//if (tabs[tabs.getChildAt(i).name] == tabs[e.target.parent.name]) {
						//trace("\tcontinue");
						//continue;
					//}					
					curPos = Math.abs(tabs[prevOpenTab].x) - 29;
					myTween = new Tween(tabs[prevOpenTab], "x", Exponential.easeOut, - curPos, 1, .4, true);					
				}
			}
		
			//open tab
			tweenHeight = Math.abs(tabs[openTab].width) - 29;			
			if(tweenHeight != Math.abs(tabs[openTab].x)){
				//for (i = 0; i<tabs.numChildren; i++) {
					//trace(tabs[tabs.getChildAt(i).name].x);
					if (tabs[openTab] == tabs[prevOpenTab]) {
						openTab = null;
						//break;
					} else {
						myTween = new Tween(tabs[e.target.parent.name], "x", Exponential.easeOut, 1, - tweenHeight, .4, true);
					}
				//}
				
			}
			
		}
		
		//used only when we click thumbs, to close the tab if user clicks on thumb.
		private function closeTabsTween(){
			//cuz of rotation x is y and y is x in menus
			
			//close tab
			for (i = 0; i<tabs.numChildren; i++) {
				//trace(Math.abs(Math.floor(tabs[tabs.getChildAt(i).name].width)) - 29 );				
				if (tabs[tabs.getChildAt(i).name].x <= 0 && tabs[tabs.getChildAt(i).name] == tabs[openTab]) {					
					//if (tabs[tabs.getChildAt(i).name] == tabs[e.target.parent.name]) {
						//trace("\tcontinue");
						//continue;
					//}					
					curPos = Math.abs(tabs[openTab].x) - 29;
					myTween = new Tween(tabs[openTab], "x", Exponential.easeOut, - curPos, 1, .4, true);
				}
			}
		}
		
	}
}

package rateaday
{
	import flash.display.*;
	import flash.geom.ColorTransform;
	import flash.events.*;
	import flash.net.*;
	import flash.text.TextField;
	
	import flash.utils.Timer;
	
	public class RateADay extends MovieClip
	{
		private var myRequest:URLRequest;
		private var myVars:URLVariables;
		private var myLoader:URLLoader;
		
		public function RateADay()
		{
			
			myVars = new URLVariables();// this holds variables to send (as dynamic properties)
			myRequest = new URLRequest();// this prepares the request for the loader
			myRequest.url='http://oa-s139-07.sheridanc.on.ca/phpie/wa2/rate_a_day.php?rand=' + Math.floor(Math.random()*1000000);
			myRequest.method=URLRequestMethod.POST;
			myRequest.data=myVars;

			myLoader = new URLLoader();// this is the loader that will send and receive
			myLoader.dataFormat = URLLoaderDataFormat.VARIABLES;// could also be be TEXT or BINARY
			
			myLoader.addEventListener(Event.COMPLETE, loadCountries);
			myLoader.addEventListener(Event.COMPLETE, loadCompMakePie);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, showError);
			
			radRateGood.addEventListener(Event.CHANGE, doRatingCat);
			radRateAvg.addEventListener(Event.CHANGE, doRatingCat);
			radRateBad.addEventListener(Event.CHANGE, doRatingCat);
			
			btnRateIt.addEventListener(MouseEvent.CLICK, doRateIt)
			
			// get the initial data from PHP which gets the data from a database
			myLoader.load(myRequest);
			
			pnlSmileys.visible = false;
			messageBox.text = "No country selected";
			pnlLegend.txtCatGood.text = "No country selected";
			pnlLegend.txtCatAvg.text = "No country selected";
			pnlLegend.txtCatBad.text = "No country selected";
		}
		
		private function loadCountries(e:Event) {
			// the data comes into the e.target.data property
			// if the data is of the format URLLoaderDataFormat.TEXT then just use the data
			// if the data is VARIABLES then convert the data into variable form like so:
			var newVars:URLVariables = new URLVariables(e.target.data);
			
			//trace(newVars.dummyVar);

			if (newVars.error == 0) {
				
				cboViewRating.addItem({label:"[Select Country]", data:"no country selected"});
				cboAddRating.addItem({label:"[Select Country]", data:"no country selected"});
				
				for (var i:uint=1; i<=newVars.totalCountries; i++) {
					//trace(newVars["countryID" + i]);
					cboViewRating.addItem({label:newVars["country" + i], data:newVars["countryID" + i]});
					cboAddRating.addItem({label:newVars["country" + i], data:newVars["countryID" + i]});
				}
				cboViewRating.addEventListener(Event.CHANGE, doViewRating);
				cboAddRating.addEventListener(Event.CHANGE, doAddRating);				
				
			} else {
				trace("There was an error in PHP, in Countries");
			}
			
			
			
			myLoader.removeEventListener(Event.COMPLETE, loadCountries);			
		}
		
		private function loadCompMakePie(e:Event) {
		
			var newVars:URLVariables = new URLVariables(e.target.data);
			
			if (newVars.error == 0) {
				
				var total:int = newVars.totalRatings;
				var good:int = newVars.totalRatingsGood;
				var avg:int = newVars.totalRatingsAvg;
				var bad:int = newVars.totalRatingsBad;				
				trace(good, avg, bad, total);
				piChart(good, avg, bad, total);
				
			} else {
				trace("There was an error in PHP, in Ratings");
			}
		}
		
		private function showError(e:IOErrorEvent) {
			trace("There was an error!");
		}
		
		var viewCountry:String = "";
		private function doViewRating(e:Event)
		{
			//trace(e.target.value);
			viewCountry = e.target.value;
			txtSelCountry.text = e.target.selectedItem.label;
			getData(e.target.value);
			
		}
		
		var addCountry:String = "";
		private function doAddRating(e:Event)
		{
			//trace(e.target.value);
			addCountry = e.target.value;
		}
		
		var ratingCat:String = "";
		private function doRatingCat(e:Event)
		{			
			if (radRateGood.selected) {
				ratingCat = 1;
			} 
			else if (radRateAvg.selected)
			{
				ratingCat = 2;
			}else if (radRateBad.selected)
			{
				ratingCat = 3;
			}
			//trace(ratingCat);
		}
		private var defaultTimer:Timer;
		private function doRateIt(e:MouseEvent)
		{
			if(addCountry != "")
			{
				if (ratingCat != "")
				{
					getData(viewCountry, addCountry, ratingCat);
				}
				else
				{
					trace("Select Category");
					btnRateIt.label = "SELECT CATEGORY";
					btnRateIt.emphasized = true;
					defaultTimer = new Timer(1000, 1.5);
					defaultTimer.start();
					defaultTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
				}
			}
			else
			{
				trace("Select Country");
				btnRateIt.label = "SELECT COUNTRY";
				btnRateIt.emphasized = true;
				defaultTimer = new Timer(1000, 2);
				defaultTimer.start();
				defaultTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			}
		}
		
		private function timerComplete(e:TimerEvent):void
		{
			btnRateIt.label = "RATE MY DAY";
			btnRateIt.emphasized = false;
		}
		
		function getData(countryID:String="", countryRateID:String="", rateCat:String="")
		{
			trace(countryID, countryRateID, rateCat);
			myVars.countryID = countryID;
			myVars.countryRateID = countryRateID;
			myVars.rateCat = rateCat;
			myLoader.load(myRequest);// this sends the variables and loads new data from php
			
			addCountry = "";
			ratingCat = "";
			cboViewRating.selectedIndex = 0;
			cboAddRating.selectedIndex = 0;
			radRateDeselect.selected = true;
		}
						
		var mcPie:MovieClip;		
		var mcPieObj:Object;
		var colorTransform:ColorTransform;
		private  function piChart(good:int, avg:int, bad:int, total:int)
		{
			if (viewCountry == "")
			{
				messageBox.text = "No country selected";
				pnlLegend.txtCatGood.text = "No country selected";
				pnlLegend.txtCatAvg.text = "No country selected";
				pnlLegend.txtCatBad.text = "No country selected";
				pnlSmileys.visible = false;
			}
			else
			{
				if(total == 0)
				{
					if (mcPie)
					{
						removeChild(mcPie);4
						mcPie = null;
					}
					messageBox.text = "No data available";
					
					pnlLegend.txtCatGood.text = "No data available";
					pnlLegend.txtCatAvg.text = "No data available";
					pnlLegend.txtCatBad.text = "No data available";
					pnlSmileys.visible = false;					
				}
				else
				{
					var aCount:Array = new Array(good, avg, bad);
					var nElements:int = aCount.length;
					var aColor:Array = new Array(0XBED600, 0XFFD300, 0XFFA12D);
					var aPercent:Array = new Array(nElements);
					var nTotal:int;
					var nTotalPercent:int;
					var nAllButLast:int;			
					var i:uint = 0;
					var j:uint = 0;
					
					pnlSmileys.visible = false;
					
					while (i < nElements) 
					{
						//trace(nTotal);
						nTotal = nTotal+ + aCount[i];
						++i;
					}
					
					i = 0;
					while (i < nElements) 
					{
						aPercent[i] = Math.round(aCount[i] / nTotal * 100);
						//trace(aPercent[i]);
						nTotalPercent = nTotalPercent + aPercent[i];
						//trace(nTotalPercent);
						if (i < nElements - 1) 
						{
							nAllButLast = nAllButLast + aPercent[i];
						}			
						++i;
					}
					
					if (nTotalPercent != 100) 
					{
						aPercent[nElements - 1] = 100 - nAllButLast;
					}
	
					if (mcPie)
					{
						removeChild(mcPie);
						mcPie = null;
					}
					
					
					mcPie = new MovieClip();			
					mcPieObj = new Object();
					
					aPercent[0] = aPercent[0] - 1;
					nRunningSum = 0;
					
					//default pie
					mcPieObj["mcPieX"] = new MCPie();
					mcPieObj["mcPieX"].x = 0;
					mcPieObj["mcPieX"].y = 0;
					mcPie.addChild(mcPieObj["mcPieX"]);
					
					pnlLegend.txtCatGood.text = Math.round(((aCount[0] / total) * 100) * 100) / 100 + "%";
					pnlLegend.txtCatAvg.text = Math.round(((aCount[1] / total) * 100) * 100) / 100 + "%";
					pnlLegend.txtCatBad.text = Math.round(((aCount[2] / total) * 100) * 100) / 100 + "%";
					
					i = 0;
					while (i < nElements) 
					{
						j = 0;		
						while (j < aPercent[i]) 
						{
							mcPieObj["mcPie"+i * nElements + j] = new MCPie();
							
							mcPie.addChild(mcPieObj["mcPie"+i * nElements + j]);
							//trace(i * nElements + j);
							
							mcPieObj["mcPie"+i * nElements + j].rotation = nRunningSum - 3.6;
							nRunningSum = nRunningSum - 3.6;
							
							colorTransform = mcPieObj["mcPie"+i * nElements + j].transform.colorTransform;
							colorTransform.color = aColor[i];
							mcPieObj["mcPie"+i * nElements + j].transform.colorTransform = colorTransform;
							
							++j;
						}
						
						++i;
					}
					
					if (pnlLegend.txtCatGood.text == "100%")
					{
						pnlSmileys.gotoAndStop(1);
						pnlSmileys.visible = true;
						trace("good");
					}
					else if (pnlLegend.txtCatAvg.text == "100%")
					{
						pnlSmileys.gotoAndStop(2);
						pnlSmileys.visible = true;
						trace("avg");
					}
					else if (pnlLegend.txtCatBad.text == "100%")
					{
						pnlSmileys.gotoAndStop(3);
						pnlSmileys.visible = true;
						trace("bad");
					}
					
					addChild(mcPie);
					mcPie.scaleX = -1
					mcPie.x = grayPie.x;
					mcPie.y = grayPie.y;
					trace(mcPie.width);
					trace(mcPie.height);
					
					swapChildren(pnlSmileys,mcPie);
				}
			}
			
		}
		
	}
}
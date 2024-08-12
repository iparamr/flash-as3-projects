<?php

	$countryID = isset($_POST['countryID']) ? $_POST['countryID'] : "";
	$countryRateID = isset($_POST['countryRateID']) ? $_POST['countryRateID'] : "";
	$rateCat = isset($_POST['rateCat']) ? $_POST['rateCat'] : "";
	
	$date = date("Y-m-d");
	
	$error = 0;

	// databse connection
	$db = mysql_connect("localhost", "root", "sheridan")  or die ("Could not connect");
	mysql_select_db("rate_a_day",$db) or die ('Could not select database');

	if ($countryRateID != "" && $rateCat != "") {

		// insert data into database
		$query = "INSERT INTO ratings (rating_id, country_id, rating_type_id) VALUES (NULL, '".mysql_real_escape_string($countryRateID)."', '".mysql_real_escape_string($rateCat)."')";
		
		$result = mysql_query($query,$db);
		if (!$result) {
			$error = "Sorry could not record fear";
		}		
	}
	
	
	echo "dummyVar=DummyVal";
	
	//###########################--countries--###########################
	
	$query = "SELECT * FROM countries ORDER BY country ASC";
	$result = mysql_query($query,$db) or die ('Query failed');
	$totalCountries = mysql_num_rows($result);
	$output = "";
	if ($result) {
		$i=0;
		while ($myrow = mysql_fetch_array($result)) {
			$i++;
			$output .= "&countryID".$i."=".urlencode($myrow['country_id']).
					   "&country".$i."=".urlencode($myrow['country']);
		}
	} else {
		$error = "Sorry could not access COUNTRIES";
	}
	echo "&totalCountries=".urlencode($totalCountries).$output;
		
		
	//###########################--ratings--###########################
	
	$query = "SELECT * FROM ratings WHERE country_id = '".mysql_real_escape_string($countryID)."'";	
	$result1 = mysql_query($query,$db) or die ('Query failed');
	$totalRatings = mysql_num_rows($result1);
	
	$query = "SELECT * FROM ratings WHERE country_id = '".mysql_real_escape_string($countryID)."' AND rating_type_id = 1";
	$result2 = mysql_query($query,$db) or die ('Query failed');
	$totalRatingsGood = mysql_num_rows($result2);
	
	$query = "SELECT * FROM ratings WHERE country_id = '".mysql_real_escape_string($countryID)."' AND rating_type_id = 2";
	$result3 = mysql_query($query,$db) or die ('Query failed');
	$totalRatingsAvg = mysql_num_rows($result3);
	
	$query = "SELECT * FROM ratings WHERE country_id = '".mysql_real_escape_string($countryID)."' AND rating_type_id = 3";
	$result4 = mysql_query($query,$db) or die ('Query failed');
	$totalRatingsBad = mysql_num_rows($result4);
	
	if ($result1 && $result2 && $result3 && $result4) {
		$error = 0;
	} else {
		$error = "Sorry could not access RATINGS";
	}
	echo "&error=".urlencode($error)."&totalRatings=".urlencode($totalRatings)."&totalRatingsGood=".urlencode($totalRatingsGood)."&totalRatingsAvg=".urlencode($totalRatingsAvg)."&totalRatingsBad=".urlencode($totalRatingsBad);

?>
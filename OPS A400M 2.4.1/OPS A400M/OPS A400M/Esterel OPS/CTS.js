function remplir(AC, captain, callsign, date, atd, engine)
{
	
	var lines = ['11','12','21','22','23','24','25','26a','26b'];
	var lineNumber;
	var line;
	
	document.getElementById('ACNumber').text = AC;
	document.getElementById('captain').text = captain;
	document.getElementById('callsign').text = callsign;
	document.getElementById('logbook').text = engine[0];
	document.getElementById('opsDate').text = date;
	document.getElementById('ATD').text = ATD;
	
	for(var index = 1; index < 5; index++)
		lineNumber = 0;
		for(line in lines)
		{
			document.getElementsByClassName(line)[index].text = engine[0][lineNumber++];
		}
	}
}
function remplir (AC, captain, callsign, date, atd, logbook, engine1, engine2, engine3, engine4, n)
{
	
	var lines = ['11','12','21','22','23','24','25','26a','26b'];
	var lineNumber;
	var line;
	
	document.getElementsByClassName('ACNumber')[n].innerHTML = AC;
	document.getElementsByClassName('captain')[n].innerHTML = captain;
	document.getElementsByClassName('callsign')[n].innerHTML = callsign;
	document.getElementsByClassName('logbook')[n].innerHTML = logbook;
	document.getElementsByClassName('opsDate')[n].innerHTML = date;
	document.getElementsByClassName('ATD')[n].innerHTML = atd;
	

		lineNumber = 0;
		for(line in lines)
		{
			document.getElementsByClassName(lines[line])[4*n].innerHTML = engine1[lineNumber].toString();
			lineNumber++;
		}
		lineNumber = 0;
		for(line in lines)
		{
			document.getElementsByClassName(lines[line])[4*n + 1].innerHTML = engine2[lineNumber].toString();
			lineNumber++;
		}
		lineNumber = 0;
		for(line in lines)
		{
			document.getElementsByClassName(lines[line])[4*n + 2].innerHTML = engine3[lineNumber].toString();
			lineNumber++;
		}
		lineNumber = 0;
		for(line in lines)
		{
			document.getElementsByClassName(lines[line])[4*n + 3].innerHTML = engine4[lineNumber].toString();
			lineNumber++;
		}
}

function setLegNumber(n)
{

	var grid = document.getElementsByTagName('body')[0].innerHTML;
	var html = grid;
	for(var i = 1; i<n; i++)
	{
		html = html.concat(grid);
	}
	document.getElementsByTagName('body')[0].innerHTML = html;

	
	var legs = document.getElementsByTagName("caption");

	var leg;
	for(var index = 1; index < (n + 1); index++)
	{	
		leg = legs[index-1];
		leg.innerHTML = leg.innerHTML.concat(index.toString());
	}
}


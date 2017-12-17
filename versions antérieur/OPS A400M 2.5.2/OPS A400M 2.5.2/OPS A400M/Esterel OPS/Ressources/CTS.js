function remplir (AC, captain, callsign, date, atd, logbook, engine1, engine2, engine3, engine4, timeGO, timeRe, timeDs, n)
{
	
	var lines = ['11','12','21','22','23','24','25','26a','26b', '3'];
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
			if(lineNumber != 0 and lineNumber != 5 and lineNumber != 9)
			{
				document.getElementsByClassName(lines[line])[4*n].innerHTML = engine1[lineNumber].toString();
			}
            else if(lineNumber == 0)
            {
                document.getElementsByClassName(lines[line])[4*n].innerHTML = engine1[lineNumber][0].toString().concat('  '.concat(engine1[lineNumber][1].toString()));
            }
            else if(lineNumber == 5)
            {
                document.getElementsByClassName(lines[line])[4*n].innerHTML = engine1[lineNumber][0].toString().concat('  '.concat(engine1[lineNumber][1].toString()));
            }
            else
            {
                document.getElementsByClassName(lines[line])[4*n].innerHTML = engine1[lineNumber].toString();
            }
			lineNumber++;
		}
		
		lineNumber = 0;
		
		for(line in lines)
		{
			if(lineNumber != 0 and lineNumber != 5 and lineNumber != 9)
			{
				document.getElementsByClassName(lines[line])[4*n+1].innerHTML = engine2[lineNumber].toString();
			}
			else if(lineNumber == 0)
			{
				document.getElementsByClassName(lines[line])[4*n+1].innerHTML = engine2[lineNumber][0].toString().concat('  '.concat(engine2[lineNumber][1].toString()));
			}
            else if(lineNumber == 5)
            {
                document.getElementsByClassName(lines[line])[4*n+1].innerHTML = engine2[lineNumber][0].toString().concat('  '.concat(engine2[lineNumber][1].toString()));
            }
            else
            {
                document.getElementsByClassName(lines[line])[4*n+1].innerHTML = engine2[lineNumber].toString();
            }
			lineNumber++;
		}
		
		lineNumber = 0;
		
		for(line in lines)
		{
			if(lineNumber != 0 and lineNumber != 5 and lineNumber != 9)
			{
				document.getElementsByClassName(lines[line])[4*n+2].innerHTML = engine3[lineNumber].toString();
			}
            else if(lineNumber == 0)
            {
                document.getElementsByClassName(lines[line])[4*n+2].innerHTML = engine3[lineNumber][0].toString().concat('  '.concat(engine3[lineNumber][1].toString()));
            }
            else if(lineNumber == 5)
            {
                document.getElementsByClassName(lines[line])[4*n+2].innerHTML = engine3[lineNumber][0].toString().concat('  '.concat(engine3[lineNumber][1].toString()));
            }
            else
            {
                document.getElementsByClassName(lines[line])[4*n+2].innerHTML = engine3[lineNumber].toString();
            }
			lineNumber++;
		}
		
		lineNumber = 0;
		
		for(line in lines)
		{
			if(lineNumber != 0 and lineNumber != 5 and lineNumber != 9)
			{
				document.getElementsByClassName(lines[line])[4*n+3].innerHTML = engine4[lineNumber].toString();
			}
            else if(lineNumber == 0)
            {
                document.getElementsByClassName(lines[line])[4*n+3].innerHTML = engine4[lineNumber][0].toString().concat('  '.concat(engine4[lineNumber][1].toString()));
            }
            else if(lineNumber == 5)
            {
                document.getElementsByClassName(lines[line])[4*n+3].innerHTML = engine4[lineNumber][0].toString().concat('  '.concat(engine4[lineNumber][1].toString()));
            }
            else
            {
                document.getElementsByClassName(lines[line])[4*n+3].innerHTML = engine4[lineNumber].toString();
            }
			lineNumber++;
		}
}

function setLegConfig(conf)
{
	var n = 0;
    var num = 0;
	for(num in conf)
	{
		n = n + conf[num];
	}
	var grid = document.getElementsByTagName('body')[0].innerHTML;
	var html = grid;
	for(var i = 0; i<n; i++)
	{
		html = html.concat(grid);
	}
	document.getElementsByTagName('body')[0].innerHTML = html;

	
	var caps = document.getElementsByTagName("caption");

	var cap;
	var legIndex = 1;
	var i;
	for(legIndex = 1; legIndex < conf.count() + 1; legIndex++)
	{	
		for(i = 1; i<= conf[legIndex]; i++)
		{
			cap = caps[index-1];
			cap.innerHTML = cap.innerHTML.concat(i.toString().concat(' FOR LEG ').concat(legIndex.toString()));
		}

	}
}


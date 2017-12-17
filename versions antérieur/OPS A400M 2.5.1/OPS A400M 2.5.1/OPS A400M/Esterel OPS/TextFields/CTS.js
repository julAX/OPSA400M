function setLegConfig(conf)
{
	var n = 0;
	var num;
	
	for(num in conf)
	{
		n = n + conf[num];
	}
	var grid = document.getElementsByTagName('body')[0].innerHTML;
	var html = grid;
	for(var i = 1; i<n; i++)
	{
		html = html.concat(grid);
	}
	document.getElementsByTagName('body')[0].innerHTML = html;
	
	
	var caps = document.getElementsByTagName("caption");
	
	var cap;
	var legIndex = 1;
	var i;
	var index = 0;
	for(legIndex = 1; legIndex < conf.length + 1; legIndex++)
	{
		for(i = 1; i<= conf[legIndex - 1]; i++)
		{
			cap = caps[index];
			cap.innerHTML = cap.innerHTML.concat(i.toString(), ' FOR LEG ', legIndex.toString());
			index++;
		}
		
	}
}


function remplir (AC, captain, callsign, date, atd, logbook, engine1, engine2, engine3, engine4, n)
{
	
	var lines = ['11','12','21','22','23','24','25','26a','26b','3'];
	var line, content="", engine, engineNumber;
	
	document.getElementsByClassName('ACNumber')[n].innerHTML = AC;
	document.getElementsByClassName('captain')[n].innerHTML = captain;
	document.getElementsByClassName('callsign')[n].innerHTML = callsign;
	document.getElementsByClassName('logbook')[n].innerHTML = logbook;
	document.getElementsByClassName('opsDate')[n].innerHTML = date;
	document.getElementsByClassName('ATD')[n].innerHTML = atd;
	

	for(line = 0; line < 10; line++)
	{
		for(engineNumber = 0; engineNumber < 4; engineNumber++)
		{
			content = "document.getElementsByClassName(lines[line])";
			engine = "engine".concat(engineNumber + 1);
			content = content.concat("[4*n + ", engineNumber.toString(), "].innerHTML = ", engine, "[line]");
			if (line == 0 || line == 5)
			{
				content = content.concat("[0].toString().concat(' / ', ", engine, "[line][1].toString())");
			}
			else
			{
				content = content.concat(".toString();");
			}
            
			eval(content);
		}
	}
}
/* DOC : 
setLegConfig([NbCTSLeg1, NbCTSLeg2, ...]);
function remplir (AC, captain, callsign, date, atd, logbook, engine1, engine2, engine3, engine4, n)
AC, captain, callsign, date, atd, logbook sont deas string.
engine1,2,3,4 au format [[Grond ops, time], 1.2, 2.1, 2.2, 2.3, [relight, time], 2.5, 2.6a, 2.6b, desert Time].
n est le numéro independant de la leg (à partir de 0) de la cts que tu remplit.
*/
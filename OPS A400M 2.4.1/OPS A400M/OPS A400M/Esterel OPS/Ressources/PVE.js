function setCaption(mission, PCB)
{
	document.getElementById('caption').innerHTML = 'Mission : '.concat(mission.concat('<br><br>PCB : '.concat(PCB)));
}

function addLeg(n)
{
	var html = document.getElementsByTagName('body')[0].innerHTML;
	html = html.concat('<h2>Leg '.concat(n.concat('</h2>')));
	document.getElementsByTagName('body')[0].innerHTML = html;
}

function addMessages(n)
{
	var bun, mes, blok, cite, rep;
	var i;
	for(i = 0; i < n; i++)
	{
		bun = document.createElement("div");
		bun.className = "bundle";
		mes = document.createElement("pre");
		mes.className = "mes";
		blok = document.createElement("blockquote");
		cite = document.createElement("cite");
		cite.innerHTML = "Réponse : ";
		rep = document.createElement("p");
		rep.className = "rep";
		blok.appendChild(cite);
		blok.appendChild(rep);
		bun.appendChild(mes);
		bun.appendChild(blok);
		document.getElementsByTagName('body')[0].appendChild(bun);
	}
}

function fillMessages(messages, reponses)
{
	var mess = document.getElementsByClassName("mes");
	var reps = document.getElementsByClassName("rep");
	var i = 0;
	var u;
	for(u in messages)
	{
		mess[i].innerHTML = messages[i];
		reps[i].innerHTML = reponses[i];
		i++;
	}
}

var l = 1;

function setCaption(mission, PCB, date, ctm, route, reseau)
{
    var html;
    html = '<div id="left">Mission : '.concat(mission, '<br><br>PCB : ', PCB, '<br><br>date : ', date, '</div><div id="right">', ctm, '<br><br>', route, '<br><br>Réseau : ', reseau);
    document.getElementById('caption').innerHTML = html;
}

function addLeg()
{
	var html = document.getElementsByTagName('body')[0].innerHTML;
	html = html.concat('<h2>Leg ', l, '</h2>');
	document.getElementsByTagName('body')[0].innerHTML = html;
    l = l + 1;
}

function addMessages(n)
{
	var bun, mes, blok, cite, rep;
	var i;
	for(i = 0; i < n; i = i + 1)
	{
		bun = document.createElement("div");
		bun.className = "bundle";
		mes = document.createElement("p");
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
		i = i + 1;
	}
}

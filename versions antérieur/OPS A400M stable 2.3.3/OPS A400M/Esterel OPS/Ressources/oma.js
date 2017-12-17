function addMissionNumber(ms)
{
    var msLine = document.getElementById("MissionNumber");
    msLine.innerHTML = "Mission n °: " + ms ;
}
function addUnit(un)
{
    var unLine = document.getElementById("Unit");
    unLine.innerHTML = "Unit : " + un;
}

//Ajouter les commentaires sur la mission
function addComments(com, number) {
    var elCom = document.getElementById("Comment")
    var comLine = document.createElement("h");
    comLine.innerHTML = "Comment n°" + number + " : <BR>" + com + "<BR>";
    elCom.appendChild(comLine);
}

function addCDB(monText) {
    var elCase = document.getElementById("cdbName");
    elCase.innerHTML = monText;
}

//Permet d'ajouter les destinations, reçoit un tableau d'escales
function addGridOneHead(dest)
{
    var elGOHead = document.createElement("table");
    var elGridOne = document.getElementById("GridOne");
    var elTB = document.createElement("thead");
    var elP1 = document.getElementById("P1");
    var elCase = new Array();
    
    elGOHead.id = "GridOneStops";
    elGOHead.className="matable";
    //elP1.appendChild(elGOHead);
    elP1.insertBefore(elGOHead, elGridOne);
    elGOHead.appendChild(elTB);
    for(i=0;i<dest.length; i++)
    {
        elCase[i] = document.createElement("th");
        elCase[i].className = "GOSCell"
        elCase[i].innerHTML = dest[i];
        elTB.appendChild(elCase[i]);
    }
}
//permet de créer une nouvelle colonne de legs
//reçoit le numéro de la ligne, le nombre de legs numLeg
function addGridOneLegs(numLEG){
    var elGridOne = document.getElementById("THGridOne");
    //Tableau contenant les cases de la ligne
    var elCase = new Array();
    //Création de la nouvelle ligne
    newLine = document.createElement("tr");
    newLine.className="HeaderGridOne";
    elGridOne.appendChild(newLine);
    
    elCase[0]=document.createElement("th");
    elCase[0].className = "GridOneLeg";
    elCase[0].id = "GridOneNom";
    elCase[0].innerHTML="Name";
    newLine.appendChild(elCase[0]);
    
    for(var i=1;i<=numLEG; i++)
    {
        elCase[i] = document.createElement("th");
        elCase[i].className = "GridOneLeg"
        elCase[i].innerHTML = "Leg " + i ;
        newLine.appendChild(elCase[i]);
    }
    
}



//Ajoute une ligne (c.-à-d. un membre d'équipage) au tableau
function addLineGridOne(monText, maCouleur)
{
    var i;
    var elGridOne = document.getElementById("TBGridOne");
    //à virer peut être
    var newLine = null;
    //Tableau contenant les cases de la ligne
    var elCase = new Array();
    //Création de la nouvelle ligne
    newLine = document.createElement("tr");
    newLine.style.cssText = "color:#" + maCouleur +";";
    //window.alert(newLine.id);
    elGridOne.appendChild(newLine);
    //Création des cases
    for(i=0;i<monText.length; i++)
    {
        elCase[i] = document.createElement("td");
        elCase[i].innerHTML = monText[i];
        
        if(i==0)
            elCase[i].className = "GridOneNameCell";
        else
            elCase[i].className = "GridOneCell";
        
        newLine.appendChild(elCase[i]);
    }
}
//Pour compter les legs (permet par exemple de leur associer un attribut css selon que ce soit un leg pair ou impair)
var k=0;
//compteur de ligne
var j=1;

function addLine1GridTwo(monText)
{
    var i;
    var elTB = document.getElementById("TBGridTwo");
    //ligne du tableau à remplir
    var newLine = (j==1)? elTB.getElementsByTagName("tr")[0] : elTB.getElementsByTagName("tr")[0].cloneNode(true);
    newLine.className = (k%2==0) ? "greyLine" : "whiteLine";
    //Tableau contenant les cases de la ligne
    var elCase = new Array();
    if(j!=1)
        elTB.appendChild(newLine);
    //Création des cases
    for(i=0;i<monText.length; i++)
    {
        
        if(monText[i]=="00:00")
            monText[i]="  ";
        //alert(monText[i]);
        
        elCase[i] = newLine.getElementsByTagName("td")[i];
        elCase[i].innerHTML = monText[i];
        
    }
    j++;
}
function addLine2GridTwo(monText)
{
    var i;
    var elTB = document.getElementById("TBGridTwo");
    //ligne du tableau à remplir
    var newLine = (j==2)? elTB.getElementsByTagName("tr")[1] : elTB.getElementsByTagName("tr")[1].cloneNode(true);
    newLine.className = (k%2==0) ? "greyLine" : "whiteLine";
    //Tableau contenant les cases de la ligne
    var elCase = new Array();
    if(j!=1)
        elTB.appendChild(newLine);
    //Création des cases
    for(i=0;i<monText.length; i++)
    {
        if(monText[i]=="00:00")
            monText[i]="  ";
        
        elCase[i] = newLine.getElementsByTagName("td")[i];
        elCase[i].innerHTML = monText[i];
        
    }
    j++;
    k++;
}

//********************* Ajout ligne aux dérogations **********************//

function addGridThree()
{
    /*changer P3 en Titre*/
    var div = document.getElementById("PP");
    
    /*var div = document.createElement("div");*/
    
    var table = document.createElement("table");
    table.id = "GridThree";
    table.className = "matable";
    
    var thead = document.createElement("thead");
    thead.id = "THGridThree";
    
    var tbody = document.createElement("tbody");
    tbody.id = "TBGridThree";
    
    table.appendChild(thead);
    table.appendChild(tbody);
    /*div.appendChild(table);*/
    div.appendChild(table);
}

function addHeaderGridThree()
{
    var i;
    var elTB = document.getElementById("THGridThree");
    //ligne titre
    var newLine = document.createElement("tr");
    newLine.id="GridThreeTitle";
    elTB.appendChild(newLine);
    //Titre
    var title = document.createElement("th");
    newLine.appendChild(title);
    title.innerHTML="WAIVERS";
    title.colSpan="4";
    //ligne en-têtes colonnes
    var newLine = document.createElement("tr");
    elTB.appendChild(newLine);
    var elCase = new Array();
    //Création des cases
    for(i=0;i<4; i++)
    {
        elCase[i] = document.createElement("th");
        newLine.appendChild(elCase[i]);
    }
    elCase[0].innerHTML="Nature";
    elCase[1].innerHTML="Comments";
    elCase[2].innerHTML="Number";
    elCase[3].innerHTML="Commander";
}


function addLineGridThree(monText)
{
    var i;
    var elTB = document.getElementById("TBGridThree");
    //ligne du tableau à remplir
    var newLine = document.createElement("tr");
    elTB.appendChild(newLine);
    //Tableau contenant les cases de la ligne
    var elCase = new Array();
    //Création des cases
    for(i=0;i<monText.length; i++)
    {
        elCase[i] = document.createElement("td");
        elCase[i].innerHTML = monText[i];
        newLine.appendChild(elCase[i]);
    }
}

function addLineExploitation(monText)
{
    var i;
    var elTB = document.getElementById("TBExploit");
    //ligne du tableau à remplir
    var newLine = document.createElement("tr");
    elTB.appendChild(newLine);
    //Tableau contenant les cases de la ligne
    var elCase = new Array();
    //Création des cases
    for(i=0;i<monText.length; i++)
    {
        elCase[i] = document.createElement("td");
        elCase[i].innerHTML = monText[i];
        newLine.appendChild(elCase[i]);
    }
}

function addTotalHours(monText)
{
    var i;
    var elTB = document.getElementById("TBTotalHours");
    //ligne du tableau à remplir
    var newLine = document.createElement("tr");
    elTB.appendChild(newLine);
    //Tableau contenant les cases de la ligne
    var elCase = new Array();
    //Création des cases
    for(i=0;i<monText.length; i++)
    {
        elCase[i] = document.createElement("td");
        elCase[i].innerHTML = monText[i];
        newLine.appendChild(elCase[i]);
    }
    
}

function test(){
    var elGridTwo = document.getElementById("GridTwo");
    var elTB = document.getElementById("TBGridTwo");
    d = (j==1)? elTB.getElementsByTagName("tr")[0] : elTB.getElementsByTagName("tr")[0].cloneNode(true);
    e = (j==1)? elTB.getElementsByTagName("tr")[1] : elTB.getElementsByTagName("tr")[1].cloneNode(true);
    f = (j==1)? "g" : "a";
    alert(f);
    document.getElementById("TBGridTwo").appendChild(d);
    document.getElementById("TBGridTwo").appendChild(e);
    j++;
    // var madiv = document.getElementById("P2");
    //madiv.appendChild(c);
}

//pour tester les foncitons
//window.onload = function test(){getValue();};

function addRefEntHeader(monText) {
    var elRefEntHeader = document.getElementById("THRefEnt");
    var elCase = new Array();
    
    elCase[0] = document.createElement("td");
    elCase[0].id = "Crew";
    elCase[0].innerHTML = monText[0];
    elRefEntHeader.appendChild(elCase[0]);
    
    var i;
  for(i=1; i<=42; i++) {
        var elRefEntBody = document.getElementById("RefEntSection" + i);
        
        elCase[i] = document.createElement("td");
        elCase[i].innerHTML = monText[i];
        elRefEntBody.appendChild(elCase[i]);
    }
}


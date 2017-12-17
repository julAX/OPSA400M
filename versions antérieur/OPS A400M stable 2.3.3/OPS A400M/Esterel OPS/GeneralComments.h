//
//  GeneralComments.h
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 17/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#ifndef GeneralComments_h
#define GeneralComments_h


//////////////////////////////////////////////////// A lire / Read me ///////////////////////////////////////////////////////////////

/*

Bonjour à toi, codeur ou curieux, et laisse moi te souhaiter d'abord beaucoup de courage si tu souhaites penetrer ce code, démuni de formation.
 
POUR LA SIMPLE MAINTENANCE / FOR SIMPLE MAINTENANCE :
 
    Les listes et quelques parametres simples se trouvent dans le fichier Parameters.h, sous GeneralComments.h (dans lequel nous sommes). En les modifiants, et en regenerant l'application, les modifications se repercuterons automatiquement dans l'appli (c'est génial hein?).
    
    Some general paramters and lists are declared in Parameters.h just below GeneralComments.h. Modifying them will repercutate on the application when reloaded on the device.
 
 
 
POUR DE LA VRAI MISE A JOUR OU MODIFICATION DE L'APPLICATION / FOR REAL MODIFICATION OR UPDATE :
 
    Bonne chance.
    A moins d'avoir beaucoup de temps et un bon feeling avec la programmation, c'est pas une bonne idée ( parole de deux X sans formations qui ont passé deux à trois semaines juste pour commencer à reprendre l'appli, et qui ont rajoutés depuis le double en contenu.... ). Il faut vraiment se plonger dedans à fond et comprendre comment ça marche avant de se lancer tête baissée. 
    Un bon site internet pour comprendre et poser des questions c'est stackoverflow.com !! Le forum est plein de toutes les questions que tu va te poser.
 
--> COMMENTAIRES GENERAUX:
    Le code en entier est en Objective C, pas en swift, et n'utilise pas de fichiers .xib, mais les nouveaux fichiers .storyboard (.xib c'est outdated)
 
    Le code prend globalament cette structure : l'application s'ouvre sur un storyBoard (le ChooseFile.storyboard), puis dès qu'une mission est chargée, on passe sur le main.storyboard, dans lequel il y a globalament toute l'application. Ne pas trop toucher à ce qui est existant (au pire il suffit de detruire des liens (segues ou dans le code) pour ne plus acceder à une vue indesirable), surtout le lien entre le chooseFile.storyboard et le main.storyboard. (A part si tu es déjà expert).
 
    Quasiment chaque view controller est un object d'une classe crée dans l'application, qui hérite de la bonne classe (en général le nom est explicite : ex CTSTableViewController est une classe d'object qui hérite de UITableViewController). Pour ajouter des objects (genre label, textfield etc...) bien regarder des tutos (openclassroom etc... font ca bien)


 !!!!!!!!!!!!!!!!!!!!
 
 --> Bien revoir (ou voir) la notion d'object et comprendre que une classe, c'est deux fichiers : le fichier.h (header) et le fichier.m (main) . Le header permet d'importer les autres classes à utiliser, de declarer les attributes, les méthodes de classe et d'instance. Le main permet d'implementer ces fonction etc...

 !!!!!!!!!!!!!!!!!!!!

 
--> OUVERUTRE ET SAUVEGARDE:
    L'ensemble de la mission est stockée dans un object Mission, dans lequel l'attribut root est un dictionnaire contenant toutes (ou presque) les infos. Pour en voir la structure, allez voir le fichier MissionVierge.plist situé dans l'onglet Ressource du projet. C'est dedans qu'il faut ajouter en premier des choses lorsque vous souhaitez faire des ajouts d'informations. Regardez bien le Mission.m, dans lequel les méthodes - init , - initWithFile et - save gèrent les ouvertures et sauvegardes des fichiers de missions.

    Pour ouvrir une première fois la mission avec la structure de base remplie, il faut envoyer par mail le plan de charge en format XML (voir le tuto en powerpoint). A la prmeiere ouverture, le fichier est un vrai xml, il est ouvert avec la methode de Mission -loadOldVersion , puis une fois qu'il est sauvgardé (dans le repertoire alloué à l'application) le type de fichier change car on l'enregistre comme des bourins en un fichier binaire qui a toujours une extension xml mais qui n'en contient pas. Faut pas trop cherhcer à comprendre mais ca marche! Attention, on ne peut enregistrer que des objects classiques qui sont ceux proposées dans le missionvierge.plist. On ne peut pas sauvergarder des objects crées par nous. nous transformons nos objects Cargos en dico avant de les enregistrer, puis les recréons à l'ouverture avec le contenu des dicos.
 
 
--> HISTORIQUE : 
    L'application a été créée à l'Esterel il y a de cela des années par d'antiques X. Elle à été rapidement reprise et mise au gout de l'A400M en 2014-2015 par deux rouges, puis est tombée entre nos jeunes mains de Jône (traduction si tu n'es pas un camarade : rouge = polytechnitien de 2014 (entre autres) et jône = polytechnitien de 2015 (entre autres)). Nous y avons fait de majeurs changement d'interface pour la rendre utilisable facilement et la rendre fiable (elle n'était ni l'un ni l'autre), le but principal étant de faire les OMA sur l'iPad et non en papier. Elle ne faisait pas non plus les crew tick sheets et le partage par bluetooth. Nos ajouts se trouvent dans Ajout X2015 en majoritée, mais l'experience et la connaissance de l'application venant, nous avons aussi modifiés les fichiers d'avant, car on n'y a été forcé. C'est pas dur en soit mais faut faire gaffe à pas tout detruire en enlevant une ligne cruciale (faire des tests très très souvent pour reperer la source des erreurs). Visuellement, notre ajout c'est le bouton "Fill Out the OMA" et tout ce qui suit, ainsi que tout ce qui concerne le Crew tick sheet et le bouton "Cargo Overview". Les boutons "block : depp/arr", "load", et "Crew" sont les anciennes pages, vétustes et ne servant plus que de consultation.
 

--> CONSEILS :
    Encore une fois, aidez vous des tutos (quitte à faire comme nous un mini projet de tuto avant de se lancer dans notre appli) et des forums. La doc Apple est aussi très utile car en cliquant sur un object, une méthode, dans l'onglet à droite de Xcode, sous le ? on peut acceder direct à la doc correspondante.
    J'ai essayé de commenter le plus possible le code en lui-même , même si comme on l'a pas fait au fûr et à mesure c'est surement pas complet et exhaustif. Enfin soit heureux, nous on a recuperé un code avec 10 lignes de commentaire en tout et pour tout! De maniere générale j'essaye de mettre les commentaires au début du .m et dans les méthodes.
 
    Essayer de bien connaitre et comprendre le principe des delegates, sans quoi peut de choses marchent, même quand tout est bien codé, si il manque un "mission.delegate = self;" dans le viewDidLoad d'un viewController, les changements de legs interactifs ne marchent pas. N'hésitez pas à regarder comment c'est fait dans les autres viewController et pomper allegrement des bouts de codes entiers.
 
    NE PAS TOUCHER AU DEUXIEME DOSSIER Esterel OPS : on sait pas pourquoi ils avait fait ça mais ya des problemes de reference si on l'enlève (si vous êtes bon allez y mais ca marche bien comme ca)
 
 
--> LES CLASSES IMPORTANTES : 
    --> Mission : bien sur elle contient tout, est utilisée dans toutes les autres classes ou presque. Ne pas hésiter à aller voir tout le temps comment elle est gérée.
    
    --> Cargo : un de nos ajouts. Une instance de Cargo représente soit une pallete, soit un groupe de pax, soit du vrac. Bien regarder ses attributs et méthodes pour comprendre comment elle marche : normalement toutes les informations nécéssaires y sont! Elle gère tout comme il faut : ajout d'un cargo, suppression, et mise en forme dans le reste de l'application.
        Detail Important, il existait avant une mise en forme du paxCargo, sous forme de dico dans chaque leg (voir le MissionVierge.plist). Mais c'était très chiant à gerer. Donc on ne l'utilise que pour remplir l'OMA (méthode qui est integralement faite par les X2014) Cargo est donc juste une surcouche, mais c'est avec elle qu'il faut travailler.

    --> PaveNumViewController : la classe des controllers avec le pavé nuimérique fait à la main. Aucun clavier de base apple de proposant ce pavé numérique, on l'a recreer de toute piece. Chaque instance à un tag unique (1000, 2001, 2002, 4004, 6001 etc... voir les commentaires dans la classe) et ces boutons ont le meme tag, et sont relié à la meme action qui utilise un switch sur les tags. Pour l'utiliser, il suffit de copier coller, de changer tous les tags, de relier le label et de rajouter le bon case dans les switchs. 
 
 
 
 
 
 
*/

#endif /* GeneralComments_h */

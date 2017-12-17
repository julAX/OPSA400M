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





/////////////////////////////////////   A FAIRE   //////////////////////////////////////////////


/*
Mettre les listes suceptibles de changer dans Paramaters.h pour modifications possibles au fil des ans (ex: liste des PN, liste des postes, des types d'entrainements etc...)
*/

/*
 Revoir contexture PVE
 --> choix EATC, CNOA
 
 Enlever tous les NSlog
 
 */



//////////////////////////////////////    FAIT   ////////////////////////////////////////////////

// permettre de mettre litre ou kg pour le fuel avec densité (mettre dans parametre la densité par defaut)


/* Changement dans le choix des coefs pour empecher les erreurs: j'ai enlevé les switch et j'ai mis des boutons qui changent de couleur à la place.
*/

/*
 Rajouter une ligne pour les perfos aéroport de départ, à aller chercher en PDF. --> impossible pour l'instant
 */

/*
Finir le Freight : Rajouter la demande de poids
*/


//SI le une heure de départ ou d'arrivé change au lendemain par rapport a l'heure prévu, faut rajouter un jour a la date  !!!! Faire gaffe!!!


///rajouter le popup pour les codes benefs.



/* dans BlocksViewController :
 Rendre la priorité au calcul de onBlocksTime et non de BetweenBlocksTime: il faut que l'heure d'arrivé soit modifié et non le temps de vol lorsqu'on change l'heure de départ.
 */

#endif /* GeneralComments_h */

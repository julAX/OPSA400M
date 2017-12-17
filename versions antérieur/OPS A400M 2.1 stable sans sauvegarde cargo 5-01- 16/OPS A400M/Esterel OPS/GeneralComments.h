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


/*

 
 Revoir la logique des depart avant arrivé dans Cargo!!!!
 
 
 //
 
 SI le une heure de départ ou d'arrivé change au lendemain par rapport a l'heure prévu, faut rajouter un jour a la date  !!!! Faire gaffe!!!
 
 */


/////////////////////////////////////   A FAIRE   //////////////////////////////////////////////

/*
 Reprendre a Cargo.m avec la derniere fonction : enterCargoInOMA : bug sur l'ajout du dictionnaire newPaxCargo à l'array PaxCargo et changer l'afichage initial.
*/


/*
 Finir le Freight :  afficher dans la page principale le pax déjà présent. Renover la page de fret déjà existante et faire le lien entre neuf et ancien, et bien sur verifier le bon repport dans l'OMA.
*/

/*
Mettre les listes suceptibles de changer dans Paramters.h pour modifications possibles au fil des ans (ex: liste des PN, liste des postes, des types d'entrainements etc...)
*/



//////////////////////////////////////    FAIT   ////////////////////////////////////////////////

/* Changement dans le choix des coefs pour empecher les erreurs: j'ai enlevé les switch et j'ai mis des boutons qui changent de couleur à la place.
*/

/*
 Rajouter une ligne pour les perfos aéroport de départ, à aller chercher en PDF. --> impossible pour l'instant
 */

/*
Finir le Freight : Rajouter la demande de poids
*/

/* dans BlocksViewController :
 Rendre la priorité au calcul de onBlocksTime et non de BetweenBlocksTime: il faut que l'heure d'arrivé soit modifié et non le temps de vol lorsqu'on change l'heure de départ.
 */

#endif /* GeneralComments_h */

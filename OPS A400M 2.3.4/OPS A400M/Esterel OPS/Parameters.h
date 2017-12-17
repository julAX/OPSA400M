//
//  Parameters.h
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#ifndef Parameters_h
#define Parameters_h


/*
 READ ME / LISEZ MOI : 
 
 Please feel free to modify the following parameters. It will impact on the app. BUT be careful to respect the format (an extra space might be harmful)
 
 Vous pouvez modifier les parametres suivant au besoin, mais ATTENTION à respecter la mise en forme des données (un espace en trop peut poser problème)
 
 */


//To set the generic weight of a PAX (poids moyen du PAX)
#define defaultPaxWeight 89

//To set the average density of fuel (densité par default du pétrole)

#define d 0.785

//Different lists to be updated

#define escadronList @[@"TOURAINE 1/61",@"CIET 340",@"EMATT 01.338"]


#define immatriculationsList @[@"FRB-AA",@"FRB-AB",@"FRB-AC",@"FRB-AD",@"FRB-AE",@"FRB-AF",@"FRB-AG",@"FRB-AH",@"FRB-AI",@"FRB-AJ"]


#define flightsRules @"E",@"I",@"A",@"O",@"V",@"Y",@"Z"


#define naList @"22",@"25",@"35",@"40",@"50",@"51",@"65",@"62"


#define beList @"W1",@"WY",@"AK",@"AZ",@"B4",@"BD",@"M6",@"M5",@"Y1",@"AX",@"AR",@"B9",@"D3",@"AC"


#define typeOfFlightList @"D",@"M",@"V",@"T",@"I",@"X"


#define secopsMailList @[@"tony.fricard@intradef.gouv.fr",@"alexandra.guein@intradef.gouv.fr"]

#define CTSMailList @[@"wulfran.besnehard@intradef.gouv.fr",@"herve.cherbonnel@intradef.gouv.fr",@"olivier.lauzur@intradef.gouv.fr",@"laurent.marques-da-silva@intradef.gouv.fr",@"julien.metro@intradef.gouv.fr",@"cedric.thirion@intradef.gouv.fr",@"teddy.turby@intradef.gouv.fr"]

#define secopsIpadMailList @[]

// Sont déprécié car non utilisées dans les dernieres versions...

#define feedbackMailList @[@"cedric.segard@intradef.gouv.fr",@"sebastien.wijas@intradef.gouv.fr",@"raphaelle.aucourt@intradef.gouv.fr",@"matthieu.kudela@intradef.gouv.fr",@"jerome.evrard@intradef.gouv.fr",@"guillaume.henneguez@intradef.gouv.fr"]

#define commentsMailList @[@"david-s.richard@intradef.gouv.fr"]



#endif /* Parameters_h */

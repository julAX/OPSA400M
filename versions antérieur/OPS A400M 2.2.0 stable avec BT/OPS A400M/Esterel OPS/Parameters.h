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




//To activate the option of delivered and received fuel during flight (change NO to YES):
#define useReceivedAndDelivered YES


//To set the generic weight of a PAX (poids moyen du PAX)
#define paxWeight 89


//Different lists to be updated

#define escadronList @[@"TOURAINE 1/61",@"CIET 340",@"EMATT 01.338"]


#define immatriculationsList @[@"FRB-AA",@"FRB-AB",@"FRB-AC",@"FRB-AD",@"FRB-AE",@"FRB-AF",@"FRB-AG",@"FRB-AH",@"FRB-AI",@"FRB-AJ"]


#define flightsRules @"E",@"I",@"A",@"O",@"V",@"Y",@"Z"


#define naList @"22",@"25",@"35",@"40",@"50",@"51",@"65",@"62"


#define beList @"W1",@"WY",@"AK",@"AZ",@"B4",@"BD",@"M6",@"M5",@"Y1",@"AX",@"AR",@"B9",@"D3",@"AC"


#define typeOfFlightList @"D",@"M",@"V",@"T",@"I",@"X"



#endif /* Parameters_h */

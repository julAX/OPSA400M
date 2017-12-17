//
//  Parameters.h
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0652423267
//  louis.david@polytechnique.edu
//
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>


#ifndef Parameters_h
#define Parameters_h


/*
 READ ME / LISEZ MOI : 
 
 Please feel free to modify the following parameters. It will impact on the app. BUT be careful to respect the format 
 
 Vous pouvez modifier les parametres suivant au besoin, mais ATTENTION à respecter la mise en forme des données
 
 */


//To set the generic weight of a PAX (poids moyen du PAX)
#define defaultPaxWeight 89

//To set the average density of fuel (densité par default du pétrole)

#define d 0.785

//Different lists to be updated

#define escadronList @[@"ET 1/61 TOURAINE",@"CIET 340",@"EMATT 01.338"]


#define immatriculationsList @[@"FRBAA-MSN07",@"FRBAB-MSN08",@"FRBAC-MSN10",@"FRBAD-MSN11",@"FRBAE-MSN12",@"FRBAF-MSN14",@"FRBAG-MSN19",@"FRBAH-MSN31",@"FRBAI-MSN33"]


#define flightsRules @"E",@"I",@"A",@"O",@"V",@"Y",@"Z"


#define naList @"22",@"25",@"35",@"40",@"50",@"51",@"65",@"62"


#define beList @"AC",@"AK",@"AR",@"AX",@"AZ",@"B4",@"B9",@"BD",@"D3",@"M5",@"M6"@"W1",@"WY",@"Y1"

#define typeOfFlightList @"D",@"M",@"V",@"T",@"I",@"X"

#define defaultReseau @"RSAO 2"

#define reseauList @[@"RSAO 2",@"RSAO 2/4", @"RSAO 4"]

#define secopsMailList @[@"tony.fricard@intradef.gouv.fr",@"alexandra.gein@intradef.gouv.fr"]

#define CTSMailList @[@"wulfran.besnehard@intradef.gouv.fr",@"herve.cherbonnel@intradef.gouv.fr",@"olivier.lauzur@intradef.gouv.fr",@"laurent.marques-da-silva@intradef.gouv.fr",@"julien.metro@intradef.gouv.fr",@"cedric.thirion@intradef.gouv.fr",@"teddy.turby@intradef.gouv.fr"]

#define secopsIpadMailList @[]

#define feedbackMailList @[@"cedric.segard@intradef.gouv.fr",@"sebastien.wijas@intradef.gouv.fr",@"raphaelle.aucourt@intradef.gouv.fr",@"matthieu.kudela@intradef.gouv.fr",@"guillaume.henneguez@intradef.gouv.fr"]

// Sont déprécié car non utilisées dans les dernieres versions...

#define commentsMailList @[@"david-s.richard@intradef.gouv.fr"]

/// Palette de couleurs

#define mightySlate [UIColor colorWithRed:0.3333 green:0.3843 blue:0.4392 alpha:1]
#define rouge [UIColor colorWithRed:1 green:0.2216 blue:0.1451 alpha:1]
#define vert [UIColor colorWithRed:0.5059 green:0.7333 blue:0.0196 alpha:1]
#define bleu [UIColor colorWithRed:0.0157 green:0.6471 blue:0.9412 alpha:0.5]
#define jone [UIColor colorWithRed:1.0000 green:0.7333 blue:0.0275 alpha:0.2]
#define jone2 [UIColor colorWithRed:1.0000 green:0.7333 blue:0.0275 alpha:1]
#define orange [UIColor colorWithRed:0.9451 green:0.3922 blue:0.1294 alpha:1]
#define violet [UIColor colorWithRed:0.7069 green:0.0000 blue:0.6196 alpha:1]
#define teal [UIColor colorWithRed:0.0 green:0.5098 blue:0.4431 alpha:0.5]
#define gris [UIColor colorWithRed:0.4941 green:0.4941 blue:0.4941 alpha:1]
#define grisDuFond [UIColor colorWithRed:0.7922 green:0.7922 blue:0.7922 alpha:1]
#define grisTransparent [UIColor colorWithRed:0.7922 green:0.7922 blue:0.7922 alpha:0.3]
#define transparant [UIColor colorWithRed:0.7922 green:0.7922 blue:0.7922 alpha:0]

#define grisFonce [UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1]

#endif /* Parameters_h */

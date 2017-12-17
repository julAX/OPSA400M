//
//  Cargo.h
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SplitViewController.h"
#import "AirportTableViewCell.h"
#import "PaveNumViewController.h"
#import "Mission.h"

/*
 Création X2015: cargo est une classe qui représente les pax, freight et vrac mis dans l'avion
 Elle permet de determiner pour chaque leg le beneficiaire pricipal (be) avec la methode de classe dite "de la plus grosse" (principaleBe).
 pour chaque instance, on stocke les attributs décrits ici.
 
 */

typedef NS_ENUM(NSUInteger, Type){
    pax,
    vrac,
    freight
};

@interface Cargo : NSObject

@property (strong, nonatomic) NSString *departure, *arrival, *be;
@property NSMutableSet *whatLegs;
@property BOOL drop;
@property NSString *weight;
@property Type type;
@property Mission *mission;
@property NSInteger identity;
@property NSMutableArray *numArrnumDep;


- (void) initSetOfLegs;

- (id) initWithMission: (Mission*) mission;
- (id) init;
- (void) destroy;
- (void) setCargoList;


+ (NSString*) principalBe: (NSUInteger) legIndex inMission:(Mission*) mission;
+ (NSMutableDictionary*) reloadBenefListWithMission : (Mission*) mission;
+ (void) reloadPaxCargoWithMission : (Mission*) mission;
+ (void)recalcLoadInMission : (Mission*)mission;


@end





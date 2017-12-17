//
//  PaveNumViewController.h
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewController.h"

#import "Parameters.h"
#import "FullDateTextField.h"
#import "LegDetailViewController.h"
#import "GrosBoutonTableViewController.h"
#import "ChoixCoefViewController.h"
#import "CargoTableViewController.h"

#import "Mission.h"

@interface PaveNumViewController: UIViewController <MissionDelegate>

/*
 ATTENTION: Nomenclature des tags des differentes pages: dans un soucis de regroupement on fait des swicht case avec chaque page qui utilise un pad numérique et des heures.
 
 Departure:
 1001: Pavé heure de départ (OBtime)
 
 Arrival:
 2001: FT
 2002: BT
 2003: Dont nuit
 2004: Dont LLF
 
 2011: 10 de jour
 2012: 10 de nuit
 2013: 10 en LLf
 2021: 62 de jour
 2022: 62 de nuit
 2023: 62 en LLF
 2031: 35 de jour
 2032: 35 de nuit
 2033: 35 en LLF
 
 2005: ATR
 2006: TAG
 2007: RG
 
 6001: BM19 (leg[FuelAdded]
 6002: Numéro de BM19
 6003: At strart Up
 6004: Delivered
 6005: Received
 6006: Final
 
 4002: Cargo Weight
 
 */

@property (strong, nonatomic) IBOutlet UILabel *paveDisplay;
// le paveDipslay correspond au paveDisplay1001 qui n'existe pas (c'est le prmier qu'on a fait avant de decider de mettre les tags précedents

@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2001;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2002;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2003;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2004;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2005;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2006;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2007;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2011;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2012;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2021;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2022;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2031;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay2032;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay6001;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay6002;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay6003;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay6004;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay6005;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay6006;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay4002;
@property (strong, nonatomic) IBOutlet UILabel *paveDisplay4003;


-(void)activeLegDidChange:(NSInteger)leg;
-(void)reloadValues;

- (IBAction)sendNumber:(id)sender;
- (IBAction)clearDisplay:(id)sender;
- (IBAction)backspaceDisplay:(id)sender;
- (IBAction)displaySave:(id)sender;

@end

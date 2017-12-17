//
//  SicopsTableViewController.m
//  Esterel OPS
//
//  Created by utilisateur on 01/04/2014.
//  Copyright (c) 2014 Esterel. All rights reserved.
//

#import "SicopsTableViewController.h"

#import "Mission.h"
#import "SplitViewController.h"
#import "LegsSelectionView.h"
#import "MyTextField.h"

@interface SicopsTableViewController ()

@property (strong, nonatomic) IBOutlet LegsSelectionView *legsSelection;

@property (strong, nonatomic) IBOutlet MyTextField *grade;
@property (strong, nonatomic) IBOutlet MyTextField *nom;
@property (strong, nonatomic) IBOutlet MyTextField *prenom;
@property (strong, nonatomic) IBOutlet MyTextField *nia;

@property (weak, nonatomic) Mission *mission;

@end

@implementation SicopsTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _mission = ((SplitViewController*)self.presentingViewController).mission;
    _legsSelection.mission = self.mission;
}

- (IBAction)valider:(id)sender {
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", _grade.text, _nom.text];
    NSMutableDictionary *crewMember = [_mission getCrewMemberVierge];
    
    crewMember[@"Name"] = name;
    crewMember[@"Function"] = @"SICOPS";
    
    if (![_nom.text isEqualToString:@""]) {
        
        for (NSString *legKey in _legsSelection.selectedLegs)
           [_legsSelection.selectedLegs[legKey][@"CrewMember"] addObject:crewMember];
        
        _mission.root[@"SECOPS"][@"Personnel"][name] = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@\nNIA: %@", name, _prenom.text, _nia.text] forKey:@"Commentaires"];
        
        [[[UIAlertView alloc] initWithTitle:@"Validé" message:@"Opération effectuée!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else
        [[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Vous devez entrer un nom!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

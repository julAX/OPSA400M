//
//  CargoTableViewController.h
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cargo.h"
#import "Mission.h"
#import "SetCargoTableViewController.h"

@interface CargoTableViewController : UITableViewController <MissionDelegate>

- (IBAction)newCargo:(id)sender;

@end

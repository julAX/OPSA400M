//
//  SetCargoTableViewController.h
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
#import "BenefAndDropTableViewCell.h"
#import "EnterWeightTableViewCell.h"

@interface SetCargoTableViewController : UITableViewController <UITextFieldDelegate, UIPopoverControllerDelegate, QuickTextDelegate>

- (IBAction)enterWeightButton:(id)sender;



@end

//
//  BenefAndDropTableViewCell.h
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mission.h"
#import "SplitViewController.h"
#import "Parameters.h"
#import "SetCargoTableViewController.h"


@interface BenefAndDropTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *benefTextField;
@property (strong, nonatomic) IBOutlet UISwitch *dropSwitch;

- (NSString*) getText;
- (BOOL) getSwitch;

@end

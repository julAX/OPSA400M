//
//  CTSTableViewController.h
//  OPS A400M
//
//  Created by richard david on 26/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTSTableViewCell.h"
#import "CTSNumberTableViewCell.h"
#import "Mission.h"
#import "SplitViewController.h"

@interface CTSTableViewController : UITableViewController <MissionDelegate>


- (IBAction)changing:(id)sender;
- (IBAction)numberEntered:(id)sender;


-(void) writeInLeg;
@end

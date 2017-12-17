//
//  CTSTableViewController.h
//  OPS A400M
//
//  Created by richard david on 26/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTSTimeTableViewCell.h"
#import "CTSNumberTableViewCell.h"
#import "Mission.h"
#import "SplitViewController.h"
#import "Parameters.h"
#import "TimeTextField.h"
#import "CTSTimeOnlyCell.h"

@interface CTSTableViewController : UITableViewController <MissionDelegate,UIPopoverControllerDelegate,MyTextFieldDelegate>


- (IBAction)changing:(id)sender;

- (IBAction)logbookChanged:(id)sender;



-(void) writeInLeg;
@end

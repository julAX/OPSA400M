//
//  CTSOverviewController.h
//  OPS A400M
//
//  Created by richard david on 09/03/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mission.h"
#import "SplitViewController.h"


@interface CTSOverviewController : UITableViewController <MissionDelegate>


-(void) addCrewTickSheet;



@end

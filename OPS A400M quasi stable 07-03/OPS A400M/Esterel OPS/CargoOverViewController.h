//
//  CargoOverViewController.h
//  OPS A400M
//
//  Created by richard david on 25/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mission.h"
#import "SplitViewController.h"
#import "CargoOverViewTableViewCell.h"
#import "Cargo.h"

@interface CargoOverViewController : UIViewController <MissionDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *overViewTableView;
@property (strong, nonatomic) IBOutlet UILabel *paxNumber;
@property (strong, nonatomic) IBOutlet UILabel *palletNumber;
@property (strong, nonatomic) IBOutlet UILabel *totalWeight;
@property (strong, nonatomic) IBOutlet UILabel *bulkWeight;

-(void) reloadTotals;

@end

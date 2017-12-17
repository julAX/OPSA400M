//
//  GrosBoutonTableViewController.h
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mission.h"
#import "QuickTextViewController.h"
#import "MyTextField.h"

@interface GrosBoutonTableViewController : UITableViewController <MissionDelegate>

@property (strong, nonatomic) IBOutlet UILabel *Crew;
@property (strong, nonatomic) IBOutlet UILabel *PaxAndFreight;
@property (strong, nonatomic) IBOutlet UILabel *Departure;
@property (strong, nonatomic) IBOutlet UILabel *Arrival;

-(void) coloriage;
-(void) recalcAll;

@end

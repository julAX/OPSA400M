//
//  AirportTableViewCell.h
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mission.h"

@interface AirportTableViewCell : UITableViewCell
@property (strong,readwrite, nonatomic) IBOutlet UIButton *buttonDeparture;
@property (strong,readwrite, nonatomic) IBOutlet UIButton *buttonArrival;



@end

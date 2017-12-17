//
//  CargoOverViewTableViewCell.h
//  OPS A400M
//
//  Created by richard david on 25/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cargo.h"

@interface CargoOverViewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *poids;
@property (strong, nonatomic) IBOutlet UILabel *benef;
@property Cargo *cargo;

@end

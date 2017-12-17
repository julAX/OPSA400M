//
//  CTSTimeOnlyCell.h
//  OPS A400M
//
//  Created by richard david on 11/03/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeTextField.h"

@interface CTSTimeOnlyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet TimeTextField *time1;
@property (strong, nonatomic) IBOutlet TimeTextField *time2;
@property (strong, nonatomic) IBOutlet TimeTextField *time3;
@property (strong, nonatomic) IBOutlet TimeTextField *time4;
@property NSString* legende;
@property (strong, nonatomic) IBOutlet UILabel *lineName;

@end

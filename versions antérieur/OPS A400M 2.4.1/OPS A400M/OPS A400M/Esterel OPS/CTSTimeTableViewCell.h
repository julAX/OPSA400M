//
//  CTSTimeTableViewCell.h
//  OPS A400M
//
//  Created by richard david on 10/03/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import "CTSTableViewCell.h"
#import "TimeTextField.h"

@interface CTSTimeTableViewCell : CTSTableViewCell
@property (strong, nonatomic) IBOutlet TimeTextField *time1;
@property (strong, nonatomic) IBOutlet TimeTextField *time2;
@property (strong, nonatomic) IBOutlet TimeTextField *time3;
@property (strong, nonatomic) IBOutlet TimeTextField *time4;

@property BOOL time1Abs, time2Abs, time3Abs, time4Abs;

@end

//
//  CTSTableViewCell.h
//  OPS A400M
//
//  Created by richard david on 26/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTSTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lineName;
@property (strong, nonatomic) IBOutlet UILabel *engine1;
@property (strong, nonatomic) IBOutlet UILabel *engine2;
@property (strong, nonatomic) IBOutlet UILabel *engine3;
@property (strong, nonatomic) IBOutlet UILabel *engine4;
- (IBAction)plus1:(id)sender;
@property (strong, nonatomic) IBOutlet UIStepper *plus1;
@property (strong, nonatomic) IBOutlet UIStepper *plus2;
@property (strong, nonatomic) IBOutlet UIStepper *plus3;
@property (strong, nonatomic) IBOutlet UIStepper *plus4;

@property (strong, nonatomic) NSString *legende;

@end

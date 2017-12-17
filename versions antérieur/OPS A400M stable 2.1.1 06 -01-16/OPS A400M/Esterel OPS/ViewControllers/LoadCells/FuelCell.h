//
//  FuelCell.h
//  Esterel-Alpha
//
//  Created by utilisateur on 20/01/2014.
//
//

#import <UIKit/UIKit.h>

#import "NumberTextField.h"

@class Mission;

@interface FuelCell : UITableViewCell <MyTextFieldDelegate>

- (void)initWithLeg:(NSInteger)l inMission:(Mission*)m;


@property (strong, nonatomic) IBOutlet NumberTextField *totalAtTakeOff;
@property (strong, nonatomic) IBOutlet NumberTextField *final;
@property (strong, nonatomic) IBOutlet NumberTextField *addedAtDep;
@property (strong, nonatomic) IBOutlet UILabel *burned;
@property (strong, nonatomic) IBOutlet NumberTextField *received;
@property (strong, nonatomic) IBOutlet NumberTextField *delivered;
@property (strong, nonatomic) IBOutlet MyTextField *bm19;

// Conversion en litres

@property (strong, nonatomic) IBOutlet UILabel *lAddedAtDep;
@property (strong, nonatomic) IBOutlet UILabel *lTotalAtTakeOff;
@property (strong, nonatomic) IBOutlet UILabel *lBurned;
@property (strong, nonatomic) IBOutlet UILabel *lfinal;
@property (strong, nonatomic) IBOutlet UILabel *lreceived;
@property (strong, nonatomic) IBOutlet UILabel *ldelivered;

@end

//
//  PaxCargoCell.h
//  Esterel-Alpha
//
//  Created by utilisateur on 15/01/2014.
//
//

#import <UIKit/UIKit.h>

#import "MyTextField.h"


@class NumberTextField, PaxCargoCell;


@protocol PaxCargoCellDelegate <NSObject>

- (void) paxCargoCellDidChange:(PaxCargoCell*)cell;
- (void)paxCargoCell:(PaxCargoCell*)cell NameDidChange:(NSString*)name;
@end

@interface PaxCargoCell : UITableViewCell <MyTextFieldDelegate>

- (void)resetCell;
- (void)initWithPaxCargo:(NSMutableDictionary*)dict pax:(bool)pax editable:(bool)editable;
- (void)reloadLabels;


@property id<PaxCargoCellDelegate> delegate;


@property (strong, nonatomic) IBOutlet MyTextField *originTextField;
@property (strong, nonatomic) IBOutlet NumberTextField *inTextField;
@property (strong, nonatomic) IBOutlet UILabel *alreadyOnBoardLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet NumberTextField *droppedTextField;
@property (strong, nonatomic) IBOutlet NumberTextField *outTextField;


@end

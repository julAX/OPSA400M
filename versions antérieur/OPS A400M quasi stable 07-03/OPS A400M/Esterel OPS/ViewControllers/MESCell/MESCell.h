//
//  MESCell.h
//  Esterel-Alpha
//
//  Created by utilisateur on 04/02/2014.
//
//

#import <UIKit/UIKit.h>

#import "QuickTextViewController.h"

@interface MESCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate, UIPopoverControllerDelegate, QuickTextDelegate>

- (void)setMES:(NSMutableDictionary*)dict;
- (IBAction)transmisChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *dest;
@property (strong, nonatomic) IBOutlet UITextField *cdb;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet UISegmentedControl *transmis;

@end

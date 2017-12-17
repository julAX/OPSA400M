//
//  CrewMemberCell.h
//  Esterel-Alpha
//
//  Created by utilisateur on 21/01/2014.
//
//

#import <UIKit/UIKit.h>

#import "QuickTextViewController.h"

@interface CrewMemberCell : UITableViewCell <UITextFieldDelegate, UIPopoverControllerDelegate, QuickTextDelegate>


- (void)setCrewMember:(NSMutableDictionary*)dict;

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *function;
@property (strong, nonatomic) IBOutlet UITextField *control;
@property (strong, nonatomic) IBOutlet UITextField *position;
@property (strong, nonatomic) IBOutlet UITextField *other;


@end

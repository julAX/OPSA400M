//
//  ReseauCell.h
//  OPS A400M
//
//  Created by richard david on 22/03/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"
#import "Mission.h"
#import "ReseauCell.h"
#import "Parameters.h"
#import "QuickTextViewController.h"


@interface ReseauCell : UITableViewCell <MissionDelegate, MyTextFieldDelegate, UITextFieldDelegate, UIPopoverControllerDelegate, QuickTextDelegate>

@property (strong, nonatomic) IBOutlet MyTextField *ReseauTextField;

@end

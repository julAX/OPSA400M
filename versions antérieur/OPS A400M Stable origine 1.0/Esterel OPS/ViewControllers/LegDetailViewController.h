//
//  LegViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 16/12/13.
//
//

#import <UIKit/UIKit.h>

#import "Mission.h"
#import "QuickTextViewController.h"
#import "MyTextField.h"


@interface LegDetailViewController : UITableViewController <MissionDelegate, MyTextFieldDelegate, UITextFieldDelegate, UIPopoverControllerDelegate, QuickTextDelegate>

@end

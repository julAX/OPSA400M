//
//  CommentDerogViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 22/01/2014.
//
//

#import <UIKit/UIKit.h>

#import "Mission.h"
#import "ChooseDerogViewController.h"


@interface CommentDerogViewController : UITableViewController <UITextViewDelegate, ChooseDerogDelegate, MissionDelegate, UIPopoverControllerDelegate>

- (IBAction)copyPrevious:(UIButton *)sender;

@end

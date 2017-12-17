//
//  MESViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 04/02/2014.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "Mission.h"

@interface MESViewController : UITableViewController <MFMailComposeViewControllerDelegate, MissionDelegate>

- (IBAction)sendMail:(UIButton *)sender;



@end



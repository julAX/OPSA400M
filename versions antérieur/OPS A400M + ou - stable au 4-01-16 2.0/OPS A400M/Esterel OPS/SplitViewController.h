//
//  MainViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 10/12/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "MissionChooser.h"
#import "SecopsViewController.h"
#import "OMAGenerator.h"


@interface SplitViewController : UISplitViewController <UISplitViewControllerDelegate, UIAlertViewDelegate, MissionChooserDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, OMADelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>


- (void)handleURL:(NSURL*)url;

- (void)saveMission;
- (void)cancel;

- (void)openOMA;
- (void)openSecopsView;
- (void)openExploitView;
- (void)openSignByOrder;
- (void)openAttestation;
- (void)openSicopsView;


@property (readonly, nonatomic) Mission *mission;


@end

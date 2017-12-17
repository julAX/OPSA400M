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
#import "CTSGenerator.h"


@interface SplitViewController : UISplitViewController <UISplitViewControllerDelegate, UIAlertViewDelegate, MissionChooserDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, OMADelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate, CTSDelegate>


@property NSURL *pdfUrl;


- (void)handleURL:(NSURL*)url;

- (void)saveMission;
- (void)cancel;

- (void)openOMAWithPreview : (BOOL) display;
- (void)openSecopsView;
- (void)openExploitView;
- (void)openSignByOrder;
- (void)openAttestation;
- (void)openSicopsView;
- (void)openCTSWithPreview : (BOOL) display;
- (void)openSettings;



@property (readonly, nonatomic) Mission *mission;


@end

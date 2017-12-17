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
#import "PVEGenerator.h"



@interface SplitViewController : UISplitViewController <UISplitViewControllerDelegate, UIAlertViewDelegate, MissionChooserDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, OMADelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate, CTSDelegate, PVEDelegate>


@property NSURL *pdfUrl;
@property BOOL showDetLeg;
@property BOOL showTools;
@property BOOL showCargos;

- (void)handleURL:(NSURL*)url;

- (void)saveMission;
- (void)cancel;

- (void)openOMAWithPreview : (BOOL) display;
- (void)openPVEWithPreview : (BOOL) display;
- (void)openSecopsView;
- (void)openExploitView;
- (void)openSignByOrder;
- (void)openAttestation;
- (void)openSicopsView;
- (void)openCTSWithPreview : (BOOL) display;
- (void)openSettings;
- (void)openCrewFeedbackForm;
- (void)testOma;


@property (readonly, nonatomic) Mission *mission;


@end

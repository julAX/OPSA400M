//
//  MasterViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 10/12/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuickLook/QuickLook.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "RenameViewController.h"
#import "NewFileViewController.h"


@class Mission;

@protocol MissionChooserDelegate <NSObject>

- (void) missionChooserDidEnd:(Mission*)mission;

@end


@interface MissionChooser : UIViewController <UITableViewDataSource, UITableViewDelegate, RenameViewControllerDelegate, NewFileDelegate, UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate /*, QLPreviewControllerDataSource, QLPreviewControllerDelegate*/>

// voir le .m - (IBAction)openHelp:(UIBarButtonItem *)sender;


- (IBAction)openBluetooth:(id)sender;
- (void)updateList;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property id<MissionChooserDelegate> delegate;

@end

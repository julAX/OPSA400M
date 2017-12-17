//
//  LegViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 16/12/13.
//
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

#import "Mission.h"
#import "QuickTextViewController.h"
#import "MyTextField.h"




@interface LegDetailViewController : UITableViewController < MyTextFieldDelegate, UITextFieldDelegate, UIPopoverControllerDelegate, QuickTextDelegate, MissionDelegate,QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *crewTickSheet;
@property (strong, nonatomic) IBOutlet UITableView *legTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *tickSheetView;
- (IBAction)hideButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITableViewCell *omaCell;
@property (strong, nonatomic) IBOutlet UILabel *omaTitle;
@property (strong, nonatomic) IBOutlet UITableViewCell *ctsCell;
@property (strong, nonatomic) IBOutlet UILabel *ctsTitle;

@property (strong, nonatomic) IBOutlet UIButton *hideShowText;


@end

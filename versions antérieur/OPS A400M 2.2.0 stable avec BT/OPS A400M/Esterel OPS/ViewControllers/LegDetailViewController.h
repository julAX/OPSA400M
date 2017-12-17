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

- (IBAction)crewTickSheetButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *crewTickSheet;
@property (strong, nonatomic) IBOutlet UITableView *legTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *tickSheetView;



@end

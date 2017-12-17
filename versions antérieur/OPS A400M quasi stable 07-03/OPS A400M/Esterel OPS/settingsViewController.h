//
//  settingsViewController.h
//  OPS A400M
//
//  Created by richard david on 27/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parameters.h"
#import <QuickLook/QuickLook.h>
#import "QuickTextViewController.h"

@interface settingsViewController : UIViewController <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

- (IBAction)deliveredAndReceived:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *darOnOff;
- (IBAction)cancel:(id)sender;
- (IBAction)tutoButton:(id)sender;
- (IBAction)helpButton:(id)sender;


@end

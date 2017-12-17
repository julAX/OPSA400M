//
//  AttestationTableViewController.h
//  Esterel OPS
//
//  Created by utilisateur on 24/03/2014.
//  Copyright (c) 2014 Esterel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuickLook/QuickLook.h>

#import "QuickTextViewController.h"

@interface AttestationTableViewController : UITableViewController <UITextFieldDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate, UIPopoverControllerDelegate, QuickTextDelegate>

@end

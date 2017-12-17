//
//  FileSharingViewController.h
//  OPS A400M
//
//  Created by Lancelot Ribot on 07/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface FileSharingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblFiles;
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, strong) NSString *documentsDirectory;

@property (nonatomic, strong) NSMutableArray *arrFiles;

@property (nonatomic, strong) NSString *selectedFile;
@property (nonatomic) NSInteger selectedRow;

-(NSArray *)getAllDocDirFiles;
-(void)didStartReceivingResourceWithNotification:(NSNotification *)notification;
-(void)updateReceivingProgressWithNotification:(NSNotification *)notification;
-(void)didFinishReceivingResourceWithNotification:(NSNotification *)notification;

@end

//
//  ConnectionViewController.h
//  OPS A400M
//
//  Created by Lancelot Ribot on 07/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "AppDelegate.h"


@interface ConnectionViewController : UIViewController <MCBrowserViewControllerDelegate,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>



@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UISwitch *swVisible;
@property (weak, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;

- (IBAction)browseForDevices:(id)sender;
- (IBAction)toggleVisibility:(id)sender;
- (IBAction)disconnect:(id)sender;


-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;


@end

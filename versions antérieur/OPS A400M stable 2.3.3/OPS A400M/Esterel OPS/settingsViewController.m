//
//  settingsViewController.m
//  OPS A400M
//
//  Created by richard david on 27/01/2016.
//  Copyright © 2016 CESAM. All rights reserved.
//

#import "settingsViewController.h"

/*
 COMMENTS X15
 
Vue qui s'ouvre depuis le legMasterViewController, qui permet de regler des parametres de l'application, et non pas juste de la mission. Il faut donc imperativmement utiliser des NSUserDefault!!
 
 */

@interface settingsViewController(){

    QLPreviewController *apercu;
    NSURL *helpUrl;
    NSURL *tutoUrl;

}


@end

@implementation settingsViewController

@synthesize darOnOff;



- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [darOnOff setSelectedSegmentIndex:([[NSUserDefaults standardUserDefaults] boolForKey:@"useDeliveredAndReceived"])?0:1];
    
    apercu = [[QLPreviewController alloc] init];
    apercu.delegate = self;
    apercu.dataSource = self;
    
    helpUrl=[[NSBundle mainBundle] URLForResource:@"Help" withExtension:@"pdf"];
    tutoUrl=[[NSBundle mainBundle] URLForResource:@"Tuto" withExtension:@"pdf"];
    
}



- (IBAction)deliveredAndReceived:(id)sender {
    
    
    [[NSUserDefaults standardUserDefaults] setBool:[sender selectedSegmentIndex] == 0 forKey:@"useDeliveredAndReceived"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


# pragma mark - Quick Look

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    if(index==0)
        return tutoUrl;
    else
        return helpUrl;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 2;
}

- (IBAction)tutoButton:(id)sender {
    apercu.currentPreviewItemIndex = 0;
    [apercu refreshCurrentPreviewItem];
    [self presentViewController:apercu animated:YES completion:nil];
    [apercu refreshCurrentPreviewItem];
}

- (IBAction)helpButton:(id)sender {
    apercu.currentPreviewItemIndex = 1;
    [apercu refreshCurrentPreviewItem];
    [self presentViewController:apercu animated:YES completion:nil];
    [apercu refreshCurrentPreviewItem];
}
@end

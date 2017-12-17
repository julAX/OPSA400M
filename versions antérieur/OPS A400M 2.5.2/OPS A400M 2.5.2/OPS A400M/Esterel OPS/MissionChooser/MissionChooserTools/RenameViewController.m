//
//  RenameViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 28/01/2014.
//
//

#import "RenameViewController.h"

@implementation RenameViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.keepPrevious setOn:NO];
    self.fileName.text = self.initialText;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.fileName becomeFirstResponder];
}


- (IBAction)cancel:(id)sender {
    [self.delegate renameViewDidCancel];
}

- (IBAction)okButton:(id)sender {
    if (self.fileName.text.length > 0)
        [self.delegate renameViewDidValidate:self.fileName.text erase:!self.keepPrevious.on];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.fileName.text.length > 0)
    {
        //[textField resignFirstResponder];
        [self.delegate renameViewDidValidate:self.fileName.text erase:!self.keepPrevious.on];
    }
    
    return NO;
}

@end

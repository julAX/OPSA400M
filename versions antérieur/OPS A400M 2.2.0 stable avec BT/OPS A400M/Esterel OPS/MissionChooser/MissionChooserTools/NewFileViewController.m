//
//  NewFileViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 29/01/2014.
//
//

#import "NewFileViewController.h"

@interface NewFileViewController ()

@end

@implementation NewFileViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.fileName becomeFirstResponder];
}


- (IBAction)cancel:(id)sender {
    [self.delegate newFileViewDidCancel];
}

- (IBAction)okButton:(id)sender {
    if (self.fileName.text.length > 0)
        [self.delegate newFileViewDidValidate:self.fileName.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.fileName.text.length > 0)
        [self.delegate newFileViewDidValidate:self.fileName.text];
    
    return NO;
}
@end

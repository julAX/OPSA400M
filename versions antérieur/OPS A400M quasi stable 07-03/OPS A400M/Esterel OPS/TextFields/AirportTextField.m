//
//  AirportTextField.m
//  Esterel-Alpha
//
//  Created by utilisateur on 08/01/2014.
//
//

#import "AirportTextField.h"
#import "QuickTextViewController.h"
#import "AirportsData.h"



@implementation AirportTextField

static UIPopoverController* popover;
static QuickTextViewController* quickText;



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!quickText)
    {
        quickText = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuickText"];
        [quickText setValues:[AirportsData oaciListe] pref:nil sub:[AirportsData nameListe]];
    }
    
    quickText.myDelegate = self;
    [quickText reloadDataForEntry:textField.text];
    
    
    if (!popover)
        popover = [[UIPopoverController alloc] initWithContentViewController:quickText];
    
    popover.delegate = self;
    
    [popover presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (popover.isPopoverVisible)
        [popover dismissPopoverAnimated:YES];
    
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [quickText reloadDataForEntry:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    
    return YES;
}


# pragma mark - QuickTextDelegate

- (void)quickTextDidSelectString:(NSString *)string
{
    self.text = string;
    
    [self resignFirstResponder];
}


# pragma mark - PopoverDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self resignFirstResponder];
}



- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view
{
    if (popover == popoverController)
    {
        *rect = self.frame;
    }
}


@end

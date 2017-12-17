//
//  MESCell.m
//  Esterel-Alpha
//
//  Created by utilisateur on 04/02/2014.
//
//

#import "MESCell.h"

@interface MESCell () {
    
    NSMutableDictionary *message;
    UITextField *activeTextField;
    NSString *destinataires;
}

@end


@implementation MESCell

static UIPopoverController *popover;
static QuickTextViewController *quickText;


- (void)setMES:(NSMutableDictionary *)dict
{
    message = dict;

    //remplir les cellules avec les données
    self.dest.text = message[@"Destinataire"];
    //self.cdb.text = message[@"CDB"];
    self.content.text = message[@"Message"];
    if ( [message[@"Message"]  isEqual: @""])
        self.content.text = @"AIRCRAFT : (NAVDB, failures)\n\n\n"
        "HANDLING : (Crew survey, parking, poc, handling services)\n\n\n"
        "EFB's : (calculation errors, documentation, airport database)\n\n\n"
        "A/EFB's : (electronic documentation)\n\n\n"
        "CESAM : (mission briefing/flight folder, dispatch, performance engineering)\n\n\n";
    
    self.transmis.selectedSegmentIndex = ([@"TRANSMIS" isEqualToString:message[@"Transmis"]]) ? 0 : 1;
}


- (IBAction)transmisChanged:(id)sender {
    
    message[@"Transmis"] = (self.transmis.selectedSegmentIndex == 0) ? @"TRANSMIS" : @"NON TRANSMIS";
}


# pragma mark - TextField delegate

//Reglage du popover

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    if (textField == self.dest)
    {
        if (!quickText)
            quickText = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuickText"];
        
        quickText.myDelegate = self;
        
        [quickText setValues:@[@"CNE SEGARD", @"CDT WIJAS", @"CNE PERSICO", @"CNE HENNEGUEZ", @"CNE EVRARD", @"CDT KUDELA", @"MAJ AUFFRET"] pref:nil sub:nil];
        
        
        if (!popover)
            popover = [[UIPopoverController alloc] initWithContentViewController:quickText];
        
        popover.delegate = self;
        
        

        
        [popover presentPopoverFromRect:textField.frame inView:textField.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (popover.isPopoverVisible)
        [popover dismissPopoverAnimated:YES];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    NSString *key = (textField == self.dest) ? @"Destinataire" : @"CDB";
    
    message[key] = textField.text;
    
    activeTextField = nil;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    //donner la valeur saisie à message[@"Message"]
    message[@"Message"] = self.content.text;

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

# pragma mark - QuickTextDelegate

- (void)quickTextDidSelectString:(NSString *)string
{
    if ([activeTextField.text isEqual:@""]) {activeTextField.text = string;}
    else {
    activeTextField.text = [activeTextField.text stringByAppendingString: [@" ; " stringByAppendingString :string]];
    }
    destinataires = activeTextField.text;
    
    [activeTextField resignFirstResponder];
}


# pragma mark - PopoverDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [activeTextField resignFirstResponder];
}

- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view
{
    if (popover == popoverController)
    {
        *rect = activeTextField.frame;
    }
}


@end



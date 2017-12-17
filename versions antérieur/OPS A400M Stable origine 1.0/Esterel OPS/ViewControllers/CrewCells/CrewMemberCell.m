//
//  CrewMemberCell.m
//  Esterel-Alpha
//
//  Created by utilisateur on 21/01/2014.
//
//

#import "CrewMemberCell.h"

#import "CrewData.h"


@interface CrewMemberCell ()
{
    NSMutableDictionary *crewMember;
    UITextField *activeTextField;
}

@end


@implementation CrewMemberCell

static UIPopoverController* popover;
static QuickTextViewController* quickText;



- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSLayoutConstraint *constrain = [NSLayoutConstraint constraintWithItem:self.name
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:0
                                                                    toItem:self.other
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:.5
                                                                  constant:0];
    [self.contentView addConstraint:constrain];
}

//sert à remplir la case name, function, control, position ou other avec le nom du membre d'équipage(?)
- (void)setCrewMember:(NSMutableDictionary*)dict
{
    crewMember = dict;
    
    self.name.text = crewMember[@"Name"];
    self.function.text = crewMember[@"Function"];
    self.control.text = crewMember[@"Controle"];
    self.position.text = crewMember[@"Position"];
    self.other.text = crewMember[@"Other"];
}

- (bool)cockpit
{
    return [@[@"PCB", @"Pcb", @"PIL"] containsObject:self.function.text];
}

# pragma mark - TextField delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
 
    if (textField.tag != 305)
    {
       if (!quickText)
            quickText = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuickText"];
        
        quickText.myDelegate = self;
        
        switch (textField.tag) {
            case 301:
                [quickText setValues:[CrewData nameListe] pref:[CrewData gradeListe] sub:nil];
                [quickText reloadDataForEntry:textField.text];
                break;
            case 302:
                [quickText setValues:@[@"PCB", @"Pcb", @"PIL", @"MES", @"ASO", @"CCP", @"CC", @"CC/P2", @"ASC", @"CVA", @"CE", @"PAX"] pref:nil sub:nil];
                break;
            case 303:
                [quickText setValues:@[@"CTR", @"CTL"] pref:nil sub:nil];
                break;
            case 304:
                [quickText setValues:(([self cockpit]) ? @[@"PF - CM1", @"PF - CM2", @"PM - CM1", @"PM - CM2", @"BQ"] : @[@"P1", @"P2", @"P3", @"P4", @"P5", @"P6", @"P7", @"P8"]) pref:nil sub:nil];
            default:
                break;
        }
        
        
        
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
//assigne à la variable crewMember[@"donnée"] la valeur rentrée dans le textField correspondant
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    
    switch (textField.tag) {
        case 301:
            crewMember[@"Name"] = textField.text;
            break;
        case 302:
            crewMember[@"Function"] = textField.text;
            break;
        case 303:
            crewMember[@"Controle"] = textField.text;
            break;
        case 304:
            crewMember[@"Position"] = textField.text;
            break;
        case 305:
            crewMember[@"Other"] = textField.text;
            
        }
    
    activeTextField = nil;
}








- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 301) {
        [quickText reloadDataForEntry:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    }

    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

# pragma mark - QuickTextDelegate

- (void)quickTextDidSelectString:(NSString *)string
{
    activeTextField.text = string;
    
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

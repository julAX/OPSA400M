//
//  NumberTextField.m
//  Esterel-Alpha
//
//  Created by utilisateur on 09/01/2014.
//
//

#import "NumberTextField.h"

@implementation NumberTextField

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length != 0)
        textField.text = @([textField.text integerValue]).description;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return ((string.length == 0) || ([string isEqualToString:@([string integerValue]).description]));
}




@end

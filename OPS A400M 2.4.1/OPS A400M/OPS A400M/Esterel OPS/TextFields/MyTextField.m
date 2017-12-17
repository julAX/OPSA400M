//
//  RootTextField.m
//  Esterel-Alpha
//
//  Created by utilisateur on 08/01/2014.
//
//

#import "MyTextField.h"

@implementation MyTextField


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{    
    [self.myDelegate myTextFieldDidEndEditing:textField];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}

@end

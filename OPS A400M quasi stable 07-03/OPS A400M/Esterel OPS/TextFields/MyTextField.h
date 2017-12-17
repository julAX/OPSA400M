//
//  RootTextField.h
//  Esterel-Alpha
//
//  Created by utilisateur on 08/01/2014.
//
//

#import <UIKit/UIKit.h>


@protocol MyTextFieldDelegate <NSObject>

- (void) myTextFieldDidEndEditing:(UITextField*)textField;

@end

@interface MyTextField : UITextField <UITextFieldDelegate>

@property id<MyTextFieldDelegate> myDelegate;

@end

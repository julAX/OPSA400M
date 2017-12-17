//
//  TimeTextField.h
//  Esterel-Alpha
//
//  Created by utilisateur on 09/01/2014.
//
//

#import "MyTextField.h"

@interface TimeTextField : MyTextField

@property (strong, nonatomic) NSDate *time;
@property BOOL emptyIfZero;

@end

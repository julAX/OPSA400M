//
//  TimeTextField.m
//  Esterel-Alpha
//
//  Created by utilisateur on 09/01/2014.
//
//

#import "TimeTextField.h"

#import "TimeTools.h"

@implementation TimeTextField

static UIDatePicker *datePicker;
static UIButton *button;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!button)
    {
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor colorWithWhite:0.78 alpha:0.95];
        button.frame = CGRectMake(0., 0., 0., 40.);
        [button setTitle:@"OK" forState:UIControlStateNormal];
    }
    
    if (!datePicker)
    {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeTime;
        [datePicker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    [self setInputAccessoryView:button];
    [self setInputView:datePicker];
}


- (void)ok
{
    [self dateChanged];
    [self resignFirstResponder];
    

}


- (void)setTime:(NSDate *)time
{
    _time = time;
    
    self.text = (self.emptyIfZero && [_time isEqualToDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0.]]) ? @"" : [TimeTools stringFromTime:_time withDays:YES];
}

- (void)dateChanged
{

    self.time = [datePicker.date copy];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    

    [button addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    
    datePicker.date = _time;
}



- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [button removeTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [datePicker removeTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];

    return YES;
}


@end
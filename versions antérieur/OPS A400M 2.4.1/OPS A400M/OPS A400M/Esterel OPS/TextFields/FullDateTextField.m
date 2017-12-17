//
//  DateTextField.m
//  Esterel-Alpha
//
//  Created by utilisateur on 08/01/2014.
//
//

#import "FullDateTextField.h"

#import "TimeTools.h"


@implementation FullDateTextField

static UIDatePicker *datePicker;
static UIButton *button;


- (void)ok
{
    [self dateChanged];
    [self resignFirstResponder];
}


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
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    _datePlaceholder = [TimeTools defaultDate];
    
    [self setInputAccessoryView:button];
    [self setInputView:datePicker];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    self.text = [TimeTools stringFromFullDate:_date];
}

- (void)setDatePlaceholder:(NSDate *)date
{
    _datePlaceholder = date;
    self.placeholder = [TimeTools stringFromFullDate:date];
}

- (void)dateChanged
{
    self.date = [datePicker.date copy];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [button addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    
    datePicker.date = [TimeTools correctDate:_date];
}



- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.text isEqualToString:@""])
        _date = _datePlaceholder;
    
    [button removeTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
    [datePicker removeTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];

    return YES;
}


@end

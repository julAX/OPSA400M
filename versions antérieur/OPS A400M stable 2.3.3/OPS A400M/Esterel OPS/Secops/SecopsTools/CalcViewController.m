//
//  CalcViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 12/02/2014.
//
//

#import "CalcViewController.h"

#import "Mission.h"
#import "TimeTools.h"

@interface CalcViewController () {
    
    IBOutlet LegsSelectionView *legsCollection;
    
    IBOutlet UITableViewCell *landingsCell;
    IBOutlet UITableViewCell *dayCell;
    IBOutlet UITableViewCell *nightCell;
    IBOutlet UITableViewCell *totalCell;
}

@end

@implementation CalcViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    legsCollection.selectionDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    legsCollection.mission = self.mission;
    
    [self reloadHoursForSelection:legsCollection.selectedLegs];
}

- (void)reloadHoursForSelection:(NSDictionary*)selectedLegs
{
    NSInteger landings = 0;
    
    NSDictionary *leg, *coeffs = @{@"Day" : [NSMutableArray new], @"Night" : [NSMutableArray new]},
    *hours = @{@"Day" : [NSMutableArray arrayWithCapacity:(selectedLegs.count * 4)],
             @"Night" : [NSMutableArray arrayWithCapacity:(selectedLegs.count * 4)]};
    
    for (NSString *legKey in selectedLegs)
    {
        leg = selectedLegs[legKey];
        
        landings += [leg[@"Landings"] integerValue];
        
        for (NSString *day in @[@"Day", @"Night"]) {
            for (NSString *coeff in @[@"10", @"22", @"35", @"62"]) {
                NSString *key = [day stringByAppendingString:coeff];
                NSDate *time = leg[key];
                
                if (!([time timeIntervalSinceReferenceDate] == 0)) {
                    
                    [hours[day] addObject:time];
                    
                }
            }
        }
    }
    
    landingsCell.textLabel.text = [NSString stringWithFormat:@"Landings : %ld", (long)landings];
    
    NSDate *hoursDay = [TimeTools sumOfTimes:hours[@"Day"]], *hoursNight = [TimeTools sumOfTimes:hours[@"Night"]];
    
    dayCell.textLabel.text = [NSString stringWithFormat:@"Time day	: %@ %@",
                              [TimeTools stringFromTime:hoursDay withDays:YES],
                              (((NSArray*)coeffs[@"Day"]).count > 0) ? [NSString stringWithFormat:@" with %@", [coeffs[@"Day"] componentsJoinedByString:@"/"]] : @""];
    
    nightCell.textLabel.text = [NSString stringWithFormat:@"Time night: %@ %@",
                                [TimeTools stringFromTime:hoursNight withDays:YES],
                                (((NSArray*)coeffs[@"Night"]).count > 0) ? [NSString stringWithFormat:@" with %@", [coeffs[@"Night"] componentsJoinedByString:@"/"]] : @""];

    totalCell.textLabel.text = [NSString stringWithFormat:@"Time total	: %@",
                                [TimeTools stringFromTime:[TimeTools sumOfTimes:@[hoursDay, hoursNight]] withDays:YES]];
}

#pragma mark - legSelection

- (void)selectionDidChange:(NSDictionary *)selectedLegs
{
    [self reloadHoursForSelection:selectedLegs];
}

@end

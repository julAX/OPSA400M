//
//  BlocksViewController.m
//  Esterel-Alpha
//  Created by utilisateur on 18/12/13.
//
//

#import "BlocksViewController.h"

#import "SplitViewController.h"

#import "TimeTools.h"
#import "FullDateTextField.h"
#import "TimeTextField.h"

/*COMMENT X15:

Ce viewController permet la visualisation des horaires et heures de vols qui sont remplies dans "fill out the oma", et la correction ponctuelle si nécessaire
 
*/

@interface BlocksViewController ()
{
    Mission *mission;
    NSMutableDictionary *leg;
    NSDateFormatter *dateFormatter;
}

@end

@implementation BlocksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.departureAirport.myDelegate = self;
    self.expectedOffBlocks.myDelegate = self;
    self.offBlocksTime.myDelegate = self;
    self.takeOffTime.myDelegate = self;
    
    self.arrivalAirport.myDelegate = self;
    self.expectedInBlocks.myDelegate = self;
    self.inBlocksTime.myDelegate = self;
    self.landingTime.myDelegate = self;
    self.landings.myDelegate = self;
    self.badVisibilityLandings.myDelegate = self;
    
    self.touchAndGo.myDelegate = self;
    self.goAround.myDelegate = self;
    self.lowLevelFlight.myDelegate = self;
    self.lowLevelFlight.emptyIfZero = YES;
    
    self.day35.myDelegate = self;
    self.day35.emptyIfZero = YES;
    self.day22.myDelegate = self;
    self.day22.emptyIfZero = YES;
    self.day10.myDelegate = self;
    self.day10.emptyIfZero = YES;
    self.day62.myDelegate = self;
    self.day62.emptyIfZero = YES;
    
    self.night35.myDelegate = self;
    self.night35.emptyIfZero = YES;
    self.night22.myDelegate = self;
    self.night22.emptyIfZero = YES;
    self.night10.myDelegate = self;
    self.night10.emptyIfZero = YES;
    self.night62.myDelegate = self;
    self.night62.emptyIfZero = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ((mission = ((SplitViewController*)self.splitViewController).mission))
    {
        mission.delegate = self;
        leg = mission.activeLeg;
        
        [self reloadValues];
    }
}


- (void)activeLegDidChange:(NSInteger)legNumber
{
    leg = mission.activeLeg;
    [self reloadValues];
}


- (UIColor*)colorForKey:(NSString*)key
{
    return ([leg[key] isEqual:leg[[@"Original" stringByAppendingString:key]]]) ? [UIColor blackColor] : [UIColor greenColor];
}

- (void)reloadValues
{
    for (NSString *key in @[@"DepartureAirport", @"ETD", @"ArrivalAirport", @"ETA"]) {
        NSString *origKey = [@"Original" stringByAppendingString:key];
        
        if (!leg[origKey])
            leg[origKey] = [leg[key] copy];
    }
    
    self.departureAirport.text = leg[@"DepartureAirport"];
    self.departureAirport.placeholder = leg[@"OriginalDepartureAirport"];
    self.expectedOffBlocks.date = leg[@"ETD"];
    self.expectedOffBlocks.datePlaceholder = leg[@"OriginalETD"];
    self.offBlocksTime.date = leg[@"OffBlocksTime"];

    
    self.takeOffTime.date = leg[@"TakeOffTime"];
    
    self.arrivalAirport.text = leg[@"ArrivalAirport"];
    self.arrivalAirport.placeholder = leg[@"OriginalArrivalAirport"];
    self.expectedInBlocks.date = leg[@"ETA"];
    self.expectedInBlocks.datePlaceholder = leg[@"OriginalETA"];
    self.inBlocksTime.date = leg[@"OnBlocksTime"];
    self.landingTime.date = leg[@"LandingTime"];
    self.landings.text = leg[@"Landings"];
    self.badVisibilityLandings.text = leg[@"BadVisibilityLandings"];
    
    self.touchAndGo.text = leg[@"TouchAndGo"];
    self.touchAndGo.placeholder = leg[@"TouchAndGo"];
    self.goAround.text = leg[@"GoAround"];
    self.goAround.placeholder = leg[@"GoAround"];
    self.lowLevelFlight.time = leg[@"LowLevelFlight"];
    
    self.day35.time = leg[@"Day35"];
    self.day22.time = leg[@"Day22"];
    self.day10.time = leg[@"Day10"];
    self.day62.time = leg[@"Day62"];
    
    self.night35.time = leg[@"Night35"];
    self.night22.time = leg[@"Night22"];
    self.night10.time = leg[@"Night10"];
    self.night62.time = leg[@"Night62"];
    
    [self reloadLabels];
}


- (void) myTextFieldDidEndEditing:(UITextField *)textField
{
    

    switch (textField.tag) {
        case 101: [self setAirport:textField.text forKey:@"DepartureAirport"];
            break;
        case 102: leg[@"ETD"] = ((FullDateTextField*)textField).date;
            break;
        case 103: leg[@"OffBlocksTime"] = ((FullDateTextField*)textField).date;
            break;
        case 104: leg[@"TakeOffTime"] = ((FullDateTextField*)textField).date;
            break;
            
        case 111: [self setAirport:textField.text forKey:@"ArrivalAirport"];
            break;
        case 112: leg[@"ETA"] = ((FullDateTextField*)textField).date;
            break;
        case 113: leg[@"OnBlocksTime"] = ((FullDateTextField*)textField).date;
            break;
        case 114: leg[@"LandingTime"] = ((FullDateTextField*)textField).date;
            break;
        case 115: leg[@"Landings"] = textField.text;
            break;
        case 116: leg[@"BadVisibilityLandings"] = textField.text;
            break;
            
        case 121: leg[@"Day35"] = ((TimeTextField*)textField).time;
            break;
        case 122: leg[@"Day22"] = ((TimeTextField*)textField).time;
            break;
        case 123: leg[@"Day10"] = ((TimeTextField*)textField).time;
            break;
        case 124: leg[@"Day62"] = ((TimeTextField*)textField).time;
            break;
            
        case 131: leg[@"Night35"] = ((TimeTextField*)textField).time;
            break;
        case 132: leg[@"Night22"] = ((TimeTextField*)textField).time;
            break;
        case 133: leg[@"Night10"] = ((TimeTextField*)textField).time;
            break;
        case 134: leg[@"Night62"] = ((TimeTextField*)textField).time;
            break;
            
        case 141: leg[@"TouchAndGo"] = ((MyTextField*)textField).text;
            break;
        case 142: leg[@"GoAround"] = ((MyTextField*)textField).text;
            break;
        case 143: leg[@"LowLevelFlight"] = ((TimeTextField*)textField).time;
            
        default: NSLog(@"Blocks textfield tag non utilisé");
            break;
    }
    
    [self reloadLabels];
}

- (void) setAirport:(NSString*)airport forKey:(NSString*)key
{
    NSInteger d = 0;
    
    if ([key isEqualToString:@"DepartureAirport"])
        d = -1;
    if ([key isEqualToString:@"ArrivalAirport"])
        d = 1;
    
    if (d != 0)
    {
        UITableView *masterTableView = ((UITableViewController*)((UINavigationController*)self.splitViewController.viewControllers.firstObject).topViewController).tableView;
        NSMutableArray *cellsToReload = [NSMutableArray arrayWithCapacity:2];
        
        [cellsToReload addObject:[NSIndexPath indexPathForRow:mission.activeLegIndex inSection:0]];
        
        leg[key] = airport;
        
        NSString *otherKey = (d == 1) ? @"DepartureAirport" : @"ArrivalAirport";
        
        NSInteger i = mission.activeLegIndex + d;
        
        if ((i >= 0) && (i < mission.legs.count)) {
            
            NSMutableDictionary *otherLeg = mission.legs[i];
            
            NSString *orig = [@"Original" stringByAppendingString:otherKey];
            
            if (!otherLeg[orig])
                otherLeg[orig] = [otherLeg[otherKey] copy];
            
            otherLeg[otherKey] = airport;
            
            [cellsToReload addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [masterTableView reloadRowsAtIndexPaths:cellsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
        [masterTableView selectRowAtIndexPath:cellsToReload.firstObject animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else
        NSLog(@"Wrong key sent to \"setAirport: forKey:\" in blocks view");
}
// Faire les sommes des heures

- (void)reloadLabels
{
    self.departureAirport.textColor = [self colorForKey:@"DepartureAirport"];
    self.expectedOffBlocks.textColor = [self colorForKey:@"ETD"];
    self.arrivalAirport.textColor = [self colorForKey:@"ArrivalAirport"];
    self.expectedInBlocks.textColor = [self colorForKey:@"ETA"];
    
    // Commenté par X15 : interference avec le rajout de code
     
    /*
     NSDate *betweenBlocks = [NSDate dateWithTimeIntervalSinceReferenceDate:
                             [self.inBlocksTime.date timeIntervalSinceDate:self.offBlocksTime.date]],
    
    *flight = [NSDate dateWithTimeIntervalSinceReferenceDate:
               [self.landingTime.date timeIntervalSinceDate:self.takeOffTime.date]];
    
    leg[@"BetweenBlocksTime"] = betweenBlocks;
    leg[@"FlightTime"] = flight;
  
    
    self.betweenBlocksTime.text = [TimeTools stringFromTime:betweenBlocks withDays:YES];
    self.flightTime.text = [TimeTools stringFromTime:flight withDays:YES];
     
    */
    
    
    //X15 rajout
    
    self.betweenBlocksTime.text = [TimeTools stringFromTime:leg[@"BetweenBlocksTime"] withDays:YES];
    self.flightTime.text = [TimeTools stringFromTime:leg[@"FlightTime"] withDays:YES];
    
    NSDate * flight = leg[@"FlightTime"];
    
    NSDate * betweenBlocks = [NSDate dateWithTimeIntervalSinceReferenceDate:
                     [self.inBlocksTime.date timeIntervalSinceDate:self.offBlocksTime.date]];
    self.betweenBlocksTime.text = [TimeTools stringFromTime:betweenBlocks withDays:YES];
    leg[@"BetweenBlocksTime"]=betweenBlocks;
    
    //X15 Fin rajout
    
    
    
    
    
    
    NSDate *hoursDay = [TimeTools sumOfTimes:@[self.day35.time,
                                               self.day22.time,
                                               self.day10.time,
                                               self.day62.time]],
    *hoursNight = [TimeTools sumOfTimes:@[self.night35.time,
                                          self.night22.time,
                                          self.night10.time,
                                          self.night62.time]];
    
    self.blockHoursDay.text = [TimeTools stringFromTime:hoursDay withDays:YES];
    self.blockHoursNight.text = [TimeTools stringFromTime:hoursNight withDays:YES];
    NSDate *hoursTotal = [TimeTools sumOfTimes:@[hoursDay, hoursNight]];
    
    self.blockHoursTotal.text = [TimeTools stringFromTime:hoursTotal withDays:YES];
    
    if ([betweenBlocks timeIntervalSinceDate:flight] < 0)
    {
        self.flightTime.textColor = [UIColor redColor];
//        [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"Flight time > Between blocks time!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:4] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else
        self.flightTime.textColor = [UIColor blackColor];
    
    
    if (![hoursTotal isEqualToDate:betweenBlocks])
    {
        self.blockHoursTotal.textColor = [UIColor redColor];
//        [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"Between blocks time =/= Block hours - Total" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:4] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else
        self.blockHoursTotal.textColor = [UIColor blackColor];
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 6;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 4;
            break;
        case 4:
            return 4;
            break;
        case 5:
            return 5;
            break;

        default:
            return 0;
            break;
    }
}

@end

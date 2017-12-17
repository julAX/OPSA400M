//
//  BlocksViewController.h
//  Esterel-Alpha
//
//  Created by utilisateur on 18/12/13.
//
//

#import <UIKit/UIKit.h>

#import "Mission.h"
#import "MyTextField.h"

@class TimeTextField, FullDateTextField;


@interface BlocksViewController : UITableViewController <MyTextFieldDelegate, MissionDelegate>



// Text fields & labels
@property (strong, nonatomic) IBOutlet MyTextField *departureAirport;
@property (strong, nonatomic) IBOutlet FullDateTextField *expectedOffBlocks;
@property (strong, nonatomic) IBOutlet FullDateTextField *offBlocksTime;
@property (strong, nonatomic) IBOutlet FullDateTextField *takeOffTime;

@property (strong, nonatomic) IBOutlet MyTextField *arrivalAirport;
@property (strong, nonatomic) IBOutlet FullDateTextField *expectedInBlocks;
@property (strong, nonatomic) IBOutlet FullDateTextField *inBlocksTime;
@property (strong, nonatomic) IBOutlet FullDateTextField *landingTime;
@property (strong, nonatomic) IBOutlet MyTextField *landings;
@property (strong, nonatomic) IBOutlet MyTextField *badVisibilityLandings;

@property (strong, nonatomic) IBOutlet MyTextField *touchAndGo;
@property (strong, nonatomic) IBOutlet MyTextField *goAround;
@property (strong, nonatomic) IBOutlet TimeTextField *lowLevelFlight;

@property (strong, nonatomic) IBOutlet TimeTextField *day35;
@property (strong, nonatomic) IBOutlet TimeTextField *day22;
@property (strong, nonatomic) IBOutlet TimeTextField *day10;
@property (strong, nonatomic) IBOutlet TimeTextField *day62;

@property (strong, nonatomic) IBOutlet TimeTextField *night35;
@property (strong, nonatomic) IBOutlet TimeTextField *night22;
@property (strong, nonatomic) IBOutlet TimeTextField *night10;
@property (strong, nonatomic) IBOutlet TimeTextField *night62;

@property (strong, nonatomic) IBOutlet UILabel *betweenBlocksTime;
@property (strong, nonatomic) IBOutlet UILabel *flightTime;
@property (strong, nonatomic) IBOutlet UILabel *blockHoursDay;
@property (strong, nonatomic) IBOutlet UILabel *blockHoursNight;
@property (strong, nonatomic) IBOutlet UILabel *blockHoursTotal;

@end

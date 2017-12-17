//
//  LegViewController.m
//  Esterel OPS
//
//  Created by utilisateur on 16/12/13.
//
//

/*
 Cette vue est la racine de la detail view, c'est donc celle qui est la première affichée à l'ouverture d'une mission et celle qui défini le bouton "Save" commun à toutes les detail views
 POUR RAJOUTER UN "AIRCRAFT" DANS LES CHOIX PROPOSES LORS DE LA SAISIE, COMPLETER LA LISTE QUICK TEST SUR CETTE PAGE
 Modifications : ajout de activeTextField afin de distinguer 2 popovers
 Ajout de Unit
 */

#import "LegDetailViewController.h"

#import "SplitViewController.h"


@interface LegDetailViewController () {
    
    IBOutlet UITextField *aircraft;
    IBOutlet MyTextField *missionNumber;
    IBOutlet UITextField *unit;
    UITextField *activeTextField;
    
    IBOutlet MyTextField *callSign;
    IBOutlet MyTextField *be;
    IBOutlet MyTextField *na;
    IBOutlet MyTextField *typeOfFlight;
    IBOutlet MyTextField *flightRules;
    IBOutlet MyTextField *payload;

    
    Mission *mission;
    NSMutableDictionary *leg;
    NSInteger legNumber;
    
    UIPopoverController *popover;
    
    UIDocumentInteractionController *documentController;
    NSURL *crewTickSheetUrl;
    NSString *crewSurveyUrlDebut;
    NSURL *crewSurveyUrl;
}

@end

@implementation LegDetailViewController

    QuickTextViewController *quickText;
@synthesize crewTickSheet;
@synthesize legTableView;
@synthesize tickSheetView;
@synthesize crewSurvey;
@synthesize crewSurveyView;


- (void)activeLegDidChange:(NSInteger)l {
    leg = mission.activeLeg;
    legNumber = l;
    
    if (!leg[@"OriginalCallSign"])
        leg[@"OriginalCallSign"] = leg[@"CallSign"];
    
    if (!leg[@"OriginalBe"])
        leg[@"OriginalBe"] = leg[@"Be"];
    
    if (!leg[@"OriginalNa"])
        leg[@"OriginalNa"] = leg[@"Na"];
    
    [self reloadValues];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Ajout X15
    //Documentation Électronique/Doc iPad/partie_f/preparation/
    
    
    crewTickSheetUrl = [[NSBundle mainBundle] URLForResource:@"Ncts" withExtension:@"pdf"];
    
    
    
    
    //A completer
    crewSurveyUrlDebut = @"~/Documents/Documentation Électronique/Doc iPad/partie_c/Crew Survey/";
    
    
    NSLog(@" url : %@",crewTickSheetUrl);
    
    
    
    
    //Fin ajout X15
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self.splitViewController action:@selector(saveMission)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    missionNumber.myDelegate = self;
    callSign.delegate = self;
    be.delegate = self;
    na.delegate = self;
    flightRules.delegate = self;
    typeOfFlight.delegate = self;
    payload.myDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ((mission = ((SplitViewController*)self.splitViewController).mission))
    {
        mission.delegate = self;
        
        leg = mission.activeLeg;
        legNumber = mission.activeLegIndex;
        

        if (!mission.root[@"OriginalAircraft"])
            mission.root[@"OriginalAircraft"] = mission.root[@"Aircraft"];
        
        if (!mission.root[@"OriginalMissionNumber"])
            mission.root[@"OriginalMissionNumber"] = mission.root[@"MissionNumber"];

        
        if (!leg[@"OriginalCallSign"])
            leg[@"OriginalCallSign"] = leg[@"CallSign"];
        
        if (!leg[@"OriginalBe"])
            leg[@"OriginalBe"] = leg[@"Be"];
        
        if (!leg[@"OriginalNa"])
            leg[@"OriginalNa"] = leg[@"Na"];
        
        
        unit.text = mission.root[@"Unit"];
        unit.placeholder = mission.root[@"Unit"];
        
        aircraft.text = mission.root[@"Aircraft"];
        aircraft.placeholder = mission.root[@"OriginalAircraft"];
        
        
        missionNumber.text = mission.root[@"MissionNumber"];
        missionNumber.placeholder = mission.root[@"OriginalMissionNumber"];
        
        
        [self reloadValues];
    }
}


- (void)myTextFieldDidEndEditing:(MyTextField *)textField
{
    switch (textField.tag) {
        case 3: mission.root[@"MissionNumber"] = textField.text;
            break;
        case 4: leg[@"CallSign"]=textField.text;
            break;
        case 5: leg[@"Be"] = textField.text;
            break;
        case 6: leg[@"Na"] = textField.text;
            break;
        case 7: leg[@"FlightRules"] = textField.text;
            break;
        case 8: leg[@"TypeOfFlight"] = textField.text;
            break;
        case 9: leg[@"Payload"] = textField.text;
            break;
    }
    
    [self reloadColors];
}

- (void)reloadValues
{    
    [self.tableView reloadSectionIndexTitles];
    
    callSign.text = leg[@"CallSign"];
    callSign.placeholder = leg[@"OriginalCallSign"];
    
    be.text = leg[@"Be"];
    be.placeholder = leg[@"OriginalBe"];
    
    na.text = leg[@"Na"];
    na.placeholder = leg[@"OriginalNa"];
    
    typeOfFlight.text = leg[@"TypeOfFlight"];
    typeOfFlight.placeholder = leg[@"TypeOfFlight"];
    
    flightRules.text = leg[@"FlightRules"];
    flightRules.placeholder = leg[@"FlightRules"];
    
    payload.text = leg[@"Payload"];
    payload.placeholder = leg[@"Payload"];

    //Ajout X15
    
    NSString *arrivalAirport = leg[@"ArrivalAirport"];
    
    NSString *currentCrewSurveyTitle = [@"Crew survey for " stringByAppendingString:arrivalAirport];
    
    [crewSurvey setTitle: currentCrewSurveyTitle forState:UIControlStateNormal ];
    
    //Fin ajout X15
    
    
    [self reloadColors];
    
    [self.tableView reloadData];
}

- (void)reloadColors
{
    UIColor *blackColor = [UIColor blackColor], *greenColor = [UIColor greenColor];
    
    aircraft.textColor = ([mission.root[@"Aircraft"] isEqualToString:mission.root[@"OriginalAircraft"]]) ? blackColor : greenColor;
    missionNumber.textColor = ([mission.root[@"MissionNumber"] isEqualToString:mission.root[@"OriginalMissionNumber"]]) ? blackColor : greenColor;
    callSign.textColor = ([leg[@"CallSign"] isEqualToString:leg[@"OriginalCallSign"]]) ? blackColor : greenColor;
    be.textColor = ([leg[@"Be"] isEqualToString:leg[@"OriginalBe"]]) ? blackColor : greenColor;
    na.textColor = ([leg[@"Na"] isEqualToString:leg[@"OriginalNa"]]) ? blackColor : greenColor;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 1) ? [NSString stringWithFormat:@"Leg %ld", (long)(legNumber + 1)] : [super tableView:tableView titleForHeaderInSection:section];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    UIViewController *vue = segue.destinationViewController;
    
    vue.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
}



# pragma mark - TextField delegate

//Faire apparaître les popovers pour Aircraft, Unit, CTM, Be et Na

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
   NSInteger i = mission.activeLegIndex;
if (!quickText)
        quickText = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuickText"];
        
quickText.myDelegate = self;
    
switch (textField.tag) {
        case 1:
            [quickText setValues:@[@"TOURAINE 1/61", @"CIET 340", @"EMATT 01.338"] pref:nil sub:nil];
            break;
        case 2:
            [quickText setValues:@[@"FRB-AA", @"FRB-AB", @"FRB-AC", @"FRB-AD", @"FRB-AE", @"FRB-AF", @"FRB-AG", @"FRB-AH", @"FRB-AI", @"FRB-AJ"] pref:nil sub:nil];
        break;
    default:
            break;
        }
    
    if (i>0) {
        
        NSMutableDictionary *previousLeg = mission.legs[i - 1];
        
        switch (textField.tag) {
            case 4:
                [quickText setValues:@[@"CTM ",previousLeg[@"CallSign"]] pref:nil sub:nil];
                break;
            case 5:
                [quickText setValues:@[previousLeg[@"Be"],@"W1",@"WY",@"AK",@"AZ",@"B4",@"BD",@"M6",@"M5",@"Y1",@"AX",@"AR",@"B9",@"D3",@"AC"] pref:nil sub:nil];
                break;
            case 6:
                [quickText setValues:@[previousLeg[@"Na"],@"22",@"25",@"35",@"40",@"50",@"51",@"65",@"62"] pref:nil sub:nil];
                break;
            case 7:
                [quickText setValues:@[previousLeg[@"FlightRules"],@"E",@"I",@"A",@"O",@"V",@"Y",@"Z"] pref:nil sub:nil];
                break;
            case 8:
                [quickText setValues:@[previousLeg[@"TypeOfFlight"],@"D",@"M",@"V",@"T",@"I",@"X"] pref:nil sub:nil];
                break;
            default:
                break;
        }
    }
    if (i==0) {
        switch (textField.tag) {
            case 4:
                [quickText setValues:@[@"CTM"] pref:nil sub:nil];
                break;
            case 5:
                [quickText setValues:@[@"W1",@"WY",@"AK",@"AZ",@"B4",@"BD",@"M6",@"M5",@"Y1",@"AX",@"AR",@"B9",@"D3",@"AC"] pref:nil sub:nil];
                break;
            case 6:
                [quickText setValues:@[@"22",@"25",@"35",@"40",@"50",@"51",@"65",@"62"] pref:nil sub:nil];
                break;
            case 7:
                [quickText setValues:@[@"E",@"I",@"A",@"O",@"V",@"Y",@"Z"] pref:nil sub:nil];
                break;
            case 8:
                [quickText setValues:@[@"D",@"M",@"V",@"T",@"I",@"X"] pref:nil sub:nil];
                break;
            default:
                break;
        }
    }
    
    if (!popover)
        popover = [[UIPopoverController alloc] initWithContentViewController:quickText];
        popover.delegate = self;
    [popover presentPopoverFromRect:textField.frame inView:textField.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}


- (BOOL)textFieldShouldEndEditing:(UITextField*)textField {
    if (popover.isPopoverVisible)
        [popover dismissPopoverAnimated:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField*)textField {
    switch(textField.tag) {
        case 1: mission.root[@"Unit"] = textField.text;
            break;
        case 2: mission.root[@"Aircraft"] = textField.text;
            break;
        case 4: leg[@"CallSign"] = textField.text;
            break;
        case 5: leg[@"Be"] = textField.text;
            break;
        case 6: leg[@"Na"] = textField.text;
            break;
        case 7: leg[@"FlightRules"] = textField.text;
            break;
        case 8: leg[@"TypeOfFlight"] = textField.text;
            break;
        case 9: leg[@"Payload"] = textField.text;
            break;
            
            }
    activeTextField = nil;
    
    [self reloadColors];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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



- (IBAction)crewTickSheetButton:(id)sender {
    documentController = [UIDocumentInteractionController interactionControllerWithURL:crewTickSheetUrl];
    
    BOOL valid = [documentController presentOpenInMenuFromRect:crewTickSheet.frame
                                           inView:tickSheetView
                                         animated:YES];
    NSLog(@"%d",valid);
    NSLog(@"%@",crewTickSheetUrl.description);
}

- (IBAction)crewSurveyButton:(id)sender {
    
    NSString *arrivalAirport = leg[@"ArrivalAirport"];
    
    //crewSurveyUrl = [[NSBundle mainBundle] URLForResource:arrivalAirport withExtension:@"pdf"];
    crewSurveyUrl = [NSURL fileURLWithPath :[[[crewSurveyUrlDebut stringByAppendingString:arrivalAirport] stringByAppendingString:@".pdf"] stringByExpandingTildeInPath]];
    
    
    documentController = [UIDocumentInteractionController interactionControllerWithURL:crewSurveyUrl];
    BOOL valid = [documentController presentOpenInMenuFromRect:crewSurvey.frame
                                                        inView:crewSurveyView
                                                      animated:YES];
    NSLog(@"%d",valid);
    
}
@end

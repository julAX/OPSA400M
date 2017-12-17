//
//  LegViewController.m
//  Esterel OPS
//
//  Created by utilisateur on 16/12/13.
//
//

/*
 
 COMMENTS X15:
 
 Cette vue est la racine de la detail view, c'est donc celle qui est la première affichée à l'ouverture d'une mission et celle qui défini le bouton "Save" commun à toutes les detail views
 POUR RAJOUTER UN "AIRCRAFT" DANS LES CHOIX PROPOSES LORS DE LA SAISIE, COMPLETER LA LISTE QUICK TEST DANS PARAMETERS.H

 */

#import "LegDetailViewController.h"
#import "Parameters.h"
#import "SplitViewController.h"
#import "Cargo.h"


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
    NSURL *QLUrl;
    QuickTextViewController *quickText;
    QLPreviewController *apercu;
}

@end

@implementation LegDetailViewController

    //QuickTextViewController *quickText;
@synthesize crewTickSheet;
@synthesize legTableView;
@synthesize tickSheetView;

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==5 && indexPath.section == 3){

    }
}

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

    
    apercu = [[QLPreviewController alloc] init];
    apercu.delegate = self;
    apercu.dataSource = self;


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
    
    [self recalcAll];
    
    if ((mission = ((SplitViewController*)self.splitViewController).mission))
    {
        mission.delegate = self;
        
        leg = mission.activeLeg;
        legNumber = mission.activeLegIndex;
        
        
        
        if(!leg[@"cargoList"]){
           leg[@"cargoList"]=[[NSMutableArray alloc]init];
            }

        if (!mission.root[@"OriginalAircraft"])
            mission.root[@"OriginalAircraft"] = mission.root[@"Aircraft"];
        
        if (!mission.root[@"OriginalMissionNumber"])
            mission.root[@"OriginalMissionNumber"] = mission.root[@"MissionNumber"];

        
        if (!leg[@"OriginalCallSign"])
            leg[@"OriginalCallSign"] = leg[@"CallSign"];
        
        
        leg[@"OriginalBe"] = @"";
        
        if (!leg[@"Na"])
            leg[@"Na"] = @"22";
        
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

-(void) viewDidAppear:(BOOL)animated{
    if([mission.legs.firstObject[@"CallSign"] isEqualToString: @"CTM X2015"] || [mission.legs.firstObject[@"CallSign"] isEqualToString: @"CTMX2015"] || [mission.legs.firstObject[@"CallSign"] isEqualToString: @"X2015"]){
        

        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Important"
                                              message: [self convertHex:alert657]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction
                                  actionWithTitle:NSLocalizedString([self convertHex:alert243], @"action1")
                                  style:UIAlertActionStyleDefault
                                  handler:nil];
        
        UIAlertAction *action2 = [UIAlertAction
                                  actionWithTitle:NSLocalizedString([self convertHex:alert378], @"action2")
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action2)
                                  {
                                      [self dismissViewControllerAnimated:YES completion:nil];
                                      [self viewDidAppear:YES];
                                      
                                  }];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action3)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           [self viewDidAppear:YES];
                                           
                                       }];
        
        [alertController addAction:action2];
        
        [alertController addAction:action1];
        
        [alertController addAction:cancelAction];

        
        [self presentViewController:alertController animated:YES completion:nil];
            
        
        
        
    }
    if([mission.legs.firstObject[@"CallSign"] isEqualToString: @"CTM 6969"] || [mission.legs.firstObject[@"CallSign"] isEqualToString: @"CTM6969"] || [mission.legs.firstObject[@"CallSign"] isEqualToString: @"6969"]){
        
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Important"
                                              message: [self convertHex:alert069]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction
                                  actionWithTitle:NSLocalizedString([self convertHex:alert031], @"action1")
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action1)
                                  {
                                      [self dismissViewControllerAnimated:YES completion:nil];
                                      //afficher image
                                      UIViewController* ctl = [[UIViewController alloc] init];
                                      UIImageView *doge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doge.jpeg"]];
                                      //ajouter le fichier
                                      
                                      [ctl.view addSubview:doge];
                                      
                                      [self presentViewController: ctl animated:NO completion:^(void){
                                          [NSThread sleepForTimeInterval:5];
                                      }];
                                      [ctl dismissViewControllerAnimated:NO completion:nil];
                                      
                                  }];

        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action3)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
        

        
        [alertController addAction:action1];
        
        [alertController addAction:cancelAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
    }
    
    
    
}

-(NSString*) convertHex : (NSString*) command{
    
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    return [[NSString alloc]initWithData:commandToSend encoding:NSUTF8StringEncoding];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 2)
        return 1;
    else if(section==1)
        return 5;
    else if(section==0)
        return 3;
    else if(section==3)
        return 2;
    else if(section==4)
        return 6;
    else
        return 0;
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


    
    [self reloadColors];
    
    [self.tableView reloadData];
}

- (void)reloadColors
{
    UIColor *blackColor = [UIColor blackColor], *greenColor = [UIColor greenColor];
    
    aircraft.textColor = ([mission.root[@"Aircraft"] isEqualToString:mission.root[@"OriginalAircraft"]]) ? blackColor : greenColor;
    missionNumber.textColor = ([mission.root[@"MissionNumber"] isEqualToString:mission.root[@"OriginalMissionNumber"]]) ? blackColor : greenColor;
    callSign.textColor = ([leg[@"CallSign"] isEqualToString:leg[@"OriginalCallSign"]]) ? blackColor : greenColor;
    be.textColor = ([leg[@"Be"] isEqualToString:leg[@"OriginalBe"]]) ? blackColor : blackColor/* la ils avait mis green mais y a aucun interet*/;
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
            [quickText setValues: escadronList pref:nil sub:nil];
            break;
        case 2:
            [quickText setValues: immatriculationsList pref:nil sub:nil];
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
                [quickText setValues:@[previousLeg[@"Be"],beList] pref:nil sub:nil];
                break;
            case 6:
                [quickText setValues:@[previousLeg[@"Na"],naList] pref:nil sub:nil];
                break;
            case 7:
                [quickText setValues:@[previousLeg[@"FlightRules"],flightsRules] pref:nil sub:nil];
                break;
            case 8:
                [quickText setValues:@[previousLeg[@"TypeOfFlight"],typeOfFlightList] pref:nil sub:nil];
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
                [quickText setValues:@[beList] pref:nil sub:nil];
                break;
            case 6:
                [quickText setValues:@[naList] pref:nil sub:nil];
                break;
            case 7:
                [quickText setValues: @[flightsRules] pref:nil sub:nil];
                break;
            case 8:
                [quickText setValues:@[typeOfFlightList] pref:nil sub:nil];
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



# pragma mark - Quick Look

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    //NSURL *pdfUrl = [NSURL fileURLWithPath:[@"~/Documents/Atte station.pdf" stringByExpandingTildeInPath]];
    return QLUrl;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}


- (void) recalcAll{
    
    NSCalendar *cal= [NSCalendar currentCalendar];
    NSTimeZone *zeroZ = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *dateNulle = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
    NSCalendarUnit calendrier = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    [cal setTimeZone: zeroZ];
    NSTimeInterval ref = 0;
    
    //calcul de OnBlockTime
    NSDateComponents *bbt = [cal components: calendrier fromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:ref] toDate: leg[@"BetweenBlocksTime"] options: 0];
    NSDate *onBlocksTime = [cal dateByAddingComponents: bbt toDate:leg[@"OffBlocksTime"] options:0];
    leg[@"OnBlocksTime"]=onBlocksTime;
    
    
    
    NSUInteger secondCoef = [leg[@"SecondCoef"] integerValue];
    NSUInteger firstCoef = [leg[@"FirstCoef"] integerValue];
    
    
    NSDateComponents *difference = [cal components:calendrier fromDate:leg[@"NightTime"] toDate:leg[@"BetweenBlocksTime"] options:0];
    
    NSDate *DayTime =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
    
    leg[@"DayTime"]=DayTime;
    
    //
    if(secondCoef == 0){
        switch (firstCoef) {
            case 1:
                leg[@"Day10"]=DayTime;
                leg[@"Night10"]=leg[@"NightTime"];
                
                leg[@"Day35"]= dateNulle;
                leg[@"Night35"]= dateNulle;
                leg[@"Day22"]= dateNulle;
                leg[@"Night22"]= dateNulle;
                leg[@"Day62"]= dateNulle;
                leg[@"Night62"]= dateNulle;
                
                
                break;
            case 2:
                leg[@"Day62"]=DayTime;
                leg[@"Night62"]=leg[@"NightTime"];
                
                
                leg[@"Day35"]= dateNulle;
                leg[@"Night35"]= dateNulle;
                leg[@"Day22"]= dateNulle;
                leg[@"Night22"]= dateNulle;
                leg[@"Day10"]= dateNulle;
                leg[@"Night10"]= dateNulle;
                

                break;
            case 3:
                leg[@"Day35"]=DayTime;
                leg[@"Night35"]=leg[@"NightTime"];
                
                leg[@"Day10"]= dateNulle;
                leg[@"Night10"]= dateNulle;
                leg[@"Day22"]= dateNulle;
                leg[@"Night22"]= dateNulle;
                leg[@"Day62"]= dateNulle;
                leg[@"Night62"]= dateNulle;
                

                
                break;
            case 4:
                leg[@"Day22"]=DayTime;
                leg[@"Night22"]=leg[@"NightTime"];
                
                
                leg[@"Day35"]= dateNulle;
                leg[@"Night35"]= dateNulle;
                leg[@"Day10"]= dateNulle;
                leg[@"Night10"]= dateNulle;
                leg[@"Day62"]= dateNulle;
                leg[@"Night62"]= dateNulle;
                

                break;
            default:
                
                break;
        }
    }
    
    else{
        switch (firstCoef) {
            case 1:{
                NSDateComponents *difference2 = [cal components:calendrier fromDate:leg[@"Night10"] toDate:leg[@"NightTime"] options:0];
                
                NSDate *nightCompl =[cal dateByAddingComponents:difference2 toDate:dateNulle options:0];
                
                
                difference = [cal components:calendrier fromDate:leg[@"Day10"] toDate:leg[@"DayTime"] options:0];
                
                NSDate *dayCompl =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                
                
                switch (secondCoef) {
                    case 2:{
                        leg[@"Day62"]= dayCompl;
                        leg[@"Night62"]= nightCompl;
                        
                        leg[@"Day35"]= dateNulle;
                        leg[@"Night35"]= dateNulle;
                        leg[@"Day22"]= dateNulle;
                        leg[@"Night22"]= dateNulle;
                        
                        break;}
                        
                    case 3:
                        leg[@"Day35"]= dayCompl;
                        leg[@"Night35"]= nightCompl;
                        
                        leg[@"Day22"]= dateNulle;
                        leg[@"Night22"]= dateNulle;
                        leg[@"Day62"]= dateNulle;
                        leg[@"Night62"]= dateNulle;
                        break;
                        
                    case 4:
                        leg[@"Day22"]= dayCompl;
                        leg[@"Night22"]= nightCompl;
                        
                        leg[@"Day35"]= dateNulle;
                        leg[@"Night35"]= dateNulle;
                        leg[@"Day62"]= dateNulle;
                        leg[@"Night62"]= dateNulle;
                        break;
                        
                    default:
                        break;
                }
                
                break;}
            case 2:{
                NSDateComponents *difference2 = [cal components:calendrier fromDate:leg[@"Night62"] toDate:leg[@"NightTime"] options:0];
                
                NSDate *nightCompl =[cal dateByAddingComponents:difference2 toDate:dateNulle options:0];
                
                
                difference = [cal components:calendrier fromDate:leg[@"Day62"] toDate:leg[@"DayTime"] options:0];
                
                NSDate *dayCompl =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                
                
                switch (secondCoef) {
                    case 3:
                        leg[@"Day35"]= dayCompl;
                        leg[@"Night35"]= nightCompl;
                        
                        leg[@"Day10"]= dateNulle;
                        leg[@"Night10"]= dateNulle;
                        leg[@"Day22"]= dateNulle;
                        leg[@"Night22"]= dateNulle;
                        
                        break;
                        
                    case 4:
                        leg[@"Day22"]= dayCompl;
                        leg[@"Night22"]= nightCompl;
                        
                        leg[@"Day10"]= dateNulle;
                        leg[@"Night10"]= dateNulle;
                        leg[@"Day35"]= dateNulle;
                        leg[@"Night35"]= dateNulle;

                        
                    default:
                        break;
                }
                
                break;
            }
            case 3:{
                NSDateComponents *difference2 = [cal components:calendrier fromDate:leg[@"Night35"] toDate:leg[@"NightTime"] options:0];
                
                NSDate *nightCompl =[cal dateByAddingComponents:difference2 toDate:dateNulle options:0];
                
                
                difference = [cal components:calendrier fromDate:leg[@"Day35"] toDate:leg[@"DayTime"] options:0];
                
                NSDate *dayCompl =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                
                leg[@"Day22"]= dayCompl;
                leg[@"Night22"]= nightCompl;
                
                leg[@"Day10"]= dateNulle;
                leg[@"Night10"]= dateNulle;
                leg[@"Day62"]= dateNulle;
                leg[@"Night62"]= dateNulle;
                
                break;
            }
            default:
                
                break;
        }
        
        
        
        
        
        
    }
    
    BOOL cargAbsurde = NO;
    NSEnumerator *enume = [mission.Instances objectEnumerator];
    Cargo *carg;
    while(carg = [enume nextObject]){
        if(carg.absurde == YES)
            cargAbsurde = YES;
    }
    
    //Si des changments de leg ont rendus des cargos abusrdes (arrivé ou départ supprimé par exemple) on le signal à l'utilisateur ici!
    
    if(cargAbsurde == YES){
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Attention Cargo !"
                                              message:@"Some cargos don't make sense anymore, please verifiy them !"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        [alertController addAction:cancelAction];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    
    
}




@end

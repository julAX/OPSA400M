//
//  SecopsViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 11/02/2014.
//
//

#import "SecopsViewController.h"

#import "Mission.h"
#import "SplitViewController.h"
#import "AirportsData.h"

#import "CalcViewController.h"
#import "PersonnelViewController.h"
#import "QuickTextRefEntViewController.h"

//COMMENT X15 : Plus utilisé donc obsolète.

@interface SecopsViewController () {
    
    UITableViewCell *New;
    NSString *str;
    
    Mission *mission;
    NSMutableArray *crewMembers, *pilotes;
    NSMutableDictionary *pilote;
    
    UIPopoverController *popoverRef;
    UITextField *activeTextField;
}

@end

@implementation SecopsViewController

QuickTextRefEntViewController *quickTextRef;


-(CGSize)preferredContentSize {
   return CGSizeMake(600., 650.);
}

-(void) forcePopoverSize {
    CGSize currentSetSizeForPopover = self.preferredContentSize;
    CGSize fakeMomentarySize = CGSizeMake(currentSetSizeForPopover.width - 1.0f, currentSetSizeForPopover.height - 1.0f);
    self.preferredContentSize = fakeMomentarySize;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
 //Bouton sauvegarder
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self.splitViewController action:@selector(saveMission)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    space.width = 30.;
    
    self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, space, self.editButtonItem];
    
    //if (crewMembers.count==0)
        //[[[UIAlertView alloc] initWithTitle:@"Attention" message:@"Saisir les membres de l'équipage dans la rubrique CREW" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    
    

}
- (void)viewWillAppear:(BOOL)animated
{
       [super viewWillAppear:animated];
    
    [self forcePopoverSize];
    
    mission = ((SplitViewController*)self.presentingViewController).mission;
    crewMembers = [mission loadCrewMembers];
    
    pilotes =[NSMutableArray array];
    
    //Cette fonction sélectionne les membres d'équipage dont la fonction est PCB, Pcb ou PIL et les met dans un NSMutableArray pilotes
    
    for(NSDictionary *crewMember in crewMembers) {
        
        if ([crewMember[@"Function"] rangeOfString:@"Pcb" options:NSCaseInsensitiveSearch].location != NSNotFound)
            [pilotes addObject: crewMember];
        if ([crewMember[@"Function"] rangeOfString:@"PIL" options:NSCaseInsensitiveSearch].location != NSNotFound)
            [pilotes addObject: crewMember];
        
        
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGSize currentSetSizeForPopover = self.preferredContentSize;
    self.preferredContentSize = currentSetSizeForPopover;
}


- (IBAction)cancel:(id)sender {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     pilote = pilotes[indexPath.section];

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [pilotes[indexPath.section][@"Entrainement"] count]) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        New = [tableView cellForRowAtIndexPath:indexPath];
        
               quickTextRef.myDelegate = self;
        
        if (!quickTextRef)
            quickTextRef = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuickTextRefEnt"];
        

        
        [quickTextRef setValues:@[@"Flight Preparation",
                               @"Aeroplane External Visual Inspection",
                               @"Cockpit Inspection",
                               @"Use of C/L prior to Starting Engines",
                               @"Instrument Take-Off",
                               @"Cross-wind Take-Off",
                               @"Take-Off at Maximum Take-Off Weight",
                               @"Normal and Abnormal Operations of systems : engine and propeller",
                               @"Normal and Abnormal Operations of systems : pressurisation and air conditioning",
                               @"Normal and Abnormal Operations of systems : Pitot and static systems",
                               @"Normal and Abnormal Operations of systems : fuel system",
                               @"Normal and Abnormal Operations of systems : electrical system",
                               @"Normal and Abnormal Operations of systems : hydraulic system",
                               @"Normal and Abnormal Operations of systems :flight control and trim sytems",
                               @"Normal and Abnormal Operations of systems : anti-icing and de-icing system; ",
                               @"Normal and Abnormal Operations of systems : A/P and F/D system",
                               @"Normal and Abnormal Operations of systems : GPWS, weather radar and RA",
                               @"Normal and Abnormal Operations of systems : FMS system ans RN system",
                               @"Normal and Abnormal Operations of systems : landing gear and brakes",
                               @"Normal and Abnormal Operations of systems : flap system",
                               @"Normal and Abnormal Operations of systems : APU system",
                               @"Holding procedures",
                               @"CAT 1 approach manually",
                               @"CAT 1 approach manually with ILS",
                               @"CAT 1 approach with ILS and AP",
                               @"Non precision approach",
                               @"Circling approach",
                               @"Normal landing",
                               @"Cross-wind landings",
                               @"RVSM procedures",
                               @"Altimeter fault in RVSM area",
                               @"MNPS procedures", @"EVS approach",
                               @"RNP approach PF", @"RNP approach PM",
                               @"Day basic handling",
                               @"Night basic handling",
                               @"Day tactical arrival",
                               @"Night tactical arrival",
                               @"Steep descent",
                               @"Day low level flight",
                               @"Night low level flight"] pref:nil sub:nil];
        
       
        
        
        if (!popoverRef)
            
        popoverRef = [[UIPopoverController alloc] initWithContentViewController:quickTextRef];
        popoverRef.delegate = self;
        
        [popoverRef setPopoverContentSize:CGSizeMake(600., 650.) animated:YES];
        
        [popoverRef presentPopoverFromRect:New.frame inView:New.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
        // [self.tableView insertRowsAtIndexPaths:0 withRowAnimation:UITableViewRowAnimationAutomatic];
        //provoque bug
        //solution: créer un tableau entrainement par pilote et le remplir avec les entraînements saisis.
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return pilotes.count; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   return [pilotes objectAtIndex:section][@"Name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return [pilotes[section][@"EntArray"] count]+1; }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
        if (indexPath.row <[pilotes[indexPath.section][@"Entrainement"] count]) {
            cell = [tableView dequeueReusableCellWithIdentifier: @"PilCell" forIndexPath:indexPath];
            pilote = [pilotes objectAtIndex: indexPath.section];
            
            cell.textLabel.text = pilotes[indexPath.section][@"EntArray"][indexPath.row];
            
            //[entrainement sortUsingSelector:@selector(compare:)];
        }
        
        if (indexPath.row == [pilotes[indexPath.section][@"Entrainement"] count]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"NewCell" forIndexPath:indexPath];
        }
        
    return cell;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return (indexPath.row<[pilotes[indexPath.section][@"EntArray"] count]); }


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        pilote = [pilotes objectAtIndex: indexPath.section];
        [pilote[@"EntArray"] removeObjectAtIndex:indexPath.row];
        [pilote[@"Entrainement"] removeObjectForKey:[[[tableView cellForRowAtIndexPath:indexPath]textLabel]text]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

# pragma mark - TextField delegate

/*
 - (BOOL)textFieldShouldEndEditing:(UITextField*)textField {
 if (popover.isPopoverVisible)
 [popover dismissPopoverAnimated:YES];
 return YES;
 }
 

 - (BOOL)textFieldShouldReturn:(UITextField *)textField
 {
 [textField resignFirstResponder];
 return NO;
 }*/


# pragma mark - QuickTextDelegate

- (void)quickTextDidSelectString:(NSString *)string
{
    
    str= string;
    
    NSArray *lesCles = [NSArray arrayWithObjects: @"Flight Preparation",
                        @"Aeroplane External Visual Inspection",
                        @"Cockpit Inspection",
                        @"Use of C/L prior to Starting Engines",
                        @"Instrument Take-Off",
                        @"Cross-wind Take-Off",
                        @"Take-Off at Maximum Take-Off Weight",
                        @"Normal and Abnormal Operations of systems : engine and propeller",
                        @"Normal and Abnormal Operations of systems : pressurisation and air conditioning",
                        @"Normal and Abnormal Operations of systems : Pitot and static systems",
                        @"Normal and Abnormal Operations of systems : fuel system",
                        @"Normal and Abnormal Operations of systems : electrical system",
                        @"Normal and Abnormal Operations of systems : hydraulic system",
                        @"Normal and Abnormal Operations of systems :flight control and trim sytems",
                        @"Normal and Abnormal Operations of systems : anti-icing and de-icing system",
                        @"Normal and Abnormal Operations of systems : A/P and F/D system",
                        @"Normal and Abnormal Operations of systems : GPWS, weather radar and RA",
                        @"Normal and Abnormal Operations of systems : FMS system ans RN system",
                        @"Normal and Abnormal Operations of systems : landing gear and brakes",
                        @"Normal and Abnormal Operations of systems : flap system",
                        @"Normal and Abnormal Operations of systems : APU system",
                        @"Holding procedures",
                        @"CAT 1 approach manually",
                        @"CAT 1 approach manually with ILS",
                        @"CAT 1 approach with ILS and AP",
                        @"Non precision approach",
                        @"Circling approach",
                        @"Normal landing",
                        @"Cross-wind landings",
                        @"RVSM procedures",
                        @"Altimeter fault in RVSM area",
                        @"MNPS procedures", @"EVS approach",
                        @"RNP approach PF", @"RNP approach PM",
                        @"Day basic handling",
                        @"Night basic handling",
                        @"Day tactical arrival",
                        @"Night tactical arrival",
                        @"Steep descent",
                        @"Day low level flight",
                        @"Night low level flight", nil];
    
    NSArray *lesObjets = [NSArray arrayWithObjects: @"RE1",
                          @"RE2", @"RE3", @"RE4", @"RE5",@"RE6",
                          @"RE7", @"RE8", @"RE9", @"RE10", @"RE11",
                          @"RE12", @"RE13", @"RE14", @"RE15",@"RE16",
                          @"RE17", @"RE18", @"RE19", @"RE20", @"RE21",
                          @"RE22", @"RE23", @"RE24", @"RE25",@"RE26",
                          @"RE27", @"RE28", @"RE29", @"RE30", @"RE31",
                          @"RE32", @"RE33", @"RE34", @"RE35",@"RE36",
                          @"RE37", @"RE38", @"RE39", @"RE40", @"RE41",
                          @"RE42", nil];
    NSDictionary *referentielEntrainement = [[NSDictionary alloc] initWithObjects: lesObjets forKeys: lesCles];
    
    [pilote[@"Entrainement"] setObject: [referentielEntrainement objectForKey: str] forKey: str];
    if (![pilote[@"EntArray"] containsObject: str]){
        [pilote[@"EntArray"] addObject: str];
    }
    
    [self.tableView reloadData];
     [New resignFirstResponder];
    
}


# pragma mark - PopoverDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    
    [New resignFirstResponder];
}

- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view
{
    if (popoverRef == popoverController)
    {
        *rect = New.frame;
    }
}


@end


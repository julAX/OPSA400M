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
        

        
        [quickTextRef setValues:@[@"Last Flight or FFS",
                                  @"Academic Control",
                                  @"Type rating skill test",
                                  @"Line check",
                                  @"Type rating instructor control",
                                  @"Rejected take-off",
                                  @"Take-Off with engine failure between V1 and V2",
                                  @"Precision approach to minima with one engine inoperative ",
                                  @"Non precision approach to minima",
                                  @"Missed approach on instrument from minima with one engine inoperative",
                                  @"Landing with one engine inoperative ",
                                  @"ILS CAT II approach",
                                  @"G/A at DH after CAT II approach",
                                  @"Landing after CAT II approach",
                                  @"LVTO at the lowest applicable minima",
                                  @"Three ferry flight",
                                  @"RVSM procedures",
                                  @"MNPS procedures",
                                  @"EVS approach",
                                  @"RNP approach",
                                  @"Day basic handling",
                                  @"Night basic handling",
                                  @"Electronic warfare",
                                  @"CSAR procedures",
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
    mission.root[@"RefEntIndicators"]=@"0";
    for(NSDictionary *pilot in pilotes){
        if([pilot[@"EntArray"] count]){
            mission.root[@"RefEntIndicators"]=@"1";
        }
    }
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
    
    NSArray *lesCles = [NSArray arrayWithObjects: @"Last Flight or FFS",
                        @"Academic Control",
                        @"Type rating skill test",
                        @"Line check",
                        @"Type rating instructor control",
                        @"Rejected take-off",
                        @"Take-Off with engine failure between V1 and V2",
                        @"Precision approach to minima with one engine inoperative ",
                        @"Non precision approach to minima",
                        @"Missed approach on instrument from minima with one engine inoperative",
                        @"Landing with one engine inoperative ",
                        @"ILS CAT II approach",
                        @"G/A at DH after CAT II approach",
                        @"Landing after CAT II approach",
                        @"LVTO at the lowest applicable minima",
                        @"Three ferry flight",
                        @"RVSM procedures",
                        @"MNPS procedures",
                        @"EVS approach",
                        @"RNP approach",
                        @"Day basic handling",
                        @"Night basic handling",
                        @"Electronic warfare",
                        @"CSAR procedures",
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
                          @"RE27", @"RE28", @"RE29", nil];
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


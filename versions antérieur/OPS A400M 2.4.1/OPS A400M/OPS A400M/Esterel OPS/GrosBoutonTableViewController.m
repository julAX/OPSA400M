//
//  GrosBoutonTableViewController.m
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import "GrosBoutonTableViewController.h"
#import "CrewViewController.h"
#import "SplitViewController.h"
#import "Cargo.h"

/*
 COMMENTS X15 
 
 Le controller qui s'ouvre au bouton "Fill Out The OMA". le nom vient du fait qu'il y a jsute 4 gros boutons.... voilà.
 
 
 
 */


@interface GrosBoutonTableViewController (){
    Mission *mission;
    NSMutableDictionary *leg;
    

}

@end

@implementation GrosBoutonTableViewController

- (void)activeLegDidChange:(NSInteger)legNumber
{
    leg = mission.activeLeg;
    [self recalcAll];
    [self coloriage];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    mission = ((SplitViewController*)self.splitViewController).mission;
    leg = mission.activeLeg;
    mission.delegate=self;
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 4;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //A la première leg on demande le fuel avant décollage. Pour les autres on le demande pas, car il est égal au fuel de la fin d'avant (demandez aux sicops si vous êtes pas d'accord, c'est comme ca qu'ils le debriefent)
    
    if(indexPath.row==4){
        if(mission.activeLegIndex==0){
            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6003"];
            [self.navigationController pushViewController:pushVC animated:YES];
        }
        else{
            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6001"];
            [self.navigationController pushViewController:pushVC animated:YES];
        }
        
    
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 232.5;
}
//Ici on reload plein de valeur pour être sur que si l'utilisateur se bare au milieu de "Arrival" par exemple, les modifications qu'il a mise ont leur repercussions dans le reste. On refait plein de calculs quoi.

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self recalcAll];

}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    mission.delegate=self;
    [self recalcAll];
    [self coloriage];
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = grisFonce;
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    header.contentView.backgroundColor = grisFonce;
}


-(void)coloriage{
    
    [mission indicatorsForLeg:mission.activeLegIndex];
    
    [mission.masterView.tableView reloadData];
    
    
    NSIndexPath *path =[NSIndexPath indexPathForRow:((mission.activeLegIndex<mission.legs.count)? mission.activeLegIndex: mission.legs.count - 1 )inSection:0];
    
    
    [mission.masterView.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    

    [self indicators];
    
    NSDictionary * indicators = leg[@"Indicators"];
    
    [self.Crew setTextColor:([indicators[@"Crew"][1] isEqualToString:@"1"])? vert : (([indicators[@"Crew"][0] isEqualToString:@"1"])? jone2 : rouge)];
    [self.Arrival setTextColor:([indicators[@"Arrival"][1] isEqualToString:@"1"])? vert : (([indicators[@"Arrival"][0] isEqualToString:@"1"])? jone2 : rouge)];
    [self.Departure setTextColor:([indicators[@"Departure"][1] isEqualToString:@"1"])? vert : (([indicators[@"Departure"][0] isEqualToString:@"1"])? jone2 : rouge)];
    //[self.PaxAndFreight setTextColor:([indicators[@"PaxAndFreight"][1] isEqualToString:@"1"])? vert : (([indicators[@"PaxAndFreight"][0] isEqualToString:@"1"])? jone2 : rouge)];
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
    
    if(!leg[@"LandingTime"])
        leg[@"LandingTime"] = [NSDate date];
    
    
    
    NSDateComponents *ft = [cal components: calendrier fromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:ref] toDate: leg[@"FlightTime"] options: 0];
    NSDate *landingTime = [cal dateByAddingComponents: ft toDate:leg[@"TakeOffTime"] options:0];
    leg[@"LandingTime"]=landingTime;
    
    
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

-(void) indicators{
    NSMutableArray *crewMembers = [mission loadCrewMembersInLeg:mission.activeLegIndex];
    
    NSMutableArray *pilotes =[NSMutableArray array];
    
    //Cette fonction sélectionne les membres d'équipage dont la fonction est PCB, Pcb ou PIL et les met dans un NSMutableArray pilotes Puis on regarde si chacun a une place attribuée.
    
    for(NSDictionary *crewMember in crewMembers) {
        
        if ([crewMember[@"Function"] rangeOfString:@"Pcb" options:NSCaseInsensitiveSearch].location != NSNotFound)
            [pilotes addObject: crewMember];
        if ([crewMember[@"Function"] rangeOfString:@"PIL" options:NSCaseInsensitiveSearch].location != NSNotFound)
            [pilotes addObject: crewMember];
        if ([crewMember[@"Function"] rangeOfString:@"CDB" options:NSCaseInsensitiveSearch].location != NSNotFound)
            [pilotes addObject: crewMember];
        
        
        
    }
    
    NSMutableDictionary * indic = leg[@"Indicators"];
    
    BOOL finished = YES;
    BOOL enCours = NO;
    
    for (NSDictionary *pilote in pilotes){
        if(![pilote[@"Position"] isEqualToString:@""] && pilote[@"Position"]){
            enCours = YES;
        }
        else{
            finished = NO;
        }
    }
    
    indic[@"Crew"][0] = (enCours)?@"1":@"0";
    indic[@"Crew"][1] = (finished)?@"1":@"0";
    
    indic[@"PaxAndFreight"][0]=@"1";
    indic[@"PaxAndFreight"][1]=@"1";

    
    
//    if(mission.Instances.count == 0){
//        indic[@"PaxAndFreight"][0]=@"0";
//        indic[@"PaxAndFreight"][1]=@"0";
//    }
//    else{
//        indic[@"PaxAndFreight"][0]=@"1";
//        if([indic[@"Departure"][1] isEqualToString:@"1"] && [indic[@"Crew"][1] isEqualToString:@"1"])
//            indic[@"PaxAndFreight"][1]=@"1";
//    }
    
//    if([indic[@"Departure"][1] isEqualToString:@"1"] && [indic[@"Arrival"][1] isEqualToString:@"1"] && [indic[@"Crew"][1] isEqualToString:@"1"] && [indic[@"PaxAndFreight"][1] isEqualToString:@"0"]){
//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:@"Attention Cargo "
//                                              message:@"There is nothing in 'Pax and Freight'"
//                                              preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *normalAction = [UIAlertAction
//                                       actionWithTitle:NSLocalizedString(@"That's normal", @"Normal action")
//                                       style:UIAlertActionStyleDefault
//                                       handler:^(UIAlertAction *action1){
//                                           indic[@"PaxAndFreight"][0]=@"1";
//                                           indic[@"PaxAndFreight"][1]=@"1";
//                                       
//                                       }];
//        UIAlertAction *cancelAction = [UIAlertAction
//                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
//                                       style:UIAlertActionStyleCancel
//                                       handler:nil];
//        
//        [alertController addAction:normalAction];
//        [alertController addAction:cancelAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//    }


}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
    // Configure the cell...
 
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vue = segue.destinationViewController;
    vue.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    
    
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

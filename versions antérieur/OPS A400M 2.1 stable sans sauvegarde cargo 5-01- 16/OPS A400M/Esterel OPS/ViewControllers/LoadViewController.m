//
//  LoadViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 10/01/2014.
//
//

#import "LoadViewController.h"

#import "SplitViewController.h"
#import "FuelCell.h"
#import "PaveNumViewController.h"


@interface LoadViewController ()
{
    Mission *mission;
    NSInteger legNumber;
    NSMutableDictionary *leg;
    NSMutableArray *paxCargoTab;
}
@end

@implementation LoadViewController

- (void)activeLegDidChange:(NSInteger)l
{
    legNumber = l;
    leg = mission.activeLeg;
    
    paxCargoTab = leg[@"PaxCargo"];
    [self recalcLoad];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSRangeFromString(@"0,3")] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    space.width = 30.;
    
    self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, space, self.editButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (mission != ((SplitViewController*)self.splitViewController).mission)
        legNumber = ((SplitViewController*)self.splitViewController).mission.activeLegIndex;
    
    mission = ((SplitViewController*)self.splitViewController).mission;
    mission.delegate = self;
    
    //legNumber = mission.activeLegIndex;
    leg = mission.activeLeg;
    
    paxCargoTab = leg[@"PaxCargo"];
    [self recalcLoad];
    
    if (legNumber != mission.activeLegIndex) {
        legNumber = mission.activeLegIndex;
        [self.tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    mission.delegate = nil;
}

//Remplit la case 'Already on board' du premier leg avec 0, pour les legs suivants avec la valeur 'totalEnd du leg précédent (où totalEnd = In - Out

- (void)recalcLoad
{
    NSUInteger index;
    
    for (NSString *pref in @[@"Pax", @"Cargo"]){
        
        for (index = 0; index < (paxCargoTab.count - 1); index++){
            
            NSMutableDictionary *dict = mission.legs.firstObject[@"PaxCargo"][index];
            
            dict[[pref stringByAppendingString:@"OnBoard"]] = @"0";
            
            long totalEnd = [dict[[pref stringByAppendingString:@"In"]] integerValue] - [dict[[pref stringByAppendingString:@"Out"]] integerValue] - [dict[[pref stringByAppendingString:@"Dropped"]] integerValue];
            
            for (NSUInteger legIndex = 1; legIndex < mission.legs.count; legIndex++){
                
                dict = mission.legs[legIndex][@"PaxCargo"][index];
                
                dict[[pref stringByAppendingString:@"OnBoard"]] = @(totalEnd).description;
                
                totalEnd += [dict[[pref stringByAppendingString:@"In"]] integerValue] - [dict[[pref stringByAppendingString:@"Out"]] integerValue];
            }
        }
        
        for (NSMutableDictionary *oneLeg in mission.legs){
            
            NSMutableArray *paxCargos = oneLeg[@"PaxCargo"];
            
            for (NSString *key in @[@"In", @"OnBoard", @"Dropped", @"Out"])
            {
                NSInteger sum = 0;
                NSString *fullKey = [pref stringByAppendingString:key];
                
                for (index = 0; index < (paxCargoTab.count - 1); index++)
                    sum += [paxCargos[index][fullKey] integerValue];
                
                
                paxCargos.lastObject[fullKey] = @(sum).description;
            }
        }
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 3; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return @"Fuel (kg)";
            break;
        case 1: return @"Pax";
            break;
        case 2: return @"Cargo (kg)";
            break;
        default: return @"Error";
            break;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return (indexPath.section == 0) ? 178. : -1.; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return (section == 0) ? 1 : (paxCargoTab.count + 2); }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        FuelCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FuelCell" forIndexPath:indexPath];
        [cell initWithLeg:legNumber inMission:mission];
        return cell;
        
    }
    
    else{
        
        if (indexPath.row == paxCargoTab.count + 1)
            return [tableView dequeueReusableCellWithIdentifier:@"AddNationalityCell" forIndexPath:indexPath];
        
        else {
            PaxCargoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaxCargoCell" forIndexPath:indexPath];
            
            if (indexPath.row != 0) {
                cell.delegate = self;
                NSMutableDictionary *paxCargoDict = paxCargoTab[indexPath.row - 1];
                [cell initWithPaxCargo:paxCargoDict pax:(indexPath.section == 1) editable:(indexPath.row != paxCargoTab.count)];
            }
            else
                [cell resetCell];
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section != 0) && (indexPath.row == paxCargoTab.count + 1))
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
        CargoTableViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"4000"];
        [self.navigationController pushViewController:pushVC animated:YES];

        /* modif X2015 : Plus aucun rapport avec la mise en forme actuelle
         
        [mission addPaxCargo];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(paxCargoTab.count - 1) inSection:1], [NSIndexPath indexPathForRow:(paxCargoTab.count - 1) inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
         */
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((indexPath.section !=0) && (indexPath.row > 4) && (indexPath.row < paxCargoTab.count));
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [mission deletePaxCargoAtIndex:(indexPath.row - 1)];
        
        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:1], [NSIndexPath indexPathForRow:indexPath.row inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - PaxCargoCell delegate

- (void)paxCargoCellDidChange:cell
{
    [self recalcLoad];
    [cell reloadLabels];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [(PaxCargoCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:paxCargoTab.count inSection:indexPath.section]] reloadLabels];
}


- (void)paxCargoCell:(PaxCargoCell*)cell NameDidChange:(NSString*)name
{
    NSMutableArray *paxCargos;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSInteger index = indexPath.row - 1;
    
    
    for (NSDictionary *oneLeg in mission.legs) {
        paxCargos = oneLeg[@"PaxCargo"];
        paxCargos[index][@"Name"] = name;
    }
    
    [((PaxCargoCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:((indexPath.section == 1) ? 2 : 1)]]) reloadLabels];
}



@end

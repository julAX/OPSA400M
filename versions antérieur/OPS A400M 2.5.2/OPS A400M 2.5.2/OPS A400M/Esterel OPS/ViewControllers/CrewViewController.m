//
//  CrewViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 21/01/2014.
//
//

#import "CrewViewController.h"

#import "SplitViewController.h"
#import "CrewMemberCell.h"

/*
 
 COMMENT X15 : comme son nom l'indique, cette classe gère la vue qui affiche l'équipage. voila
 
 */

@interface CrewViewController () {
    
    Mission *mission;
    NSMutableArray *crew;
}

@end

@implementation CrewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    space.width = 30.;
    
    self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, space, self.editButtonItem];
    
    }


- (void)activeLegDidChange:(NSInteger)l
{
    crew = [NSMutableArray array];
    NSMutableDictionary *leg = mission.activeLeg;
    
    crew = leg[@"CrewMember"];
    
   if (!leg[@"OriginalCrewMember"])
        leg[@"OriginalCrewMember"] = [crew deepCopy];
    
    if (self.splitViewController.presentedViewController)
        [self.tableView reloadData];
    else
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    crew = [NSMutableArray array];
    
    mission = ((SplitViewController*)self.splitViewController).mission;
    mission.delegate = self;
    
    NSMutableDictionary *leg = mission.activeLeg;
    
    crew = leg[@"CrewMember"];
    
    if (!leg[@"OriginalCrewMember"])
        leg[@"OriginalCrewMember"] = [crew deepCopy];
    
}

//Bouton Copy From Previous Leg

- (IBAction)copyPrevious:(UIButton *)sender {
    
    NSInteger i = mission.activeLegIndex;
    if (i>0) {
    NSMutableDictionary *previousLeg = mission.legs[i-1];
    NSMutableDictionary *leg = mission.activeLeg;
    
    leg[@"CrewMember"] = [previousLeg[@"CrewMember"] mutableCopy];
    
    
    crew = leg[@"CrewMember"];
    
    if (!leg[@"OriginalCrewMember"])
        leg[@"OriginalCrewMember"] = [crew deepCopy];

    if (self.splitViewController.presentedViewController)
       [self.tableView reloadData];
    else
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}



#pragma mark - Table view data source
//Lorsqu'on clique sur NEW
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == crew.count)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        [crew addObject: [mission getCrewMemberVierge]];
           
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return crew.count + 1; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //modifs copyprev
    if (indexPath.row < crew.count)
    {
        static NSString *CellIdentifier = @"CrewMemberCell";
        CrewMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        [cell setCrewMember:crew[indexPath.row]];
        
        return cell;
    }
    else
    {
        return [tableView dequeueReusableCellWithIdentifier:@"NewCell" forIndexPath:indexPath];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return (indexPath.row != crew.count); }

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return [NSIndexPath indexPathForRow:((proposedDestinationIndexPath.row == crew.count) ? (crew.count - 1) : proposedDestinationIndexPath.row) inSection:0];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [crew removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row != crew.count);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableDictionary *movingCrew = crew[sourceIndexPath.row];
    [crew removeObjectAtIndex:sourceIndexPath.row];
    [crew insertObject:movingCrew atIndex:destinationIndexPath.row];
}



@end

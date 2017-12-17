//
//  LegsViewController.m
//  Esterel OPS
//
//  Created by utilisateur on 16/12/13.
//
//

/*
 La master view est chargée de présenter les différents legs de la mission, et permet de les sélectionner, de les supprimer ou bien d'en ajouter.
 La procédure SignByOrder n'étant pas utile sur A400M à Orléans, l'onglet a été supprimé mais il est possible de le rajouter facilement en cas de besoin (cf suite du code dans ce fichier)
 */


#import "LegMasterViewController.h"

#import "Mission.h"
#import "SplitViewController.h"

@interface LegMasterViewController () {
    
    Mission *mission;
    NSMutableArray *legs;
    
    NSIndexPath *deletingRow;
}

@end


@implementation LegMasterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                          target:self.splitViewController
//                                                                                          action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStyleBordered target:self.splitViewController action:@selector(cancel)];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    mission = ((SplitViewController*)self.splitViewController).mission;
    legs = mission.legs;
    
    if (mission)
    {
//        if (mission.activeLegIndex >= legs.count)
//            mission.activeLegIndex = legs.count - 1;
        
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mission.activeLegIndex inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Table view data source

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mission.activeLegIndex inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { return (section == 0) ? @"Legs" : @"Tools"; }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 2; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return (section == 0) ? legs.count + 1 : 5; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == legs.count)
            return [tableView dequeueReusableCellWithIdentifier:@"NewLeg" forIndexPath:indexPath];
        
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LegCell"
                                                                    forIndexPath:indexPath];
            
            NSDictionary *leg = legs[indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"Leg %ld", (long)(indexPath.row + 1)];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                         leg[@"DepartureAirport"],
                                         leg[@"ArrivalAirport"]];
            
            return cell;
        }
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"OMA PDF";
                break;
            case 1:
                cell.textLabel.text = @"Entraînement";
                break;
            case 2:
                cell.textLabel.text = @"Exploitation";
                break;
            //case 3:
               // cell.textLabel.text = @"Signature par ordre";
               // break;
            case 3:
                cell.textLabel.text = @"Attestation de vol";
                break;
            case 4:
                cell.textLabel.text = @"Sicops";
                break;
            default:
                cell.textLabel.text = @"Error";
                break;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == legs.count) {
            
            [mission addLeg];
            
            [tableView insertRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
            
            mission.activeLegIndex = indexPath.row;

            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        else
        {
            mission.activeLegIndex = indexPath.row;
            //[[self.splitViewController.viewControllers.lastObject topViewController] viewWillAppear:NO];
        }
    }
    else {
        
        switch (indexPath.row) {
            case 0:
                [(SplitViewController*)self.splitViewController openOMA];
                break;
            case 1:
                [(SplitViewController*)self.splitViewController openSecopsView];
                break;
            case 2:
                [(SplitViewController*)self.splitViewController openExploitView];
                break;
            //case 3:
               // [(SplitViewController*)self.splitViewController openSignByOrder];
               // break;
            case 3:
                [(SplitViewController*)self.splitViewController openAttestation];
                break;
            case 4:
                [(SplitViewController*)self.splitViewController openSicopsView];
                break;
        }
        
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mission.activeLegIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((indexPath.section == 0) && (indexPath.row < legs.count));
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        deletingRow = indexPath;
        
        [[[UIAlertView alloc] initWithTitle:@"Supprimer" message:@"Etes vous sûr de vouloir supprimer cette étape?" delegate:self cancelButtonTitle:@"Non" otherButtonTitles:@"Oui", nil] show];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [mission deleteLegAtIndex:deletingRow.row];
        
        if (legs.count == 0)
        {
            [mission addLeg];
            [self.tableView reloadRowsAtIndexPaths:@[deletingRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            [self.tableView deleteRowsAtIndexPaths:@[deletingRow] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            NSMutableArray *cellToReload = [NSMutableArray arrayWithCapacity:(legs.count - deletingRow.row + 1)];
            
            for (NSInteger i = deletingRow.row; i < legs.count; i++)
                [cellToReload addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            
            [self.tableView reloadRowsAtIndexPaths:cellToReload withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        mission.activeLegIndex = (deletingRow.row < mission.activeLegIndex) ? mission.activeLegIndex - 1 : ((mission.activeLegIndex == legs.count) ? legs.count - 1 : mission.activeLegIndex);
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mission.activeLegIndex inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
    }
    else
        [self setEditing:NO animated:YES];
}


# pragma mark - Moving legs

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return [NSIndexPath indexPathForRow:((proposedDestinationIndexPath.row == legs.count || proposedDestinationIndexPath.section != 0) ? (legs.count - 1) : proposedDestinationIndexPath.row) inSection:0];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0 && indexPath.row < legs.count);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableDictionary *movingLeg = legs[sourceIndexPath.row];
    [legs removeObjectAtIndex:sourceIndexPath.row];
    [legs insertObject:movingLeg atIndex:destinationIndexPath.row];
    
    movingLeg[@"DepartureAirport"] = (destinationIndexPath.row == 0) ? @"LFOJ" : legs[destinationIndexPath.row - 1][@"ArrivalAirport"];
    movingLeg[@"ArrivalAirport"] = (destinationIndexPath.row == legs.count - 1) ? @"LFOJ" : legs[destinationIndexPath.row + 1][@"DepartureAirport"];

    mission.activeLegIndex = tableView.indexPathForSelectedRow.row;
    
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mission.activeLegIndex inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

@end

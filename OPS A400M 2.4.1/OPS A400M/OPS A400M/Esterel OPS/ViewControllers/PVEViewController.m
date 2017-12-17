//
//  PVEViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 30/01/2014.
//
//

#import "PVEViewController.h"

#import "SplitViewController.h"
#import "MessageViewController.h"

#import "TimeTools.h"

//COMMENT X15 : Plus utilisé (pour le remettre, permettre l'affichage du bouton dans legDetailViewController en changeant le nombre de cases affichées dans la bonne section ! (voir avec le storyboard, y a plus de cases que celles qui apparaissent dans l'application une fois lancée.

@interface PVEViewController () {
    
    Mission *mission;
    NSMutableArray *messages;
    
    NSInteger beginIndex;
}

@end

@implementation PVEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    space.width = 30.;

    self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, space, self.editButtonItem];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)activeLegDidChange:(NSInteger)leg
{
    messages = mission.activeLeg[@"Message"];
    
    beginIndex = [self messageNumberForFirstMessageInLeg:leg];
    
    [self.navigationController popToViewController:self animated:YES];
    
    if (self.splitViewController.presentedViewController)
        [self.tableView reloadData];
    else
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    mission = ((SplitViewController*)self.splitViewController).mission;
    mission.delegate = self;
    
    messages = mission.activeLeg[@"Message"];
    
    beginIndex = [self messageNumberForFirstMessageInLeg:mission.activeLegIndex];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == messages.count)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSMutableDictionary *nouv = [mission getMessageVierge];
        
        nouv[@"IndicatifE"] = mission.activeLeg[@"CallSign"];
        
        if (messages.count)
        {
            nouv[@"Frequence"] = messages.lastObject[@"Frequence"];
            nouv[@"Heure"] = messages.lastObject[@"ProchainContact"];
            nouv[@"TypeMessage"] = @"POSITION";
        }
        
        [messages addObject:nouv];
        
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
        [self performSegueWithIdentifier:@"PVESegue" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return messages.count + 1; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row != messages.count)
    {
        NSMutableDictionary *message = messages[indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"PVECell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"Msg n°%ld: %@", (long)(beginIndex + indexPath.row), message[@"TypeMessage"]];
        NSLog(@"%@", message[@"TypeMessage"]);
        cell.detailTextLabel.text = [TimeTools stringFromTime:message[@"Heure"] withDays:NO];
        
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NewCell" forIndexPath:indexPath];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return (indexPath.row != messages.count); }

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return [NSIndexPath indexPathForRow:((proposedDestinationIndexPath.row == messages.count) ? (messages.count - 1) : proposedDestinationIndexPath.row) inSection:0];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [messages removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row != messages.count);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableDictionary *movingMessage = messages[sourceIndexPath.row];
    [messages removeObjectAtIndex:sourceIndexPath.row];
    [messages insertObject:movingMessage atIndex:destinationIndexPath.row];
    
    [tableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PVESegue"])
    {
        NSInteger index = self.tableView.indexPathForSelectedRow.row;
        MessageViewController *vc = (MessageViewController*)segue.destinationViewController;
        
        vc.message = messages[index];
        vc.messageNumber = index + beginIndex;
        
        vc.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    }
}

- (NSInteger)messageNumberForFirstMessageInLeg:(NSInteger)index
{
    NSInteger number = 1;
    
    for (NSUInteger i = 0; i < index; i++)
        number += ((NSArray*)mission.legs[i][@"Message"]).count;
    
    return number;
}




@end

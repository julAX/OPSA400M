//
//  MESViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 04/02/2014.
//
//

#import "MESViewController.h"
#import "parameters.h"
#import "SplitViewController.h"
#import "MESCell.h"

#import "TimeTools.h"





@interface MESViewController () {
    
    Mission *mission;
    NSMutableDictionary *leg;
    NSInteger legNumber;
    
    NSIndexPath *mailIndexPath;
    NSMutableArray *messages;
    NSArray *legs;
}

@end

@implementation MESViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    mission = ((SplitViewController*)self.presentingViewController).mission;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    space.width = 30.;
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:mission action:@selector(save)], space, self.editButtonItem];

}


- (void)activeLegDidChange:(NSInteger)l
{
    legNumber = l;
    leg = mission.activeLeg;
    messages = leg[@"MES"];
    
    if (self.splitViewController.presentedViewController)
        [self.tableView reloadData];
    else
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    mission = ((SplitViewController*)self.presentingViewController).mission;


    mission.delegate = self;
    legs = mission.legs;
    legNumber = mission.activeLegIndex;
    leg = [legs objectAtIndex: 0];
    messages = leg[@"MES"];
    
}

#pragma mark - Table view data source

//Lorsqu'on clique sur Add Message (que se passe-t-il avec le cdb ??)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == messages.count)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSMutableDictionary* mesVierge = [mission getMesVierge];
        
        mesVierge[@"CDB"] = [mission cdbForLeg:0];
        
        
        [messages addObject:mesVierge];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return messages.count + 1; }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (!(indexPath.row == messages.count)) ? 655 : ((indexPath.row == messages.count)) ? 44 : [super tableView:tableView heightForRowAtIndexPath:indexPath]; }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < messages.count)
    {
        static NSString *CellIdentifier = @"MESCell";
        MESCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        // A quoi sert cette ligne?
        [cell setMES:messages[indexPath.row]];
        
        return cell;
    }
else
    {
        return [tableView dequeueReusableCellWithIdentifier:@"NewCell" forIndexPath:indexPath];
    }
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
}


# pragma mark - Mail

- (IBAction)sendMail:(UIButton *)sender {


    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
        mailView.mailComposeDelegate = self;
        [mailView setModalPresentationStyle:UIModalPresentationFormSheet];
        
        
        id up = [sender superview];
        
        while (![up isKindOfClass:[UITableViewCell class]])
            up = [up superview];
        
        mailIndexPath = [self.tableView indexPathForCell:(UITableViewCell*)up];
        
        NSDictionary *messagePourMail = messages[mailIndexPath.row];
        NSString *route = [mission route];
        
        
        
        [mailView setSubject:[NSString stringWithFormat:@"Compte-rendu: mission n°%@ %@", mission.root[@"MissionNumber"], route]];

        
        // ajouter ici toutes les adresses des gens qui doivent recevoir le debrief SV :
        [mailView setToRecipients: feedbackMailList];
        NSString *corpsDuMessage;
        if (![messagePourMail[@"Message"] isEqual: @""]) {
            corpsDuMessage = messagePourMail[@"Message"]; }
        else {
            corpsDuMessage=@"HANDLING : (NAVDB, failures)\n\n\n"
            "AIRCRAFT : (Crew survey, parking, poc, handling services)\n\n\n"
            "EFB's : (calculation errors, documentation, airport database)\n\n\n"
            "A/EFB's : (electronic documentation)\n\n\n"
            "CESAM : (mission briefing/flight folder, dispatch, performance engineering)\n\n\n";
        }
        
        [mailView setMessageBody:[NSString stringWithFormat:
                                  @"CREW FEEDBACK FORM\n\n"
                                  
                                  "N°mission : %@\n"
                                  "Aircraft : %@\n"
                                  "Unit : %@\n"
                                  "From : %@\n"
                                  "To : %@\n"
                                  "CallSign : %@\n"
                                  "Route : %@\n\n"
                                  
                                  //"Leg : %ld\n"
                                  "Destinataires : CDT KUDELA, CDT WIJAS, CNE PERSICO, CNE SEGARD, CNE EVRARD, CNE HENNEGUEZ, MAJ AUFFRET"
                                  "CDB : %@\n\n"
                                  
                                  "Message : \n%@",
                                  mission.root[@"MissionNumber"],
                                  mission.root[@"Aircraft"], mission.root[@"Unit"],
                                  [TimeTools stringFromDate:mission.legs.firstObject[@"OffBlocksTime"]],
                                  [TimeTools stringFromDate:mission.legs.lastObject[@"OnBlocksTime"]],
                                  leg[@"CallSign"],
                                  [mission route],
                                  //(long)(legNumber + 1),
                                  //messagePourMail[@"Destinataire"],
                                  //messagePourMail[@"CDB"],
                                  [mission cdbForLeg:0],
                                  
                                  corpsDuMessage] isHTML:NO];
        
        
        
        [self presentViewController:mailView animated:YES completion:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Failure"
                                    message:@"Your device doesn't support the composer sheet"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
    }
}

- (IBAction)cancel:(id)sender {
    
        [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultSent) {
        
        messages[mailIndexPath.row][@"Transmis"] = @"TRANSMIS";
        ((MESCell*)[self.tableView cellForRowAtIndexPath:mailIndexPath]).transmis.selectedSegmentIndex = 0;
    }
    else if (result == MFMailComposeResultFailed)
        NSLog(@"Send mail error");
}

@end




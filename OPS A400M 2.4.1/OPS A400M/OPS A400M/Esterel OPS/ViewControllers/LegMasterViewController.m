//
//  LegsViewController.m
//  Esterel OPS
//
//  Created by utilisateur on 16/12/13.
//
//

/*
 COMMENTS X15 :
 
 La master view est chargée de présenter les différents legs de la mission, et permet de les sélectionner, de les supprimer ou bien d'en ajouter.
 Les onglets Expoitation et Sign by ordre et sycops ont été supprimé smais il est possible de le rajouter facilement en cas de besoin (cf suite du code dans ce fichier)
 */


#import "LegMasterViewController.h"
#import "LoadViewController.h"
#import "Mission.h"
#import "SplitViewController.h"
#import "Cargo.h"
#import "TimeTools.h"
#import "Parameters.h"

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
    mission.masterView=self;
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



- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    
    // Dismiss the mail compose view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = grisFonce;
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    header.contentView.backgroundColor = grisFonce;
}



- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mission.activeLegIndex inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { return (section == 0) ? @"Legs" :(((section == 1) ? @"Mission Tools" :(section == 2) ?@"End of mission":@"More")); }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 4; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return (section == 0) ? legs.count + 1 :((section == 1) ? 2: ((section == 2)?2:5)); }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell;
        if (indexPath.row == legs.count)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"NewLeg" forIndexPath:indexPath];
            cell.textLabel.textColor = [UIColor blueColor];
            cell.backgroundColor = jone;
            cell.textLabel.backgroundColor=transparant;
            cell.detailTextLabel.backgroundColor=transparant;

        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LegCell"
                                                                    forIndexPath:indexPath];

            NSDictionary *leg = legs[indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"Leg %ld", (long)(indexPath.row + 1)];
            //cell.textLabel.textColor = mightySlate;
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                         leg[@"DepartureAirport"],
                                         leg[@"ArrivalAirport"]];
            
            [mission indicatorsForLeg:mission.activeLegIndex];
            
            cell.detailTextLabel.textColor = [UIColor blackColor];
            
            
            UIView* greyCell = [[UIView alloc] initWithFrame:cell.frame];
            [greyCell setBackgroundColor:grisTransparent];
            cell.selectedBackgroundView = greyCell;
            cell.backgroundColor = ([leg[@"Indicators"][@"Finished"] isEqualToString:@"1"])? vert : (([leg[@"Indicators"][@"InProgress"] isEqualToString:@"1"])? jone2:rouge);;
        }
        cell.textLabel.backgroundColor=transparant;
        cell.detailTextLabel.backgroundColor=transparant;
        cell.textLabel.highlightedTextColor = [UIColor blueColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor blueColor];

        return cell;
    }

    else if(indexPath.section==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell" forIndexPath:indexPath];
        cell.backgroundColor = jone;
        cell.textLabel.backgroundColor = transparant;
        switch (indexPath.row) {
            
            case 0:
                cell.textLabel.text = @"Attestation de vol";
                break;
            case 1:
                cell.textLabel.text = @"Entraînement";
                break;
            case 2:
                cell.textLabel.text = @"Settings & Help";
                break;
            default:
                cell.textLabel.text = @"";
                break;

            
        }

        return cell;

    }
    
    else if (indexPath.section==2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell" forIndexPath:indexPath];
        cell.backgroundColor = jone;
        //cell.contentView.backgroundColor = jone;
        cell.textLabel.backgroundColor = transparant;
        switch (indexPath.row) {
            
            case 0:
            cell.textLabel.text = @"Generate OMA PDF";
            break;
            case 1:
            cell.textLabel.text = @"Generate all CTS";
            break;
            
            default:
            cell.textLabel.text = @"";
            break;
            
        }
        
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell" forIndexPath:indexPath];
        cell.backgroundColor = jone;
        //cell.contentView.backgroundColor = jone;
        cell.textLabel.backgroundColor = transparant;
        switch (indexPath.row) {
            
            case 0:
            cell.textLabel.text = @"Settings and Help";
            break;
            
            default:
            cell.textLabel.text = @"";
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
    else if(indexPath.section==1){
        
        switch (indexPath.row) {
            case 0:
                [(SplitViewController*)self.splitViewController openAttestation];
                break;
            case 1:
                [(SplitViewController*)self.splitViewController openSecopsView];
                break;

        }
        
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mission.activeLegIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else if(indexPath.section==2){
        switch (indexPath.row) {
            case 0:{
                BOOL cargAbsurde = NO;
                NSEnumerator *enume = [mission.Instances objectEnumerator];
                Cargo *carg;
                while(carg = [enume nextObject]){
                    if(carg.absurde == YES)
                    cargAbsurde = YES;
                }
                
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
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else{
                    
                    ((SplitViewController*)self.splitViewController).pdfUrl = [NSURL fileURLWithPath:[[[@"~/Documents/OMA_" stringByAppendingString: mission.legs.firstObject[@"CallSign"]] stringByAppendingString:@".pdf"] stringByExpandingTildeInPath]];
                    
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Options"
                                                          message:@"Preview or directly send the OMA?"
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *sendAction = [UIAlertAction
                                                 actionWithTitle:NSLocalizedString(@"Send by mail", @"mail action")
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action1)
                                                 {
                                                     if (![MFMailComposeViewController canSendMail]) {
                                                         NSLog(@"Mail services are not available.");}
                                                     
                                                     else{
                                                         MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
                                                         composeVC.mailComposeDelegate =  self;
                                                         
                                                         // Configure the fields of the interface.
                                                         [composeVC setToRecipients:secopsMailList];
                                                         [composeVC setSubject:[@"OMA_" stringByAppendingString:mission.legs.firstObject[@"CallSign"]]];
                                                         [composeVC setMessageBody:[NSString  stringWithFormat: @"Bonjour, \n Veuillez recevoir l'OMA et le référentiel entraînement pour le %@.\n\n"
                                                                                    "Aircraft : %@\n"
                                                                                    "Unit : %@\n"
                                                                                    "From : %@\n"
                                                                                    "To : %@\n"
                                                                                    
                                                                                    "Route : %@\n\n"
                                                                                    
                                                                                    "\n %@",mission.legs.firstObject[@"CallSign"],
                                                                                    mission.root[@"Aircraft"], mission.root[@"Unit"],
                                                                                    [TimeTools stringFromDate:mission.legs.firstObject[@"OffBlocksTime"]],
                                                                                    [TimeTools stringFromDate:mission.legs.lastObject[@"OnBlocksTime"]],
                                                                                    [mission route],
                                                                                    [mission cdbForLeg:0]] isHTML:NO];
                                                         
                                                         [(SplitViewController*)self.splitViewController openOMAWithPreview: NO];
                                                         
                                                         NSURL *omaURL = [NSURL fileURLWithPath:[[[@"~/Documents/OMA_" stringByAppendingString: mission.legs.firstObject[@"CallSign"]] stringByAppendingString:@".pdf"] stringByExpandingTildeInPath]];
                                                         NSData *oma = [NSData dataWithContentsOfURL:omaURL];
                                                         
                                                         [composeVC addAttachmentData: oma mimeType:@"application/pdf" fileName:[@"OMA_"stringByAppendingString: mission.legs.firstObject[@"CallSign"]]];
                                                         
                                                         // Present the view controller modally.
                                                         [self presentViewController:composeVC animated:YES completion:nil];}
                                                     
                                                 }];
                    
                    UIAlertAction *previewAction = [UIAlertAction
                                                    actionWithTitle:NSLocalizedString(@"Continue to preview", @"continue action")
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action2)
                                                    {
                                                        [(SplitViewController*)self.splitViewController openOMAWithPreview:YES];
                                                        
                                                    }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction
                                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                   style:UIAlertActionStyleCancel
                                                   handler:nil];
                    
                    [alertController addAction:sendAction];
                    
                    [alertController addAction:previewAction];
                    
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                    
                }
                break;}
            
            case 1:{
                ((SplitViewController*)self.splitViewController).pdfUrl = [NSURL fileURLWithPath:[[[@"~/Documents/CTS_" stringByAppendingString: mission.legs.firstObject[@"CallSign"]] stringByAppendingString:@".pdf"] stringByExpandingTildeInPath]];
                
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Options"
                                                      message:@"Do you want to preview or directly send the crew tick sheets?"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *sendAction = [UIAlertAction
                                             actionWithTitle:NSLocalizedString(@"Send by mail", @"mail action")
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *action1)
                                             {
                                                 if (![MFMailComposeViewController canSendMail]) {
                                                     NSLog(@"Mail services are not available.");}
                                                 
                                                 else{
                                                     MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
                                                     composeVC.mailComposeDelegate =  self;
                                                     
                                                     // Configure the fields of the interface.
                                                     [composeVC setToRecipients:CTSMailList];
                                                     [composeVC setSubject:[@"Crew tick sheets " stringByAppendingString:mission.legs.firstObject[@"CallSign"]]];
                                                     [composeVC setMessageBody:[NSString  stringWithFormat: @"Bonjour, \n Veuillez recevoir les crew ticks sheets pour le %@.\n\n"
                                                                                "Aircraft : %@\n"
                                                                                "Unit : %@\n"
                                                                                "From : %@\n"
                                                                                "To : %@\n"
                                                                                "Route : %@\n\n"
                                                                                
                                                                                "\n %@",mission.legs.firstObject[@"CallSign"],
                                                                                mission.root[@"Aircraft"], mission.root[@"Unit"],
                                                                                [TimeTools stringFromDate:mission.legs.firstObject[@"OffBlocksTime"]],
                                                                                [TimeTools stringFromDate:mission.legs.lastObject[@"OnBlocksTime"]],
                                                                                [mission route],
                                                                                [mission cdbForLeg:0]] isHTML:NO];
                                                     
                                                     //Add a joint piece
                                                     
                                                     [(SplitViewController*)self.splitViewController openCTSWithPreview: NO];
                                                     NSURL *ctsURL = [NSURL fileURLWithPath:[[[@"~/Documents/CTS_" stringByAppendingString: mission.legs.firstObject[@"CallSign"]] stringByAppendingString:@".pdf"] stringByExpandingTildeInPath]];
                                                     NSData *cts = [NSData dataWithContentsOfURL:ctsURL];
                                                     
                                                     [composeVC addAttachmentData: cts mimeType:@"application/pdf" fileName:[@"Crew_tick_sheets_"stringByAppendingString: mission.legs.firstObject[@"CallSign"]]];
                                                     
                                                     // Present the view controller modally.
                                                     [self presentViewController:composeVC animated:YES completion:nil];}
                                                 
                                             }];
                
                UIAlertAction *previewAction = [UIAlertAction
                                                actionWithTitle:NSLocalizedString(@"Continue to preview", @"continue action")
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action2)
                                                {
                                                    [(SplitViewController*)self.splitViewController openCTSWithPreview:YES];
                                                    
                                                }];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                               style:UIAlertActionStyleCancel
                                               handler:nil];
                
                [alertController addAction:sendAction];
                
                [alertController addAction:previewAction];
                
                [alertController addAction:cancelAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                
                break;}
            
        }
        
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mission.activeLegIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];

    }
    else{
        switch (indexPath.row) {
            case 0:
            [(SplitViewController*)self.splitViewController openSettings];
            break;
        }
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mission.activeLegIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];

    
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((indexPath.section == 0) && (indexPath.row < legs.count)) && legs.count > 1;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        
        [[[UIAlertView alloc] initWithTitle:@"Supprimer" message:@"Etes vous sûr de vouloir supprimer cette étape?" delegate:self cancelButtonTitle:@"Non" otherButtonTitles:@"Oui", nil] show];
        
        deletingRow = indexPath;
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void) sendByMail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
        mailView.mailComposeDelegate = self;
        [mailView setModalPresentationStyle:UIModalPresentationFormSheet];
        
        //adresses pour faire suivre les fichiers xml
        NSRange doc;
        doc.location = 0;
        doc.length = 12;
        [mailView setMessageBody:[NSString  stringWithFormat: @"Bonjour, \n Veuillez recevoir la mission (au format pour ouvrir dans OPS A400M sur Ipad) pour le %@.\n\n"
                                  "Aircraft : %@\n"
                                  "Unit : %@\n"
                                  "From : %@\n"
                                  "To : %@\n"

                                  "Route : %@\n\n"
                                  
                                  "\n %@",mission.legs.firstObject[@"CallSign"],
                                  mission.root[@"Aircraft"], mission.root[@"Unit"],
                                  [TimeTools stringFromDate:mission.legs.firstObject[@"OffBlocksTime"]],
                                  [TimeTools stringFromDate:mission.legs.lastObject[@"OnBlocksTime"]],
                                  [mission route],
                                  [mission cdbForLeg:0]] isHTML:NO];
        
        [mailView setToRecipients:secopsIpadMailList];
        [mailView setSubject:[[[[mission.path stringByAbbreviatingWithTildeInPath] stringByReplacingCharactersInRange:doc withString:@""]stringByDeletingPathExtension]stringByAppendingString:mission.legs.firstObject[@"CallSign"]]];
//        NSString *documents = [@"~/Documents" stringByExpandingTildeInPath];
//        
//        NSString *fullPath = [documents stringByAppendingPathComponent:mission.path];
        //        NSMutableDictionary *dico = [NSMutableDictionary dictionaryWithContentsOfFile:fullPath];
        //
        //        if (dico)
        //            [mailView addAttachmentData:[NSPropertyListSerialization dataWithPropertyList:dico format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil] mimeType:@"application/xml" fileName:path];
        //        else
        [mailView addAttachmentData:[NSData dataWithContentsOfFile:mission.path] mimeType:@"application/xml" fileName:[[mission.path stringByAbbreviatingWithTildeInPath] stringByReplacingCharactersInRange:doc withString:@""] ];
        
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




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [mission deleteLegAtIndex:deletingRow.row];

        
        
        if (legs.count == 0)
        {
            [mission addLeg];
            [self.tableView reloadRowsAtIndexPaths:@[deletingRow] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {

            [self.tableView deleteRowsAtIndexPaths:@[deletingRow] withRowAnimation:UITableViewRowAnimationFade];
            
            NSMutableArray *cellToReload = [NSMutableArray arrayWithCapacity:(legs.count - deletingRow.row + 1)];
            

            for (NSInteger i = deletingRow.row; i < legs.count; i++)
                [cellToReload addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            

            mission.activeLegIndex = (deletingRow.row < mission.activeLegIndex) ? mission.activeLegIndex - 1 : ((mission.activeLegIndex == legs.count) ? legs.count - 1 : mission.activeLegIndex);
            [self.tableView reloadRowsAtIndexPaths:cellToReload withRowAnimation:UITableViewRowAnimationFade];

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
    NSInteger source = sourceIndexPath.row;
    NSInteger cible = destinationIndexPath.row;
    NSMutableDictionary *movingLeg = legs[source];
    [legs removeObjectAtIndex:source];
    [legs insertObject:movingLeg atIndex:cible];
    
    movingLeg[@"DepartureAirport"] = (cible == 0) ? @"LFOJ" : legs[cible - 1][@"ArrivalAirport"];
    movingLeg[@"ArrivalAirport"] = (cible == legs.count - 1) ? @"LFOJ" : legs[cible + 1][@"DepartureAirport"];

    
    //Rajout X2015
    //On rend absurde un cargo si sa leg de départ ou d'arrivée est modifiée, pour que le pilote aille verifier.
    NSEnumerator * cargEnum = [mission.Instances objectEnumerator];
    Cargo *carg;
    while(carg = [cargEnum nextObject]){
        NSInteger depp = [carg.numArrnumDep[0] integerValue];
        NSInteger arr = [carg.numArrnumDep[1] integerValue];
        
        if(source>cible){
            if(depp >= cible && depp <= source){
                carg.numArrnumDep[0]= [NSNumber numberWithInteger:[carg.numArrnumDep[0] integerValue]+1];
            }
            if(arr < source && arr>= cible){
                carg.numArrnumDep[1]= [NSNumber numberWithInteger:[carg.numArrnumDep[1] integerValue]+1];
            }
        }
    
        else if (cible>source){
            if(depp>source && depp<= cible){
                carg.numArrnumDep[0]= [NSNumber numberWithInteger:[carg.numArrnumDep[0] integerValue]-1];
            }
            if(arr>=source && arr<=cible){
                carg.numArrnumDep[1]= [NSNumber numberWithInteger:[carg.numArrnumDep[1] integerValue]-1];
            }
        }
        
        if((arr==source || depp==source) && source!=cible){
            carg.absurde=YES;
        }
        
        [carg initSetOfLegs];
    }
    [Cargo reloadBenefListWithMission:mission];
    //Fin rajout X15
    
    mission.activeLegIndex = tableView.indexPathForSelectedRow.row;
    
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:mission.activeLegIndex inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

@end

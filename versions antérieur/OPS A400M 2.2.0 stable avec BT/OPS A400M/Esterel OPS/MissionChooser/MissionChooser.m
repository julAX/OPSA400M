//
//  MasterViewController.m
//  Esterel OPS
//
//  Created by utilisateur on 10/12/13.
//
//

/* Ici il est simplement question d'afficher la liste des fichiers xml en mémoire dans l'appli, de les ouvrir, les renommer, les exporter ou les envoyer par mail, il est aussi possible de créer une mission vierge ici
 */

/* X15
 note : le missionChosser et le storyboard associé n'est pas appelé au lancement de l'application, c'est le splitViewController qui l'apelle lorsqu'aucune mission n'est chargée

 les methodes du protocole missionChooserDelegate sont implementés dans le SplitViewController.m
 
 */



#import "MissionChooser.h"

#import "Mission.h"


@interface MissionChooser ()
{
    NSMutableArray *files;
    NSString *path, *documents;
    
    //QLPreviewController *aide;
    
    UIPopoverController *popover;

    UITableViewController *fileOptions;
    NewFileViewController *newFileView;
    RenameViewController *renameView;
    
    UIDocumentInteractionController *documentController;
    UITableViewCell *activeMission;
    
    IBOutlet UILabel *version;
}

@end

@implementation MissionChooser

- (IBAction)commenterAppli:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
        mailView.mailComposeDelegate = self;
        [mailView setModalPresentationStyle:UIModalPresentationFormSheet];
        
        [mailView setToRecipients:@[@"david-s.richard@intradef.gouv.fr"]];
        [mailView setSubject:@"Commentaire A400M OPS"];
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    version.text = [NSString stringWithFormat:@"Version: %@", [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    space.width = 30.;
    
    self.navigationItem.leftBarButtonItems = @[self.editButtonItem, space, self.navigationItem.leftBarButtonItem];

    // Bouton d'ajout de nouveau fichier
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewMission)], space, self.navigationItem.rightBarButtonItem];
    
    
    // Aide
    //aide = [[QLPreviewController alloc] init];
    //aide.dataSource = self;
    
    
    documents = [@"~/Documents" stringByExpandingTildeInPath];
    
    // Preparation du popover. X15:les popover sont les fenetres reliées à rien dans le storyboard, on y accede avec leur "toryboard identifier", ici on les crée pour les afficher plus tard
    fileOptions = [self.storyboard instantiateViewControllerWithIdentifier:@"FilePopover"];
    
    fileOptions.tableView.delegate = self;
    
    renameView = [self.storyboard instantiateViewControllerWithIdentifier:@"RenamePopover"];
    renameView.delegate = self;
    
    newFileView = [self.storyboard instantiateViewControllerWithIdentifier:@"NewFilePopover"];
    newFileView.delegate = self;
    
    popover = [[UIPopoverController alloc] initWithContentViewController:fileOptions];
    popover.delegate = self;
}



- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
    [self updateList];
    
    if (indexPath)
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}


// Création d'une nouvelle mission

- (void)createNewMission
{

    popover = [[UIPopoverController alloc] initWithContentViewController:newFileView];
    popover.delegate = self;


    [popover setPopoverContentSize:CGSizeMake(700., 130.) animated:YES];
    
  // [popover setContentViewController:newFileView animated:YES];
    
    [popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    }


// Ouverture d'une mission existante

- (void)openMission
{
    
    [self.delegate missionChooserDidEnd:[[Mission alloc] initWithFile:[documents stringByAppendingPathComponent:path]]];
}



#pragma mark - Table View

// Mise a jour de la liste des fichiers



- (void)updateList
{
    files = [[NSMutableArray alloc] init];
    
    NSString *file;
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:documents];
    
    while ((file = [dirEnum nextObject])) {
        if ([[file pathExtension] isEqualToString: @"xml"])
            [files addObject:[file copy]];
    }
    
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return files.count; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell" forIndexPath:indexPath];

    NSString *file = files[indexPath.row];
    cell.textLabel.text =  [file stringByDeletingPathExtension];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return YES; }

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[NSFileManager defaultManager] removeItemAtPath:[documents stringByAppendingPathComponent:files[indexPath.row]] error:nil];
        [files removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        path = files[indexPath.row];
        renameView.initialText = [path stringByDeletingPathExtension];
        
        
        activeMission = [tableView cellForRowAtIndexPath:indexPath];
        
        
        popover = [[UIPopoverController alloc] initWithContentViewController:fileOptions];
        popover.delegate = self;
        
        //[popover setContentViewController:fileOptions animated:YES];
        
        [popover setPopoverContentSize:CGSizeMake(170., 176.)];
        
        [popover presentPopoverFromRect:activeMission.frame
                                  inView:activeMission.superview
                permittedArrowDirections:
         UIPopoverArrowDirectionAny animated:YES];
        }
    else {
        
     //quand on choisit une des 4 "file options"
        switch (indexPath.row)
        {
            case 0: [popover dismissPopoverAnimated:YES];
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                [self openMission];
                break;
            case 1: [popover setPopoverContentSize:CGSizeMake(700., 130.) animated:YES];
                [popover setContentViewController:renameView animated:YES];
                break;
                
                [popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

                
            case 2: [popover dismissPopoverAnimated:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];

                [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                [self sendByMail];
                break;
            case 3: [popover dismissPopoverAnimated:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];

                
                documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[documents stringByAppendingPathComponent:path]]];
                [documentController presentOpenInMenuFromRect:activeMission.frame
                                                       inView:activeMission.superview
                                                     animated:YES];
                
                [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                break;
                //[tableView deselectRowAtIndexPath:indexPath animated:YES];

        }
    }

}




# pragma mark - RenameView Delegate

- (void)renameViewDidCancel
{
    [popover dismissPopoverAnimated:YES];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    path = nil;
}

- (void)renameViewDidValidate:(NSString *)filename erase:(bool)erase
{
    NSString *origPath = [documents stringByAppendingPathComponent:path], *pathBis = [[documents stringByAppendingPathComponent:filename] stringByAppendingPathExtension:@"xml"];
    
    if (![origPath isEqualToString:pathBis])
    {
        NSLog(@"Rename %@ to %@ with erasing %s", origPath, pathBis, ((erase) ? "on" : "off"));
        
        if (erase)
            [[NSFileManager defaultManager] moveItemAtPath:origPath toPath:pathBis error:nil];
        else
            [[NSFileManager defaultManager] copyItemAtPath:origPath toPath:pathBis error:nil];

        
        [self updateList];
        [self.tableView reloadData];
    }
    else
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    
    [popover dismissPopoverAnimated:YES];
    
    path = nil;
}


# pragma mark - NewFile delegate

- (void)newFileViewDidCancel
{
    [popover dismissPopoverAnimated:YES];
}

- (void)newFileViewDidValidate:(NSString *)name
{
    
    [popover dismissPopoverAnimated:YES];

    Mission *newMission = [[Mission alloc] initWithFile:[[documents stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"xml"]];
    
    [self.delegate missionChooserDidEnd:newMission];
}


# pragma mark - Popover delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    path = nil;
}

- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view
{
    if (popover == popoverController)
    {
        *rect = activeMission.frame;
    }
}


# pragma mark - Mail Composer delegate

- (void) sendByMail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
        mailView.mailComposeDelegate = self;
        [mailView setModalPresentationStyle:UIModalPresentationFormSheet];
        
        //adresses pour faire suivre les fichiers xml
        
        [mailView setToRecipients:@[@""]];
        [mailView setSubject:[path stringByDeletingPathExtension]];
        
        NSString *fullPath = [documents stringByAppendingPathComponent:path];
//        NSMutableDictionary *dico = [NSMutableDictionary dictionaryWithContentsOfFile:fullPath];
//        
//        if (dico)
//            [mailView addAttachmentData:[NSPropertyListSerialization dataWithPropertyList:dico format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil] mimeType:@"application/xml" fileName:path];
//        else
        [mailView addAttachmentData:[NSData dataWithContentsOfFile:fullPath] mimeType:@"application/xml" fileName:path];
        
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

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultFailed)
        NSLog(@"Send mail error");
}


# pragma mark - Help
/* On l'enveleve jusqu'à mise à jour de l'aide. On reutilise le bouton pour l'option bluetooth
 
//ouvrir l'aide
- (IBAction)openHelp:(UIBarButtonItem *)sender {
    
    [self presentViewController:aide animated:YES completion:nil];
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [[NSBundle mainBundle] URLForResource:@"Help" withExtension:@"pdf"];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

 
 */

# pragma mark - Bluetooth Sharing

- (IBAction)openBluetooth:(id)sender {
    UITabBarController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"BluetoothController"];
    [self.navigationController pushViewController:pushVC animated:YES];
    
    
    
    
    
}
@end

















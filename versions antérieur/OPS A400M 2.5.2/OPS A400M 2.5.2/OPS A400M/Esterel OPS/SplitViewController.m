//
//  MainViewController.m
//  Esterel OPS
//
//  Created by utilisateur on 10/12/13.
//
/*
 Malgré les apparence la split view est la vue initiale du projet, à peine ouverte elle présente un MissionChooser pour charger une mission, je n'ai pas mis le mission chooser en root view car il n'est pas possible d'effectuer une segue vers une split view
 
 Ensuite chaque vue va accéder à la mission en la demandant à la splitview qui possède la référence commune.
 */

#import "SplitViewController.h"
#import "parameters.h"
#import "CrewData.h"
#import "AirportsData.h"
#import "TimeTools.h"
#import "Mission.h"


@interface SplitViewController () {
    
    UINavigationController *chooseFileView, *secopsView, *attestationView, *sicopsView, *exploitView, *settingsView, *feedbackView;
    UIViewController *mainDetailViewControllerWaitedForCancelling;
    
    UIAlertView *saveConfirmation, *cancelConfirmation, *importConfirmation;
    NSString *importingFile;
    
    OMAGenerator *oma;
    CTSGenerator *cts;
    PVEGenerator *pve;
    QLPreviewController *omaPdf;
    QLPreviewController *ctsPdf;
    QLPreviewController *pvePdf;
    MFMailComposeViewController * omaMailController;
    MFMailComposeViewController * ctsMailController;
    MFMailComposeViewController * pveMailController;
    
    BOOL omaBool;
    BOOL ctsBool;
    BOOL pveBool;
    

    


}
@end

@implementation SplitViewController

@synthesize pdfUrl;
@synthesize showDetLeg, showTools, showCargos;

// Import de fichier et mise à jour des BDD

- (void)handleURL:(NSURL *)url
{
    NSString *fileName = [url lastPathComponent], *path = [url path];
    
    if ([fileName isEqualToString:@"listeequipages.xml"])
        [CrewData updateDatabase:path];
    else if ([fileName isEqualToString:@"listeaeroports.xml"])
        [AirportsData updateDatabase:path];
    else
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[@"~/Documents" stringByExpandingTildeInPath] stringByAppendingPathComponent:fileName]]) {
            importingFile = path;
            [importConfirmation show];
        }
        else {
            [self importFile:path];
        }
    }
}

//importer un fichier xml

- (void)importFile:(NSString*)path
{
    NSString *fileName = [path lastPathComponent];
    NSString *newPath = [[@"~/Documents" stringByExpandingTildeInPath] stringByAppendingPathComponent:fileName];
    
    [[NSFileManager defaultManager] removeItemAtPath:newPath error:nil];
    
    [[NSFileManager defaultManager] moveItemAtPath:path toPath:newPath error:nil];
    
    [[NSFileManager defaultManager] removeItemAtPath:[@"~/Documents/Inbox" stringByExpandingTildeInPath] error:nil];
    
    if (self.presentedViewController == chooseFileView)
        [(MissionChooser*)chooseFileView.topViewController updateList];
    
    [[[UIAlertView alloc] initWithTitle:@"Import" message:[NSString stringWithFormat:@"Le fichier %@ a bien été importé.", fileName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}



// Fonction de redimensionnement de la master view

- (void)viewDidLayoutSubviews
{
    const CGFloat kMasterViewWidth = 250.0; // TAILLE DE LA MASTER VIEW
    
    UIViewController *masterViewController = [self.viewControllers objectAtIndex:0];
    UIViewController *detailViewController = [self.viewControllers objectAtIndex:1];
    
    if (detailViewController.view.frame.origin.x > 0.0) {
        // Adjust the width of the master view
        CGRect masterViewFrame = masterViewController.view.frame;
        CGFloat deltaX = masterViewFrame.size.width - kMasterViewWidth;
        masterViewFrame.size.width -= deltaX;
        masterViewController.view.frame = masterViewFrame;
        
        // Adjust the width of the detail view
        CGRect detailViewFrame = detailViewController.view.frame;
        detailViewFrame.origin.x -= deltaX;
        detailViewFrame.size.width += deltaX;
        detailViewController.view.frame = detailViewFrame;
        
        [masterViewController.view setNeedsLayout];
        [detailViewController.view setNeedsLayout];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.delegate = self;
    
    if (!chooseFileView) {
        chooseFileView = [[UIStoryboard storyboardWithName:@"ChooseFile" bundle:nil] instantiateInitialViewController];
        ((MissionChooser*)chooseFileView.topViewController).delegate = self;
    }
    
    omaPdf = [[QLPreviewController alloc] init];
    omaPdf.dataSource = self;
    omaPdf.delegate = self;
    
    ctsPdf = [[QLPreviewController alloc] init];
    ctsPdf.dataSource = self;
    ctsPdf.delegate = self;
    
    omaMailController = [[MFMailComposeViewController alloc]init];
    omaMailController.mailComposeDelegate = self;
    
    ctsMailController = [[MFMailComposeViewController alloc]init];
    ctsMailController.mailComposeDelegate = self;
    
    cancelConfirmation = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Etes-vous sûr de vouloir quitter?\nVous allez perdre toutes les données non enregistrées." delegate:self cancelButtonTitle:@"Oui" otherButtonTitles:@"Sauvegarder et quitter", @"Non", nil];

    saveConfirmation = [[UIAlertView alloc] initWithTitle:@"Sauvegarde" message:@"Voulez-vous enregistrer et écraser les anciennes données?" delegate:self cancelButtonTitle:@"Non" otherButtonTitles:@"Oui", nil];
    
    importConfirmation = [[UIAlertView alloc] initWithTitle:@"Import" message:@"Un fichier du même nom existe déjà, voulez-vous l'écraser?" delegate:self cancelButtonTitle:@"Non" otherButtonTitles:@"Oui", nil];


    // permet de desactiver le clavier lorsque l'on touche a l'exterieur
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self.view
                                   action:@selector(endEditing:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.mission)
        [self presentViewController:chooseFileView animated:NO completion:nil];
    showDetLeg = YES;
    showTools = NO;
    showCargos = YES;
}



- (void)openExploitView
{
    if (!exploitView)
        exploitView = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploitView"];

    [self presentViewController:exploitView animated:YES completion:nil];
}



- (void)saveMission
{
    [saveConfirmation show];
}

- (void)cancel
{
    [cancelConfirmation show];
}


# pragma mark - Attestation de vol

- (void)openAttestation
{
    if (!attestationView)
        attestationView = [self.storyboard instantiateViewControllerWithIdentifier:@"AttestationView"];
    
    [self presentViewController:attestationView animated:YES completion:nil];
}


# pragma mark - Sicops

- (void)openSicopsView
{
    if (!sicopsView)
        sicopsView = [self.storyboard instantiateViewControllerWithIdentifier:@"SicopsView"];
    
    [self presentViewController:sicopsView animated:YES completion:nil];
}

# pragma mark - Settings

- (void)openSettings
{
    if(!settingsView)
        settingsView = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsView"];
    
    [self presentViewController:settingsView animated:YES completion:nil];

}


-(void)openCrewFeedbackForm
{
    
    if(!feedbackView)
        feedbackView = [self.storyboard instantiateViewControllerWithIdentifier:@"crewFeedbackForm"];


    [self presentViewController:feedbackView animated:YES completion:nil];

}


#pragma mark - MissionChooser Delegate


// Une mission a été ouverte par le missionChooser, on peut donc le fermer et s'assurant que la detail view est bien revenue à son point de départ.

- (void)missionChooserDidEnd:(Mission *)mission
{
    _mission = mission;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - OMADelegate


- (void)openOMAWithPreview : (BOOL) display

{   
    omaBool = display;
    oma = [[OMAGenerator alloc] initWithMission:self.mission];
    oma.delegate = self;
    
    omaPdf = [[QLPreviewController alloc] init];
    omaPdf.dataSource = self;
    omaPdf.delegate = self;
    

}


- (void)omaPdfDidFinishLoading:(NSString *)path
{
    pdfUrl = [NSURL fileURLWithPath:path];
    
    if(omaBool){
        UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 180, 44.01)];
        [toolbar setTranslucent:YES];
        toolbar.tintColor = rouge;

        NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:4];
        
        UIBarButtonItem *openButton = [[UIBarButtonItem alloc] initWithTitle : @"Send OMA by mail" style:UIBarButtonItemStyleBordered target:self action:@selector(testOma)];
        [buttons addObject:openButton];

        [toolbar setItems:buttons animated:NO];

        [[omaPdf navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:toolbar]];
       
        [self presentViewController:omaPdf animated:YES completion:nil];
    }
    oma = nil;
}


-(void)testOma{
    [omaPdf dismissViewControllerAnimated:YES completion:nil];
    if(![Mission testVide:[self.mission missionIndicators]]){
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Warning"
                                              message:[self.mission missionIndicators]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Send Mail Anyway ...", @"continue action")
                                       style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                       [self sendOmaMail];
                                   }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    
    else{
        [self sendOmaMail];
    }


}

-(void)sendOmaMail
{
    
    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Mail services are not available.");}
    
    else{
        //[omaPdf dismissViewControllerAnimated:YES completion:nil];
        omaMailController = [[MFMailComposeViewController alloc] init];
        omaMailController.mailComposeDelegate=self;
        
        
        // Configure the fields of the interface.
        [omaMailController setToRecipients:secopsMailList];
        [omaMailController setSubject:[@"OMA_" stringByAppendingString:self.mission.legs.firstObject[@"CallSign"]]];
        [omaMailController setMessageBody:[NSString  stringWithFormat: @"Bonjour, \n Veuillez recevoir l'OMA et le référentiel entraînement pour le %@.\n\n"
                                           "Aircraft : %@\n"
                                           "Unit : %@\n"
                                           "From : %@\n"
                                           "To : %@\n"
                                           
                                           "Route : %@\n\n"
                                           
                                           "\n %@",self.mission.legs.firstObject[@"CallSign"],
                                           self.mission.root[@"Aircraft"], self.mission.root[@"Unit"],
                                           [TimeTools stringFromDate:self.mission.legs.firstObject[@"OffBlocksTime"]],
                                           [TimeTools stringFromDate:self.mission.legs.lastObject[@"OnBlocksTime"]],
                                           [self.mission route],
                                           [self.mission cdbForLeg:0]] isHTML:NO];
        
        
        
        NSURL *omaURL = [NSURL fileURLWithPath:[[[@"~/Documents/OMA_" stringByAppendingString: self.mission.legs.firstObject[@"CallSign"]] stringByAppendingString:@".pdf"] stringByExpandingTildeInPath]];
        NSData *omaData = [NSData dataWithContentsOfURL:omaURL];
        
        [omaMailController addAttachmentData: omaData mimeType:@"application/pdf" fileName:[@"OMA_"stringByAppendingString: self.mission.legs.firstObject[@"CallSign"]]];
        
        
        [self presentViewController:omaMailController animated:YES completion:nil];
    }

}



# pragma mark - CTSDelegate


- (void)openCTSWithPreview:(BOOL)display

{
    ctsBool = display;
    cts = [[CTSGenerator alloc] initWithMission:self.mission];
    cts.delegate = self;
    

    ctsPdf = [[QLPreviewController alloc] init];
    ctsPdf.dataSource = self;
    ctsPdf.delegate = self;
    

    
}


- (void)ctsPdfDidFinishLoading:(NSString *)path
{
    pdfUrl = [NSURL fileURLWithPath:path];
    
    if(ctsBool){
//        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//
//        space.width = 30.;
//
//        ctsPdf.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:ctsPdf action:@selector(sendCtsMail)], space, ctsPdf.navigationItem.rightBarButtonItem];
        UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 140, 44)];
        [toolbar setTranslucent:YES];
        toolbar.tintColor = rouge;
        
        NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:4];
        
        UIBarButtonItem *openButton = [[UIBarButtonItem alloc] initWithTitle : @"Send to BT" style:UIBarButtonItemStyleDone target:self action:@selector(testCTS)];
        [buttons addObject:openButton];
        
        [toolbar setItems:buttons animated:NO];
        
        [[ctsPdf navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:toolbar]];
//
        [self presentViewController:ctsPdf animated:YES completion:nil];
    }
    cts = nil;
}


-(void)testCTS{
    [ctsPdf dismissViewControllerAnimated:YES completion:nil];
    BOOL ctsOk = YES;
    
    for(NSMutableDictionary *leg in self.mission.legs)
    {
        if(![leg[@"Indicators"][@"CrewTickSheet"][1] isEqualToString:@"1"])
            ctsOk = NO;
    }
    
    
    
    if(!ctsOk){
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Warning"
                                              message:@"Some crew tick sheets are incomplete"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Send Mail Anyway ...", @"continue action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                       [self sendCtsMail];
                                   }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    
    else{
        [self sendCtsMail];
    }
    
    

    
}

-(void) sendCtsMail{
    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Mail services are not available.");}
    
    else{
        [ctsPdf dismissViewControllerAnimated:YES completion:nil];
        
        ctsMailController = [[MFMailComposeViewController alloc] init];
        ctsMailController.mailComposeDelegate =  self;
        
        // Configure the fields of the interface.
        [ctsMailController setToRecipients:CTSMailList];
        [ctsMailController setSubject:[@"Crew tick sheets " stringByAppendingString:self.mission.legs.firstObject[@"CallSign"]]];
        [ctsMailController setMessageBody:[NSString  stringWithFormat: @"Bonjour, \n Veuillez recevoir les crew ticks sheets pour le %@.\n\n"
                                           "Aircraft : %@\n"
                                           "Unit : %@\n"
                                           "From : %@\n"
                                           "To : %@\n"
                                           "Route : %@\n\n"
                                           
                                           "\n %@",self.mission.legs.firstObject[@"CallSign"],
                                           self.mission.root[@"Aircraft"], self.mission.root[@"Unit"],
                                           [TimeTools stringFromDate:self.mission.legs.firstObject[@"OffBlocksTime"]],
                                           [TimeTools stringFromDate:self.mission.legs.lastObject[@"OnBlocksTime"]],
                                           [self.mission route],
                                           [self.mission cdbForLeg:0]] isHTML:NO];
        
        //Add a joint piece
        

        NSURL *ctsURL = [NSURL fileURLWithPath:[[[@"~/Documents/CTS_" stringByAppendingString: self.mission.legs.firstObject[@"CallSign"]] stringByAppendingString:@".pdf"] stringByExpandingTildeInPath]];
        NSData *ctsData = [NSData dataWithContentsOfURL:ctsURL];
        
        [ctsMailController addAttachmentData: ctsData mimeType:@"application/pdf" fileName:[@"Crew_tick_sheets_"stringByAppendingString: self.mission.legs.firstObject[@"CallSign"]]];
        
        // Present the view controller modally.
        [self presentViewController:ctsMailController animated:YES completion:nil];}
    
    



}

#pragma mark - PVEDelegate


- (void)openPVEWithPreview:(BOOL)display

{
    pveBool = display;
    pve = [[PVEGenerator alloc] initWithMission:self.mission];
    pve.delegate = self;
    
    
    pvePdf = [[QLPreviewController alloc] init];
    pvePdf.dataSource = self;
    pvePdf.delegate = self;
    
    
    
}


- (void)pvePdfDidFinishLoading:(NSString *)path
{
    pdfUrl = [NSURL fileURLWithPath:path];
    
    if(pveBool){
        //        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //
        //        space.width = 30.;
        //
        //        ctsPdf.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:ctsPdf action:@selector(sendCtsMail)], space, ctsPdf.navigationItem.rightBarButtonItem];
        UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 140, 44)];
        [toolbar setTranslucent:YES];
        toolbar.tintColor = rouge;
        
        NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:4];
        
        UIBarButtonItem *openButton = [[UIBarButtonItem alloc] initWithTitle : @"Send to Secops" style:UIBarButtonItemStyleDone target:self action:@selector(testPVE)];
        [buttons addObject:openButton];
        
        [toolbar setItems:buttons animated:NO];
        
        [[pvePdf navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:toolbar]];
        //
        [self presentViewController:pvePdf animated:YES completion:nil];
    }
    pve = nil;
}

-(void)testPVE{
    [pvePdf dismissViewControllerAnimated:YES completion:nil];
    BOOL pveOk = YES;
    
    for(NSMutableDictionary *leg in self.mission.legs)
    {
        if(![leg[@"Indicators"][@"PVE"][1] isEqualToString:@"1"])
            pveOk = NO;
    }
    
    
    
    if(!pveOk){
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Warning"
                                              message:@"There are legs where the pve are missing\n (departure message is required)"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Send Mail Anyway ...", @"continue action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                       [self sendPveMail];
                                   }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    
    else{
        [self sendPveMail];
    }
    
    
    
    
}


-(void) sendPveMail{
    if (![MFMailComposeViewController canSendMail]) {
        NSLog(@"Mail services are not available.");}
    
    else{
        [pvePdf dismissViewControllerAnimated:YES completion:nil];
        
        pveMailController = [[MFMailComposeViewController alloc] init];
        pveMailController.mailComposeDelegate =  self;
        
        // Configure the fields of the interface.
        [pveMailController setToRecipients:secopsMailList];
        [pveMailController setSubject:[@"Procès verbal d'exploitation " stringByAppendingString:self.mission.legs.firstObject[@"CallSign"]]];
        [pveMailController setMessageBody:[NSString  stringWithFormat: @"Bonjour, \n Veuillez recevoir le procès verbal d'exploitation pour le %@.\n\n"
                                           "Aircraft : %@\n"
                                           "Unit : %@\n"
                                           "From : %@\n"
                                           "To : %@\n"
                                           "Route : %@\n\n"
                                           
                                           "\n %@",self.mission.legs.firstObject[@"CallSign"],
                                           self.mission.root[@"Aircraft"], self.mission.root[@"Unit"],
                                           [TimeTools stringFromDate:self.mission.legs.firstObject[@"OffBlocksTime"]],
                                           [TimeTools stringFromDate:self.mission.legs.lastObject[@"OnBlocksTime"]],
                                           [self.mission route],
                                           [self.mission cdbForLeg:0]] isHTML:NO];
        
        //Add a joint piece
        
        
        NSURL *pveURL = [NSURL fileURLWithPath:[[[@"~/Documents/PVE_" stringByAppendingString: self.mission.legs.firstObject[@"CallSign"]] stringByAppendingString:@".pdf"] stringByExpandingTildeInPath]];
        NSData *pveData = [NSData dataWithContentsOfURL:pveURL];
        
        [pveMailController addAttachmentData: pveData mimeType:@"application/pdf" fileName:[@"Proces_verbal_exploitation_"stringByAppendingString: self.mission.legs.firstObject[@"CallSign"]]];
        
        // Present the view controller modally.
        [self presentViewController:pveMailController animated:YES completion:nil];}
    
    
    
    
    
}


#pragma mark - QLPreviewController

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{

    return self.pdfUrl;

}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}



#pragma mark - SecopsDelegate


- (void)openSecopsView
{
    if (!secopsView)
    {
        secopsView = [[UIStoryboard storyboardWithName:@"Secops" bundle:nil] instantiateViewControllerWithIdentifier:@"SecopsView"];
       
    }
    
    [self presentViewController:secopsView animated:YES completion:nil];
    
    }



#pragma mark - Split View

// Pour ne jamais cacher la master view

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation { return NO; }



#pragma mark - Alert View

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == saveConfirmation && buttonIndex == 1)
        [self.mission save];
    
    else if (alertView == cancelConfirmation) {// && buttonIndex == 1) {
        
        if (buttonIndex == 1)
            [self.mission save];
        
        if (buttonIndex < 2) {
            UINavigationController *nav = self.viewControllers[1];
            nav.delegate = self;
            
            mainDetailViewControllerWaitedForCancelling = nav.viewControllers[0];
            
            if (mainDetailViewControllerWaitedForCancelling == nav.topViewController) {
                [self navigationController:nav didShowViewController:mainDetailViewControllerWaitedForCancelling animated:NO];
            }
            else
                [nav popToRootViewControllerAnimated:YES];
            
        }
    }
    else if (alertView == importConfirmation)// && buttonIndex == 1)
    {
        if (buttonIndex == 1)
            [self importFile:importingFile];
        else
        {
            [[NSFileManager defaultManager] removeItemAtPath:[@"~/Documents/Inbox" stringByExpandingTildeInPath] error:nil];
            
            if (self.presentedViewController == chooseFileView)
                [(MissionChooser*)chooseFileView.topViewController updateList];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (mainDetailViewControllerWaitedForCancelling == viewController) {
        mainDetailViewControllerWaitedForCancelling = nil;
        
        _mission = nil;
        secopsView = nil;
        attestationView = nil;
        sicopsView = nil;
        [self presentViewController:chooseFileView animated:YES completion:nil];
    }
}


#pragma mark - Mail Delegate

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)openSignByOrder
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
        mailView.mailComposeDelegate = self;
        [mailView setModalPresentationStyle:UIModalPresentationFormSheet];
        //ajouter ici les adresses des gens qui doivent recevoir le mail de confirmation pour les signatures par ordre.
        [mailView setToRecipients:secopsMailList];
        [mailView setSubject:[_mission.path.lastPathComponent stringByDeletingPathExtension]];
        
        [mailView setMessageBody:[NSString stringWithFormat:@"J'ai bien pris en compte l'ordre d'opération pour la mission n°%@\n", _mission.root[@"MissionNumber"]] isHTML:NO];
        
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
    //if (result == MFMailComposeResultFailed)
        //NSLog(@"Send mail error");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[((UITableViewController*)((UINavigationController*)self.viewControllers.firstObject).topViewController).tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_mission.activeLegIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}


@end

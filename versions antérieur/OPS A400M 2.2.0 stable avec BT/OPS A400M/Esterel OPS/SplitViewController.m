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

#import "CrewData.h"
#import "AirportsData.h"

#import "Mission.h"


@interface SplitViewController () {
    
    UINavigationController *chooseFileView, *secopsView, *attestationView, *sicopsView, *exploitView;
    UIViewController *mainDetailViewControllerWaitedForCancelling;
    
    UIAlertView *saveConfirmation, *cancelConfirmation, *importConfirmation;
    NSString *importingFile;
    
    OMAGenerator *oma;
    QLPreviewController *omaPdf;
    NSURL *pdfUrl;
}
@end

@implementation SplitViewController


// Import de fichier et mise à jour des BDD

- (void)handleURL:(NSURL *)url
{
    NSLog(@"Handle URL:%@", url);
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




#pragma mark - MissionChooser Delegate


// Une mission a été ouverte par le missionChooser, on peut donc le fermer et s'assurant que la detail view est bien revenue à son point de départ.

- (void)missionChooserDidEnd:(Mission *)mission
{
    _mission = mission;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


# pragma mark - OMADelegate


- (void)openOMA

{   
    
    omaPdf = [[QLPreviewController alloc] init];
    omaPdf.dataSource = self;
    omaPdf.delegate = self;

    oma = [[OMAGenerator alloc] initWithMission:self.mission];
    oma.delegate = self;
}


- (void)omaPdfDidFinishLoading:(NSString *)path
{
    pdfUrl = [NSURL fileURLWithPath:path];
    
    [self presentViewController:omaPdf animated:YES completion:nil];
    
    oma = nil;
}



#pragma mark - QLPreviewController

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return pdfUrl;
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



- (void)openSignByOrder
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
        mailView.mailComposeDelegate = self;
        [mailView setModalPresentationStyle:UIModalPresentationFormSheet];
        //ajouter ici les adresses des gens qui doivent recevoir le mail de confirmation pour les signatures par ordre.
        [mailView setToRecipients:@[@"adjoint.saa.esterel@gmail.com", @"secops.esterel@gmail.com", @"saa.esterel@gmail.com"]];
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
    if (result == MFMailComposeResultFailed)
        NSLog(@"Send mail error");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[((UITableViewController*)((UINavigationController*)self.viewControllers.firstObject).topViewController).tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_mission.activeLegIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}


@end

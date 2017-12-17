//
//  AttestationTableViewController.m
//  Esterel OPS
//
//  Created by utilisateur on 24/03/2014.
//  Copyright (c) 2014 Esterel. All rights reserved.
//

#import "AttestationTableViewController.h"

#import "SplitViewController.h"
#import "Mission.h"
#import "TimeTools.h"
#import "AirportsData.h"


#define DELTA_ENTETE 421.5
#define DELTA_TAB 416.16
#define DELTA_BAS 414.5


/* COMMENTS X15
Ca on y a pas touché. Ca fait ce que ca fait, c'est a dire les attestations de vol. Voila.
^ En fait si.
 
*/




@interface AttestationTableViewController () {
    
    IBOutlet UILabel *debutLabel;
    IBOutlet UIStepper *debutStepper;
    
    IBOutlet UILabel *finLabel;
    IBOutlet UIStepper *finStepper;
    
    IBOutlet UITextField *concernant;
    IBOutlet UITextField *fonction;
    IBOutlet UITextField *cdb;
    IBOutlet UITextField *telephone;
    
    Mission *mission;
    NSArray *legs;
    
    BOOL pdfAJour;
    NSDate *timeZero;
    NSURL *pdfUrl;
    QLPreviewController *apercu;
    NSDictionary *attr;
    
    UIDocumentInteractionController *documentController;
    UIPopoverController *popover;

}

@end

@implementation AttestationTableViewController

static float coord[] = {46., 102., 158., 228., 445., 509., 555., 601., 679.};


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pdfUrl = [NSURL fileURLWithPath:[@"~/Documents/Attestation.pdf" stringByExpandingTildeInPath]];

    
    timeZero = [NSDate dateWithTimeIntervalSinceReferenceDate:0.];
    
    apercu = [[QLPreviewController alloc] init];
    apercu.delegate = self;
    apercu.dataSource = self;
    
    mission = ((SplitViewController*)self.presentingViewController).mission;
    legs = mission.legs;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    UIFont *font = [UIFont systemFontOfSize:9.];
    
    attr = @{NSParagraphStyleAttributeName:style, NSFontAttributeName:font};
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    pdfAJour = NO;
    
    debutStepper.maximumValue = legs.count - 1;
    finStepper.maximumValue = legs.count - 1;
    
    debutStepper.value = 0.;
    finStepper.value = 0.;
    
    [self setEtape:0 forLabel:debutLabel final:NO];
    [self setEtape:0 forLabel:finLabel final:YES];
    
    cdb.text = [mission cdbForLeg:0];
}


- (IBAction)etapeChanged:(UIStepper *)sender {
    
    pdfAJour = NO;
    
    if (sender == debutStepper) {
        
        [self setEtape:debutStepper.value forLabel:debutLabel final:NO];
        
        if (debutStepper.value > finStepper.value) {
            finStepper.value = debutStepper.value;
            [self setEtape:finStepper.value forLabel:finLabel final:YES];
        }
    }
    else if (sender == finStepper) {
        
        [self setEtape:finStepper.value forLabel:finLabel final:YES];
        
        if (finStepper.value < debutStepper.value) {
            debutStepper.value = finStepper.value;
            [self setEtape:debutStepper.value forLabel:debutLabel final: NO];
        }
    }
}

- (void)setEtape:(double)d forLabel:(UILabel*)label final:(BOOL)final
{
    NSInteger i = round(d);
    //ancien/
    //label.text = [NSString stringWithFormat:@"Etape %d: %@ - %@", (int)i+1, legs[i][@"DepartureAirport"], legs[i][@"ArrivalAirport"]];
    label.text = (final)?legs[i][@"ArrivalAirport"]:legs[i][@"DepartureAirport"];
}


- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{NSLog(@"Test -1");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Test 0");
    if (indexPath.section == 1) {
        
        if ([self genererPdf]) {
            NSLog(@"Test 1");
            switch (indexPath.row) {
                case 0:
                    NSLog(@"Test 2");
                    apercu = [[QLPreviewController alloc] init];
                    apercu.delegate = self;
                    apercu.dataSource = self;
                    

                    [self presentViewController:apercu animated:YES completion:nil];
                    break;
                case 1:
                    NSLog(@"Test 3");
                    documentController = [UIDocumentInteractionController interactionControllerWithURL:pdfUrl];

                    [documentController presentOpenInMenuFromRect:[tableView cellForRowAtIndexPath:indexPath].frame
                                                           inView:tableView
                                                         animated:YES];
                    
                    
                    break;
                default:
                    break;
            }
        }
        else
            [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"Aucune heure de vol n'est comptabilisée sur les étapes sélectionnées, vérifiez si les temps associés aux coefficients ont bien été remplis." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

# pragma mark - Creation du pdf


- (BOOL)genererPdf
{
    if (!pdfAJour) {
    
    NSString *avion = @{@"FRBAA" : @"A400M MSN7",
                        @"FRBAB" : @"A400M MSN8",
                        @"FRBAC" : @"A400M MSN10",
                        @"FRBAD" : @"A400M MSN11",
                        @"FRBAE" : @"A400M MSN12",
                        @"FRBAF" : @"A400M MSN14"}[mission.root[@"Aircraft"]], *text;
    
    if (!avion)
        avion = @"";
    
  
    int ligne = 0, dernierLeg = round(finStepper.value);
   
    NSTimeInterval tempsTotal, tempsNuit;
    
    NSMutableArray *lignes = [NSMutableArray new];
  
    for (int l = round(debutStepper.value); l <= dernierLeg; l++) {
        
        NSDictionary *leg = legs[l];
       
        NSString *date = [TimeTools stringFromDate:leg[@"OffBlocksTime"]] , *dateFin = [TimeTools stringFromDate:leg[@"OnBlocksTime"]], *trajet = [NSString stringWithFormat:@"%@ - %@", [AirportsData nameForOaci:leg[@"DepartureAirport"]], [AirportsData nameForOaci:leg[@"ArrivalAirport"]]], *atterissages = leg[@"Landings"];
     
        ///////////////////////////////////////////////////////////////////////////
        
        int index = 0;
        BOOL attero = NO;
        for (NSString *coeff in @[@"35", @"22", @"10", @"62"]) {
            
            NSDate *jour = leg[[@"Day" stringByAppendingString:coeff]], *nuit = leg[[@"Night" stringByAppendingString:coeff]];
         
            if (!([jour isEqualToDate:timeZero] && [nuit isEqualToDate:timeZero])) {
                if (!attero){
                    [lignes addObject:@[date, fonction.text, avion, trajet, atterissages, jour, nuit, coeff, dateFin]];
                    attero = YES;
                    
                }
                else{
                   
                    [lignes addObject:@[date, fonction.text, avion, trajet, @"", jour, nuit, coeff, dateFin]];
                    
                
                }
                    
                    
//                    else
//                    {
//                        if (![jour isEqualToDate:timeZero])
//                            [lignes addObject:@[date, fonction.text, avion, trajet, atterissages, jour, timeZero, leg[@"DayOtherCode"], dateFin]];
//                        
//                        if (![nuit isEqualToDate:timeZero])
//                            [lignes addObject:@[date, fonction.text, avion, trajet, atterissages, timeZero, nuit, leg[@"NightOtherCode"], dateFin]];
//                    }
                
            }
            
            index++;
            
        }
    }
    
    if (lignes.count == 0)
        return NO;
 
    
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)[[NSBundle mainBundle] URLForResource:@"Attestation" withExtension:@"pdf"]);
    
        
    
    NSMutableData* data = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(data, CGRectZero, nil);
    
       
    //	Get the current page and page frame
    CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdf, 1);
    const CGRect pageFrame = CGPDFPageGetBoxRect(pdfPage, kCGPDFMediaBox);
 
    
    for(NSArray *tab in lignes)
    {
        if (ligne % 7 == 0) {
        
            UIGraphicsBeginPDFPageWithInfo(pageFrame, nil);
            
            //	Draw the page (flipped)
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);
            CGContextScaleCTM(ctx, 1, -1);
            CGContextTranslateCTM(ctx, 0, -pageFrame.size.height);
            CGContextDrawPDFPage(ctx, pdfPage);
            CGContextRestoreGState(ctx);
            
            tempsNuit = 0.;
            tempsTotal = 0.;
            
            [self drawText:tab[0] atPoint:CGPointMake(203., 110.) decalage:422.];
            [self drawText:concernant.text atPoint:CGPointMake(222., 124.5) decalage:DELTA_ENTETE];
            [self drawText:[NSString stringWithFormat:@"Contact : %@", telephone.text] atPoint:CGPointMake(230,100) decalage:DELTA_ENTETE];
          
        }
        
        CGRect rect = CGRectMake(0., 217. + (ligne % 7) * 17.14, 0., 15.);
 
        for (NSInteger i = 0; i < 8; i++) {
       
            rect.origin.x = coord[i];
            rect.size.width = coord[i+1] - coord[i];
            
            if ([tab[i] isKindOfClass:[NSDate class]])
                text = ([tab[i] isEqualToDate:timeZero]) ? @"" : [TimeTools stringFromTime:tab[i] withDays:YES];
            else
                text = tab[i];
     
            [self drawText:text inRect:rect decalage:DELTA_TAB];
    
        }
        
        
        NSTimeInterval nuit = [tab[6] timeIntervalSinceReferenceDate];
        tempsTotal += nuit + [tab[5] timeIntervalSinceReferenceDate];
        tempsNuit += nuit;
   
        if ((ligne % 7 == 6) || (ligne == lignes.count - 1)) {
            // ECRIRE LA DATE DE FIN ET LE BAS DE PAGE (NOMS, SOMMES)
        
            [self drawText:tab[8] atPoint:CGPointMake(480., 110) decalage:DELTA_ENTETE];
            
           
            [self drawText:[TimeTools tempsToutesLettres:tempsTotal] atPoint:CGPointMake(260., 350.5) decalage:DELTA_BAS];
           
            [self drawText:[TimeTools tempsToutesLettres:tempsNuit] atPoint:CGPointMake(260., 366.5) decalage:DELTA_BAS];
            
            [self drawText:cdb.text atPoint:CGPointMake(327., 414.5) decalage:DELTA_BAS];
        
NSString *unité = @{@"TOURAINE 1/61" : @"ET 01.061 TOURAINE",
                    @"CIET 340" : @"CIET 00.340",
                    @"EMATT 01.338" : @"EMATT 01.338",
                    }[mission.root[@"Unit"]];
            [self drawText: unité atPoint:CGPointMake(90., 90.) decalage:DELTA_ENTETE];
NSString *unitéDuCDB = @{@"TOURAINE 1/61" : @"de l'ET 01.061 TOURAINE",
                        @"CIET 340" : @" du CIET 00.340",
                        @"EMATT 01.338" : @"de l'EMATT 01.338",
                                     }[mission.root[@"Unit"]];
            [self drawText: unitéDuCDB atPoint:CGPointMake(267., 383.) decalage:DELTA_BAS];
          
        }
  
        
        ligne++;
    }
    
        
    UIGraphicsEndPDFContext();
    
    CGPDFDocumentRelease(pdf);
    pdf = nil;
    
    [data writeToURL:pdfUrl atomically:YES];
        
    pdfAJour = YES;
    }

    return YES;
}


- (void)drawText:(NSString*)text inRect:(CGRect)rect decalage:(float)d
{
    [text drawInRect:rect withAttributes:attr];
    
    rect.origin.y += d;
    
    [text drawInRect:rect withAttributes:attr];
    
    rect.origin.y -= d;
}

- (void)drawText:(NSString*)text atPoint:(CGPoint)point decalage:(float)d
{
    [text drawAtPoint:point withAttributes:attr];
    
    point.y += d;
    
    [text drawAtPoint:point withAttributes:attr];
    
    point.y -= d;
}


- (NSArray*)getCdbList
{
    NSMutableSet *set = [NSMutableSet new];
    
    for (NSInteger i = 0; i < legs.count; i++)
        [set addObject:[mission cdbForLeg:i]];
    
    [set removeObject:@""];
    
    return [set allObjects];
}



# pragma mark - TextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == cdb) {
        if (!popover)
        {
            QuickTextViewController *quickText = [self.storyboard instantiateViewControllerWithIdentifier:@"QuickText"];
            quickText.myDelegate = self;
            
            [quickText setValues:[self getCdbList] pref:nil sub:nil];
            
            popover = [[UIPopoverController alloc] initWithContentViewController:quickText];
            popover.delegate = self;
        }
        
        [popover presentPopoverFromRect:textField.frame inView:textField.superview permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    pdfAJour = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (popover.isPopoverVisible)
        [popover dismissPopoverAnimated:YES];
    
    return YES;
}

# pragma mark - QuickTextDelegate

- (void)quickTextDidSelectString:(NSString *)string
{
    cdb.text = string;
    
    [cdb resignFirstResponder];
}


# pragma mark - PopoverDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [cdb resignFirstResponder];
}

- (void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view
{
    if (popover == popoverController)
    {
        *rect = cdb.frame;
    }
}



# pragma mark - Quick Look

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return pdfUrl;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

@end

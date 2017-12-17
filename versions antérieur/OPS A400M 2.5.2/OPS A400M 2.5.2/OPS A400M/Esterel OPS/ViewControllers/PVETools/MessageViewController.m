//
//  MessageViewController.m
//  Esterel-Alpha
//
//  Created by utilisateur on 31/01/2014.
//
//

#import "MessageViewController.h"

#import "SplitViewController.h"
#import "Mission.h"

#import "TimeTextField.h"
#import "TimeTools.h"

//COMMENT X15 : Plus utilisé

@interface MessageViewController () {
    
    NSArray *visibleCells, *settings;
    
    Mission *mission;
    NSInteger legNumber;
    NSMutableDictionary *leg;
}

@end

@implementation MessageViewController

@synthesize contexture;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    settings = @[@[@0, @1, @5, @6, @7],
                 @[@2, @3, @5, @6, @7],
                 @[@4, @5, @6, @7],
                 @[@5, @6, @7],
                 @[@0, @1, @5, @6, @7]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ((mission = ((SplitViewController*)self.splitViewController).mission))
    {
        leg = mission.activeLeg;
        legNumber = mission.activeLegIndex;
        
        NSInteger index = [self indexForType:_message[@"TypeMessage"]];
        NSInteger indexSegment = [self indexForSegment:_message[@"ChargementStandard"]];
        NSInteger indexChargement = [self indexForLoad:_message[@"ChargementStandard"]];
        
        if (index == 0) {
            visibleCells = settings[indexChargement];
        }
        else visibleCells = settings[index];
        
        
        self.frequence.myDelegate = self;
        self.indicatifE.myDelegate = self;
        self.indicatifR.myDelegate = self;
        self.priorite.myDelegate = self;
        self.heure.myDelegate = self;
        self.heureEstAtr.myDelegate = self;
        
        self.longitude.myDelegate = self;
        self.latitude.myDelegate = self;
        self.nouvLong.myDelegate = self;
        self.nouvLat.myDelegate = self;
        self.arrEst.myDelegate = self;
        self.qrx.myDelegate = self;
        self.destinataires.myDelegate = self;
        self.infos.myDelegate = self;
        self.rep.myDelegate = self;
        
        self.typeMessage.selectedSegmentIndex = index;
        self.chargementStandard.selectedSegmentIndex = indexSegment;
    
        self.frequence.text = _message[@"Frequence"];
        self.indicatifE.text = _message[@"IndicatifE"];
        self.indicatifR.text = _message[@"IndicatifR"];
        self.priorite.text = _message[@"PrioriteTransmission"];
        self.heure.time = _message[@"Heure"];
        //destinataires
        self.destinataires.text = _message[@"Destinataires"];
        //infos
        self.infos.text = _message[@"Infos"];
        
        self.heureEstAtr.time = _message[@"HeureEstimeeAtterrissage"];
        self.longitude.text = _message[@"Longitude"];
        self.latitude.text = _message[@"Latitude"];
        self.nouvLong.text = _message[@"NouvelleLongitude"];
        self.nouvLat.text = _message[@"NouvelleLatitude"];
        self.arrEst.time = _message[@"ArriveeEstimee"];
        self.qrx.time = _message[@"ProchainContact"];
        self.rep.text = _message[@"reponse"];
        
      
        
        [self reloadLabel];
        
        self.copButton.enabled = (legNumber != 0);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (mission.delegate == nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)reloadLabel
{
    self.nouvPosLabel.text = [NSString stringWithFormat:@"Nouvelle estimée à %@ Z", self.qrx.text];
}


- (NSInteger)indexForType:(NSString*)type
{
    if ([type isEqualToString:@"DEPART"])
        return 0;
        
    if ([type isEqualToString:@"POSITION"])
        return 1;
    
    if ([type isEqualToString:@"ARRIVEE"])
        return 2;
    
    return 3;
}

- (NSInteger) indexForLoad: (NSString*)chargement
{
    if ([chargement isEqualToString:@"OUI"])
        return 0;
    if ([chargement isEqualToString:@"NON"])
        return 4;
    
   else return 0;
}
- (NSInteger) indexForSegment: (NSString*)chargement
{
    if ([chargement isEqualToString:@"OUI"])
        return 0;
    if ([chargement isEqualToString:@"NON"])
        return 1;
    
    else return 0;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((section == 1) ? visibleCells.count : [super tableView:tableView numberOfRowsInSection:section]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView cellForRowAtIndexPath:((indexPath.section == 1) ? [NSIndexPath indexPathForRow:[visibleCells[indexPath.row] integerValue] inSection:1] : indexPath)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView heightForRowAtIndexPath:((indexPath.section == 1) ? [NSIndexPath indexPathForRow:[visibleCells[indexPath.row] integerValue] inSection:1] : indexPath)];
}

- (IBAction)typeChange:(UISegmentedControl*)sender
{
    
    NSInteger index = sender.selectedSegmentIndex;
    
    _message[@"TypeMessage"] = [sender titleForSegmentAtIndex:index];
    
    if ([_message[@"TypeMessage"] isEqual : @"DEPART"]&&[_message[@"ChargementStandard"] isEqual : @"NON"]) {index = 4;}
    
    visibleCells = settings[index];
    
    [self.tableView reloadData];
     _message[@"contenu"] = [self genereMessage];
}

- (IBAction)chargementChange:(UISegmentedControl*)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    _message[@"ChargementStandard"] = [sender titleForSegmentAtIndex:index];
    
    if (index == 1) { index = 4; }
    
    visibleCells = settings[index];
    
    [self.tableView reloadData];
     _message[@"contenu"] = [self genereMessage];
}


- (IBAction)copyInfos:(id)sender
{
    NSMutableString *text = [self.infos.text mutableCopy];
    
    if (![text isEqualToString:@""])
        [text appendString:@"\n"];
    
    [text appendString:mission.legs[legNumber-1][@"Message"][0][@"Infos"]];
    
    self.infos.text = text;
    
    _message[@"Infos"] = text;
     _message[@"contenu"] = [self genereMessage];
}






# pragma mark - TextField & TextView delegate


- (void)myTextFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 600: _message[@"Frequence"] = textField.text;
            break;
        case 601: _message[@"IndicatifE"] = textField.text;
            break;
        case 602: _message[@"IndicatifR"] = textField.text;
            break;
        case 603: _message[@"PrioriteTransmission"] = textField.text;
            break;
        case 604: _message[@"Heure"] = ((TimeTextField*)textField).time;
            break;
        case 605: _message[@"Destinataires"] = textField.text;
            break;

            
        case 610: _message[@"HeureEstimeeAtterrissage"] = ((TimeTextField*)textField).time;
            break;
        case 611: _message[@"Palettes"] = textField.text;
            break;
        case 612: _message[@"Longitude"] = textField.text;
            break;
        case 613: _message[@"Latitude"] = textField.text;
            break;
        case 614: _message[@"NouvelleLongitude"] = textField.text;
            break;
        case 615: _message[@"NouvelleLatitude"] = textField.text;
            break;
        case 616: _message[@"ArriveeEstimee"] = ((TimeTextField*)textField).time;
            break;
        case 617: _message[@"ProchainContact"] = ((TimeTextField*)textField).time;
            
            break;
        case 618:  _message[@"Infos"] = textField.text;
            break;
            
        case 650: _message[@"reponse"] = textField.text;
            break;
            

    }
    [self reloadLabel];
    _message[@"contenu"] = [self genereMessage];
}




# pragma mark - Message Apercu

- (NSMutableString*)genereMessage
{
    NSMutableString *texte = [[NSMutableString alloc]init];
    
    if(contexture.selectedSegmentIndex==1){ //Contexture ancienne CDAOA
        
        texte = [NSMutableString stringWithFormat:
                 @"                Message n°%ld\n\n"
                 "Fréquence: %@     Indicatif R.: %@     Indicatif E.: %@\n\n"
                 "%@  CJ A %@  AO %@  %@",
                 (long)_messageNumber,
                 _message[@"Frequence"], _message[@"IndicatifR"], _message[@"IndicatifE"],
                 _message[@"PrioriteTransmission"], self.heure.text, leg[@"CallSign"], _message[@"Destinataires"]];
        
        if ([@"DEPART" isEqualToString:_message[@"TypeMessage"]])
        {

            
            NSDate *OBTime = leg[@"OffBlocksTime"], *TOTime = leg[@"TakeOffTime"];
            
            [texte appendFormat:@"\nR/L %@ %@ Z   D/L %@ Z   EST ARR %@ %@ Z\n"
             "PEQ: %lu   PAX: %@   FRET: %@ kg ",
             leg[@"DepartureAirport"],
             [TimeTools stringFromTime:OBTime withDays:NO],
             [TimeTools stringFromTime:TOTime withDays:NO],
             leg[@"ArrivalAirport"],
             self.heureEstAtr.text,
             (unsigned long)((NSArray*)leg[@"CrewMember"]).count,
             leg[@"numberOfPax"],
             leg[@"TotalWeight"]];
            
            if (YES) {
                [texte appendFormat:@"DONT %@ kg SUR %@ PAL, %@ kg ROULANT, %@ kg VRAC", leg[@"weightOfPallet"], leg[@"numberOfPallet"], leg[@"weightOfWheeled"], leg[@"bulkWeight"]];
            }
            else [texte appendFormat:@"\nCHARGEMENT STANDARD"];
        }
        
        
        
        if ([@"POSITION" isEqualToString:_message[@"TypeMessage"]])
        {
            [texte appendFormat:@"\nPOSITION  %@ / %@\n"
             "NEW ESTIMATE  %@ / %@\n"
             "OPERATION NORMALE",
             _message[@"Latitude"],
             _message[@"Longitude"],
             _message[@"NouvelleLatitude"],
             _message[@"NouvelleLongitude"]];
        }
        
        if ([@"ARRIVEE" isEqualToString:_message[@"TypeMessage"]])
        {
            [texte appendFormat:@"\nARRIVEE %@ A %@ Z\n",
             leg[@"ArrivalAirport"],
             self.arrEst.text];
        }
        
        
        [texte appendFormat:@"\n\n%@", _message[@"Infos"]];
        
        if ([@"DEPART" isEqualToString:_message[@"TypeMessage"]] || [@"POSITION" isEqualToString:_message[@"TypeMessage"]]) {
            [texte appendFormat:@"\n\nQRX: %@ Z", self.qrx.text];
        }
        
        
        
        
        
        //if ([@"ARRIVEE" isEqualToString:_message[@"TypeMessage"]])
        //{
        // [texte appendFormat:@"\n\nMISSION TERMINEE"];
        // }
        
        
        
    }
    
    else{//contexture EATC
        texte = [NSMutableString stringWithFormat:
                 @"                Message n°%ld\n\n"
                 "Fréquence: %@     Indicatif R.: %@     Indicatif E.: %@\n\n"
                 "CJ A %@ %@  %@",
                 (long)_messageNumber,
                 _message[@"Frequence"], _message[@"IndicatifR"], _message[@"IndicatifE"], self.heure.text, leg[@"CallSign"], _message[@"Destinataires"]];
        
        if ([@"DEPART" isEqualToString:_message[@"TypeMessage"]])
        {

            
            NSDate *OBTime = leg[@"OffBlocksTime"], *TOTime = leg[@"TakeOffTime"];
            
            [texte appendFormat:@"\nR/L %@ %@ Z   D/L %@ Z   EST ARR %@ %@ Z\n",
             leg[@"DepartureAirport"],
             [TimeTools stringFromTime:OBTime withDays:NO],
             [TimeTools stringFromTime:TOTime withDays:NO],
             leg[@"ArrivalAirport"],
             self.heureEstAtr.text];
            
            if ([_message[@"ChargementStandard"] isEqual:@"NON"]) {
                [texte appendFormat:@"PAX: %@, FRET:  %@ kg SUR %@ PAL, %@ kg ROULANT, %@ kg VRAC", leg[@"numberOfPax"], leg[@"weightOfPallet"], leg[@"numberOfPallet"], leg[@"weightOfWheeled"], leg[@"bulkWeight"]];
            }
            else [texte appendFormat:@"\nCHARGEMENT CONFORME ATMO"];
        }
        
        
        
        if ([@"POSITION" isEqualToString:_message[@"TypeMessage"]])
        {
            [texte appendFormat:@"\nPOSITION  %@ / %@\n"
             "NEW ESTIMATE  %@ / %@\n"
             "OPERATION NORMALE",
             _message[@"Latitude"],
             _message[@"Longitude"],
             _message[@"NouvelleLatitude"],
             _message[@"NouvelleLongitude"]];
        }
        
        if ([@"ARRIVEE" isEqualToString:_message[@"TypeMessage"]])
        {
            [texte appendFormat:@"\nARRIVEE %@ A %@ Z\n",
             leg[@"ArrivalAirport"],
             self.arrEst.text];
        }
        
        
        
        [texte appendFormat:@"\n\n%@", _message[@"Infos"]];
        
        if ([@"DEPART" isEqualToString:_message[@"TypeMessage"]] || [@"POSITION" isEqualToString:_message[@"TypeMessage"]]) {
            [texte appendFormat:@"\n\nQRX: %@ Z", self.qrx.text];
        }
        
        
    }

    return texte;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    _message[@"contenu"] = [self genereMessage];
    if ([segue.identifier isEqualToString:@"MessageViewSegue"])
    {
        UITextView *textView = (UITextView*)[[segue.destinationViewController view] viewWithTag:1];
        
        
        
        textView.text = [self genereMessage];
    }
}

@end

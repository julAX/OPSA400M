//
//  Mission.m
//  Esterel OPS
//
//  Created by utilisateur on 13/12/13.
//
//

/* COMMENT X15:
 
 Ce fichier est un des plus importants, il s'agit de l'ouverture de la mission au format XML, la plupars du temps les missions seront des fichiers XML classiques et seront converties au format binaire dégueu lors du premier enregistrement pour plus de facilitée d'enregistrement et d'ouverture.
 
 On gère pas mal de truc ici puisque c'est quand même l'objet mission qui contient toute la mission finalement.
 */


#import "Mission.h"
#import "XMLDictionary.h"
#include "Cargo.h"
#import "TimeTools.h"


@interface Mission ()
{
    NSMutableDictionary *ftaVierge, *legVierge, *crewMemberVierge, *mesVierge, *messageVierge, *paxCargoVierge,*indicatorsVierge;
    //*refEntVierge;
    NSMutableArray *instanceArrayVierge;
}

@end

@implementation Mission

@synthesize Instances, benefList;
// Init & save : à ne pas toucher // Comment X2015 : Oups....

- (Mission *)initWithFile:(NSString *)path
{
    self = [self init];
    self.root[@"Reseau"] = @"RSAO 2";
    
    //Ajout X15
    self.Instances = [[NSMutableSet alloc ]init];
    self.benefList = [[NSMutableDictionary alloc]init];
    
    // fin ajout
    
    NSLog(@"Opening file: %@", path);
    
    self.path = path;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //NSMutableDictionary *dict = [(NSDictionary*)[NSDictionary dictionaryWithContentsOfFile:_path] mutableDeepCopy];
        //NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:_path];
        NSMutableDictionary * dict;
        
        @try{
            dict = [NSKeyedUnarchiver unarchiveObjectWithFile:_path];
        }
        
        @catch(NSException *exep){
        }
        
        @finally{
        }
        
        if (dict)
            _root = dict;
        else // Si le dictionnaire est nul cela signifie qu'on est en présence d'un fichier qui n'est pas une plist
            [self loadOldVersion:path];
    }
    
    
    
    else // Modifications de la mission vierge pour correspondre aux exigences
    {
        [self.root[@"Derog"] removeAllObjects];
        self.root[@"Leg"][0] = [legVierge mutableDeepCopy];
    }
    

    _legs = _root[@"Leg"];
    _activeLegIndex = 0;
    _activeLeg = _legs[0];
    _activeLeg[@"cargoList"]=[[NSMutableArray alloc]init];
    
    
    
    for(NSDictionary *cargDict in _root[@"InstanceArray"]){
        Cargo *carg = [[Cargo alloc] initWithMission:self];
        
        carg.be=cargDict[@"be"];
        carg.type = ([cargDict[@"type"] isEqual:@"pax"])? pax : (([cargDict[@"type"]  isEqual: @"freight"])? freight :([cargDict[@"type"]  isEqual: @"vrac"])? vrac : roulant);
        carg.weight=cargDict[@"weight"];
        carg.arrival=cargDict[@"arrival"];
        carg.departure=cargDict[@"departure"];
        carg.drop = ([cargDict[@"drop"] isEqualToString:@"1"])? YES : NO;
        carg.absurde = ([cargDict[@"absurde"] isEqualToString:@"1"])? YES : NO;
        carg.numArrnumDep[0]=[NSNumber numberWithInteger:[cargDict[@"legDep"] integerValue]];
        carg.numArrnumDep[1]=[NSNumber numberWithInteger:[cargDict[@"legArr"] integerValue]];
        carg.paxWeight= [cargDict[@"paxWeight"] floatValue];
        carg.nombrePax= [cargDict[@"nombrePax"] integerValue];
        carg.comment = cargDict[@"comment"];
    }
    
    for(NSMutableDictionary *leg in self.legs){
        if([leg[@"Na"] isEqualToString:@""] || leg[@"Na"]==nil ){
            leg[@"Na"]=@"22";
        
        }
        
        if(!leg[@"Indicators"]){
            leg[@"Indicators"]=indicatorsVierge;
        }
        
        if(!leg[@"CrewTickSheets"]){
            leg[@"CrewTickSheets"]=[[NSMutableArray alloc]init];
            [leg[@"CrewTickSheets"] addObject:[[NSMutableArray alloc]init]];
            NSDate * datenulle = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:0.];
            
            NSMutableArray *engine = [[NSMutableArray alloc] initWithArray:@[@[@"0",datenulle],@"0",@"0",@"0",@"0",@[@"0",datenulle],@"0",@"0",@"0",@"0",datenulle]];
            [leg[@"CrewTickSheets"][0] addObject:[[NSString alloc]init]];
            [leg[@"CrewTickSheets"][0] addObject:[engine mutableDeepCopy]];
            [leg[@"CrewTickSheets"][0] addObject:[engine mutableDeepCopy]];
            [leg[@"CrewTickSheets"][0] addObject:[engine mutableDeepCopy]];
            [leg[@"CrewTickSheets"][0] addObject:[engine mutableDeepCopy]];
            [leg[@"CrewTickSheets"][0] addObject:@"1"];
        }
    }
    
    // Verification du nom de l'escadron
    
    if([self.root[@"Unit"] containsString:@"1/61"] || [self.root[@"Unit"] containsString:@"Touraine"] ){
        self.root[@"Unit"] = @"ET 1/61 Touraine";
    }

    
    [Cargo reloadBenefListWithMission:self];
    return self;
}


// Initialisation de la mission vide et des objects vierges réutilisables

- (Mission *)init
{
    self = [super init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MissionVierge" ofType:@"plist"];
    
    //    _root = [(NSDictionary*)[NSDictionary dictionaryWithContentsOfFile:path] mutableDeepCopy];
    _root = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    

    
    ftaVierge = [(NSMutableDictionary*)[self.root[@"FTA"] firstObject] mutableDeepCopy];
    legVierge = [(NSMutableDictionary*)[self.root[@"Leg"] firstObject] mutableDeepCopy];
    
    crewMemberVierge = [(NSMutableDictionary*)[legVierge[@"CrewMember"] firstObject] mutableDeepCopy];
    messageVierge = [(NSMutableDictionary*)[legVierge[@"Message"] firstObject] mutableDeepCopy];
    mesVierge = [(NSMutableDictionary*)[legVierge[@"MES"] firstObject] mutableDeepCopy];
    paxCargoVierge = [(NSMutableDictionary*)[legVierge[@"PaxCargo"] firstObject] mutableDeepCopy];
    indicatorsVierge = [(NSMutableDictionary*)legVierge[@"Indicators"] mutableDeepCopy];
    paxCargoVierge[@"Name"] = @"";
    instanceArrayVierge = [(NSMutableArray*) self.root[@"InstanceArray"] mutableDeepCopy];
    self.crewTickSheetVierge = [((NSMutableArray*) ((NSMutableArray*) self.root[@"Leg"]).firstObject[@"CrewTickSheets"]).firstObject mutableDeepCopy];
    // refEntVierge = [(NSMutableDictionary*)[legVierge[@"CrewMember"][@"Entrainement"][@"Item"] firstObject] mutableDeepCopy];
    
    [legVierge[@"CrewMember"] removeAllObjects];
    [legVierge[@"MES"] removeAllObjects];
    [legVierge[@"Message"] removeAllObjects];
    [self.root[@"InstanceArray"] removeAllObjects];
    
    _legs = _root[@"Leg"];
    _activeLegIndex = 0;
    _activeLeg = _legs[0];
    
    _activeLeg[@"cargoList"]=[[NSMutableArray alloc]init];
    
    
    return self;
}



- (void)save
{
    [self.root[@"InstanceArray"] removeAllObjects];
    for (NSInteger i = 0; i<self.legs.count;i++){
        [self.legs[i][@"cargoList"] removeAllObjects];
    }
    
    NSEnumerator *instancesEnumerator = [self.Instances objectEnumerator];
    Cargo *carg;
    while(carg = [instancesEnumerator nextObject]){
        NSMutableDictionary *cargDict = [[NSMutableDictionary alloc] init];
        
        cargDict[@"be"]=[NSString stringWithString: carg.be];
        
        cargDict[@"type"]= (carg.type==pax)? @"pax" : ((carg.type==freight)? @"freight" : ((carg.type==vrac)? @"vrac" : @"roulant"));
        
        cargDict[@"weight"]=[NSString stringWithString:carg.weight];
        cargDict[@"arrival"]=[NSString stringWithString:carg.arrival];
        cargDict[@"departure"]=[NSString stringWithString:carg.departure];
        cargDict[@"drop"]=(carg.drop)? @"1": @"0";
        NSInteger legDep = [carg.numArrnumDep[0] integerValue];
        NSInteger legArr = [carg.numArrnumDep[1] integerValue];
        cargDict[@"legDep"]=@(legDep).description;
        cargDict[@"legArr"]=@(legArr).description;
        cargDict[@"absurde"]=(carg.absurde)? @"1": @"0";
        cargDict[@"paxWeight"]=((@(carg.paxWeight).description)? @(carg.paxWeight).description : @"") ;
        cargDict[@"nombrePax"]=((@(carg.nombrePax).description)? @(carg.nombrePax).description : @"") ;
        cargDict[@"comment"] = [NSString stringWithString:carg.comment];
        
        [self.root[@"InstanceArray"] addObject : cargDict];
    }
    
    NSLog(@"Saving file: %@", _path);


    NSError *error;
//    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:_root format:NSPropertyListBinaryFormat_v1_0 options:0
//                                                                    error:&error];
    
    NSData *plistData = [NSKeyedArchiver archivedDataWithRootObject: self.root];
    
    if(plistData)
        [plistData writeToFile:_path atomically:YES];
    else
        NSLog(@"Error : %@",error);
    
}


// Fonction de conversion d'un ancien fichier xml sous le nouveau format, il s'agit de remplir la mission vierge avec les informations récupérées dans le fichier XML puis de copier les informations donc le format a été modifié

- (void)loadOldVersion:(NSString *)path
{
    NSDictionary* xmlDict = [NSDictionary dictionaryWithXMLFile:path];
    
    if ([Mission recurrFill:self.root with:xmlDict]) {
        
        NSArray *xmlLegs = [xmlDict arrayValueForKeyPath:@"Leg"], *xmlMessages = [xmlDict arrayValueForKeyPath:@"Message"], *xmlMES = [xmlDict arrayValueForKeyPath:@"MES"];
        
        NSString *val;
        
        for (NSUInteger l = 0; l < xmlLegs.count; l++) {
            
                        [self.legs[l][@"Message"] removeAllObjects];
            [self.legs[l][@"MES"] removeAllObjects];
            
            // Correction d'une incohérence
            if ((val = xmlLegs[l][@"GroundInitial"]))
                self.legs[l][@"FuelAtTakeOff"] = val;
        }
        
        NSInteger l;
        NSMutableDictionary *dico;
        
        for (NSDictionary *messageXML in xmlMessages) {
            
            l = [messageXML[@"NumeroEtape"] integerValue] - 1;
            
            if (l >= 0 && l < self.legs.count) {
                dico = [messageVierge mutableDeepCopy];
                
                if (![Mission recurrFill:dico with:messageXML])
                    NSLog(@"Erreur Message");
                
                [self.legs[l][@"Message"] addObject:dico];
            }
        }
        
        for (NSDictionary *mesXML in xmlMES) {
            
            l = [mesXML[@"Leg"] integerValue] - 1;
            
            if (l >= 0 && l < self.legs.count) {
                dico = [mesVierge mutableDeepCopy];
                
                [Mission recurrFill:dico with:mesXML];
                
                [self.legs[l][@"MES"] addObject:dico];
            }
        }
        
        if (!xmlDict[@"Derog"])
            [self.root[@"Derog"] removeAllObjects];
        
        // Ajout X15 : on corrige la fonction du CDB en PCB (qui est different de Pcb) et on ajoute les array pour le crew tick sheet
        
        for (NSMutableDictionary *leg in self.legs){
            //Crew tick sheet
            if(!leg[@"CrewTickSheets"]){
                leg[@"CrewTickSheets"]=[[NSMutableArray alloc]init];
                [leg[@"CrewTickSheets"] addObject:[[NSMutableArray alloc]init]];
                NSDate * datenulle = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:0.];
                
                NSMutableArray *engine = [[NSMutableArray alloc] initWithArray:@[@[@"0",datenulle],@"0",@"0",@"0",@"0",@[@"0",datenulle],@"0",@"0",@"0",@"0",datenulle]];

                [leg[@"CrewTickSheets"][0] addObject:[[NSString alloc]init]];
                [leg[@"CrewTickSheets"][0] addObject:[engine mutableDeepCopy]];
                [leg[@"CrewTickSheets"][0] addObject:[engine mutableDeepCopy]];
                [leg[@"CrewTickSheets"][0] addObject:[engine mutableDeepCopy]];
                [leg[@"CrewTickSheets"][0] addObject:[engine mutableDeepCopy]];
                [leg[@"CrewTickSheets"][0] addObject:@"1"];

            }
            
            
            //CDB
            for(NSMutableDictionary * pil in leg[@"CrewMember"]){
                if([pil[@"Function"] isEqualToString:@"CDB"]){
                    pil[@"Function"]=@"PCB";
                }
            }
        }
    }
    else
        NSLog(@"loadOldVersion Error!!!");
    
}


// Fonction de remplissage d'un dictionnaire par un autre, uniquement adapté à la situation présente, quand une clé n'existe pas dans le dictionnaire de destination, elle n'est simplement pas copiée, cela assure un respect du format prédéfini

+ (NSMutableDictionary*)recurrFill:(NSMutableDictionary*)target with:(NSDictionary*)source
{
    for (NSString* key in source)
    {
        id src = source[key], trg = target[key];
        
        if (trg)
        {
            if ([src isKindOfClass:[NSString class]]) {
                
                if ([trg isKindOfClass:[NSString class]])
                    target[key] = src;
                else if ([trg isKindOfClass:[NSDate class]])
                    target[key] = [TimeTools dateFromString:src];
                else
                    return nil;
                
            }
            else if ([src isKindOfClass:[NSArray class]]) {
                
                if ([trg isKindOfClass:[NSArray class]]) {
                    
                    NSUInteger l = [src count], i;
                    id srcDic, trgDic;
                    
                    for (i = 1; i < l; i++)
                        [trg addObject:[(NSMutableDictionary*)[trg firstObject] mutableDeepCopy]];
                    
                    for (i = 0; i < l; i++) {
                        
                        srcDic = src[i];
                        trgDic = trg[i];
                        
                        if ([srcDic isKindOfClass:[NSDictionary class]] && [trgDic isKindOfClass:[NSMutableDictionary class]]) {
                            if (![Mission recurrFill:trgDic with:srcDic])
                                return nil;
                        }
                        else
                            return nil;
                    }
                }
                else
                    return nil;
                
            }
            else if ([src isKindOfClass:[NSDictionary class]]) {
                
                if ([trg isKindOfClass:[NSArray class]]) {
                    if (![Mission recurrFill:[trg firstObject] with:src])
                        return nil;
                }
                else if ([trg isKindOfClass:[NSDictionary class]]) {
                    if (![Mission recurrFill:trg with:src])
                        return nil;
                }
                else
                    return nil;
                
            }
        }
    }
    
    return target;
}



- (NSMutableArray*)loadCrewMembers
{
    NSMutableDictionary *pers, *elt;
    NSUInteger legIndex = 0;
    
    NSMutableArray *crewMembers = [NSMutableArray new];
    
    for (NSDictionary *leg in self.legs) {
        for (NSDictionary *crewMember in leg[@"CrewMember"]) {
            if ((elt = [Mission crewMemberArray:crewMembers contains:crewMember[@"Name"]])) {
                
                elt[@"Presence"][@(legIndex).description] = [NSString stringWithFormat:@"%@ %@",
                                                             crewMember[@"Function"],
                                                             crewMember[@"Position"]];
            }
            else {
                pers = [crewMember mutableCopy];
                
                pers[@"Presence"] = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@",
                                                                               crewMember[@"Function"],
                                                                               crewMember[@"Position"]] forKey: @(legIndex).description];
                [crewMembers addObject:pers];
            }
        }
        legIndex ++;
    }
    
    return crewMembers;
}


- (NSMutableArray*)loadCrewMembersInLeg :(NSInteger)l{
    
    NSMutableArray * crewMembers = [NSMutableArray array];
    NSMutableDictionary *pers, *elt;
    NSDictionary * leg = self.legs[l];
    for (NSDictionary *crewMember in leg[@"CrewMember"]) {
        if ((elt = [Mission crewMemberArray:crewMembers contains:crewMember[@"Name"]])) {
            
            elt[@"Presence"][@(l).description] = [NSString stringWithFormat:@"%@ %@",
                                                         crewMember[@"Function"],
                                                         crewMember[@"Position"]];
        }
        else {
            pers = [crewMember mutableCopy];
            
            pers[@"Presence"] = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %@",
                                                                           crewMember[@"Function"],
                                                                           crewMember[@"Position"]] forKey: @(l).description];
            [crewMembers addObject:pers];
        }
    }
    
    return crewMembers;
}




+ (NSMutableDictionary*)crewMemberArray:(NSArray*)array contains:(NSString*)crewMemberName
{
    for (NSMutableDictionary *elt in array)
        if ([elt[@"Name"] isEqualToString:crewMemberName])
            return elt;
    
    return nil;
}


// Le setter de la variable activeLegIndex déclenche la mise a jour de activeLeg et averti le delegate

- (void)setActiveLegIndex:(NSInteger)index
{
    _activeLegIndex = index;
    _activeLeg = self.legs[index];
    
    [self.delegate activeLegDidChange:_activeLegIndex];
}



// Deux simples fonctions de recherche d'informations simples dans la mission

- (NSString*)route {
    
    NSMutableString *str = [self.legs[0][@"DepartureAirport"] mutableCopy];
    
    for (NSUInteger i = 0; i < self.legs.count; i++)
        [str appendFormat:@"-%@", self.legs[i][@"ArrivalAirport"]];
    
    return [NSString stringWithString:str];
}

- (NSArray*)airportList {
    
    NSMutableArray *airportList = [@[[self.legs[0][@"DepartureAirport"] mutableCopy]] mutableCopy];
    
    for (NSUInteger i = 0; i < self.legs.count; i++)
        [airportList addObject: self.legs[i][@"ArrivalAirport"]];
    
    return [NSArray arrayWithArray:airportList];
}


//intéressant pour sélectionner les PIL
- (NSString *)cdbForLeg:(NSInteger)l
{
    for (NSDictionary *crewMember in self.legs[l][@"CrewMember"]) {
        if ([crewMember[@"Function"] rangeOfString:@"PCB" options:NSCaseInsensitiveSearch].location != NSNotFound)
            return crewMember[@"Name"];
        
    }
    
    return @"";
    
}




- (void)addLeg
{
    NSMutableDictionary *newLeg = [legVierge mutableDeepCopy];
    
    
    if (self.legs.count != 0)
    {
        NSMutableArray *tab = [self.legs.lastObject[@"PaxCargo"] mutableDeepCopy];
        NSArray *keys = @[@"CargoIn", @"CargoOnBoard", @"CargoDropped", @"CargoOut", @"PaxIn", @"PaxOnBoard", @"PaxDropped", @"PaxOut"];
        
        for (NSMutableDictionary *paxCargo in tab)
            for (NSString *key in keys)
                paxCargo[key] = @"0";
        
        newLeg[@"PaxCargo"] = tab;
        
        newLeg[@"DepartureAirport"] = self.legs.lastObject[@"ArrivalAirport"];
        
        //Ajout X15
        
        newLeg[@"CrewMember"] = [self.legs.lastObject[@"CrewMember"] mutableDeepCopy];
        newLeg[@"CallSign"] = [self.legs.lastObject[@"CallSign"] copy];
        
        
        //Fin ajout X15
        
    }
    
    [self.legs addObject:newLeg];
}




- (void)deleteLegAtIndex:(NSInteger)index {
    [self.legs removeObjectAtIndex:index];
    if(index>=1 && index < self.legs.count){
        self.legs[index][@"DepartureAirport"]=self.legs[index-1][@"ArrivalAirport"];

    }
    

    
    NSEnumerator * cargEnum = [self.Instances objectEnumerator];
    

    Cargo *carg;
    while(carg = [cargEnum nextObject]){

        NSInteger depp = [carg.numArrnumDep[0] integerValue];
        NSInteger arr = [carg.numArrnumDep[1] integerValue];
        if(depp>index || (depp==index && index==self.legs.count)){
            carg.numArrnumDep[0]= [NSNumber numberWithInteger:[carg.numArrnumDep[0] integerValue]-1];

        }
        if(arr>index || (arr==index && index==self.legs.count)){
            carg.numArrnumDep[1]= [NSNumber numberWithInteger:[carg.numArrnumDep[1] integerValue]-1];
 
        }

        if(arr==index || depp==index){
        
            carg.absurde = YES;

        }
    }

    
    [carg initSetOfLegs];
    

    [Cargo reloadBenefListWithMission:self];

}


- (void)addPaxCargo
{
    //Rajoute un dico paxCargo vierge dans chaque leg
    NSUInteger index = [(NSArray*)[self.legs firstObject][@"PaxCargo"] count] - 1;
    
    for (NSDictionary *leg in self.legs)
        [leg[@"PaxCargo"] insertObject:[paxCargoVierge mutableDeepCopy] atIndex:index];
}

- (void)deletePaxCargoAtIndex:(NSInteger)index
{
    for (NSDictionary *leg in self.legs)
        [leg[@"PaxCargo"] removeObjectAtIndex:index];
}


- (NSMutableDictionary*)getCrewMemberVierge { return [crewMemberVierge mutableDeepCopy]; }

- (NSMutableDictionary*)getMessageVierge { return [messageVierge mutableDeepCopy]; }

- (NSMutableDictionary*)getMesVierge { return [mesVierge mutableDeepCopy]; }
//- (NSMutableDictionary*)getRefEntVierge { return [refEntVierge mutableDeepCopy]; }

#pragma mark indicators

-(void) indicatorsForLeg:(NSInteger)l{
    
    NSMutableArray *crewMembers = [self loadCrewMembersInLeg:l];
    NSDictionary * leg = self.legs[l];
    NSDictionary * indic = leg[@"Indicators"];
    NSMutableArray *pilotes =[NSMutableArray array];
    
    //Cette fonction sélectionne les membres d'équipage dont la fonction est PCB, Pcb ou PIL et les met dans un NSMutableArray pilotes Puis on regarde si chacun a une place attribuée.
    
    
    //Crew
    for(NSDictionary *crewMember in crewMembers) {
        
        if ([crewMember[@"Function"] rangeOfString:@"Pcb" options:NSCaseInsensitiveSearch].location != NSNotFound)
            [pilotes addObject: crewMember];
        if ([crewMember[@"Function"] rangeOfString:@"PIL" options:NSCaseInsensitiveSearch].location != NSNotFound)
            [pilotes addObject: crewMember];
        if ([crewMember[@"Function"] rangeOfString:@"CDB" options:NSCaseInsensitiveSearch].location != NSNotFound)
            [pilotes addObject: crewMember];
        
        
        
    }
    
    BOOL finished = YES;
    BOOL enCours = NO;
    
    for (NSDictionary *pilote in pilotes){
        if(![pilote[@"Position"] isEqualToString:@""] && pilote[@"Position"]){
            enCours = YES;
        }
        else{
            finished = NO;
        }
    }
    
    indic[@"Crew"][0] = (enCours)?@"1":@"0";
    indic[@"Crew"][1] = (finished)?@"1":@"0";
    
    // PVE
    
    indic[@"PVE"][0]=@"0";
    indic[@"PVE"][1]=@"0";
    BOOL depart = NO;

    BOOL arrive = NO;
    
    for (NSDictionary *message in leg[@"Message"]){
        if([message[@"TypeMessage"] isEqualToString:@"DEPART"]){
            indic[@"PVE"][0]=@"1";
            depart = YES;
        }
        if([message[@"TypeMessage"] isEqualToString:@"POSITION"]){
            indic[@"PVE"][0]=@"1";
        }
        if([message[@"TypeMessage"] isEqualToString:@"ARRIVEE"]){
            arrive=YES;
        }
    }

    if(depart){ //anciennement arrive && depart pour avoir les 2 messages pour passer au vert
        indic[@"PVE"][1]=@"1";
    }
    

    //OMA
    
    BOOL omafinished = YES;
    BOOL omaInProgress = NO;
    
    NSArray * keys =@[@"Crew",@"Departure",@"Arrival"];
    
    for (NSString *key in keys){
        if([indic[key][0] isEqualToString:@"1"])
            omaInProgress = YES;
        if([indic[key][1] isEqualToString:@"0"])
            omafinished = NO;
    }

    
    
    
    if(omafinished)
        indic[@"OMA"][1]=@"1";
    else
        indic[@"OMA"][1]=@"0";
    
    if(omaInProgress)
        indic[@"OMA"][0]=@"1";
    else
        indic[@"OMA"][0]=@"0";
    
    
    //Maintenant on verifie si la leg est bonne
    
    BOOL legFinished = YES;
    BOOL legInProgress = NO;
    
    if([indic[@"OMA"][1] isEqualToString:@"0"] || [indic[@"CrewTickSheet"][1] isEqualToString:@"0"] || [indic[@"PVE"][1] isEqualToString:@"0"])
        legFinished=NO;
    if([indic[@"OMA"][0] isEqualToString:@"1"] || [indic[@"CrewTickSheet"][0] isEqualToString:@"1"] || [indic[@"PVE"][0] isEqualToString:@"1"])
        legInProgress=YES;
    
    
    [indic setValue:((legFinished)? @"1":@"0") forKey:@"Finished"];
    [indic setValue:((legInProgress)? @"1":@"0") forKey:@"InProgress"];
    
}

-(NSString*) missionIndicators{
    NSString *reponse =@"";
    NSDictionary *mis = self.root;
    if([Mission testVide : mis[@"MissionNumber"]]){
        reponse = [reponse stringByAppendingString:@"- Missing Mission Number\n"];
    }
    if([Mission testVide : mis[@"Aircraft"]]){
        reponse = [reponse stringByAppendingString:@"- Missing Aircraft Number\n"];
    }
    if([Mission testVide : mis[@"Unit"]]){
        reponse = [reponse stringByAppendingString:@"- Missing Unit\n"];
    }
    
    for (int i = 0 ; i<self.legs.count ; i++){
        [self indicatorsForLeg:i];
        if([self.legs[i][@"Indicators"][@"Finished"] isEqualToString:@"0"]){
            reponse = [reponse stringByAppendingFormat:@"- Leg N°%ld incomplete \n", (long)i + 1];
        }
    }
    
    if([mis[@"RefEntIndicators"]isEqualToString:@"0"] || [Mission testVide:mis[@"RefEntIndicators"]]){
        reponse = [reponse stringByAppendingFormat:@"- Training Grid (RE) incomplete (Go to 'Entraînement' in the section : End Of Mission ) \n"];
    }
    
    if(![Mission testVide:reponse]){
        reponse = [reponse stringByAppendingString: @"Please complete the previous items before sending the OMA and RE to anyone" ];
        reponse = [@"The Following items are incomplete : \n" stringByAppendingString: reponse ];
    }
    
    return reponse;
}

+(BOOL) testVide : (NSString*)string{
    if([string isEqualToString:@""] || !string)
        return YES;
    else
        return NO;

}

@end





// Deep Copying, indispensable pour copier un dictionnaire ou un tableau de manière récursive


@implementation NSArray (Mission)

- (NSArray*) deepCopy {
    NSUInteger count = [self count];
    id cArray[count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        id obj = [self objectAtIndex:i];
        if ([obj respondsToSelector:@selector(deepCopy)])
            cArray[i] = [obj deepCopy];
        else
            cArray[i] = [obj copy];
    }
    
    return [NSArray arrayWithObjects:cArray count:count];
}

- (NSMutableArray*) mutableDeepCopy {
    NSUInteger count = [self count];
    id cArray[count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        id obj = [self objectAtIndex:i];
        
        // Try to do a deep mutable copy, if this object supports it
        if ([obj respondsToSelector:@selector(mutableDeepCopy)])
            cArray[i] = [obj mutableDeepCopy];
        
        // Then try a shallow mutable copy, if the object supports that
        else if ([obj respondsToSelector:@selector(mutableCopyWithZone:)])
            cArray[i] = [obj mutableCopy];
        
        // Next try to do a deep copy
        else if ([obj respondsToSelector:@selector(deepCopy)])
            cArray[i] = [obj deepCopy];
        
        // If all else fails, fall back to an ordinary copy
        else
            cArray[i] = [obj copy];
    }
    
    return [NSMutableArray arrayWithObjects:cArray count:count];
}



@end

@implementation NSDictionary (Mission)

- (NSMutableArray *)mutableArrayValueForKeyPath:(NSString *)keyPath
{
    id value = [self valueForKeyPath:keyPath];
    
    if (value && ![value isKindOfClass:[NSArray class]])
        return [NSMutableArray arrayWithObject:value];
    
    if (!value)
        return [NSMutableArray new];
    
    return value;
}


- (NSDictionary*) deepCopy {
    NSUInteger count = [self count];
    id cObjects[count];
    id cKeys[count];
    
    NSEnumerator *e = [self keyEnumerator];
    NSUInteger i = 0;
    id thisKey;
    while ((thisKey = [e nextObject]) != nil) {
        id obj = [self objectForKey:thisKey];
        
        if ([obj respondsToSelector:@selector(deepCopy)])
            cObjects[i] = [obj deepCopy];
        else
            cObjects[i] = [obj copy];
        
        if ([thisKey respondsToSelector:@selector(deepCopy)])
            cKeys[i] = [thisKey deepCopy];
        else
            cKeys[i] = [thisKey copy];
        
        ++i;
    }
    
    return [NSDictionary dictionaryWithObjects:cObjects forKeys:cKeys count:count];
}

- (NSMutableDictionary*) mutableDeepCopy {
    NSUInteger count = [self count];
    id cObjects[count];
    id cKeys[count];
    
    NSEnumerator *e = [self keyEnumerator];
    NSUInteger i = 0;
    id thisKey;
    while ((thisKey = [e nextObject]) != nil) {
        id obj = [self objectForKey:thisKey];
        
        // Try to do a deep mutable copy, if this object supports it
        if ([obj respondsToSelector:@selector(mutableDeepCopy)])
            cObjects[i] = [obj mutableDeepCopy];
        
        // Then try a shallow mutable copy, if the object supports that
        else if ([obj respondsToSelector:@selector(mutableCopyWithZone:)])
            cObjects[i] = [obj mutableCopy];
        
        // Next try to do a deep copy
        else if ([obj respondsToSelector:@selector(deepCopy)])
            cObjects[i] = [obj deepCopy];
        
        // If all else fails, fall back to an ordinary copy
        else
            cObjects[i] = [obj copy];
        
        // I don't think mutable keys make much sense, so just do an ordinary copy
        if ([thisKey respondsToSelector:@selector(deepCopy)])
            cKeys[i] = [thisKey deepCopy];
        else
            cKeys[i] = [thisKey copy];
        
        ++i;
    }
    
    return [NSMutableDictionary dictionaryWithObjects:cObjects forKeys:cKeys count:count];
}






@end
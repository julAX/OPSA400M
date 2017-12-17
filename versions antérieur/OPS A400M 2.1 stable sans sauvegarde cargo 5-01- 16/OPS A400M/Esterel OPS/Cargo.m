//
//  Cargo.m
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import "Cargo.h"


@interface Cargo(){

}

@end

@implementation Cargo

@synthesize type,weight,departure,arrival,drop,be,whatLegs, identity;


- (id) init {
    self = [super init];
        if(self){
        
    }
    return self;
    
}

- (id) initWithMission: (Mission*) mission{
    self = [self init];
    
    if(self){
        
        self.mission = mission;
        [mission.Instances addObject:self];
    }
    return self;
}


- (void) destroy{
    [self.mission.Instances removeObject:self];
    [Cargo reloadBenefListWithMission : self.mission];
}

- (void) initSetOfLegs{
    NSInteger i = 0;
    NSUInteger legDep = 0;
    NSUInteger legArr = 0;
    self.numArrnumDep = [[NSMutableArray alloc]init];
    
    for (i=0; i < (self.mission.legs.count); i++){
        if([self.departure isEqualToString:self.mission.legs[i][@"DepartureAirport"]]){
            legDep = i;
        }
    }
    for (i=0; i <(self.mission.legs.count); i++){
        if([self.arrival isEqualToString:self.mission.legs[i][@"ArrivalAirport"]]){
            legArr = i;
        
        }
    }
    for (i=legDep; i<=legArr; i++){
        [self.whatLegs addObject:[NSNumber numberWithInteger:i]];
    }
    
    NSLog(@"%lu et %lu",(unsigned long)legDep,(unsigned long)legArr);
    
    [self.numArrnumDep insertObject: [NSNumber numberWithInteger: legDep] atIndex:0];
    [self.numArrnumDep insertObject: [NSNumber numberWithInteger: legArr] atIndex:1];
    
    NSLog(@"dep = %ld et arr = %ld",(long)[self.numArrnumDep[0] integerValue],(long)[self.numArrnumDep[1]integerValue]);
    
    
}





+ (NSString*) principalBe: (NSUInteger) legIndex inMission:(Mission*) mission {
    
    NSMutableDictionary *Beneficiaire;
    
    NSEnumerator *enumInstances = [mission.Instances objectEnumerator];
    Cargo *instanceEnCour;
    while (instanceEnCour=[enumInstances nextObject]) {
        if([instanceEnCour.whatLegs containsObject:[NSNumber numberWithInteger:legIndex]]){
            NSString *beEnCours = instanceEnCour.be;
            if(!Beneficiaire[beEnCours]){
                Beneficiaire[beEnCours]= instanceEnCour.weight;
            }
            else{
                Beneficiaire[beEnCours]=@([instanceEnCour.weight integerValue]+[Beneficiaire[beEnCours] integerValue]).description;
            }
        }
    }
    
    NSEnumerator *enumBenef = [Beneficiaire keyEnumerator];
    NSString *benefenumere;
    NSString *maxBenef=[enumBenef nextObject];
    
    while(benefenumere=[enumBenef nextObject]){
        
        if([Beneficiaire[benefenumere]integerValue]>[Beneficiaire[maxBenef] integerValue]){
            maxBenef=benefenumere;
        }
    
    }
    return maxBenef;
}

-(void) enterCargoInOMA {
    /*
    [self initSetOfLegs];
    
    
    
    NSInteger legIndexDepart = [self.numArrnumDep[0] integerValue];
    NSInteger legIndexArrive = [self.numArrnumDep[1] integerValue];

    NSMutableDictionary *newPaxCargo =[[NSMutableDictionary alloc] init];
    NSMutableDictionary *newPaxCargo2 =[[NSMutableDictionary alloc] init];
    NSMutableDictionary *newPaxCargo3 =[[NSMutableDictionary alloc] init];
    
    for(NSInteger i = 0; i< self.mission.legs.count; i++){
    
    //gerer le depart
        
        if(i==legIndexDepart){

            newPaxCargo[@"Name"]=self.be;
            if(self.type==pax){
                newPaxCargo[@"PaxIn"]=@([self.weight integerValue]/paxWeight).description;
                newPaxCargo[@"CargoIn"]=@"0";
            }
            else{
                newPaxCargo[@"CargoIn"]=self.weight;
                newPaxCargo[@"PaxIn"]=@"0";
            }
            newPaxCargo[@"CargoOnBoard"]=@"0";
            newPaxCargo[@"CargoDropped"]=@"0";
            newPaxCargo[@"CargoOut"]=@"0";
            newPaxCargo[@"PaxOnBoard"]=@"0";
            newPaxCargo[@"PaxDropped"]=@"0";
            newPaxCargo[@"PaxOut"]=@"0";
            
            [self.mission.legs[i][@"PaxCargo"] insertObject: newPaxCargo atIndex:0];
        }
        else if(i==legIndexArrive){
            newPaxCargo2[@"Name"]=self.be;
            if(self.type==pax){
                newPaxCargo2[@"CargoOut"]=@"0";
                newPaxCargo2[@"CargoDropped"]=@"0";
                
                if(!self.drop){
                    newPaxCargo2[@"PaxOut"]=@([self.weight integerValue]/paxWeight).description;
                    newPaxCargo2[@"PaxDropped"]=@"0";
                }
                else{
                    newPaxCargo2[@"PaxDropped"]=@([self.weight integerValue]/paxWeight).description;
                    newPaxCargo2[@"PaxOut"]=@"0";
                }
            }
            else{
                newPaxCargo2[@"PaxOut"]=@"0";
                newPaxCargo2[@"PaxDropped"]=@"0";
                
                if(!self.drop){
                    newPaxCargo2[@"CargoOut"]=self.weight;
                    newPaxCargo2[@"CargoDropped"]=@"0";
                }
                else{
                    newPaxCargo2[@"CargoOut"]=@"0";
                    newPaxCargo2[@"CargoDropped"]=self.weight;
                }
            }
            newPaxCargo2[@"CargoOnBoard"]=@"0";
            newPaxCargo2[@"CargoIn"]=@"0";
            newPaxCargo2[@"PaxOnBoard"]=@"0";
            newPaxCargo2[@"PaxIn"]=@"0";
            
            [self.mission.legs[i][@"PaxCargo"] insertObject: newPaxCargo2 atIndex:0];
        }
        else if(i<legIndexArrive && i>legIndexDepart){
            NSMutableDictionary *newPaxCargo4=[newPaxCargo3 mutableDeepCopy];
            newPaxCargo4[@"Name"]=self.be;
            //Faire les calucls
            [self.mission.legs[i][@"PaxCargo"] insertObject: newPaxCargo4 atIndex:0];
        }
        
        else{
            NSMutableDictionary *newPaxCargo4=[newPaxCargo3 mutableDeepCopy];
            newPaxCargo4[@"Name"]=self.be;
            newPaxCargo4[@"CargoOnBoard"]=@"0";
            newPaxCargo4[@"CargoIn"]=@"0";
            newPaxCargo4[@"PaxOnBoard"]=@"0";
            newPaxCargo4[@"PaxIn"]=@"0";
            [self.mission.legs[i][@"PaxCargo"] insertObject: newPaxCargo4 atIndex:0];
        }

    }
    */
}

- (void) setCargoList {
    [self initSetOfLegs];
    NSUInteger legdep = [self.numArrnumDep[0]integerValue];
    NSUInteger legarr = [self.numArrnumDep[1]integerValue];
    for (NSInteger i= legdep; i<=legarr; i++){
        if(!self.mission.legs[i][@"cargoList"]){
            self.mission.legs[i][@"cargoList"]=[[NSMutableArray alloc]init];
        }
        
        [self.mission.legs[i][@"cargoList"] addObject:self];
        
    }
}

+ (NSMutableDictionary*) reloadBenefListWithMission : (Mission*) mission{
    NSEnumerator *instanceEnumerator = [mission.Instances objectEnumerator];
    Cargo *carg;
    
    // vide benefList pour la remplir a nouveau avec Instances mise a jour
    [mission.benefList removeAllObjects];
    
    while(carg=[instanceEnumerator nextObject]){
        if(!mission.benefList[carg.be]){
            mission.benefList[carg.be]=[[NSMutableArray alloc]init];
        }
        [mission.benefList[carg.be] addObject:carg];
    }
    
    [Cargo reloadPaxCargoWithMission:mission];
    
    return mission.benefList;
}

+ (void) reloadPaxCargoWithMission:(Mission *)mission{
    //Vidons d'abord toutes les listes PaxCargo de chaque leg, sauf le dernier element qui est le total, puis on rerempli tout
    
    for (NSUInteger legIndex = 0; legIndex<mission.legs.count; legIndex++){
        [mission.legs[legIndex][@"PaxCargo"] removeObjectsInRange: NSMakeRange(0 , ((NSMutableArray *) mission.legs[legIndex][@"PaxCargo"]).count - 1 )];
    }
    
    NSEnumerator *beEnumerator = [mission.benefList keyEnumerator];
    NSString *keyBe;
    while(keyBe = [beEnumerator nextObject]){
        
        [mission addPaxCargo];
        
        
        for (NSUInteger legIndex = 0; legIndex<mission.legs.count; legIndex++) {
            NSMutableDictionary *paxCargo = mission.legs[legIndex][@"PaxCargo"][((NSMutableArray *) mission.legs[legIndex][@"PaxCargo"]).count - 2];
            
            paxCargo [@"Name"] = keyBe;
            
            
            
            for(Cargo* cargo in mission.benefList[keyBe]){
                
                if(cargo.type == pax){
                    if(legIndex == [cargo.numArrnumDep[0] integerValue]){
                        paxCargo[@"PaxIn"]=@([paxCargo[@"PaxIn"] integerValue] + [cargo.weight integerValue]/paxWeight).description;
                        
                    }
                    if(legIndex == [cargo.numArrnumDep[1] integerValue]){
                        if(cargo.drop)
                            paxCargo[@"PaxDropped"]=@([paxCargo[@"PaxDropped"] integerValue] + [cargo.weight integerValue]/paxWeight).description;
                        else
                            paxCargo[@"PaxOut"]=@([paxCargo[@"PaxOut"] integerValue] + [cargo.weight integerValue]/paxWeight).description;
                    }
                }
                else{
                    if(legIndex == [cargo.numArrnumDep[0] integerValue]){
                        paxCargo[@"CargoIn"]=@([paxCargo[@"CargoIn"] integerValue] + [cargo.weight integerValue]).description;
                        
                    }
                    if(legIndex == [cargo.numArrnumDep[1] integerValue]){
                        if(cargo.drop)
                            paxCargo[@"CargoDropped"]=@([paxCargo[@"CargoDropped"] integerValue] + [cargo.weight integerValue]).description;
                        else
                            paxCargo[@"CargoOut"]=@([paxCargo[@"CargoOut"] integerValue] + [cargo.weight integerValue]).description;
                    }
                }
            }
        }
    }
}


@end




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
            self.numArrnumDep = [[NSMutableArray alloc] initWithArray:@[[NSNumber numberWithInt:-1],[NSNumber numberWithInt:-1]]];
        
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
    for (NSInteger index = 0; index<self.mission.legs.count;index++)
        self.mission.legs[index][@"Be"]=[Cargo principalBe:index inMission:self.mission];
}

- (void) initSetOfLegs{
    NSInteger i = 0;
    NSInteger legDep = [self.numArrnumDep[0] integerValue];
    NSInteger legArr = [self.numArrnumDep[1] integerValue];
    
    for (i=legDep; i<=legArr; i++){
        [self.whatLegs addObject:[NSNumber numberWithInteger:i]];
    }
    
}





+ (NSString*) principalBe: (NSUInteger) legIndex inMission:(Mission*) mission {
    
    NSMutableDictionary *Beneficiaire = [[NSMutableDictionary alloc]init];
    
    NSEnumerator *enumInstances = [mission.Instances objectEnumerator];
    Cargo *instanceEnCour;
    
    
    while (instanceEnCour=[enumInstances nextObject]) {
        [instanceEnCour initSetOfLegs];

        if(legIndex<=[instanceEnCour.numArrnumDep[1]integerValue] && legIndex>=[instanceEnCour.numArrnumDep[0]integerValue]){
            NSString *beEnCours = instanceEnCour.be;
            if(!Beneficiaire[beEnCours]){
                [Beneficiaire setObject:instanceEnCour.weight forKey: beEnCours];

                
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


- (void) setCargoList {
    [self initSetOfLegs];
    /*NSUInteger legdep = [self.numArrnumDep[0]integerValue];
    NSUInteger legarr = [self.numArrnumDep[1]integerValue];
    for (NSInteger i= legdep; i<=legarr; i++){
        if(!self.mission.legs[i][@"cargoList"]){
            self.mission.legs[i][@"cargoList"]=[[NSMutableArray alloc]init];
        }
        
        [self.mission.legs[i][@"cargoList"] addObject:self];
        
    }*/
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
    [Cargo recalcLoadInMission : mission];
}

+ (void)recalcLoadInMission : (Mission*)mission
{
    NSUInteger index;
    NSMutableArray * paxCargoTab = mission.legs.firstObject[@"PaxCargo"];
    for (NSString *pref in @[@"Pax", @"Cargo"]){
        
        for (index = 0; index < (paxCargoTab.count - 1); index++){
            
            NSMutableDictionary *dict = paxCargoTab[index];
            
            dict[[pref stringByAppendingString:@"OnBoard"]] = @"0";
            
            long totalEnd = [dict[[pref stringByAppendingString:@"In"]] integerValue] - [dict[[pref stringByAppendingString:@"Out"]] integerValue] - [dict[[pref stringByAppendingString:@"Dropped"]] integerValue];
            
            for (NSUInteger legIndex = 1; legIndex < mission.legs.count; legIndex++){
                
                dict = mission.legs[legIndex][@"PaxCargo"][index];
                
                dict[[pref stringByAppendingString:@"OnBoard"]] = @(totalEnd).description;
                
                totalEnd += [dict[[pref stringByAppendingString:@"In"]] integerValue] - [dict[[pref stringByAppendingString:@"Out"]] integerValue] - [dict[[pref stringByAppendingString:@"Dropped"]] integerValue];
            }
        }
        
        for (NSMutableDictionary *oneLeg in mission.legs){
            
            NSMutableArray *paxCargos = oneLeg[@"PaxCargo"];
            
            for (NSString *key in @[@"In", @"OnBoard", @"Dropped", @"Out"])
            {
                NSInteger sum = 0;
                NSString *fullKey = [pref stringByAppendingString:key];
                
                for (index = 0; index < (paxCargoTab.count - 1); index++)
                    sum += [paxCargos[index][fullKey] integerValue];
                
                
                paxCargos.lastObject[fullKey] = @(sum).description;
            }
        }
    }
}


@end




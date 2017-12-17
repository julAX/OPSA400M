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
}

- (void) initSetOfLegs{
    NSInteger i = 0;
    NSUInteger legDep;
    NSUInteger legArr;
    for (i=0; i == self.mission.legs.count-1; i++){
        if([self.departure isEqualToString:self.mission.legs[i][@"DepartureAirport"]]){
            legDep = i+1;
        }
    }
    for (i=0; i == self.mission.legs.count-1; i++){
        if([self.arrival isEqualToString:self.mission.legs[i][@"ArrivalAirport"]]){
            legArr = i+1;
        
        }
    }
    for (i=legDep; i==legArr; i++){
        [self.whatLegs addObject:[NSNumber numberWithInteger:i]];
    }
    [self.numArrnumDep insertObject: [NSNumber numberWithInteger: legDep] atIndex:0];
    [self.numArrnumDep insertObject: [NSNumber numberWithInteger: legArr] atIndex:1];
    
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

    [self initSetOfLegs];
    
    NSInteger legIndexDepart = [self.numArrnumDep[0] integerValue];
    NSInteger legIndexArrive = [self.numArrnumDep[1] integerValue];
    NSMutableArray *listPaxCargoDep;
    NSMutableArray *listPaxCargoArr;
    NSMutableDictionary *newPaxCargo =[[NSMutableDictionary alloc] init];
    NSMutableDictionary *newPaxCargo2 =[[NSMutableDictionary alloc] init];;
    listPaxCargoDep = self.mission.legs[legIndexDepart][@"PaxCargo"];
    newPaxCargo[@"Name"]=self.be;
    if(self.type==pax){
        newPaxCargo[@"PaxIn"]=@([self.weight integerValue]/89).description;
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
    
    [listPaxCargoDep addObject:newPaxCargo];
    
    listPaxCargoArr = self.mission.legs[legIndexArrive][@"PaxCargo"];
    newPaxCargo2[@"Name"]=self.be;
    if(self.type==pax){
        newPaxCargo2[@"PaxOut"]=@([self.weight integerValue]/89).description;
    }
    else{
        newPaxCargo2[@"CargoOut"]=self.weight;
    }
    //[listPaxCargoArr addObject:newPaxCargo2];
}


@end




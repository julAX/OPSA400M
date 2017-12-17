//
//  FuelCell.m
//  Esterel-Alpha
//
//  Created by utilisateur on 20/01/2014.
//
//

#import "FuelCell.h"

#import "Mission.h"


@interface FuelCell ()
{
    Mission *mission;
    NSMutableDictionary *leg, *nextLeg;
    NSInteger legNumber;
}

@end

@implementation FuelCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.totalAtTakeOff.myDelegate = self;
    self.addedAtDep.myDelegate = self;
    self.final.myDelegate = self;
    self.received.myDelegate = self;
    self.delivered.myDelegate = self;
    self.bm19.myDelegate = self;
    
}

- (void)initWithLeg:(NSInteger)l inMission:(Mission*)m
{
    legNumber = l;
    mission = m;
    leg = mission.legs[legNumber];
    
    
    self.addedAtDep.enabled = YES; //(legNumber != 0);  X2015 on demande le at departure a chaque fois
    UIColor *textFieldColor1 = (YES) /*(legNumber != 0)*/ ? [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] : [UIColor darkTextColor];
    [self.addedAtDep setTextColor:textFieldColor1];
    
    self.final.enabled = YES; //(legNumber == mission.legs.count - 1);
    UIColor *textFieldColor2 = (YES)/*(legNumber == mission.legs.count - 1)*/? [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] : [UIColor darkTextColor];
    [self.final setTextColor:textFieldColor2];

    
    [self reloadLabels];
}


- (void)myTextFieldDidEndEditing:(UITextField *)textField
{
    //211: Fuel added = BM19
    //212: Fuel at Take off
    //213: Fuel received during flight
    //214: Fuel deliverd during flight
    //215: Final Fuel (at landing)
    //216: ID number of the BM19
    switch (textField.tag) {
        case 211: leg[@"FuelAdded"] = textField.text;
            
            leg[@"GroundInit"] = @([leg[@"FuelAtTakeOff"] integerValue] - [leg[@"FuelAdded"] integerValue]).description;
            
            /*X15 modif : calculs rendus inutiles.
             
             
            
            if (legNumber > 0) {
                mission.legs[legNumber-1][@"FinalFuel"] = leg[@"GroundInit"];
                mission.legs[legNumber-1][@"FuelBurned"] = @([mission.legs[legNumber-1][@"FuelAtTakeOff"] integerValue] - [mission.legs[legNumber-1][@"FinalFuel"] integerValue] - [mission.legs[legNumber-1][@"FuelDelivered"] integerValue] + [mission.legs[legNumber-1][@"FuelReceived"] integerValue] ).description;
            }
             */

                        break;
            
        case 212: leg[@"FuelAtTakeOff"] = textField.text;
            
            leg[@"GroundInit"] = @([leg[@"FuelAtTakeOff"] integerValue] - [leg[@"FuelAdded"] integerValue]).description;
            
            /* X15 idem inutile
            
             if (legNumber > 0) {
             mission.legs[legNumber-1][@"FinalFuel"] = leg[@"GroundInit"];
             mission.legs[legNumber-1][@"FuelBurned"] = @([mission.legs[legNumber-1][@"FuelAtTakeOff"] integerValue] - [mission.legs[legNumber-1][@"FinalFuel"] integerValue] - [mission.legs[legNumber-1][@"FuelDelivered"] integerValue] + [mission.legs[legNumber-1][@"FuelReceived"] integerValue] ).description;
             }
             */
            
            leg[@"FuelBurned"] = @([leg[@"FuelAtTakeOff"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
            
           

            break;
            
        case 213: leg[@"FuelReceived"] = textField.text;
            leg[@"FuelBurned"] = @([leg[@"FuelAtTakeOff"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
            break;
            
        case 214: leg[@"FuelDelivered"] = textField.text;
            leg[@"FuelBurned"] = @([leg[@"FuelAtTakeOff"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
            break;
            
        case 215: leg[@"FinalFuel"] = textField.text;
            leg[@"FuelBurned"] = @([leg[@"FuelAtTakeOff"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
            break;
            
        case 216: leg[@"N°BM19"] = textField.text;
            break;
            
            
            
    
    }
    
    [self reloadLabels];
}


- (void)reloadLabels
{

    self.addedAtDep.text = leg[@"FuelAdded"];
    self.totalAtTakeOff.text = leg[@"FuelAtTakeOff"];
    self.burned.text = leg[@"FuelBurned"];
    self.final.text = leg[@"FinalFuel"];
    self.received.text = leg[@"FuelReceived"];
    self.delivered.text = leg[@"FuelDelivered"];
    self.bm19.text = leg[@"N°BM19"];
    
    
    //self.groundInit.text = (legNumber == 0) ? mission.root[@"GroundInit"] : mission.legs[legNumber - 1][@"FinalFuel"];
    //self.groundInit.text = @([self.totalAtTakeOff.text integerValue] - [self.addedAtDep.text integerValue]).description;
    
    //self.addedAtDep.text = @([self.totalAtTakeOff.text integerValue] - [self.groundInit.text integerValue]).description;
    //if (legNumber != mission.legs.count -1) { self.
    
    
    // Conversion en litres
    
    float d = 0.8;
    

    self.lAddedAtDep.text = [NSString stringWithFormat:@"%.0f L", (0.5 + [self.addedAtDep.text integerValue] / d)];
    self.lTotalAtTakeOff.text = [NSString stringWithFormat:@"%.0f L", (0.5 + [self.totalAtTakeOff.text integerValue] / d)];
    self.lBurned.text = [NSString stringWithFormat:@"%.0f L", (0.5 + [self.burned.text integerValue] / d)];
    self.lfinal.text = [NSString stringWithFormat:@"%.0f L", (0.5 + [self.final.text integerValue] / d)];
    self.lreceived.text = [NSString stringWithFormat:@"%.0f L", (0.5 + [self.received.text integerValue] / d)];
    self.ldelivered.text = [NSString stringWithFormat:@"%.0f L", (0.5 + [self.delivered.text integerValue] / d)];
}

@end

//
//  ChoixCoefViewController.m
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import "ChoixCoefViewController.h"


@interface ChoixCoefViewController (){
    Mission *mission;
    NSMutableDictionary *leg;
}

@end

@implementation ChoixCoefViewController

@synthesize buttonOk, button10, button22, button35,button62;

NSUInteger compteur = 1;
NSUInteger first = 4;
NSUInteger second = 4;

BOOL on10 = NO;
BOOL on62 = NO;
BOOL on35 = NO;
BOOL on22 = YES;

/*
 ATTENTION: Nomenclature des tags des differentes pages: dans un soucis de regroupement on fait des swicht case avec chaque page qui utilise un pad numérique et des heures.
 
 Departure:
 1001: Pavé heure de départ (OBtime)
 
 Arrival:
 2001: FT
 2002: BT
 2003: Dont nuit
 2004: Dont LLF
 
 2011: 10 de jour
 2012: 10 de nuit
 2013: 10 en LLf
 2021: 62 de jour
 2022: 62 de nuit
 2023: 62 en LLF
 2031: 35 de jour
 2032: 35 de nuit
 2033: 35 en LLF
 
 2005: ATR
 2006: TAG
 2007: RG
 
 6001: BM19 (leg[FuelAdded]
 6002: Numéro de BM19
 6003: At strart Up
 6004: Delivered
 6005: Received
 6006: Final
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    mission = ((SplitViewController*)self.splitViewController).mission;
    leg = mission.activeLeg;
    compteur=0;
    
    if(on10){
        [button10 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        compteur+=1;
    }
    if(on62){
        [button62 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        compteur+=1;
    }
    if(on35){
        [button35 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        compteur+=1;
    }
    if(on22){
        [button22 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        compteur+=1;
    }
    
    if(!on10){
        [button10 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    if(!on62){
        [button62 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    if(!on35){
        [button35 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    if(!on22){
        [button22 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    if(compteur>2){
        compteur=2;
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)push10:(id)sender{
    if(on10){
        if(compteur==2){
            on10=NO;
            [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            compteur = 1;

        }
    }
    else{
        if(compteur==1){
            on10=YES;
            compteur = 2;
            [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];

        }
    }
}

- (IBAction)push62:(id)sender{
    if(on62){
        if(compteur==2){
            on62=NO;
            [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            compteur = 1;
        }
    }
    else{
        if(compteur==1){
            on62=YES;
            compteur = 2;
            [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)push35:(id)sender{
    if(on35){
        if(compteur==2){
            on35=NO;
            [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            compteur = 1;
        }
    }
    else{
        if(compteur==1){
            on35=YES;
            compteur = 2;
            [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)push22:(id)sender{
    if(on22){
        if(compteur==2){
            on22=NO;
            [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            compteur = 1;
        }
    }
    else{
        if(compteur==1){
            on22=YES;
            compteur = 2;
            [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }
    }
}



 
- (IBAction)validateCoef:(id)sender {

    
    if(on10){
        first=1;
        second=0;
    
    }
    if(on62){
        first=2;
        second=0;
        
    }
    if(on35){
        first=3;
        second=0;
        
    }
    if(on22){
        first=4;
        second=0;
        
    }
    
    if(on10 && on62){
        first=1;
        second=2;
    }
    if(on10 && on35){
        first=1;
        second=3;
    }
    if(on10 && on22){
        first=1;
        second=4;
    }
    if(on35 && on62){
        first=2;
        second=3;
    }
    if(on22 && on62){
        first=2;
        second=4;
    }
    if(on35 && on22){
        first=3;
        second=4;
    }

    
    if(second==0 || second==first){
        
        NSDate *dateNulle = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
        
        switch(first){
            case 1:{
                leg[@"Night10"]=leg[@"NightTime"];

                
                NSCalendarUnit calendrier = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
                NSCalendar *cal= [NSCalendar currentCalendar];
                NSTimeZone *zeroZ = [NSTimeZone timeZoneWithName:@"GMT"];
                [cal setTimeZone:zeroZ];
                NSDateComponents *difference = [cal components:calendrier fromDate:leg[@"NightTime"] toDate:leg[@"BetweenBlocksTime"] options:0];
                
                NSDate *d10 =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                
                /*
                NSDateFormatter* df = [[NSDateFormatter alloc]init];
                [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                NSString *output5 = [df stringFromDate: d10];
                NSLog(output5);
                */
                
                leg[@"Day10"]= d10;
                
                
                
                
                leg[@"Day22"]=dateNulle;
                leg[@"Day35"]=dateNulle;
                leg[@"Day62"]=dateNulle;
                leg[@"Night22"]=dateNulle;
                leg[@"Night35"]=dateNulle;
                leg[@"Night62"]=dateNulle;
                
                break;}
            case 2:{
                leg[@"Night62"]=leg[@"NightTime"];
                
                
                NSCalendarUnit calendrier = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
                NSCalendar *cal= [NSCalendar currentCalendar];
                NSTimeZone *zeroZ = [NSTimeZone timeZoneWithName:@"GMT"];
                [cal setTimeZone:zeroZ];
                NSDateComponents *difference = [cal components:calendrier fromDate:leg[@"NightTime"] toDate:leg[@"BetweenBlocksTime"] options:0];
                
                NSDate *d62 =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                
                leg[@"Day62"]= d62;
                
                leg[@"Day22"]=dateNulle;
                leg[@"Day35"]=dateNulle;
                leg[@"Day10"]=dateNulle;
                leg[@"Night22"]=dateNulle;
                leg[@"Night35"]=dateNulle;
                leg[@"Night10"]=dateNulle;
                break;}
            case 3:{
                leg[@"Night35"]=leg[@"NightTime"];
                
                
                NSCalendarUnit calendrier = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
                NSCalendar *cal= [NSCalendar currentCalendar];
                NSTimeZone *zeroZ = [NSTimeZone timeZoneWithName:@"GMT"];
                [cal setTimeZone:zeroZ];
                NSDateComponents *difference = [cal components:calendrier fromDate:leg[@"NightTime"] toDate:leg[@"BetweenBlocksTime"] options:0];
                
                NSDate *d35 =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                leg[@"Day35"]= d35;
                
                leg[@"Day22"]=dateNulle;
                leg[@"Day10"]=dateNulle;
                leg[@"Day62"]=dateNulle;
                leg[@"Night10"]=dateNulle;
                leg[@"Night22"]=dateNulle;
                leg[@"Night62"]=dateNulle;
                
                break;}
            case 4:{
                leg[@"Night22"]=leg[@"NightTime"];
                
                
                NSCalendarUnit calendrier = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
                NSCalendar *cal= [NSCalendar currentCalendar];
                NSTimeZone *zeroZ = [NSTimeZone timeZoneWithName:@"GMT"];
                [cal setTimeZone:zeroZ];
                NSDateComponents *difference = [cal components:calendrier fromDate:leg[@"NightTime"] toDate:leg[@"BetweenBlocksTime"] options:0];
                
                NSDate *d22 =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                leg[@"Day22"]= d22;
                
                leg[@"Day35"]=dateNulle;
                leg[@"Day10"]=dateNulle;
                leg[@"Day62"]=dateNulle;
                leg[@"Night10"]=dateNulle;
                leg[@"Night35"]=dateNulle;
                leg[@"Night62"]=dateNulle;
                
                break;}
                
        
        
        }
        
        PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2005"];
        [self.navigationController pushViewController:pushVC animated:YES];
        
    }

    else{
        NSString * firstcoef=[NSString stringWithFormat: @"%lu",(unsigned long)first];
        leg[@"FirstCoef"]= firstcoef;
        NSString * secondcoef=[NSString stringWithFormat: @"%lu",(unsigned long)second];
        leg[@"SecondCoef"]= secondcoef;


        switch (first) {
            case 1:{
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2011"];
                [self.navigationController pushViewController:pushVC animated:YES];
                break;}
            case 2:{
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2021"];
                [self.navigationController pushViewController:pushVC animated:YES];
                break;}
            case 3:{
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2031"];
                [self.navigationController pushViewController:pushVC animated:YES];
                break;}
        }
    }

}

@end

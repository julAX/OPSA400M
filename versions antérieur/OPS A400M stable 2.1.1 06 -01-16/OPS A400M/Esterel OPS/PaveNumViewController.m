//
//  PaveNumViewController.m
//  OPS A400M
//
//  Created by Amaury Camus & Louis David on 01/12/2015.
//  0630337745
//  amaury.camus@polytechnique.edu
//  Copyright © 2015 CESAM. All rights reserved.
//

#import "PaveNumViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PaveNumViewController (){
    
    Mission *mission;
    NSMutableDictionary *leg;
    Cargo *currentCargo;
}
    

@end

@implementation PaveNumViewController




@synthesize paveDisplay;

@synthesize paveDisplay2001;
@synthesize paveDisplay2002;
@synthesize paveDisplay2003;
@synthesize paveDisplay2004;
@synthesize paveDisplay2005;
@synthesize paveDisplay2006;
@synthesize paveDisplay2007;

@synthesize paveDisplay2011;
@synthesize paveDisplay2012;

@synthesize paveDisplay2021;
@synthesize paveDisplay2022;

@synthesize paveDisplay2031;
@synthesize paveDisplay2032;

@synthesize paveDisplay6001;
@synthesize paveDisplay6002;
@synthesize paveDisplay6003;
@synthesize paveDisplay6004;
@synthesize paveDisplay6005;
@synthesize paveDisplay6006;

@synthesize paveDisplay4002;
@synthesize paveDisplay4003;

- (void)activeLegDidChange:(NSInteger)legNumber
{
    leg = mission.activeLeg;
    [self reloadValues];
}


- (void)reloadValues{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    paveDisplay.text = [df stringFromDate:leg[@"OffBlocksTime"]];
    paveDisplay2001.text=[df stringFromDate:leg[@"FlightTime"]];
    paveDisplay2002.text=[df stringFromDate:leg[@"BetweenBlocksTime"]];
    //paveDisplay2003.text=[df stringFromDate:leg[@"NightTime"]];
    paveDisplay2004.text=[df stringFromDate:leg[@"LowLevelFlight"]];
    
    paveDisplay2011.text=[df stringFromDate:leg[@"Day10"]];
    paveDisplay2012.text=[df stringFromDate:leg[@"Night10"]];
    paveDisplay2021.text=[df stringFromDate:leg[@"Day62"]];
    paveDisplay2022.text=[df stringFromDate:leg[@"Night62"]];
    paveDisplay2031.text=[df stringFromDate:leg[@"Day35"]];
    paveDisplay2032.text=[df stringFromDate:leg[@"Night35"]];
    
    paveDisplay2005.text=leg[@"Landings"];
    paveDisplay2006.text=leg[@"TouchAndGo"];
    paveDisplay2007.text=leg[@"GoAround"];
    
    paveDisplay6001.text=leg[@"FuelAdded"];
    paveDisplay6002.text=leg[@"N°BM19"];
    paveDisplay6003.text=leg[@"FuelAtTakeOff"];
    paveDisplay6004.text=leg[@"FuelDelivered"];
    paveDisplay6005.text=leg[@"FuelReceived"];
    paveDisplay6006.text=leg[@"FinalFuel"];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    mission = ((SplitViewController*)self.splitViewController).mission;
    leg = mission.activeLeg;
    currentCargo=mission.currentCargo;

    
        // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ((mission = ((SplitViewController*)self.splitViewController).mission))
    {
        mission.delegate = self;
        leg = mission.activeLeg;
        
        [self reloadValues];
    }
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

/*
 ATTENTION: Nomenclature des tags des differentes pages: dans un soucis de regroupement on fait des swicht case avec chaque page qui utilise un pad numérique et des heures.
 
 Departure:
 1001: Pavé heure de départ (OBtime)
 
 Arrival:
 2001: FT
 2002: BT
 2003: Dont nuit (donnée rajoutée dans le dictionnaire leg)
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
 
 2005: ATR Landings
 2006: TAG TouchAndGo
 2007: RG ou GoAroud
 
 
 
 
 Fuel:
 6001: BM19 (leg[FuelAdded]
 6002: Numéro de BM19
 6003: At strart Up
 6004: Delivered } utilisés ssi on passe la variable useReceivedAndDelivered = YES dans Parameters.h
 6005: Received  }
 6006: Final
 
 
 Cargo:
 4002: Cargo Weight (for pax)
 4003: Cargo Weight (for pallet and bulk)

 */





- (IBAction)sendNumber:(id)sender {
    
    //on récupère le numéro appuyé
    NSString *num = [sender currentTitle];
    
    switch ([sender tag]) {
        case 1001:
            
            if([paveDisplay.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
            }
            
            paveDisplay.backgroundColor = [UIColor whiteColor];
            if(paveDisplay.text.length==2){
                paveDisplay.text = [paveDisplay.text stringByAppendingString: @":"];
            }
            if(paveDisplay.text.length <=4){
                
                
                paveDisplay.text = [paveDisplay.text stringByAppendingString: num];
                
                
                if(paveDisplay.text.length==2){
                    paveDisplay.text = [paveDisplay.text stringByAppendingString: @":"];
                }
                
            }
            break;
        
        case 2001:
            if([paveDisplay2001.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
            }
            paveDisplay2001.backgroundColor = [UIColor whiteColor];
            if(paveDisplay2001.text.length==2){
                paveDisplay2001.text = [paveDisplay2001.text stringByAppendingString: @":"];
            }
            if(paveDisplay2001.text.length <=4){
                
                
                paveDisplay2001.text = [paveDisplay2001.text stringByAppendingString: num];
                
                
                if(paveDisplay2001.text.length==2){
                    paveDisplay2001.text = [paveDisplay2001.text stringByAppendingString: @":"];
                }
            break;
            
        case 2002:
                if([paveDisplay2002.text isEqualToString:@"00:00"]){
                    [self clearDisplay:sender];
                }
                paveDisplay2002.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2002.text.length==2){
                    paveDisplay2002.text = [paveDisplay2002.text stringByAppendingString: @":"];
                }
                if(paveDisplay2002.text.length <=4){
                    
                    
                    paveDisplay2002.text = [paveDisplay2002.text stringByAppendingString: num];
                    
                    
                    if(paveDisplay2002.text.length==2){
                        paveDisplay2002.text = [paveDisplay2002.text stringByAppendingString: @":"];
                    }
                }
            break;
            
        case 2003:
                if([paveDisplay2003.text isEqualToString:@"00:00"]){
                    [self clearDisplay:sender];
                }
                paveDisplay2003.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2003.text.length==2){
                    paveDisplay2003.text = [paveDisplay2003.text stringByAppendingString: @":"];
                }
                if(paveDisplay2003.text.length <=4){
                    
                    
                    paveDisplay2003.text = [paveDisplay2003.text stringByAppendingString: num];
                    
                    
                    if(paveDisplay2003.text.length==2){
                        paveDisplay2003.text = [paveDisplay2003.text stringByAppendingString: @":"];
                    }
                }
            break;
            
        case 2004:
                if([paveDisplay2004.text isEqualToString:@"00:00"]){
                    [self clearDisplay:sender];
                }
                paveDisplay2004.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2004.text.length==2){
                    paveDisplay2004.text = [paveDisplay2004.text stringByAppendingString: @":"];
                }
                if(paveDisplay2004.text.length <=4){
                    
                    
                    paveDisplay2004.text = [paveDisplay2004.text stringByAppendingString: num];
                    
                    
                    if(paveDisplay2004.text.length==2){
                        paveDisplay2004.text = [paveDisplay2004.text stringByAppendingString: @":"];
                    }
                }
            break;
            
        case 2005:
                paveDisplay2005.backgroundColor = [UIColor whiteColor];
                
                if(paveDisplay2005.text.length <=4){
                    paveDisplay2005.text = [paveDisplay2005.text stringByAppendingString: num];
                }
            break;
            
        case 2006:
                paveDisplay2006.backgroundColor = [UIColor whiteColor];
                
                if(paveDisplay2006.text.length <=4){
                    paveDisplay2006.text = [paveDisplay2006.text stringByAppendingString: num];
                }
            break;
            
        case 2007:
                paveDisplay2007.backgroundColor = [UIColor whiteColor];
                
                if(paveDisplay2007.text.length <=4){
                    paveDisplay2007.text = [paveDisplay2007.text stringByAppendingString: num];
                }
            break;
        
        case 2011:
                if([paveDisplay2011.text isEqualToString:@"00:00"]){
                    [self clearDisplay:sender];
                }
                paveDisplay2011.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2011.text.length==2){
                    paveDisplay2011.text = [paveDisplay2011.text stringByAppendingString: @":"];
                }
                if(paveDisplay2011.text.length <=4){
                    
                    
                    paveDisplay2011.text = [paveDisplay2011.text stringByAppendingString: num];
                    
                    
                    if(paveDisplay2011.text.length==2){
                        paveDisplay2011.text = [paveDisplay2011.text stringByAppendingString: @":"];
                    }
                }
            break;
        case 2012:
                if([paveDisplay2012.text isEqualToString:@"00:00"]){
                    [self clearDisplay:sender];
                }
                paveDisplay2012.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2012.text.length==2){
                    paveDisplay2012.text = [paveDisplay2012.text stringByAppendingString: @":"];
                }
                if(paveDisplay2012.text.length <=4){
                    
                    
                    paveDisplay2012.text = [paveDisplay2012.text stringByAppendingString: num];
                    
                    
                    if(paveDisplay2012.text.length==2){
                        paveDisplay2012.text = [paveDisplay2012.text stringByAppendingString: @":"];
                    }
                }
            break;
        case 2021:
                if([paveDisplay2021.text isEqualToString:@"00:00"]){
                    [self clearDisplay:sender];
                }
                paveDisplay2021.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2021.text.length==2){
                    paveDisplay2021.text = [paveDisplay2021.text stringByAppendingString: @":"];
                }
                if(paveDisplay2021.text.length <=4){
                    
                    
                    paveDisplay2021.text = [paveDisplay2021.text stringByAppendingString: num];
                    
                    
                    if(paveDisplay2021.text.length==2){
                        paveDisplay2021.text = [paveDisplay2021.text stringByAppendingString: @":"];
                    }
                }
            break;

        case 2022:
                if([paveDisplay2022.text isEqualToString:@"00:00"]){
                    [self clearDisplay:sender];
                }
                paveDisplay2022.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2022.text.length==2){
                    paveDisplay2022.text = [paveDisplay2022.text stringByAppendingString: @":"];
                }
                if(paveDisplay2022.text.length <=4){
                    
                    
                    paveDisplay2022.text = [paveDisplay2022.text stringByAppendingString: num];
                    
                    
                    if(paveDisplay2022.text.length==2){
                        paveDisplay2022.text = [paveDisplay2022.text stringByAppendingString: @":"];
                    }
                }
            break;
        case 2031:
                if([paveDisplay2031.text isEqualToString:@"00:00"]){
                    [self clearDisplay:sender];
                }
                paveDisplay2031.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2031.text.length==2){
                    paveDisplay2031.text = [paveDisplay2031.text stringByAppendingString: @":"];
                }
                
                if(paveDisplay2031.text.length <=4){
                    
                    
                    paveDisplay2031.text = [paveDisplay2031.text stringByAppendingString: num];
                    
                    
                    if(paveDisplay2031.text.length==2){
                        paveDisplay2031.text = [paveDisplay2031.text stringByAppendingString: @":"];
                    }
                }
            break;
        case 2032:
                if([paveDisplay2032.text isEqualToString:@"00:00"]){
                    [self clearDisplay:sender];
                }
                paveDisplay2032.backgroundColor = [UIColor whiteColor];
                
                if(paveDisplay2032.text.length==2){
                    paveDisplay2032.text = [paveDisplay2032.text stringByAppendingString: @":"];
                }

                if(paveDisplay2032.text.length <=4){
                    
                    
                    paveDisplay2032.text = [paveDisplay2032.text stringByAppendingString: num];
                    
                    
                    if(paveDisplay2032.text.length==2){
                        paveDisplay2032.text = [paveDisplay2032.text stringByAppendingString: @":"];
                    }
                }
            break;
                
        case 6001:
                if([paveDisplay6001.text isEqualToString:@"0"]){
                    [self clearDisplay:sender];
                }

                 paveDisplay6001.text = [paveDisplay6001.text stringByAppendingString: num];
            break;
                
        case 6002:
                 paveDisplay6002.text = [paveDisplay6002.text stringByAppendingString: num];
            break;
                
        case 6003:
                if([paveDisplay6003.text isEqualToString:@"0"]){
                    [self clearDisplay:sender];
                }
                 paveDisplay6003.backgroundColor = [UIColor whiteColor];
                 paveDisplay6003.text = [paveDisplay6003.text stringByAppendingString: num];
            break;
        case 6004:
                if([paveDisplay6004.text isEqualToString:@"0"]){
                    [self clearDisplay:sender];
                }

                paveDisplay6004.backgroundColor = [UIColor whiteColor];
                paveDisplay6004.text = [paveDisplay6004.text stringByAppendingString: num];
            break;
        case 6005:
                if([paveDisplay6005.text isEqualToString:@"0"]){
                    [self clearDisplay:sender];
                }

                paveDisplay6005.backgroundColor = [UIColor whiteColor];
                paveDisplay6005.text = [paveDisplay6005.text stringByAppendingString: num];
            break;
        case 6006:
                if([paveDisplay6006.text isEqualToString:@"0"]){
                    [self clearDisplay:sender];
                }

                paveDisplay6006.backgroundColor = [UIColor whiteColor];
                paveDisplay6006.text = [paveDisplay6006.text stringByAppendingString: num];
            break;
        case 4002:
                if([paveDisplay4002.text isEqualToString:@"0"]){
                    [self clearDisplay:sender];
                }

                paveDisplay4002.backgroundColor = [UIColor whiteColor];
                paveDisplay4002.text = [paveDisplay4002.text stringByAppendingString: num];
            break;
        case 4003:
                if([paveDisplay4003.text isEqualToString:@"0"]){
                    [self clearDisplay:sender];
                }

                paveDisplay4003.backgroundColor = [UIColor whiteColor];
                paveDisplay4003.text = [paveDisplay4003.text stringByAppendingString: num];
            break;
        default:
            break;
    }
    
    
    }

}
/* Les actions suivantes gèrent:
-l'écriture et la suppression de l'horaire

-Le rajout d'un zero si l'on ne rentre que trois chiffres (ex: 820 qui s'affiche 82:0 mais qui donnera 08:20
 
-la vérification du format de l'heure (après le rajout éventuel du zéro)

-L'enregistrement (au clic sur OK) de l'heure dans le dictionnaire leg

 */

- (IBAction)clearDisplay:(id)sender {
    
    switch ([sender tag]) {
        case 1001:
            paveDisplay.backgroundColor = [UIColor whiteColor];
            paveDisplay.text = @"";
            break;
            
        case 2001:
            paveDisplay2001.backgroundColor = [UIColor whiteColor];
            paveDisplay2001.text = @"";
            break;
            
        case 2002:
            paveDisplay2002.backgroundColor = [UIColor whiteColor];
            paveDisplay2002.text = @"";
            break;
            
        case 2003:
            paveDisplay2003.backgroundColor = [UIColor whiteColor];
            paveDisplay2003.text = @"";
            break;
            
        case 2004:
            paveDisplay2004.backgroundColor = [UIColor whiteColor];
            paveDisplay2004.text = @"";
            break;
            
        case 2005:
            paveDisplay2005.backgroundColor = [UIColor whiteColor];
            paveDisplay2005.text = @"";
            break;
            
        case 2006:
            paveDisplay2006.backgroundColor = [UIColor whiteColor];
            paveDisplay2006.text = @"";
            break;
            
        case 2007:
            paveDisplay2007.backgroundColor = [UIColor whiteColor];
            paveDisplay2007.text = @"";
            break;
        case 2011:
            paveDisplay2011.backgroundColor = [UIColor whiteColor];
            paveDisplay2011.text = @"";
            break;
        case 2012:
            paveDisplay2012.backgroundColor = [UIColor whiteColor];
            paveDisplay2012.text = @"";
            break;
        case 2021:
            paveDisplay2021.backgroundColor = [UIColor whiteColor];
            paveDisplay2021.text = @"";
            break;
        case 2022:
            paveDisplay2022.backgroundColor = [UIColor whiteColor];
            paveDisplay2022.text = @"";
            break;
        case 2031:
            paveDisplay2031.backgroundColor = [UIColor whiteColor];
            paveDisplay2031.text = @"";
            break;
        case 2032:
            paveDisplay2032.backgroundColor = [UIColor whiteColor];
            paveDisplay2032.text = @"";
            break;
        case 6001:
            paveDisplay6001.backgroundColor = [UIColor whiteColor];
            paveDisplay6001.text = @"";
            break;
        case 6002:
            paveDisplay6002.backgroundColor = [UIColor whiteColor];
            paveDisplay6002.text = @"";
            break;
        case 6003:
            paveDisplay6003.backgroundColor = [UIColor whiteColor];
            paveDisplay6003.text = @"";
            break;
        case 6004:
            paveDisplay6004.backgroundColor = [UIColor whiteColor];
            paveDisplay6004.text = @"";
            break;
        case 6005:
            paveDisplay6005.backgroundColor = [UIColor whiteColor];
            paveDisplay6005.text = @"";
            break;
        case 6006:
            paveDisplay6006.backgroundColor = [UIColor whiteColor];
            paveDisplay6006.text = @"";
            break;
        case 4002:
            paveDisplay4002.backgroundColor = [UIColor whiteColor];
            paveDisplay4002.text = @"";
            break;
        case 4003:
            paveDisplay4003.backgroundColor = [UIColor whiteColor];
            paveDisplay4003.text = @"";
            break;
        default:
            break;
    }
    

}

- (IBAction)backspaceDisplay:(id)sender {
    
    switch ([sender tag]) {
        case 1001:
            if(paveDisplay.text.length != 0){
                paveDisplay.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay.text = [paveDisplay.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
            
        case 2001:
            if(paveDisplay2001.text.length != 0){
                paveDisplay2001.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2001.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2001.text = [paveDisplay2001.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
            
        case 2002:
            if(paveDisplay2002.text.length != 0){
                paveDisplay2002.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2002.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2002.text = [paveDisplay2002.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
            
        case 2003:
            if(paveDisplay2003.text.length != 0){
                paveDisplay2003.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2003.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2003.text = [paveDisplay2003.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
            
        case 2004:
            if(paveDisplay2004.text.length != 0){
                paveDisplay2004.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2004.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2004.text = [paveDisplay2004.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
            
        case 2005:
            if(paveDisplay2005.text.length != 0){
                paveDisplay2005.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2005.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2005.text = [paveDisplay2005.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
            
        case 2006:
            if(paveDisplay2006.text.length != 0){
                paveDisplay2006.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2006.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2006.text = [paveDisplay2006.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
            
        case 2007:
            if(paveDisplay2007.text.length != 0){
                paveDisplay2007.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2007.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2007.text = [paveDisplay2007.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
            
        case 2011:
            if(paveDisplay2011.text.length != 0){
                paveDisplay2011.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2011.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2011.text = [paveDisplay2011.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 2012:
            if(paveDisplay2012.text.length != 0){
                paveDisplay2012.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2012.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2012.text = [paveDisplay2012.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 2021:
            if(paveDisplay2021.text.length != 0){
                paveDisplay2021.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2021.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2021.text = [paveDisplay2021.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
            
        case 2022:
            if(paveDisplay2022.text.length != 0){
                paveDisplay2022.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2022.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2022.text = [paveDisplay2022.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 2031:
            if(paveDisplay2031.text.length != 0){
                paveDisplay2031.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2031.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2031.text = [paveDisplay2031.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 2032:
            if(paveDisplay2032.text.length != 0){
                paveDisplay2032.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay2032.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay2032.text = [paveDisplay2032.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 6001:
            if(paveDisplay6001.text.length != 0){
                paveDisplay6001.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay6001.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay6001.text = [paveDisplay6001.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 6002:
            if(paveDisplay6002.text.length != 0){
                paveDisplay6002.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay6002.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay6002.text = [paveDisplay6002.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 6003:
            if(paveDisplay6003.text.length != 0){
                paveDisplay6003.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay6003.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay6003.text = [paveDisplay6003.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 6004:
            if(paveDisplay6004.text.length != 0){
                paveDisplay6004.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay6004.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay6004.text = [paveDisplay6004.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 6005:
            if(paveDisplay6005.text.length != 0){
                paveDisplay6005.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay6005.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay6005.text = [paveDisplay6005.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 6006:
            if(paveDisplay6006.text.length != 0){
                paveDisplay6006.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay6006.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay6006.text = [paveDisplay6006.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 4002:
            if(paveDisplay4002.text.length != 0){
                paveDisplay4002.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay4002.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay4002.text = [paveDisplay4002.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        case 4003:
            if(paveDisplay4003.text.length != 0){
                paveDisplay4003.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay4003.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay4003.text = [paveDisplay4003.text stringByReplacingCharactersInRange:lastChar withString:@""];
            }
            break;
        default:
            break;
    }

    
    
}

//Relié au bouton OK

- (IBAction)displaySave:(id)sender {
    NSDate *dateNulle = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    switch ([sender tag]) {
        case 1001:
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            paveDisplay.backgroundColor = [UIColor whiteColor];
            if(paveDisplay.text.length==4){
                
                NSRange numero2;
                numero2.length = (NSUInteger)1;
                numero2.location = (NSUInteger)1;
                
                NSString *temp = [paveDisplay.text copy];
                NSString * searchedChar = [temp substringWithRange:numero2];
                
                
                NSString *remplacementText = [@":" stringByAppendingString: searchedChar];
                
                
                NSRange numero3;
                numero3.length = (NSUInteger)2;
                numero3.location = (NSUInteger)1;
                
                
                paveDisplay.text = [paveDisplay.text stringByReplacingCharactersInRange: numero3 withString:remplacementText];
                
                NSString *zero = @"0";
                paveDisplay.text = [zero stringByAppendingString: paveDisplay.text];
                [NSThread sleepForTimeInterval:0.5f];
                
                
            }
            
            if(paveDisplay.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay.text copy];
                NSString *extraction2 = [paveDisplay.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                if(heure<24 && minutes<60){
                    NSDate * OBT;
                    //Trouver l'endroit ou est stockée l'heure de départ
                    
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    
                    if(leg[@"OffBlocksTime"]==nil || leg[@"OffBlocksTime"]==[NSDate dateWithTimeIntervalSince1970:0] || leg[@"OffBlocksTime"]==[NSDate dateWithTimeIntervalSinceReferenceDate:0]){
                        
                        if(leg[@"ETD"]==nil || leg[@"ETD"]==[NSDate dateWithTimeIntervalSince1970:0] || leg[@"ETD"]==[NSDate dateWithTimeIntervalSinceReferenceDate:0]){
                            
                            OBT = [NSDate dateWithTimeIntervalSinceNow:0];
                        }
                        else{
                            OBT = leg[@"ETD"];
                        }
                    }
                    else{
                        OBT = leg[@"OffBlocksTime"];
                    }
                    
                    NSString *formattedOBT = [df stringFromDate:OBT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedOBT = [formattedOBT stringByReplacingCharactersInRange:hhmm withString:paveDisplay.text];
                    
                    OBT = [df dateFromString:formattedOBT];
                    leg[@"OffBlocksTime"] = OBT;
                    [NSThread sleepForTimeInterval:0.5f];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }
                else{
                    paveDisplay.backgroundColor = [UIColor redColor];
                    
                    
                }
                
            }
            if (paveDisplay.text.length<4){
                paveDisplay.backgroundColor = [UIColor redColor];
                
            }
            break;
            
        case 2001:
            paveDisplay2001.backgroundColor = [UIColor whiteColor];
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            if(paveDisplay2001.text.length==4){
                
                NSRange numero2;
                numero2.length = (NSUInteger)1;
                numero2.location = (NSUInteger)1;
                
                NSString *temp = [paveDisplay2001.text copy];
                NSString * searchedChar = [temp substringWithRange:numero2];
                
                
                NSString *remplacementText = [@":" stringByAppendingString: searchedChar];
                
                
                NSRange numero3;
                numero3.length = (NSUInteger)2;
                numero3.location = (NSUInteger)1;
                
                
                paveDisplay2001.text = [paveDisplay2001.text stringByReplacingCharactersInRange: numero3 withString:remplacementText];
                
                NSString *zero = @"0";
                paveDisplay2001.text = [zero stringByAppendingString: paveDisplay2001.text];
                
                
                
            }
            
            if(paveDisplay2001.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay2001.text copy];
                NSString *extraction2 = [paveDisplay2001.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                if(heure<24 && minutes<60){
                    
                    //Trouver l'endroit ou est stockée l'heure de départ
                    NSDate *FT = [NSDate dateWithTimeIntervalSinceReferenceDate:0];;
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *formattedFT = [df stringFromDate:FT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedFT = [formattedFT stringByReplacingCharactersInRange:hhmm withString:paveDisplay2001.text];
                    
                    FT = [df dateFromString:formattedFT];
                    leg[@"FlightTime"] = FT;
                    
                    
                
                    [NSThread sleepForTimeInterval:0.35f];
                    [NSThread sleepForTimeInterval:0.5f];
                    //Rajouter le push vers la vue suivante
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2002"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                    
                    
                }
                else{
                    paveDisplay2001.backgroundColor = [UIColor redColor];
                    
                }
            }
            if (paveDisplay2001.text.length<4){
                paveDisplay2001.backgroundColor = [UIColor redColor];
            }
                
            
            break;
            
        case 2002:
            paveDisplay2002.backgroundColor = [UIColor whiteColor];
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            if(paveDisplay2002.text.length==4){
                
                NSRange numero2;
                numero2.length = (NSUInteger)1;
                numero2.location = (NSUInteger)1;
                
                NSString *temp = [paveDisplay2002.text copy];
                NSString * searchedChar = [temp substringWithRange:numero2];
                
                
                NSString *remplacementText = [@":" stringByAppendingString: searchedChar];
                
                
                NSRange numero3;
                numero3.length = (NSUInteger)2;
                numero3.location = (NSUInteger)1;
                
                
                paveDisplay2002.text = [paveDisplay2002.text stringByReplacingCharactersInRange: numero3 withString:remplacementText];
                
                NSString *zero = @"0";
                paveDisplay2002.text = [zero stringByAppendingString: paveDisplay2002.text];
                [NSThread sleepForTimeInterval:0.5f];
                
                
            }
            
            if(paveDisplay2002.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay2002.text copy];
                NSString *extraction2 = [paveDisplay2002.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                if(heure<24 && minutes<60){
                    
                    //Trouver l'endroit ou est stockée l'heure de départ
                    NSDate *FT = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *formattedFT = [df stringFromDate:FT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedFT = [formattedFT stringByReplacingCharactersInRange:hhmm withString:paveDisplay2002.text];
                    
                    FT = [df dateFromString:formattedFT];
                    leg[@"BetweenBlocksTime"] = FT;
                    [NSThread sleepForTimeInterval:0.5f];
                    
                    
                    
                    //ATTENTION il faut faire le calcul de onBlocksTime (betweenBlocksTime + offBlocksTime)
                    
                    NSCalendar *cal= [NSCalendar currentCalendar];
                    NSTimeZone *zeroZ = [NSTimeZone timeZoneWithName:@"GMT"];
                    
                    NSCalendarUnit calendrier = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
                    [cal setTimeZone: zeroZ];
                    NSTimeInterval ref = 0;
                    
                    NSDateComponents *bbt = [cal components: calendrier fromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:ref] toDate: FT options: 0];
                    NSDate *onBlocksTime = [cal dateByAddingComponents: bbt toDate:leg[@"OffBlocksTime"] options:0];
                    
                    NSString *output3 = [df stringFromDate:onBlocksTime];

                    
                    
                    leg[@"OnBlocksTime"]=onBlocksTime;
                    
                    [NSThread sleepForTimeInterval:0.5f];
                    //Rajouter le push vers la vue suivante
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2003"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                    
                    
                }
                else{
                    paveDisplay2002.backgroundColor = [UIColor redColor];
                    
                }
            }
            if (paveDisplay2002.text.length<4){
                paveDisplay2002.backgroundColor = [UIColor redColor];
            }

            break;
            
        case 2003:
            paveDisplay2003.backgroundColor = [UIColor whiteColor];
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            if(paveDisplay2003.text.length==4){
                
                NSRange numero2;
                numero2.length = (NSUInteger)1;
                numero2.location = (NSUInteger)1;
                
                NSString *temp = [paveDisplay2003.text copy];
                NSString * searchedChar = [temp substringWithRange:numero2];
                
                
                NSString *remplacementText = [@":" stringByAppendingString: searchedChar];
                
                
                NSRange numero3;
                numero3.length = (NSUInteger)2;
                numero3.location = (NSUInteger)1;
                
                
                paveDisplay2003.text = [paveDisplay2003.text stringByReplacingCharactersInRange: numero3 withString:remplacementText];
                
                NSString *zero = @"0";
                paveDisplay2003.text = [zero stringByAppendingString: paveDisplay2003.text];
                [NSThread sleepForTimeInterval:0.5f];
                
                
            }
            
            if(paveDisplay2003.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay2003.text copy];
                NSString *extraction2 = [paveDisplay2003.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                if(heure<24 && minutes<60){
                    NSDate * nightTime;
                    nightTime = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
                    leg[@"NightTime"]=nightTime;
                    //Trouver l'endroit ou est stockée l'heure de départ
                    NSDate *NT = leg[@"NightTime"];//ATTENTION
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *formattedFT = [df stringFromDate:NT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedFT = [formattedFT stringByReplacingCharactersInRange:hhmm withString:paveDisplay2003.text];
                    
                    NT = [df dateFromString:formattedFT];
                    leg[@"NightTime"] = NT;
                    [NSThread sleepForTimeInterval:0.5f];
                    
                    //ATTENTION il faut faire le calcul de onBlocksTime (betweenBlocksTime + offBlocksTime)
                    [NSThread sleepForTimeInterval:0.5f];
                    //Rajouter le push vers la vue suivante
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2004"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                    
                    
                }
                else{
                    paveDisplay2003.backgroundColor = [UIColor redColor];
                    
                }
            }
            if (paveDisplay2003.text.length<4){
                paveDisplay2003.backgroundColor = [UIColor redColor];
            }

            break;
            
        case 2004:
            paveDisplay2004.backgroundColor = [UIColor whiteColor];
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            if(paveDisplay2004.text.length==4){
                
                NSRange numero2;
                numero2.length = (NSUInteger)1;
                numero2.location = (NSUInteger)1;
                
                NSString *temp = [paveDisplay2004.text copy];
                NSString * searchedChar = [temp substringWithRange:numero2];
                
                
                NSString *remplacementText = [@":" stringByAppendingString: searchedChar];
                
                
                NSRange numero3;
                numero3.length = (NSUInteger)2;
                numero3.location = (NSUInteger)1;
                
                
                paveDisplay2004.text = [paveDisplay2004.text stringByReplacingCharactersInRange: numero3 withString:remplacementText];
                
                NSString *zero = @"0";
                paveDisplay2004.text = [zero stringByAppendingString: paveDisplay2004.text];
                [NSThread sleepForTimeInterval:0.5f];
                
                
            }
            
            if(paveDisplay2004.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay2004.text copy];
                NSString *extraction2 = [paveDisplay2004.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                    if(heure<24 && minutes<60){
//                    NSDate * nightTime;
//                    leg[@"NightTime"]=nightTime;
                        
                    //Trouver l'endroit ou est stockée l'heure demandée
                    NSDate *NT = leg[@"LowLevelFlight"];
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *formattedFT = [df stringFromDate:NT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedFT = [formattedFT stringByReplacingCharactersInRange:hhmm withString:paveDisplay2004.text];
                    
                    NT = [df dateFromString:formattedFT];
                    leg[@"LowLevelFlight"] = NT;
                    [NSThread sleepForTimeInterval:0.5f];
                    
                    //ATTENTION il faut faire le calcul de onBlocksTime (betweenBlocksTime + offBlocksTime)
                    
                    [NSThread sleepForTimeInterval:0.5f];
                    //Rajouter le push vers la vue suivante
                    ChoixCoefViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"ChoixCoef"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                    
                    
                }
                else{
                    paveDisplay2004.backgroundColor = [UIColor redColor];
                    
                }
            }
            if (paveDisplay2004.text.length<4){
                paveDisplay2004.backgroundColor = [UIColor redColor];
            }

            break;
            
        case 2005:
            if(paveDisplay2005.text.length!=0){
                leg[@"Landings"]=paveDisplay2005.text;
                
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2006"];
                [self.navigationController pushViewController:pushVC animated:YES];
                
            }
            else{
                paveDisplay2005.backgroundColor = [UIColor redColor];
            
            }
            
            
            break;
            
        case 2006:
            if(paveDisplay2006.text.length!=0){
                leg[@"TouchAndGo"]=paveDisplay2006.text;
                
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2007"];
                [self.navigationController pushViewController:pushVC animated:YES];
                
            }
            else{
                paveDisplay2006.backgroundColor = [UIColor redColor];
                
            }
            
            break;
            
        case 2007:
            if(paveDisplay2007.text.length!=0){
                leg[@"GoAround"]=paveDisplay2007.text;
                
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            else{
                paveDisplay2007.backgroundColor = [UIColor redColor];
                
            }
            break;
        
        
        case 2011:
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            paveDisplay2011.backgroundColor = [UIColor whiteColor];
            if(paveDisplay2011.text.length==4){
                
                NSRange numero2;
                numero2.length = (NSUInteger)1;
                numero2.location = (NSUInteger)1;
                
                NSString *temp = [paveDisplay2011.text copy];
                NSString * searchedChar = [temp substringWithRange:numero2];
                
                
                NSString *remplacementText = [@":" stringByAppendingString: searchedChar];
                
                
                NSRange numero3;
                numero3.length = (NSUInteger)2;
                numero3.location = (NSUInteger)1;
                
                
                paveDisplay2011.text = [paveDisplay2011.text stringByReplacingCharactersInRange: numero3 withString:remplacementText];
                
                NSString *zero = @"0";
                paveDisplay2011.text = [zero stringByAppendingString: paveDisplay2011.text];
                [NSThread sleepForTimeInterval:0.5f];
                
                
            }
            
            if(paveDisplay2011.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay2011.text copy];
                NSString *extraction2 = [paveDisplay2011.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                if(heure<24 && minutes<60){
                    //Trouver l'endroit ou est stockée l'heure de départ
                    
                    
                    leg[@"Day10"]=dateNulle;
                    NSDate *OBT=leg[@"Day10"];
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *formattedOBT = [df stringFromDate:OBT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedOBT = [formattedOBT stringByReplacingCharactersInRange:hhmm withString:paveDisplay2011.text];
                    
                    OBT = [df dateFromString:formattedOBT];
                    leg[@"Day10"] = OBT;
                    [NSThread sleepForTimeInterval:0.5f];
                    
                    [NSThread sleepForTimeInterval:0.5f];
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2012"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                    
                }
                else{
                    paveDisplay2011.backgroundColor = [UIColor redColor];
                    
                    
                }
                
            }
            if (paveDisplay2011.text.length<4){
                paveDisplay2011.backgroundColor = [UIColor redColor];
                
            }
            break;

        case 2012:
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            paveDisplay2012.backgroundColor = [UIColor whiteColor];
            if(paveDisplay2012.text.length==4){
                
                NSRange numero2;
                numero2.length = (NSUInteger)1;
                numero2.location = (NSUInteger)1;
                
                NSString *temp = [paveDisplay2012.text copy];
                NSString * searchedChar = [temp substringWithRange:numero2];
                
                
                NSString *remplacementText = [@":" stringByAppendingString: searchedChar];
                
                
                NSRange numero3;
                numero3.length = (NSUInteger)2;
                numero3.location = (NSUInteger)1;
                
                
                paveDisplay2012.text = [paveDisplay2012.text stringByReplacingCharactersInRange: numero3 withString:remplacementText];
                
                NSString *zero = @"0";
                paveDisplay2012.text = [zero stringByAppendingString: paveDisplay2012.text];
                [NSThread sleepForTimeInterval:0.5f];
                
                
            }
            
            if(paveDisplay2012.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay2012.text copy];
                NSString *extraction2 = [paveDisplay2012.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                if(heure<24 && minutes<60){
                    //Trouver l'endroit ou est stockée l'heure de départ
                    
                    
                    leg[@"Night10"]=dateNulle;
                    NSDate *OBT=leg[@"Night10"];
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *formattedOBT = [df stringFromDate:OBT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedOBT = [formattedOBT stringByReplacingCharactersInRange:hhmm withString:paveDisplay2012.text];
                    
                    OBT = [df dateFromString:formattedOBT];
                    leg[@"Night10"] = OBT;
                    [NSThread sleepForTimeInterval:0.60f];
                    
                    //Faire les calculs ici
                    
                    NSUInteger secondCoef = [leg[@"SecondCoef"] integerValue];
                    
                    NSCalendarUnit calendrier = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
                    NSCalendar *cal= [NSCalendar currentCalendar];
                    NSTimeZone *zeroZ = [NSTimeZone timeZoneWithName:@"GMT"];
                    [cal setTimeZone:zeroZ];
                    
                    NSDateComponents *difference = [cal components:calendrier fromDate:leg[@"NightTime"] toDate:leg[@"BetweenBlocksTime"] options:0];
                    
                    NSDate *DayTime =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                    
                    leg[@"DayTime"]=DayTime;
                    
                    NSDateComponents *difference2 = [cal components:calendrier fromDate:leg[@"Night10"] toDate:leg[@"NightTime"] options:0];
                    
                    NSDate *nightCompl =[cal dateByAddingComponents:difference2 toDate:dateNulle options:0];
                    
                    
                    difference = [cal components:calendrier fromDate:leg[@"Day10"] toDate:leg[@"DayTime"] options:0];
                    
                    NSDate *dayCompl =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                    
                    
                    switch (secondCoef) {
                        case 2:{
                            leg[@"Day62"]= dayCompl;
                            leg[@"Night62"]= nightCompl;
                            
                            break;}
                        
                        case 3:
                            leg[@"Day35"]= dayCompl;
                            leg[@"Night35"]= nightCompl;
                            break;
                        
                        case 4:
                            leg[@"Day22"]= dayCompl;
                            leg[@"Night22"]= nightCompl;
                            break;
                            
                        default:
                            break;
                    }
                    
                    
                    [NSThread sleepForTimeInterval:0.5f];
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2005"];
                    [self.navigationController pushViewController:pushVC animated:YES];

                    
                }
                else{
                    paveDisplay2012.backgroundColor = [UIColor redColor];
                    
                    
                }
                
            }
            if (paveDisplay2012.text.length<4){
                paveDisplay2012.backgroundColor = [UIColor redColor];
                
            }
            break;
            

        case 2021:
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            paveDisplay2021.backgroundColor = [UIColor whiteColor];
            if(paveDisplay2021.text.length==4){
                
                NSRange numero2;
                numero2.length = (NSUInteger)1;
                numero2.location = (NSUInteger)1;
                
                NSString *temp = [paveDisplay2021.text copy];
                NSString * searchedChar = [temp substringWithRange:numero2];
                
                
                NSString *remplacementText = [@":" stringByAppendingString: searchedChar];
                
                
                NSRange numero3;
                numero3.length = (NSUInteger)2;
                numero3.location = (NSUInteger)1;
                
                
                paveDisplay2021.text = [paveDisplay2021.text stringByReplacingCharactersInRange: numero3 withString:remplacementText];
                
                NSString *zero = @"0";
                paveDisplay2021.text = [zero stringByAppendingString: paveDisplay2021.text];
                [NSThread sleepForTimeInterval:0.5f];
                
                
            }
            
            if(paveDisplay2021.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay2021.text copy];
                NSString *extraction2 = [paveDisplay2021.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                if(heure<24 && minutes<60){
                    //Trouver l'endroit ou est stockée l'heure de départ
                    
                    
                    leg[@"Day62"]=dateNulle;
                    NSDate *OBT=leg[@"Day62"];
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *formattedOBT = [df stringFromDate:OBT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedOBT = [formattedOBT stringByReplacingCharactersInRange:hhmm withString:paveDisplay2021.text];
                    
                    OBT = [df dateFromString:formattedOBT];
                    leg[@"Day62"] = OBT;
                    [NSThread sleepForTimeInterval:0.5f];
                    
                    [NSThread sleepForTimeInterval:0.5f];
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2022"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                    
                }
                else{
                    paveDisplay2021.backgroundColor = [UIColor redColor];
                    
                    
                }
                
            }
            if (paveDisplay2021.text.length<4){
                paveDisplay2021.backgroundColor = [UIColor redColor];
                
            }
            break;

        case 2022:
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            paveDisplay2022.backgroundColor = [UIColor whiteColor];
            if(paveDisplay2022.text.length==4){
                
                NSRange numero2;
                numero2.length = (NSUInteger)1;
                numero2.location = (NSUInteger)1;
                
                NSString *temp = [paveDisplay2022.text copy];
                NSString * searchedChar = [temp substringWithRange:numero2];
                
                
                NSString *remplacementText = [@":" stringByAppendingString: searchedChar];
                
                
                NSRange numero3;
                numero3.length = (NSUInteger)2;
                numero3.location = (NSUInteger)1;
                
                
                paveDisplay2022.text = [paveDisplay2022.text stringByReplacingCharactersInRange: numero3 withString:remplacementText];
                
                NSString *zero = @"0";
                paveDisplay2022.text = [zero stringByAppendingString: paveDisplay2022.text];
                [NSThread sleepForTimeInterval:0.5f];
                
                
            }
            
            if(paveDisplay2022.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay2022.text copy];
                NSString *extraction2 = [paveDisplay2022.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                if(heure<24 && minutes<60){
                    //Trouver l'endroit ou est stockée l'heure de départ
                    
                    
                    leg[@"Night62"]=dateNulle;
                    NSDate *OBT=leg[@"Night62"];
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *formattedOBT = [df stringFromDate:OBT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedOBT = [formattedOBT stringByReplacingCharactersInRange:hhmm withString:paveDisplay2022.text];
                    
                    OBT = [df dateFromString:formattedOBT];
                    leg[@"Night62"] = OBT;
                    [NSThread sleepForTimeInterval:0.60f];
                    
                    //Faire les calculs ici
                    
                    NSUInteger secondCoef = [leg[@"SecondCoef"] integerValue];
                    
                    NSCalendarUnit calendrier = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
                    NSCalendar *cal= [NSCalendar currentCalendar];
                    NSTimeZone *zeroZ = [NSTimeZone timeZoneWithName:@"GMT"];
                    [cal setTimeZone:zeroZ];
                    
                    NSDateComponents *difference = [cal components:calendrier fromDate:leg[@"NightTime"] toDate:leg[@"BetweenBlocksTime"] options:0];
                    
                    NSDate *DayTime =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                    
                    leg[@"DayTime"]=DayTime;
                    
                    NSDateComponents *difference2 = [cal components:calendrier fromDate:leg[@"Night62"] toDate:leg[@"NightTime"] options:0];
                    
                    NSDate *nightCompl =[cal dateByAddingComponents:difference2 toDate:dateNulle options:0];
                    
                    
                    difference = [cal components:calendrier fromDate:leg[@"Day62"] toDate:leg[@"DayTime"] options:0];
                    
                    NSDate *dayCompl =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                    
                    
                    switch (secondCoef) {
                        case 3:
                            leg[@"Day35"]= dayCompl;
                            leg[@"Night35"]= nightCompl;
                            break;
                            
                        case 4:
                            leg[@"Day22"]= dayCompl;
                            leg[@"Night22"]= nightCompl;
                            break;
                            
                        default:
                            break;
                    }
                    
                    [NSThread sleepForTimeInterval:0.5f];
                    
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2005"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                    
                    
                }
                else{
                    paveDisplay2022.backgroundColor = [UIColor redColor];
                    
                    
                }
                
            }
            if (paveDisplay2022.text.length<4){
                paveDisplay2022.backgroundColor = [UIColor redColor];
                
            }
            break;
            
        case 2031:
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            paveDisplay2031.backgroundColor = [UIColor whiteColor];
            if(paveDisplay2031.text.length==4){
                
                NSRange numero2;
                numero2.length = (NSUInteger)1;
                numero2.location = (NSUInteger)1;
                
                NSString *temp = [paveDisplay2031.text copy];
                NSString * searchedChar = [temp substringWithRange:numero2];
                
                
                NSString *remplacementText = [@":" stringByAppendingString: searchedChar];
                
                
                NSRange numero3;
                numero3.length = (NSUInteger)2;
                numero3.location = (NSUInteger)1;
                
                
                paveDisplay2031.text = [paveDisplay2031.text stringByReplacingCharactersInRange: numero3 withString:remplacementText];
                
                NSString *zero = @"0";
                paveDisplay2031.text = [zero stringByAppendingString: paveDisplay2031.text];
                [NSThread sleepForTimeInterval:0.5f];
                
                
            }
            
            if(paveDisplay2031.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay2031.text copy];
                NSString *extraction2 = [paveDisplay2031.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                if(heure<24 && minutes<60){
                    //Trouver l'endroit ou est stockée l'heure de départ
                    
                    
                    leg[@"Day35"]=dateNulle;
                    NSDate *OBT=leg[@"Day35"];
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *formattedOBT = [df stringFromDate:OBT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedOBT = [formattedOBT stringByReplacingCharactersInRange:hhmm withString:paveDisplay2031.text];
                    
                    OBT = [df dateFromString:formattedOBT];
                    leg[@"Day35"] = OBT;
                    [NSThread sleepForTimeInterval:0.5f];
                    [NSThread sleepForTimeInterval:0.5f];
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2032"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                    
                }
                else{
                    paveDisplay2031.backgroundColor = [UIColor redColor];
                    
                    
                }
                
            }
            if (paveDisplay2031.text.length<4){
                paveDisplay2031.backgroundColor = [UIColor redColor];
                
            }
            break;

        case 2032:
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            paveDisplay2032.backgroundColor = [UIColor whiteColor];
            if(paveDisplay2032.text.length==4){
                
                NSRange numero2;
                numero2.length = (NSUInteger)1;
                numero2.location = (NSUInteger)1;
                
                NSString *temp = [paveDisplay2032.text copy];
                NSString * searchedChar = [temp substringWithRange:numero2];
                
                
                NSString *remplacementText = [@":" stringByAppendingString: searchedChar];
                
                
                NSRange numero3;
                numero3.length = (NSUInteger)2;
                numero3.location = (NSUInteger)1;
                
                
                paveDisplay2032.text = [paveDisplay2032.text stringByReplacingCharactersInRange: numero3 withString:remplacementText];
                
                NSString *zero = @"0";
                paveDisplay2032.text = [zero stringByAppendingString: paveDisplay2032.text];
                [NSThread sleepForTimeInterval:0.5f];
                
                
            }
            
            if(paveDisplay2032.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay2032.text copy];
                NSString *extraction2 = [paveDisplay2032.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                if(heure<24 && minutes<60){
                    //Trouver l'endroit ou est stockée l'heure de départ
                    
                    
                    leg[@"Night35"]=dateNulle;
                    NSDate *OBT=leg[@"Night35"];
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    NSString *formattedOBT = [df stringFromDate:OBT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedOBT = [formattedOBT stringByReplacingCharactersInRange:hhmm withString:paveDisplay2032.text];
                    
                    OBT = [df dateFromString:formattedOBT];
                    leg[@"Night35"] = OBT;
                    [NSThread sleepForTimeInterval:0.60f];
                    
                    //Faire les calculs ici
                    
                    
                    NSCalendarUnit calendrier = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
                    NSCalendar *cal= [NSCalendar currentCalendar];
                    NSTimeZone *zeroZ = [NSTimeZone timeZoneWithName:@"GMT"];
                    [cal setTimeZone:zeroZ];
                    
                    NSDateComponents *difference = [cal components:calendrier fromDate:leg[@"NightTime"] toDate:leg[@"BetweenBlocksTime"] options:0];
                    
                    NSDate *DayTime =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                    
                    leg[@"DayTime"]=DayTime;
                    
                    NSDateComponents *difference2 = [cal components:calendrier fromDate:leg[@"Night35"] toDate:leg[@"NightTime"] options:0];
                    
                    NSDate *nightCompl =[cal dateByAddingComponents:difference2 toDate:dateNulle options:0];
                    
                    
                    difference = [cal components:calendrier fromDate:leg[@"Day35"] toDate:leg[@"DayTime"] options:0];
                    
                    NSDate *dayCompl =[cal dateByAddingComponents:difference toDate:dateNulle options:0];

                    leg[@"Day22"]= dayCompl;
                    leg[@"Night22"]= nightCompl;
                    
                    [NSThread sleepForTimeInterval:0.5f];
                    
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2005"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                    
                    
                }
                else{
                    paveDisplay2032.backgroundColor = [UIColor redColor];
                    
                    
                }
                
            }
            if (paveDisplay2032.text.length<4){
                paveDisplay2032.backgroundColor = [UIColor redColor];
                
            }
            break;
        
        case 6001:{
            leg[@"FuelAdded"]=paveDisplay6001.text;
            
            [NSThread sleepForTimeInterval:0.5f];
            
            leg[@"FuelBurned"] = @([leg[@"FuelAtTakeOff"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
            
            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6002"];
            [self.navigationController pushViewController:pushVC animated:YES];
            break;
            }
            
        case 6002:{
            leg[@"N°BM19"]=paveDisplay6002.text;
            
            [NSThread sleepForTimeInterval:0.5f];
            
            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6003"];
            [self.navigationController pushViewController:pushVC animated:YES];
            break;
        }
        case 6003:{
            
            if(paveDisplay6003.text.length!=0){
                leg[@"FuelAtTakeOff"]=paveDisplay6003.text;
                
                [NSThread sleepForTimeInterval:0.5f];
                
                leg[@"FuelBurned"] = @([leg[@"FuelAtTakeOff"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
                
                
                if(!useReceivedAndDelivered){
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6006"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                
                }
                else{
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6004"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                }
            }
            
            else{
            
                paveDisplay6003.backgroundColor = [UIColor redColor];
            
            }
            
            break;
        }
            
        case 6004:{
            leg[@"FuelDelivered"]=paveDisplay6004.text;
            
            [NSThread sleepForTimeInterval:0.5f];
            
            leg[@"FuelBurned"] = @([leg[@"FuelAtTakeOff"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
            
            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6005"];
            [self.navigationController pushViewController:pushVC animated:YES];
            
            
            break;
        }
        case 6005:{
            leg[@"FuelReceived"]=paveDisplay6005.text;
            
            [NSThread sleepForTimeInterval:0.5f];
            
            leg[@"FuelBurned"] = @([leg[@"FuelAtTakeOff"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
            
            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6006"];
            [self.navigationController pushViewController:pushVC animated:YES];
            break;
        }
            
        case 6006:{
            
            if(paveDisplay6006.text.length !=0){
                
                NSInteger finalFuel = [paveDisplay6006.text integerValue];
                
                
                [NSThread sleepForTimeInterval:0.5f];
                
                NSInteger fuelBurned = [leg[@"FuelAtTakeOff"] integerValue] - finalFuel - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue];
                
                
                
                if(fuelBurned>=0){
                    leg[@"FinalFuel"]=paveDisplay6006.text;
                    leg[@"FuelBurned"] = @([leg[@"FuelAtTakeOff"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else{
                paveDisplay6006.backgroundColor = [UIColor redColor];
                    
                }
            }
            
            else{
            
                paveDisplay6006.backgroundColor = [UIColor redColor];
            
            }
            
            break;
        }
        case 4002:
            if(paveDisplay4002.text.length){

                currentCargo.weight=@([paveDisplay4002.text integerValue]*89).description;
                [currentCargo setCargoList];
                
                [Cargo reloadBenefListWithMission : mission];

                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            
            }
            else{
                paveDisplay4002.backgroundColor = [UIColor redColor];
            }
            
            break;
            
        case 4003:
            if(paveDisplay4003.text.length){
                
                currentCargo.weight= paveDisplay4003.text;
                
                [currentCargo setCargoList];
                
                [Cargo reloadBenefListWithMission : mission];

                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                paveDisplay4003.backgroundColor = [UIColor redColor];
            }
            
            break;
            
        default:
            break;
    }

    
    
}
@end

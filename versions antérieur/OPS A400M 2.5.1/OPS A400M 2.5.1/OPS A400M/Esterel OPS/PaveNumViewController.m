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
#import "LoadViewController.h"



/*
 COMMENTS X15:
 
Ceci est la classe des controllers avec le pavé nuimérique fait à la main. Aucun clavier de base apple de proposant ce pavé numérique, on l'a recreer de toute piece. Chaque instance à un tag unique (1000, 2001, 2002, 4004, 6001 etc... ) et ces boutons ont le meme tag, et sont relié à la meme action qui utilise un switch sur les tags. Pour l'utiliser, il suffit de copier coller, de changer tous les tags, de relier le label et de rajouter le bon case dans les switchs.
 
 
 
 ATTENTION: Nomenclature des tags des differentes pages: dans un soucis de regroupement on fait des swicht case avec chaque page qui utilise un pad numérique et des heures.
 Ne pas avoir peur de la taille du texte, c'est globalement du méga copier coller, avec du traitement au cas par cas si on traite avec des heures, des nombres, et pour l'enregistrement dans mission.legs...
 
 Departure:
 1001: Pavé heure de départ (OBtime)
 1002: pavé heure de deco : (TOTime)
 
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
 4002: PAX number (for pax)
 4003: Cargo Weight (for pallet and bulk)
 4004: total PAX weight
 */





@interface PaveNumViewController (){
    
    Mission *mission;
    NSMutableDictionary *leg;
    Cargo *currentCargo;
    NSInteger localLegIndex;

}
    

@end

@implementation PaveNumViewController




@synthesize paveDisplay; // en gros 1001 quoi.... //
@synthesize paveDisplay1002;

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
@synthesize paveDisplay4004;


- (void)activeLegDidChange:(NSInteger)legNumber
{
    leg = mission.activeLeg;
    
    if(mission.activeLegIndex==0 && localLegIndex !=0){
        //C'est la cas ou on passe de n'importe quelle leg à la premiere
        if([self.restorationIdentifier isEqualToString: @"6001"] || [self.restorationIdentifier isEqualToString: @"6002"]){
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
        }
    }
    
    else if(mission.activeLegIndex!=0 && localLegIndex ==0){
        if([self.restorationIdentifier isEqualToString: @"6003"]){
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
        }
    
    }
    [self makeTitles];
    [self reloadValues];
    localLegIndex = mission.activeLegIndex;
}


- (void)reloadValues{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    
    
    paveDisplay.text = [df stringFromDate:leg[@"OffBlocksTime"]];
    paveDisplay1002.text = [df stringFromDate:leg[@"TakeOffTime"]];
    paveDisplay2001.text=[df stringFromDate:leg[@"FlightTime"]];
    paveDisplay2002.text=[df stringFromDate:leg[@"BetweenBlocksTime"]];
    
    paveDisplay2003.text=(leg[@"NightTime"])? [df stringFromDate:leg[@"NightTime"]]:@"00:00";
    
    
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
    
    if(currentCargo.weight){

        paveDisplay4002.text=@(currentCargo.nombrePax).description;
        paveDisplay4003.text=currentCargo.weight;
        paveDisplay4004.text=currentCargo.weight;
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    mission = ((SplitViewController*)self.splitViewController).mission;
    leg = mission.activeLeg;
    currentCargo=mission.currentCargo;
    localLegIndex=mission.activeLegIndex;
    
        // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ((mission = ((SplitViewController*)self.splitViewController).mission))
    {
        mission.delegate = self;
        leg = mission.activeLeg;
        localLegIndex=mission.activeLegIndex;
        [self reloadValues];
        [self makeTitles];
       
        
        
        
    }
}

- (void) makeTitles{
    NSString * total =([[NSUserDefaults standardUserDefaults] boolForKey:@"useDeliveredAndReceived"])?@"11)":@"9)";

    switch ([self.restorationIdentifier integerValue]) {
            
        //partie départ
        case 1001:
            self.title = [@"Off-Blocks Time (1/" stringByAppendingString:((mission.activeLegIndex==0)?@"3)":@"4)")];
            break;
        case 1002:
            self.title = [@"Take-Off Time (2/" stringByAppendingString:((mission.activeLegIndex==0)?@"3)":@"4)")];
            break;
        case 6003:
            self.title = @"Fuel at start up (kg) (3/3)";
            break;
        case 6001:
            self.title = @"BM19 (kg) (3/4)";
            break;
        case 6002:
            self.title = @"Num BM19 (4/4)";
            break;

        case 2001:
            self.title = [@"Flight Time (1/" stringByAppendingString:total ];
            break;
        case 2002:
            self.title = [@"Block Time (2/" stringByAppendingString:total ];
            break;
        case 2003:
            self.title = [@"Including Night Time (3/" stringByAppendingString:total ];
            break;
        case 2004:
            self.title = [@"Including LLF (4/" stringByAppendingString:total ];
            break;
        case 2005:
            self.title = [@"Number of Landings (6/" stringByAppendingString:total ];
            break;
        case 2006:
            self.title = [@"Number of TAG (7/" stringByAppendingString:total ];
            break;
        case 2007:
            self.title = [@"Number of Go Around (8/" stringByAppendingString:total ];
            break;
        case 6006:
            self.title = [@"Final Fuel (kg) (9/" stringByAppendingString:total ];
            break;
        case 6004:
            self.title = [@"Delivered Fuel (kg) (10/" stringByAppendingString:total ];
            break;
        case 6005:
            self.title = [@"Received Fuel (kg) (11/" stringByAppendingString:total ];
            break;
            
        case 2011:
            self.title = [@"Including 10 Day Time (5a/" stringByAppendingString:total ];
            break;
        case 2012:
            self.title = [@"Including 10 Night Time (5b/" stringByAppendingString:total ];
            break;
        case 2021:
            self.title = [@"Including 62 Day Time (5a/" stringByAppendingString:total ];
            break;
        case 2022:
            self.title = [@"Including 62 Night Time (5b/" stringByAppendingString:total ];
            break;
        case 2031:
            self.title = [@"Including 35 Day Time (5a/" stringByAppendingString:total ];
            break;
        case 2032:
            self.title = [@"Including 35 Night Time (5b/" stringByAppendingString:total ];
            break;
        default:
            break;
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

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}



- (IBAction)sendNumber:(id)sender {
    
    //on récupère le numéro appuyé
    NSString *num = [sender currentTitle];
    
    switch ([sender tag]) {
        case 1001:
            paveDisplay.backgroundColor = [UIColor whiteColor];

            if([paveDisplay.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay.text = [paveDisplay.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay.text.length<=1){
                paveDisplay.text = [paveDisplay.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay.text.length==2){
                paveDisplay.text = [paveDisplay.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay.text = [paveDisplay.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay.text.length ==4){
                
                paveDisplay.text = [paveDisplay.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay.text = [paveDisplay.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay.text = [paveDisplay.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
            }
            break;
            
        case 1002:
            paveDisplay1002.backgroundColor = [UIColor whiteColor];
            
            if([paveDisplay1002.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay1002.text = [paveDisplay1002.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay1002.text.length<=1){
                paveDisplay1002.text = [paveDisplay1002.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay1002.text.length==2){
                paveDisplay1002.text = [paveDisplay1002.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay1002.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay1002.text = [paveDisplay1002.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay1002.text.length ==4){
                
                paveDisplay1002.text = [paveDisplay1002.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay1002.text = [paveDisplay1002.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay1002.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay1002.text = [paveDisplay1002.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
            }
            break;
            

            
        case 2001:
            paveDisplay2001.backgroundColor = [UIColor whiteColor];
            
            if([paveDisplay2001.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay2001.text = [paveDisplay2001.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2001.text.length<=1){
                paveDisplay2001.text = [paveDisplay2001.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2001.text.length==2){
                paveDisplay2001.text = [paveDisplay2001.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay2001.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2001.text = [paveDisplay2001.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay2001.text.length ==4){
                
                paveDisplay2001.text = [paveDisplay2001.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay2001.text = [paveDisplay2001.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay2001.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2001.text = [paveDisplay2001.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
            }
            break;
            
        case 2002:
            paveDisplay2002.backgroundColor = [UIColor whiteColor];
            
            if([paveDisplay2002.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay2002.text = [paveDisplay2002.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2002.text.length<=1){
                paveDisplay2002.text = [paveDisplay2002.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2002.text.length==2){
                paveDisplay2002.text = [paveDisplay2002.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay2002.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2002.text = [paveDisplay2002.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay2002.text.length ==4){
                
                paveDisplay2002.text = [paveDisplay2002.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay2002.text = [paveDisplay2002.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay2002.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2002.text = [paveDisplay2002.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
            }
            break;
            
        case 2003:
            paveDisplay2003.backgroundColor = [UIColor whiteColor];
            
            if([paveDisplay2003.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay2003.text = [paveDisplay2003.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2003.text.length<=1){
                paveDisplay2003.text = [paveDisplay2003.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2003.text.length==2){
                paveDisplay2003.text = [paveDisplay2003.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay2003.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2003.text = [paveDisplay2003.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay2003.text.length ==4){
                
                paveDisplay2003.text = [paveDisplay2003.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay2003.text = [paveDisplay2003.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay2003.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2003.text = [paveDisplay2003.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
            }
            break;
            
        case 2004:
            paveDisplay2004.backgroundColor = [UIColor whiteColor];
            
            if([paveDisplay2004.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay2004.text = [paveDisplay2004.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2004.text.length<=1){
                paveDisplay2004.text = [paveDisplay2004.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2004.text.length==2){
                paveDisplay2004.text = [paveDisplay2004.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay2004.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2004.text = [paveDisplay2004.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay2004.text.length ==4){
                
                paveDisplay2004.text = [paveDisplay2004.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay2004.text = [paveDisplay2004.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay2004.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2004.text = [paveDisplay2004.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
            }
            break;
            
        case 2005:
                if([paveDisplay2005.text isEqualToString:@"0"]){
                    [self clearDisplay:sender];
                }
                paveDisplay2005.backgroundColor = [UIColor whiteColor];
                
                if(paveDisplay2005.text.length <=4){
                    paveDisplay2005.text = [paveDisplay2005.text stringByAppendingString: num];
                }
            break;
            
        case 2006:
                if([paveDisplay2006.text isEqualToString:@"0"]){
                    [self clearDisplay:sender];}
                paveDisplay2006.backgroundColor = [UIColor whiteColor];
                
                if(paveDisplay2006.text.length <=4){
                    paveDisplay2006.text = [paveDisplay2006.text stringByAppendingString: num];
                }
            break;
            
        case 2007:
                if([paveDisplay2007.text isEqualToString:@"0"]){
                    [self clearDisplay:sender];}
                paveDisplay2007.backgroundColor = [UIColor whiteColor];
                
                if(paveDisplay2007.text.length <=4){
                    paveDisplay2007.text = [paveDisplay2007.text stringByAppendingString: num];
                }
            break;
        
        case 2011:
            paveDisplay2011.backgroundColor = [UIColor whiteColor];
            
            if([paveDisplay2011.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay2011.text = [paveDisplay2011.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2011.text.length<=1){
                paveDisplay2011.text = [paveDisplay2011.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2011.text.length==2){
                paveDisplay2011.text = [paveDisplay2011.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay2011.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2011.text = [paveDisplay2011.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay2011.text.length ==4){
                
                paveDisplay2011.text = [paveDisplay2011.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay2011.text = [paveDisplay2011.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay2011.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2011.text = [paveDisplay2011.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
            }
            break;
        case 2012:
            paveDisplay2012.backgroundColor = [UIColor whiteColor];
            
            if([paveDisplay2012.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay2012.text = [paveDisplay2012.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2012.text.length<=1){
                paveDisplay2012.text = [paveDisplay2012.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2012.text.length==2){
                paveDisplay2012.text = [paveDisplay2012.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay2012.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2012.text = [paveDisplay2012.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay2012.text.length ==4){
                
                paveDisplay2012.text = [paveDisplay2012.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay2012.text = [paveDisplay2012.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay2012.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2012.text = [paveDisplay2012.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
            }
            break;
        case 2021:
            paveDisplay2021.backgroundColor = [UIColor whiteColor];
            
            if([paveDisplay2021.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay2021.text = [paveDisplay2021.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2021.text.length<=1){
                paveDisplay2021.text = [paveDisplay2021.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2021.text.length==2){
                paveDisplay2021.text = [paveDisplay2021.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay2021.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2021.text = [paveDisplay2021.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay2021.text.length ==4){
                
                paveDisplay2021.text = [paveDisplay2021.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay2021.text = [paveDisplay2021.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay2021.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2021.text = [paveDisplay2021.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
            }
            break;

        case 2022:
            paveDisplay2022.backgroundColor = [UIColor whiteColor];
            
            if([paveDisplay2022.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay2022.text = [paveDisplay2022.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2022.text.length<=1){
                paveDisplay2022.text = [paveDisplay2022.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2022.text.length==2){
                paveDisplay2022.text = [paveDisplay2022.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay2022.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2022.text = [paveDisplay2022.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay2022.text.length ==4){
                
                paveDisplay2022.text = [paveDisplay2022.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay2022.text = [paveDisplay2022.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay2022.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2022.text = [paveDisplay2022.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
            }
            break;
        case 2031:
            paveDisplay2031.backgroundColor = [UIColor whiteColor];
            
            if([paveDisplay2031.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay2031.text = [paveDisplay2031.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2031.text.length<=1){
                paveDisplay2031.text = [paveDisplay2031.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2031.text.length==2){
                paveDisplay2031.text = [paveDisplay2031.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay2031.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2031.text = [paveDisplay2031.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay2031.text.length ==4){
                
                paveDisplay2031.text = [paveDisplay2031.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay2031.text = [paveDisplay2031.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay2031.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2031.text = [paveDisplay2031.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
            }
            break;
        case 2032:
            paveDisplay2032.backgroundColor = [UIColor whiteColor];
            
            if([paveDisplay2032.text isEqualToString:@"00:00"]){
                [self clearDisplay:sender];
                paveDisplay2032.text = [paveDisplay2032.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2032.text.length<=1){
                paveDisplay2032.text = [paveDisplay2032.text stringByAppendingString: num];
            }
            
            
            else if(paveDisplay2032.text.length==2){
                paveDisplay2032.text = [paveDisplay2032.text stringByAppendingString: num];
                NSRange range;
                range.length=1;
                range.location=0;
                NSString *deb = [paveDisplay2032.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2032.text = [paveDisplay2032.text stringByReplacingCharactersInRange:range withString:deb];
                
            }
            else if(paveDisplay2032.text.length ==4){
                
                paveDisplay2032.text = [paveDisplay2032.text stringByAppendingString: num];
                
                NSRange range;
                range.length=1;
                range.location=1;
                paveDisplay2032.text = [paveDisplay2032.text stringByReplacingCharactersInRange:range withString:@""];
                
                range.length=2;
                range.location=0 ;
                
                NSString *deb = [paveDisplay2032.text substringWithRange:range];
                deb = [deb stringByAppendingString:@":"];
                paveDisplay2032.text = [paveDisplay2032.text stringByReplacingCharactersInRange:range withString:deb];
                
                
                
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
        case 4004:
            if([paveDisplay4004.text isEqualToString:@"0"]){
                [self clearDisplay:sender];
            }
            
            paveDisplay4004.backgroundColor = [UIColor whiteColor];
            paveDisplay4004.text = [paveDisplay4004.text stringByAppendingString: num];
            break;

        default:
            break;
    
    
    
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
            
        case 1002:
            paveDisplay1002.backgroundColor = [UIColor whiteColor];
            paveDisplay1002.text = @"";
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
        case 4004:
            paveDisplay4004.backgroundColor = [UIColor whiteColor];
            paveDisplay4004.text = @"";
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
                if(paveDisplay.text.length <=2){
                    NSUInteger longueur = paveDisplay.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay.text = [paveDisplay.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay.text = [paveDisplay.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay.text = [paveDisplay.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay.text = [paveDisplay.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay.text = [paveDisplay.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay.text = [paveDisplay.text stringByReplacingCharactersInRange:range withString:@":"];
                
                }
            }
            break;
            
        case 1002:
            if(paveDisplay1002.text.length != 0){
                paveDisplay1002.backgroundColor = [UIColor whiteColor];
                if(paveDisplay1002.text.length <=2){
                    NSUInteger longueur = paveDisplay1002.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay1002.text = [paveDisplay1002.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay1002.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay1002.text = [paveDisplay1002.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay1002.text = [paveDisplay1002.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay1002.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay1002.text = [paveDisplay1002.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay1002.text = [paveDisplay1002.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay1002.text = [paveDisplay1002.text stringByReplacingCharactersInRange:range withString:@":"];
                    
                }
            }
            break;

            
        case 2001:
            if(paveDisplay2001.text.length != 0){
                paveDisplay2001.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2001.text.length <=2){
                    NSUInteger longueur = paveDisplay2001.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay2001.text = [paveDisplay2001.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay2001.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay2001.text = [paveDisplay2001.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay2001.text = [paveDisplay2001.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay2001.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay2001.text = [paveDisplay2001.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay2001.text = [paveDisplay2001.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay2001.text = [paveDisplay2001.text stringByReplacingCharactersInRange:range withString:@":"];
                    
                }
            }

            break;
            
        case 2002:
            if(paveDisplay2002.text.length != 0){
                paveDisplay2002.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2002.text.length <=2){
                    NSUInteger longueur = paveDisplay2002.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay2002.text = [paveDisplay2002.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay2002.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay2002.text = [paveDisplay2002.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay2002.text = [paveDisplay2002.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay2002.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay2002.text = [paveDisplay2002.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay2002.text = [paveDisplay2002.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay2002.text = [paveDisplay2002.text stringByReplacingCharactersInRange:range withString:@":"];
                    
                }
            }            break;
            
        case 2003:
            if(paveDisplay2003.text.length != 0){
                paveDisplay2003.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2003.text.length <=2){
                    NSUInteger longueur = paveDisplay2003.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay2003.text = [paveDisplay2003.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay2003.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay2003.text = [paveDisplay2003.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay2003.text = [paveDisplay2003.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay2003.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay2003.text = [paveDisplay2003.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay2003.text = [paveDisplay2003.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay2003.text = [paveDisplay2003.text stringByReplacingCharactersInRange:range withString:@":"];
                    
                }
            }
            

            break;
            
        case 2004:
            if(paveDisplay2004.text.length != 0){
                paveDisplay2004.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2004.text.length <=2){
                    NSUInteger longueur = paveDisplay2004.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay2004.text = [paveDisplay2004.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay2004.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay2004.text = [paveDisplay2004.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay2004.text = [paveDisplay2004.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay2004.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay2004.text = [paveDisplay2004.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay2004.text = [paveDisplay2004.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay2004.text = [paveDisplay2004.text stringByReplacingCharactersInRange:range withString:@":"];
                    
                }
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
                if(paveDisplay2011.text.length <=2){
                    NSUInteger longueur = paveDisplay2011.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay2011.text = [paveDisplay2011.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay2011.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay2011.text = [paveDisplay2011.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay2011.text = [paveDisplay2011.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay2011.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay2011.text = [paveDisplay2011.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay2011.text = [paveDisplay2011.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay2011.text = [paveDisplay2011.text stringByReplacingCharactersInRange:range withString:@":"];
                    
                }
            }
            

            break;
        case 2012:
            if(paveDisplay2012.text.length != 0){
                paveDisplay2012.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2012.text.length <=2){
                    NSUInteger longueur = paveDisplay2012.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay2012.text = [paveDisplay2012.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay2012.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay2012.text = [paveDisplay2012.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay2012.text = [paveDisplay2012.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay2012.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay2012.text = [paveDisplay2012.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay2012.text = [paveDisplay2012.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay2012.text = [paveDisplay2012.text stringByReplacingCharactersInRange:range withString:@":"];
                    
                }
            }
            

            break;
        case 2021:
            if(paveDisplay2021.text.length != 0){
                paveDisplay2021.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2021.text.length <=2){
                    NSUInteger longueur = paveDisplay2021.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay2021.text = [paveDisplay2021.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay2021.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay2021.text = [paveDisplay2021.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay2021.text = [paveDisplay2021.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay2021.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay2021.text = [paveDisplay2021.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay2021.text = [paveDisplay2021.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay2021.text = [paveDisplay2021.text stringByReplacingCharactersInRange:range withString:@":"];
                    
                }
            }
            

            break;
            
        case 2022:
            if(paveDisplay2022.text.length != 0){
                paveDisplay2022.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2022.text.length <=2){
                    NSUInteger longueur = paveDisplay2022.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay2022.text = [paveDisplay2022.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay2022.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay2022.text = [paveDisplay2022.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay2022.text = [paveDisplay2022.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay2022.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay2022.text = [paveDisplay2022.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay2022.text = [paveDisplay2022.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay2022.text = [paveDisplay2022.text stringByReplacingCharactersInRange:range withString:@":"];
                    
                }
            }
            

            break;
        case 2031:
            if(paveDisplay2031.text.length != 0){
                paveDisplay2031.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2031.text.length <=2){
                    NSUInteger longueur = paveDisplay2031.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay2031.text = [paveDisplay2031.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay2031.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay2031.text = [paveDisplay2031.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay2031.text = [paveDisplay2031.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay2031.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay2031.text = [paveDisplay2031.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay2031.text = [paveDisplay2031.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay2031.text = [paveDisplay2031.text stringByReplacingCharactersInRange:range withString:@":"];
                    
                }
            }
            

            break;
        case 2032:
            if(paveDisplay2032.text.length != 0){
                paveDisplay2032.backgroundColor = [UIColor whiteColor];
                if(paveDisplay2032.text.length <=2){
                    NSUInteger longueur = paveDisplay2032.text.length;
                    NSRange lastChar;
                    lastChar.location=longueur-1;
                    lastChar.length=(NSUInteger)1;
                    paveDisplay2032.text = [paveDisplay2032.text stringByReplacingCharactersInRange:lastChar withString:@""];
                }
                else if(paveDisplay2032.text.length==4){
                    NSRange range;
                    range.length=1;
                    range.location=1;
                    paveDisplay2032.text = [paveDisplay2032.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=2;
                    paveDisplay2032.text = [paveDisplay2032.text stringByReplacingCharactersInRange:range withString:@""];
                }
                else if(paveDisplay2032.text.length==5){
                    NSRange range;
                    range.length=1;
                    range.location=2;
                    paveDisplay2032.text = [paveDisplay2032.text stringByReplacingCharactersInRange:range withString:@""];
                    range.location=3;
                    paveDisplay2032.text = [paveDisplay2032.text stringByReplacingCharactersInRange:range withString:@""];
                    range.length = 0;
                    range.location = 1;
                    paveDisplay2032.text = [paveDisplay2032.text stringByReplacingCharactersInRange:range withString:@":"];
                    
                }
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
        case 4004:
            if(paveDisplay4004.text.length != 0){
                paveDisplay4004.backgroundColor = [UIColor whiteColor];
                NSUInteger longueur = paveDisplay4004.text.length;
                NSRange lastChar;
                lastChar.location=longueur-1;
                lastChar.length=(NSUInteger)1;
                paveDisplay4004.text = [paveDisplay4004.text stringByReplacingCharactersInRange:lastChar withString:@""];
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
                paveDisplay.text = [@"0" stringByAppendingString:paveDisplay.text];
                
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
                    
                    if(leg[@"OffBlocksTime"]==nil || [leg[@"OffBlocksTime"] isEqualToDate :[NSDate dateWithTimeIntervalSince1970:0]] || [leg[@"OffBlocksTime"]isEqualToDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]]){

                        if(leg[@"ETD"]==nil || [leg[@"ETD"] isEqualToDate: [NSDate dateWithTimeIntervalSince1970:0]] || [leg[@"ETD"] isEqualToDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]]){

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
                    
                    NSTimeInterval retard = [[df dateFromString:formattedOBT] timeIntervalSinceDate: leg[@"ETD"]];
                    
                    //
                    if(retard < (-3*3600)){
                        NSTimeInterval day = 24*3600;
                        OBT = [[df dateFromString:formattedOBT] dateByAddingTimeInterval:day];
                    }
                    else {
                        OBT = [df dateFromString:formattedOBT];
                    }
                    
                    leg[@"OffBlocksTime"] = OBT;
                    
                    leg[@"Indicators"][@"Departure"][0]=@"1";
                    
                    // on regarde si on est sur la première leg ou non puis on demande le Fuel
                    
                    
                    PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"1002"];
                    [self.navigationController pushViewController:pushVC animated:YES];
                    
                    
                    
                    
                    
                    
                }
                else{
                    paveDisplay.backgroundColor = [UIColor redColor];
                    
                    
                }
                
            }
            if (paveDisplay.text.length<4){
                paveDisplay.backgroundColor = [UIColor redColor];
                
            }
            break;
        
            
        case 1002:
            //Rajoute un zéro au début si on a tapé que 3 chiffres (82:0 --> 8:20 --> 08:20)
            paveDisplay1002.backgroundColor = [UIColor whiteColor];
            if(paveDisplay1002.text.length==4){
                paveDisplay1002.text = [@"0" stringByAppendingString:paveDisplay1002.text];
                
            }
            
            if(paveDisplay1002.text.length == 5){
                
                NSRange plage;
                plage.length=(NSUInteger)3;
                plage.location=(NSUInteger)2;
                NSString *extraction1 = [paveDisplay1002.text copy];
                NSString *extraction2 = [paveDisplay1002.text copy];
                NSInteger heure = [[extraction1 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                plage.location=(NSUInteger)0;
                NSInteger minutes = [[extraction2 stringByReplacingCharactersInRange:plage withString:@""] integerValue];
                if(heure<24 && minutes<60){
                    NSDate * OBT;
                    //Trouver l'endroit ou est stockée l'heure de départ
                    
                    NSDateFormatter* df = [[NSDateFormatter alloc]init];
                    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
                    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                    
                    if(leg[@"TakeOffTime"]==nil || [leg[@"TakeOffTime"] isEqualToDate :[NSDate dateWithTimeIntervalSince1970:0]] || [leg[@"TakeOffTime"]isEqualToDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]]){
                        
                        if(leg[@"ETD"]==nil || [leg[@"ETD"] isEqualToDate: [NSDate dateWithTimeIntervalSince1970:0]] || [leg[@"ETD"] isEqualToDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0]]){
                            
                            OBT = [NSDate dateWithTimeIntervalSinceNow:0];
                        }
                        else{
                            OBT = leg[@"ETD"];
                            
                        }
                    }
                    else{
                        OBT = leg[@"TakeOffTime"];
                        
                    }
                    
                    NSString *formattedOBT = [df stringFromDate:OBT];
                    
                    NSRange hhmm;
                    hhmm.length = (NSUInteger)5;
                    hhmm.location = (NSUInteger)11;
                    
                    formattedOBT = [formattedOBT stringByReplacingCharactersInRange:hhmm withString:paveDisplay1002.text];
                    
                    NSTimeInterval retard = [[df dateFromString:formattedOBT] timeIntervalSinceDate: leg[@"ETD"]];
                    
                    //
                    if(retard < (-3*3600)){
                        NSTimeInterval day = 24*3600;
                        OBT = [[df dateFromString:formattedOBT] dateByAddingTimeInterval:day];
                    }
                    else {
                        OBT = [df dateFromString:formattedOBT];
                    }
                    
                    leg[@"TakeOffTime"] = OBT;
                    
                    
                    // on regarde si on est sur la première leg ou non puis on demande le Fuel
                    if(mission.activeLegIndex==0){
                        PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6003"];
                        [self.navigationController pushViewController:pushVC animated:YES];
                        
                    }
                    else{
                        PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6001"];
                        [self.navigationController pushViewController:pushVC animated:YES];
                        
                    }
                    
                    
                    
                    
                }
                else{
                    paveDisplay1002.backgroundColor = [UIColor redColor];
                    
                    
                }
                
            }
            if (paveDisplay1002.text.length<4){
                paveDisplay1002.backgroundColor = [UIColor redColor];
                
            }
            break;
            
        case 2001:
            paveDisplay2001.backgroundColor = [UIColor whiteColor];
            
            if(paveDisplay2001.text.length==4){
                paveDisplay2001.text = [@"0" stringByAppendingString:paveDisplay2001.text];
                
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
                    
                    
                    leg[@"Indicators"][@"Arrival"][0]=@"1";
                
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
            
            if(paveDisplay2002.text.length==4){
                paveDisplay2002.text = [@"0" stringByAppendingString:paveDisplay2002.text];
                
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
                    
                    NSTimeInterval diff = [FT timeIntervalSinceDate:leg[@"FlightTime"]];
                    
                    if(diff >= 0){
                    
                        leg[@"BetweenBlocksTime"] = FT;
                        
                        
                        
                        //ATTENTION il faut faire le calcul de onBlocksTime (betweenBlocksTime + offBlocksTime)
                        
                        NSCalendar *cal= [NSCalendar currentCalendar];
                        NSTimeZone *zeroZ = [NSTimeZone timeZoneWithName:@"GMT"];
                        
                        NSCalendarUnit calendrier = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
                        [cal setTimeZone: zeroZ];
                        NSTimeInterval ref = 0;
                        
                        NSDateComponents *bbt = [cal components: calendrier fromDate: [NSDate dateWithTimeIntervalSinceReferenceDate:ref] toDate: FT options: 0];
                        NSDate *onBlocksTime = [cal dateByAddingComponents: bbt toDate:leg[@"OffBlocksTime"] options:0];
                        
                        
                        
                        leg[@"OnBlocksTime"]=onBlocksTime;
                        
                        
                        //Rajouter le push vers la vue suivante

           
                        
                        PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2003"];
                        [self.navigationController pushViewController:pushVC animated:YES];
                    }
                    else{
                        paveDisplay2002.backgroundColor = [UIColor redColor];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"! Impossible !"
                                                              message:@"Blocks time cannot inferior to the flight time"
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                       style:UIAlertActionStyleCancel
                                                       handler:nil];
                        [alertController addAction:cancelAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                    }
                    
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
            if(paveDisplay2003.text.length==4){
                paveDisplay2003.text = [@"0" stringByAppendingString:paveDisplay2003.text];
                
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
                    
                    NSTimeInterval jour = [leg[@"BetweenBlocksTime"] timeIntervalSinceDate: NT];
                    
                    
                    if(jour >= 0){
                        leg[@"NightTime"] = NT;
                        NSCalendar *cal= [NSCalendar currentCalendar];
                        NSTimeZone *zeroZ = [NSTimeZone timeZoneWithName:@"GMT"];
                        NSDate *dateNulle = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
                        
                        NSCalendarUnit calendrier = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
                        [cal setTimeZone: zeroZ];
                        NSDateComponents *difference = [cal components:calendrier fromDate:leg[@"NightTime"] toDate:leg[@"BetweenBlocksTime"] options:0];
                        
                        NSDate *DayTime =[cal dateByAddingComponents:difference toDate:dateNulle options:0];
                        
                        leg[@"DayTime"]=DayTime;
                        
                        PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2004"];
                        [self.navigationController pushViewController:pushVC animated:YES];
                    }
                    else{
                        paveDisplay2003.backgroundColor = [UIColor redColor];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"! Impossible !"
                                                              message:@"Night time cannot be greater than total block time"
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                       style:UIAlertActionStyleCancel
                                                       handler:nil];
                        [alertController addAction:cancelAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    NSLog(@"%@",leg[@"NightTime"]);
                    
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
            if(paveDisplay2004.text.length==4){
                paveDisplay2004.text = [@"0" stringByAppendingString:paveDisplay2004.text];
                
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
                    
                    NSTimeInterval diff = [NT timeIntervalSinceDate:leg[@"BetweenBlocksTime"]];
                        
                    if(diff <= 0){
                        leg[@"LowLevelFlight"] = NT;
                        
                        
                        ChoixCoefViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"ChoixCoef"];
                        [self.navigationController pushViewController:pushVC animated:YES];
                    }
                        
                    else{
                        paveDisplay2004.backgroundColor = [UIColor redColor];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"! Impossible !"
                                                              message:@"Low level flight time cannot be greater than total block time"
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                       style:UIAlertActionStyleCancel
                                                       handler:nil];
                        [alertController addAction:cancelAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                        
                        
                    
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
                
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6006"];
                [self.navigationController pushViewController:pushVC animated:YES];
                
                
                
            }
            else{
                paveDisplay2007.backgroundColor = [UIColor redColor];
                
            }
            break;
        
        
        case 2011:
            
            paveDisplay2011.backgroundColor = [UIColor whiteColor];
            if(paveDisplay2011.text.length==4){
                paveDisplay2011.text = [@"0" stringByAppendingString:paveDisplay2011.text];
                
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
                    
                    
                    
                    
                    NSTimeInterval diff = [OBT timeIntervalSinceDate:leg[@"DayTime"]];
                    
                    if(diff <= 0){
                        
                        leg[@"Day10"] = OBT;
                        
                        
                        if([leg[@"NightTime"] timeIntervalSinceDate:dateNulle] == 0.0){
                            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2005"];
                            [self.navigationController pushViewController:pushVC animated:YES];
                        
                        }
                        
                        else{
                            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2012"];
                            [self.navigationController pushViewController:pushVC animated:YES];
                        }
                    }
                    
                    else{
                        paveDisplay2011.backgroundColor = [UIColor redColor];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"! Impossible !"
                                                              message:@"coef 10 day time cannot be greater than total day time"
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                       style:UIAlertActionStyleCancel
                                                       handler:nil];
                        [alertController addAction:cancelAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    

                    
                    
                    
                    
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
                paveDisplay2012.text = [@"0" stringByAppendingString:paveDisplay2012.text];
                
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
                    
                    
                    NSLog(@"%@",leg[@"NightTime"]);
                    
                    
                    NSTimeInterval diff = [OBT timeIntervalSinceDate:leg[@"NightTime"]];
                    
                    NSLog(@"%f",diff);
                    
                    if(diff <= 0){
                        leg[@"Night10"] = OBT;
                        
                        
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
                                
                                leg[@"Day35"]= dateNulle;
                                leg[@"Night35"]= dateNulle;
                                leg[@"Day22"]= dateNulle;
                                leg[@"Night22"]= dateNulle;
                                
                                break;}
                                
                            case 3:
                                leg[@"Day35"]= dayCompl;
                                leg[@"Night35"]= nightCompl;
                                
                                leg[@"Day22"]= dateNulle;
                                leg[@"Night22"]= dateNulle;
                                leg[@"Day62"]= dateNulle;
                                leg[@"Night62"]= dateNulle;
                                break;
                                
                            case 4:
                                leg[@"Day22"]= dayCompl;
                                leg[@"Night22"]= nightCompl;
                                
                                leg[@"Day35"]= dateNulle;
                                leg[@"Night35"]= dateNulle;
                                leg[@"Day62"]= dateNulle;
                                leg[@"Night62"]= dateNulle;
                                break;
                                
                            default:
                                break;
                        }
                        
                        
                        
                        PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2005"];
                        [self.navigationController pushViewController:pushVC animated:YES];
                        
                        
                    }
                    
                    else{
                        paveDisplay2012.backgroundColor = [UIColor redColor];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"! Impossible !"
                                                              message:@"coef 10 night time cannot be greater than total night time"
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                       style:UIAlertActionStyleCancel
                                                       handler:nil];
                        [alertController addAction:cancelAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                    
                    
                    
                    
                    
                    
                    

                    
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
                paveDisplay2021.text = [@"0" stringByAppendingString:paveDisplay2021.text];
                
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
                    
                    
                    NSTimeInterval diff = [OBT timeIntervalSinceDate:leg[@"DayTime"]];
                    
                    if(diff <= 0){
                        
                        
                        leg[@"Day62"] = OBT;
                        
                        if([leg[@"NightTime"] timeIntervalSinceDate:dateNulle] == 0.0){
                            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2005"];
                            [self.navigationController pushViewController:pushVC animated:YES];
                            
                        }
                        
                        else{
                            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2022"];
                            [self.navigationController pushViewController:pushVC animated:YES];
                        }
                    }
                    
                    else{
                        paveDisplay2021.backgroundColor = [UIColor redColor];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"! Impossible !"
                                                              message:@"coef 62 day time cannot be greater than total day time"
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                       style:UIAlertActionStyleCancel
                                                       handler:nil];
                        [alertController addAction:cancelAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
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
                paveDisplay2022.text = [@"0" stringByAppendingString:paveDisplay2022.text];
                
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
                    
                    
                    NSTimeInterval diff = [OBT timeIntervalSinceDate:leg[@"NightTime"]];
                    
                    if(diff <= 0){
                        
                        
                        leg[@"Night62"] = OBT;
                        
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
                                
                                leg[@"Day10"]= dateNulle;
                                leg[@"Night10"]= dateNulle;
                                leg[@"Day22"]= dateNulle;
                                leg[@"Night22"]= dateNulle;
                                
                                break;
                                
                            case 4:
                                leg[@"Day22"]= dayCompl;
                                leg[@"Night22"]= nightCompl;
                                
                                leg[@"Day10"]= dateNulle;
                                leg[@"Night10"]= dateNulle;
                                leg[@"Day35"]= dateNulle;
                                leg[@"Night35"]= dateNulle;

                                break;
                                
                            default:
                                break;
                        }
                        
                        PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2005"];
                        [self.navigationController pushViewController:pushVC animated:YES];
                    }
                    
                    else{
                        paveDisplay2022.backgroundColor = [UIColor redColor];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"! Impossible !"
                                                              message:@"coef 62 night time cannot be greater than total night time"
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                       style:UIAlertActionStyleCancel
                                                       handler:nil];
                        [alertController addAction:cancelAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }

                    
                    
                    
                    
                    
                    
                    
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
                paveDisplay2031.text = [@"0" stringByAppendingString:paveDisplay2031.text];
                
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
                    
                    
                    
                    NSTimeInterval diff = [OBT timeIntervalSinceDate:leg[@"DayTime"]];
                    
                    if(diff <= 0){
                        
                        leg[@"Day35"] = OBT;
                        
                        if([leg[@"NightTime"] timeIntervalSinceDate:dateNulle] == 0.0){
                            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2005"];
                            [self.navigationController pushViewController:pushVC animated:YES];
                            
                        }
                        
                        else{
                            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2032"];
                            [self.navigationController pushViewController:pushVC animated:YES];
                        }
                    }
                    
                    else{
                        paveDisplay2031.backgroundColor = [UIColor redColor];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"! Impossible !"
                                                              message:@"coef 35 day time cannot be greater than total day time"
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                       style:UIAlertActionStyleCancel
                                                       handler:nil];
                        [alertController addAction:cancelAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }

                    
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
                paveDisplay2032.text = [@"0" stringByAppendingString:paveDisplay2032.text];
                
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
                    
                    
                    NSTimeInterval diff = [OBT timeIntervalSinceDate:leg[@"DayTime"]];
                    
                    if(diff <= 0){
                        
                        
                        leg[@"Night35"] = OBT;
                        
                        
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
                        
                        leg[@"Day10"]= dateNulle;
                        leg[@"Night10"]= dateNulle;
                        leg[@"Day62"]= dateNulle;
                        leg[@"Night62"]= dateNulle;
                        
                        
                        PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"2005"];
                        [self.navigationController pushViewController:pushVC animated:YES];
                        
                        
                    }
                    
                    else{
                        paveDisplay2032.backgroundColor = [UIColor redColor];
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"! Impossible !"
                                                              message:@"coef 35 night time cannot be greater than total night time"
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction
                                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                                       style:UIAlertActionStyleCancel
                                                       handler:nil];
                        [alertController addAction:cancelAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    

                    
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
            
            

            
            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6002"];
            [self.navigationController pushViewController:pushVC animated:YES];
            break;
            }
        
        case 6002:{
            
            
            leg[@"N°BM19"]=paveDisplay6002.text;
            
            if(mission.activeLegIndex==0){
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6003"];
                [self.navigationController pushViewController:pushVC animated:YES];}
            
            else{
                leg[@"Indicators"][@"Departure"][1]=@"1";
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                }
            
            
            
            break;
        }
        case 6003:{
            
            if(paveDisplay6003.text.length!=0){
                leg[@"FuelAtTakeOff"]=paveDisplay6003.text;
                
                if(mission.activeLegIndex == 0){
                    leg[@"GroundInit"]=paveDisplay6003.text;
                }

                leg[@"Indicators"][@"Departure"][1]=@"1";
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            else{
            
                paveDisplay6003.backgroundColor = [UIColor redColor];
            
            }
            
            break;
        }
            
        case 6004:{
            leg[@"FuelDelivered"]=paveDisplay6004.text;
          
            
            leg[@"FuelBurned"] = @([leg[@"GroundInit"] integerValue] + [leg[@"FuelAdded"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
            
                        
            PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6005"];
            [self.navigationController pushViewController:pushVC animated:YES];
            
            
            break;
        }
        case 6005:{
            leg[@"FuelReceived"]=paveDisplay6005.text;
            
            
            
            leg[@"FuelBurned"] = @([leg[@"GroundInit"] integerValue] + [leg[@"FuelAdded"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
            leg[@"Indicators"][@"Arrival"][1]=@"1";
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
            
        case 6006:{
            
            if(paveDisplay6006.text.length !=0){
                
                NSInteger finalFuel = [paveDisplay6006.text integerValue];
                
                
                               
                NSInteger fuelBurned = [leg[@"GroundInit"] integerValue] + [leg[@"FuelAdded"] integerValue] - finalFuel - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ;

                
                if(fuelBurned>=0){
                    if(mission.activeLegIndex<mission.legs.count -1){
                        mission.legs[mission.activeLegIndex +1][@"GroundInit"]=paveDisplay6006.text;
                    }
                    leg[@"FinalFuel"]=paveDisplay6006.text;
                    leg[@"FuelBurned"] = @([leg[@"GroundInit"] integerValue] + [leg[@"FuelAdded"] integerValue] - [leg[@"FinalFuel"] integerValue] - [leg[@"FuelDelivered"] integerValue] + [leg[@"FuelReceived"] integerValue] ).description;
                    
                    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"useDeliveredAndReceived"]){
                        leg[@"Indicators"][@"Arrival"][1]=@"1";
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }
                    else{
                        PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"6004"];
                        [self.navigationController pushViewController:pushVC animated:YES];
                    }
                    
                    
                    
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
                currentCargo.nombrePax = [paveDisplay4002.text integerValue];
                PaveNumViewController *pushVC = [self.storyboard instantiateViewControllerWithIdentifier: @"4004"];
                [self.navigationController pushViewController:pushVC animated:YES];
                NSLog(@"nombre pax 4002= %f",currentCargo.nombrePax);
            
            }
            else{
                paveDisplay4002.backgroundColor = [UIColor redColor];
            }
            
            break;
            
        case 4003:
            if(paveDisplay4003.text.length){
                
                currentCargo.weight= paveDisplay4003.text;
                
                [currentCargo initSetOfLegs];
                
                for (NSInteger index = 0; index< mission.legs.count;index++){
                    mission.legs[index][@"Be"]=@"";
                    mission.legs[index][@"Be"]=[Cargo principalBe:index inMission: mission];
                    }
                [Cargo reloadBenefListWithMission : mission];


                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                
            }
            else{
                paveDisplay4003.backgroundColor = [UIColor redColor];
            }
            
            break;
            
        case 4004:
            if(paveDisplay4004.text.length){
                
                //on demande le poid total, on calcule le poid par pax et on remet le bon poid dans currentCargo.weight
                
                currentCargo.weight = paveDisplay4004.text;
                currentCargo.paxWeight = (float) [currentCargo.weight integerValue] / ((float)currentCargo.nombrePax);
                NSLog(@"%f",currentCargo.paxWeight);

                
                [currentCargo initSetOfLegs];
                
                [Cargo reloadBenefListWithMission : mission];
                
                for (NSInteger index = 0; index< mission.legs.count;index++){
                    mission.legs[index][@"Be"]=@"";
                    mission.legs[index][@"Be"]=[Cargo principalBe:index inMission: mission];}
            
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];

                
            }
            
        default:
            break;
    }

    
    
}
@end

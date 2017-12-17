//
//  ViewController.m
//  Tableau_secops
//
//  Created by Arnaud Gallant on 19/02/2014.
//
/*
 Ce ViewController permet d'afficher une page html et d'enregistrer son contenu au format pdf afin de l'envoyer par email.
 Pour cela on utilise un fichier html modèle, la mise en page étant géré par une feuille css.
 Le choix de l'ajout du contenu fut d'utiliser du javascript, on aurait pu aussi prendre un parseur html.
 */


#import <JavaScriptCore/JavaScriptCore.h>

#import "OMAGenerator.h"
#import "NDHTMLtoPDF.h"

#import "Mission.h"
#import "TimeTools.h"
#import "AirportsData.h"


#define fPaperSizeA4 CGSizeMake(841.8, 595.2)

@interface OMAGenerator (){
    
    UIWebView *myWebView;
    Mission *mission;
    NSArray *legs, *crewMembers;
    NSMutableDictionary *secops, *personnel, *derog;
    NSMutableArray *pilotes;

}
@end

@implementation OMAGenerator

static NSArray *crewColors;


- (id)initWithMission:(Mission *)m
{
    self = [self init];
    
    if (!crewColors)
        crewColors = @[[UIColor colorWithRed:0./255. green:64./255. blue:128./255. alpha:1.],
                       [UIColor colorWithRed:0./255. green:128./255. blue:64./255. alpha:1.],
                       [UIColor colorWithRed:64./255. green:0./255. blue:128./255. alpha:1.],
                       [UIColor colorWithRed:64./255. green:128./255. blue:0./255. alpha:1.],
                       [UIColor colorWithRed:128./255. green:0./255. blue:64./255. alpha:1.],
                       [UIColor colorWithRed:128./255. green:64./255. blue:0./255. alpha:1.]];
    
    mission = m;
    legs = mission.legs;
    crewMembers = [mission loadCrewMembers];
    secops = mission.root[@"SECOPS"];
    personnel = secops[@"Personnel"];
    derog = mission.root[@"Derog"];
    
    myWebView = [[UIWebView alloc] init];
    myWebView.delegate = self;
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"tableau" withExtension:@"html"]]];
    
    return self;
}


- (void)printPDF
{
    NSString *html = [myWebView stringByEvaluatingJavaScriptFromString:
                      @"document.documentElement.innerHTML"];
    self.PDFCreator = [NDHTMLtoPDF createPDFWithHTML:html baseURL:[[NSBundle mainBundle] resourceURL] pathForPDF:[@"~/Documents/OMA.pdf" stringByExpandingTildeInPath] pageSize:fPaperSizeA4 margins:UIEdgeInsetsMake(10, 5, 10, 5) successBlock:^(NDHTMLtoPDF *htmlToPDF) {
        
        NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath];
        
        NSLog(@"%@",result);
        
        [self.delegate omaPdfDidFinishLoading:htmlToPDF.PDFpath];
        
    } errorBlock:^(NDHTMLtoPDF *htmlToPDF) {
        NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
        NSLog(@"%@",result);
    }];
}


- (NSString *)hexStringForColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadWithData:webView];
    [self printPDF];
}


-(void)loadWithData:(UIWebView *)webView
{
    //SecopsViewController *secopsVC = (SecopsViewController*)((UINavigationController*)self.presentingViewController).topViewController;
    
    NSMutableString *refEnt = [@"var y = new Array(" mutableCopy], *ligneCrew = [@"var x = new Array(" mutableCopy], *dest = [@"var y = new Array(" mutableCopy], *exploit = [@"var z = new Array(" mutableCopy];
    NSUInteger numLeg = 0;
    NSTimeInterval totalJour = 0., totalNuit = 0.;
    NSTimeInterval totalJour35 = 0., totalJour22 = 0., totalJour10 = 0., totalJour62 = 0., totalNuit35 = 0., totalNuit22 = 0., totalNuit10 = 0., totalNuit62 = 0.;
    //Création du contexte javascript (js) pour pourvoir évaluer les commamndes js
    //Les fonctions js sont définies dans oma.js
    //Ajout du numéro de mission et des numéros de leg
    
    //int h;
    //NSString *com;
    //for (h=0; h<legs.count; h++) {
       // com = [[legs[h][@"Comments"] stringByAppendingString:@"\n"] mutableCopy];
       // }
    
    
    //NSMutableString *com = [NSMutableString stringWithFormat:@"'%@'",legs[0][@"Comments"]];
    
        JSContext *moncontext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *numMission = [NSString stringWithFormat:@"'%@'", mission.root[@"MissionNumber"]], *unit = [NSString stringWithFormat:@"'%@'",mission.root[@"Unit"]], *cdb = [NSString stringWithFormat:@"%@", [mission cdbForLeg:0]], *function = [NSString stringWithFormat:@"addMissionNumber(%@); addGridOneLegs('%d'); addUnit(%@); addCDB('%@')", numMission,(int)[legs count], unit, cdb];
    [moncontext evaluateScript:function];
    
    int h;
    int m=1;
    for (h=0; h<legs.count; h++) {
        if (![legs[h][@"Comments"] isEqual:@""]) {
        NSMutableString *com = [NSMutableString stringWithFormat:@"%@ ; ", legs[h][@"Comments"]];
        NSString *comments = [NSString stringWithFormat:@"addComments('%@', '%d')", com, m];
            [moncontext evaluateScript: comments];
            m++;
        }
        //[com appendString:[NSString stringWithFormat: @"'%@'",legs[h][@"Comments"]]];
    }
    
    //Remplissage Tableau Exploitation
    
    int i=1;
    for(NSString *key in @[@"MEAT",@"SICOPS",@"RefEnt",@"ActPN", @"XLS", @"ATT", @"RegistreAC"]){
        [exploit appendFormat:@"%@'%@'", ((i == 1) ? @"" : @", "), mission.root[key]];
        
        i++;
    }
    [exploit appendFormat:@"); addLineExploitation(z);"];
    [moncontext evaluateScript:exploit];
    
    //Ajout du tableau des membres déquipages : GridOne
    pilotes = [NSMutableArray array];
    
    for(NSDictionary *crewMember in crewMembers)
    {
        
        for(NSInteger  i = -1; i < (NSInteger)[legs count]; i++){
            if(i == -1){
                [ligneCrew appendFormat:@"'%@'", [crewMember[@"Name"] stringByReplacingOccurrencesOfString:@"'" withString:@" "]];
            }
            else{
                NSString *str = crewMember[@"Presence"][@(i).description];
                
                [ligneCrew appendFormat:@", '%@'", (str) ? str : @" "];
            }
        }
        [ligneCrew appendFormat:@"); addLineGridOne(x,'%@');", [self hexStringForColor:[self textColorForCrewMember:crewMember]]];
        [moncontext evaluateScript:ligneCrew];
        ligneCrew = [@"var x = new Array(" mutableCopy];
        
        //sélectionne les membres d'équipage dont la fonction est PCB, Pcb ou PIL et les met dans un MutableArray nommé pilotes
        if ([crewMember[@"Function"] rangeOfString:@"Pcb" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [pilotes addObject: crewMember];
        }
        if ([crewMember[@"Function"] rangeOfString:@"PIL" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [pilotes addObject: crewMember];
        }
    }
    
    
    // Remplissage refEnt avec les noms des pilotes
   int k=1;
    for(NSDictionary *pilote in pilotes)
    {
        [refEnt appendFormat:@"'%@'", pilote[@"Name"]];
        int q;
        for(q=1; q<=42; q++) {
            NSString *str = @"RE";
            NSString *ent = [NSString stringWithFormat:@"%i", q];
            str = [str stringByAppendingString: ent];
            
            if ([pilote[@"Entrainement"] containsObject: str])
            {
                [refEnt appendFormat:@", 'X'"];
            }
            else [refEnt appendFormat:@", ' '"];
        }
        [refEnt appendFormat:@"); addRefEntHeader(y);"];
        [moncontext evaluateScript:refEnt];
        NSLog(@"%@", refEnt);
        NSLog(@"pilotes = %@", pilotes);
        
        if (k < pilotes.count) {
            refEnt = [@"var y = new Array(" mutableCopy];
        }
        
        k++;
    }
    // tableau principal
    
    numLeg = 1;
    for(NSDictionary *leg in legs){
        
        NSString *airport = leg[@"DepartureAirport"];
        
        //Ajout des destinations dans GridOne, le code js est exécuté après la boucle for
        if(numLeg==[legs count]) {
            NSString *arrAirport = leg[@"ArrivalAirport"];
            
            [dest appendFormat:@"'%@', '%@'); addGridOneHead(y);",
             [NSString stringWithFormat:@"%@<BR>%@", airport, [AirportsData iataForOaci:airport]], [NSString stringWithFormat:@"%@<BR>%@", arrAirport, [AirportsData iataForOaci:arrAirport]]];
        }
        else
            [dest appendFormat:@"'%@',", [NSString stringWithFormat:@"%@<BR>%@", airport, [AirportsData iataForOaci:airport]]];
        
        
        //Création de la première ligne du tableau récapitulatif du leg n°numLeg
        //N°
        [ligneCrew appendFormat:@"'%d'", (int)numLeg];
        //Avion
        if(mission.root[@"OriginalAircraft"])
            [ligneCrew appendFormat:@",'%@'", mission.root[@"OriginalAircraft"]];
        else
            [ligneCrew appendString:@",' '"];
        //Callsign
        if(leg[@"OriginalCallSign"])
            [ligneCrew appendFormat:@",'%@'", leg[@"OriginalCallSign"]];
        else
            [ligneCrew appendString:@",' '"];
        //Be
        if(leg[@"OriginalBe"])
            [ligneCrew appendFormat:@",'%@'", leg[@"OriginalBe"]];
        else
            [ligneCrew appendString:@",' '"];
        //Na
        if(leg[@"OriginalNa"])
            [ligneCrew appendFormat:@",'%@'", leg[@"OriginalNa"]];
        else
            [ligneCrew appendString:@",' '"];
        //ETD
        [ligneCrew appendFormat:@",'%@'", [TimeTools stringFromFullDate:leg[@"ETD"]]];
        //DepartureAirport
        [ligneCrew appendFormat:@",'%@'", leg[@"DepartureAirport"]];
        //ETA
        [ligneCrew appendFormat:@",'%@'", [TimeTools stringFromFullDate:leg[@"ETA"]]];
        //ArrivalAirport
        [ligneCrew appendFormat:@",'%@'", leg[@"ArrivalAirport"]];
        //Day35
        [ligneCrew appendFormat:@",'<span class=\"blueSpan\">35</span> <br/> %@'", [OMAGenerator omaStringFromTime:leg[@"Day35"]]];
        //Day22
        [ligneCrew appendFormat:@",'<span class=\"blueSpan\">22</span> <br/> %@'", [OMAGenerator omaStringFromTime:leg[@"Day22"]]];
        //Night35
        [ligneCrew appendFormat:@",'<span class=\"blueSpan\">35</span> <br/> %@'", [OMAGenerator omaStringFromTime:leg[@"Night35"]]];
        //Night22
        [ligneCrew appendFormat:@",'<span class=\"blueSpan\">22</span> <br/> %@'", [OMAGenerator omaStringFromTime:leg[@"Night22"]]];
        //Incl LLF
        [ligneCrew appendFormat:@",'%@'", [OMAGenerator omaStringFromTime:leg[@"LowLevelFlight"]]];
        
        //Total des heures Aircraft
        [ligneCrew appendFormat:@",'%@'", [TimeTools stringFromTime:leg[@"FlightTime"] withDays:YES]];
        
        //T/G
        [ligneCrew appendFormat:@",'%@'", leg[@"TouchAndGo"]];
        
        //Landings
        [ligneCrew appendFormat:@",'%@'", leg[@"Landings"]];
        
        //Flight rules
        [ligneCrew appendFormat:@",'%@'", leg[@"FlightRules"]];
        //titre "PAX"
        [ligneCrew appendString:@",'PAX'" ];
        
        //totalPaxIn (=Loading)
        [ligneCrew appendFormat:@",'%@'", [leg[@"PaxCargo"] lastObject][@"PaxIn"]];
        
        //totalPaxOnBoard (pax qui étaient déjà à bord)
        [ligneCrew appendFormat:@",'%@'", [leg[@"PaxCargo"] lastObject][@"PaxOnBoard"]];
        
        //totalPaxDropped
        [ligneCrew appendFormat:@",'%@'", [leg[@"PaxCargo"] lastObject][@"PaxDropped"]];
        
        //totalPaxOut
        [ligneCrew appendFormat:@",'%@'", [leg[@"PaxCargo"] lastObject][@"PaxOut"]];
        
        //FuelIn BM19
        [ligneCrew appendFormat:@",'%@'", leg[@"FuelAdded"]];
        
        //FuelReceived
        [ligneCrew appendFormat:@",'%@'", leg[@"FuelReceived"]];
        
        
        //FuelDelivered
        [ligneCrew appendFormat:@",'%@'", leg[@"FuelDelivered"]];
        
        //N°BM 190
        [ligneCrew appendFormat:@",'%@'", leg[@"N°BM19"]];
        
        //Percentage of payload
        [ligneCrew appendFormat:@",'%@'", leg[@"Payload"]];
        
        [ligneCrew appendString:@"); addLine1GridTwo(x);"];
        //NSLog(@"%@", ligneCrew); //pour debugging
        [moncontext evaluateScript:ligneCrew];
        ligneCrew = [@"var x = new Array(" mutableCopy];
        
        //Création de la deuxième ligne
        //[[leg[@"PaxCargo"] lastObject][@"CargoOnBoard"],[[leg[@"PaxCargo"] lastObject][@"CargoOut"],
        //New Aircraft
        if(![mission.root[@"Aircraft"] isEqualToString:mission.root[@"OriginalAircraft"]])
            [ligneCrew appendFormat:@"'%@'", mission.root[@"Aircraft"]];
        else
            [ligneCrew appendString:@"' '"];
        //New CallSign
        if(![leg[@"CallSign"] isEqualToString:leg[@"OriginalCallSign"]])
            [ligneCrew appendFormat:@",'%@'", leg[@"CallSign"]];
        else
            [ligneCrew appendString:@",' '"];
        //New Be
        if(![leg[@"Be"] isEqualToString:leg[@"OriginalBe"]])
            [ligneCrew appendFormat:@",'%@'", leg[@"Be"]];
        else
            [ligneCrew appendString:@",' '"];
        //New Na
        if(![leg[@"Na"] isEqualToString:leg[@"OriginalNa"]])
            [ligneCrew appendFormat:@",'%@'", leg[@"Na"]];
        else
            [ligneCrew appendString:@",' '"];
        //OffBlocksTime with Take off time
        [ligneCrew appendFormat:@",'%@ <br/> <span class=\"brownSpan\">%@</span> | <span class=\"blueSpan\">%@</span>'", [TimeTools stringFromDate:leg[@"OffBlocksTime"]], [TimeTools stringFromTime:leg[@"OffBlocksTime"] withDays:NO], [TimeTools stringFromTime:leg[@"TakeOffTime"] withDays:NO]];
        //OnBlocksTime with Landing time
        [ligneCrew appendFormat:@",'%@ <br/> <span class=\"blueSpan\">%@</span> <span class=\"brownSpan\">%@</span>'", [TimeTools stringFromDate:leg[@"OnBlocksTime"]], [TimeTools stringFromTime:leg[@"LandingTime"] withDays:NO], [TimeTools stringFromTime:leg[@"OnBlocksTime"] withDays:NO]];
        //Day10
        [ligneCrew appendFormat:@",'<span class=\"blueSpan\">10</span> <br/> %@'", [OMAGenerator omaStringFromTime:leg[@"Day10"]]];
        //Day62
        [ligneCrew appendFormat:@",'<span class=\"blueSpan\">62</span> <br/> %@'", [OMAGenerator omaStringFromTime:leg[@"Day62"]]];
        //Night10
        [ligneCrew appendFormat:@",'<span class=\"blueSpan\">10</span> <br/> %@'", [OMAGenerator omaStringFromTime:leg[@"Night10"]]];
        //Night62
        [ligneCrew appendFormat:@",'<span class=\"blueSpan\">62</span> <br/> %@'", [OMAGenerator omaStringFromTime:leg[@"Night62"]]];
        
        //Total des heures Crew
        [ligneCrew appendFormat:@",'%@'", [OMAGenerator omaStringFromTime:leg[@"BetweenBlocksTime"]]];
        
        //GoAround
        [ligneCrew appendFormat:@",'%@'", leg[@"GoAround"] ];
        //Type of Flight
        [ligneCrew appendFormat:@",'%@'", leg[@"TypeOfFlight"] ];
        
        //titre "FREIGHT"
        [ligneCrew appendString:@",'Freight'"];
        //totalCargoIn
        [ligneCrew appendFormat:@",'%@'",
         [leg[@"PaxCargo"] lastObject][@"CargoIn"]];
        //totalCargoOnBoard
        [ligneCrew appendFormat:@",'%@'",
         [leg[@"PaxCargo"] lastObject][@"CargoOnBoard"]];
        //totalCargoDropped
        [ligneCrew appendFormat:@",'%@'", [leg[@"PaxCargo"] lastObject][@"CargoDropped"]];
        //totalCargoOut
        [ligneCrew appendFormat:@",'%@'",
         [leg[@"PaxCargo"] lastObject][@"CargoOut"]];
        
        
        //FuelBeforeFlight
        [ligneCrew appendFormat:@",'%@'", leg[@"GroundInit"]];
        //Fuel Burned
        [ligneCrew appendFormat:@",'%i'", [leg[@"FuelAtTakeOff"] intValue] - [leg[@"FinalFuel"] intValue]];
        //After Flight Fuel on Board
        [ligneCrew appendFormat:@",'%@'", leg[@"FinalFuel"]];

        
        [ligneCrew appendString:@"); addLine2GridTwo(x);"];
        
        //        NSLog(@"%@", ligneCrew);
        [moncontext evaluateScript:ligneCrew];
        ligneCrew = [@"var x = new Array(" mutableCopy];
        
        
        
        BOOL jour = YES;
        for (NSString *day in @[@"Day", @"Night"]) {
            for (NSString *coeff in @[@"10", @"22", @"35", @"62"]) {
                NSString *key = [day stringByAppendingString:coeff];
                
                if (jour) {
                totalJour += [leg[key] timeIntervalSinceReferenceDate];
                                }
                else {
                    totalNuit += [leg[key] timeIntervalSinceReferenceDate];
                                   }
                
            }
            
            jour = NO;
        }
        
        
        
        BOOL dayt = YES;
                        if (dayt) {
                    totalJour35 +=[leg[@"Day35"] timeIntervalSinceReferenceDate];
                    totalJour22 +=[leg[@"Day22"] timeIntervalSinceReferenceDate];
                    totalJour10 +=[leg[@"Day10"] timeIntervalSinceReferenceDate];
                    totalJour62 +=[leg[@"Day62"] timeIntervalSinceReferenceDate];
                    totalNuit35 +=[leg[@"Night35"] timeIntervalSinceReferenceDate];
                                    }
                else {
                    totalNuit35 +=[leg[@"Night35"] timeIntervalSinceReferenceDate];
                    totalNuit22 +=[leg[@"Night22"] timeIntervalSinceReferenceDate];
                    totalNuit10 +=[leg[@"Night10"] timeIntervalSinceReferenceDate];
                    totalNuit62 +=[leg[@"Night62"] timeIntervalSinceReferenceDate];
                }
            
            dayt = NO;
    
        numLeg++;
    }
    
    
    
    NSDate *totDay = [NSDate dateWithTimeIntervalSinceReferenceDate:totalJour], *totNight = [NSDate dateWithTimeIntervalSinceReferenceDate:totalNuit];
    
    NSDate *totDay35 = [NSDate dateWithTimeIntervalSinceReferenceDate:totalJour35],
    *totDay22 = [NSDate dateWithTimeIntervalSinceReferenceDate:totalJour22],
    *totDay10 = [NSDate dateWithTimeIntervalSinceReferenceDate:totalJour10],
    *totDay62 = [NSDate dateWithTimeIntervalSinceReferenceDate:totalJour62],
    *totNight35 = [NSDate dateWithTimeIntervalSinceReferenceDate:totalNuit35],
    *totNight22 = [NSDate dateWithTimeIntervalSinceReferenceDate:totalNuit22],
    *totNight10 = [NSDate dateWithTimeIntervalSinceReferenceDate:totalNuit10],
    *totNight62 = [NSDate dateWithTimeIntervalSinceReferenceDate:totalNuit62];
    
    [moncontext evaluateScript:[NSString stringWithFormat:@"var x = new Array('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@'); addTotalHours(x);",
                                [TimeTools stringFromTime:totDay35 withDays:YES],
                                [TimeTools stringFromTime:totDay22 withDays:YES],
                                [TimeTools stringFromTime:totDay10 withDays:YES],
                                [TimeTools stringFromTime:totDay62 withDays:YES],
                                [TimeTools stringFromTime:totNight35 withDays:YES],
                                [TimeTools stringFromTime:totNight22 withDays:YES],
                                [TimeTools stringFromTime:totNight10 withDays:YES],
                                [TimeTools stringFromTime:totNight62 withDays:YES]]];
    [moncontext evaluateScript:dest];
    
    
    //réutilisation de ligneCrew pour les dérogations; comprendre "ligneDerog"
    if(derog.count != 0){
        [moncontext evaluateScript:@"addGridThree();"];
        
        [moncontext evaluateScript:@"addHeaderGridThree();"];
        
        for(NSDictionary *dic in derog)
            [moncontext evaluateScript:[NSString stringWithFormat:@"var x = new Array('%@','%@','%@','%@'); addLineGridThree(x);", dic[@"Nature"], dic[@"Commentaires"], dic[@"Numero"], dic[@"Ordonnateur"]]];
    }
}

- (UIColor*)textColorForCrewMember:(NSDictionary*)crewMember
{
    NSUInteger min = mission.legs.count;
    NSInteger temp;
    
    for (NSString *key in crewMember[@"Presence"]) {
        temp = key.integerValue;
        
        if (temp < min)
            min = temp;
    }
    
    return crewColors[min % 6];
}


+ (NSString*)omaStringFromTime:(NSDate*)time
{
    if ([time timeIntervalSinceReferenceDate] == 0.)
        return @" ";
    else
        return [TimeTools stringFromTime:time withDays:YES];
}


@end

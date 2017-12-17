//
//  AirportsData.m
//  Esterel-Alpha
//
//  Created by utilisateur on 20/12/2013.
//
//

#import "AirportsData.h"

#import "XMLDictionary.h"

#import "Mission.h"

@interface AirportsData ()

@property (strong, nonatomic) NSArray *airports, *iataListe, *oaciListe, *nameListe;

@end


@implementation AirportsData

static dispatch_once_t once;
static AirportsData *sharedInstance;

+ (AirportsData *)sharedInstance
{
    dispatch_once(&once, ^{
        
        sharedInstance = [[AirportsData alloc] init];
    });
    return sharedInstance;
}

+ (void)reset
{
    if (sharedInstance)
        sharedInstance = [[AirportsData alloc] init];
    else
        [AirportsData sharedInstance];
}


+ (NSArray *)iataListe
{
    return [[AirportsData sharedInstance].iataListe deepCopy];
}

+ (NSArray *)oaciListe
{
    return [[AirportsData sharedInstance].oaciListe deepCopy];
}

+ (NSArray *)nameListe
{
    return [[AirportsData sharedInstance].nameListe deepCopy];
}

+ (NSString*)iataForOaci:(NSString*)oaci
{
    NSUInteger index = 0;
    
    for (NSString *elt in [AirportsData sharedInstance].oaciListe) {
        if ([elt isEqualToString:oaci])
            return [AirportsData sharedInstance].iataListe[index];
        
        index ++;
    }
    
    return @"";
}

+ (NSString*)nameForOaci:(NSString*)oaci
{
    NSUInteger index = 0;
    
    for (NSString *elt in [AirportsData sharedInstance].oaciListe) {
        if ([elt isEqualToString:oaci])
            return [AirportsData sharedInstance].nameListe[index];
        
        index ++;
    }
    
    return @"";
}


- (AirportsData *)init
{
    self = [super init];
    
    _airports = [AirportsData getData][@"Airport"];
    
    NSUInteger count = _airports.count, i = 0;
    id cIata[count], cOaci[count], cName[count];
    
    for (NSDictionary *airport in _airports) {
        
        cIata[i] = airport[@"IATA"];
        cOaci[i] = airport[@"OACI"];
        cName[i] = airport[@"Name"];
        
        if (!cIata[i])
            cIata[i] = @"";
        if (!cOaci[i])
            cOaci[i] = @"";
        if (!cName[i])
            cName[i] = @"";
        
        i++;
    }
    
    _iataListe = [NSArray arrayWithObjects:cIata count:count];
    _oaciListe = [NSArray arrayWithObjects:cOaci count:count];
    _nameListe = [NSArray arrayWithObjects:cName count:count];
    
    return self;
}


+ (NSDictionary*)getData
{
    NSString *path = [@"~/Documents/ListeAeroports.plist" stringByExpandingTildeInPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        path = [[NSBundle mainBundle] pathForResource:@"ListeAeroports" ofType:@"plist"];
    
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (void)updateDatabase:(NSString *)path
{
    NSDictionary *dico = [NSDictionary dictionaryWithXMLFile:path];
    
    [dico writeToFile:[@"~/Documents/ListeAeroports.plist" stringByExpandingTildeInPath] atomically:YES];
        
    [AirportsData reset];
    
    [[[UIAlertView alloc] initWithTitle:@"Mise à jour" message:@"La base de donnée des aéroports a été mise à jour." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    [[NSFileManager defaultManager] removeItemAtPath:[@"~/Documents/Inbox" stringByExpandingTildeInPath] error:nil];
}

@end

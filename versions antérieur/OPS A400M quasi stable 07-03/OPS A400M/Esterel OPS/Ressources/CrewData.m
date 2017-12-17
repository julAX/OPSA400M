//
//  CrewData.m
//  Esterel-Alpha
//
//  Created by utilisateur on 21/01/2014.
//
//

#import "CrewData.h"

#import "XMLDictionary.h"

#import "Mission.h"


@interface CrewData ()
    
@property (strong, nonatomic) NSArray *equipages, *nameListe, *gradeListe;

@end


@implementation CrewData


static dispatch_once_t once;
static CrewData *sharedInstance;

+ (CrewData *)sharedInstance
{
    dispatch_once(&once, ^{
        
        sharedInstance = [[CrewData alloc] init];
    });
    return sharedInstance;
}

+ (void)reset
{
    if (sharedInstance)
        sharedInstance = [[CrewData alloc] init];
    else
        [CrewData sharedInstance];
}


+ (NSArray *)nameListe
{
    return [[CrewData sharedInstance].nameListe deepCopy];
}

+ (NSArray *)gradeListe
{
    return [[CrewData sharedInstance].gradeListe deepCopy];
}


- (CrewData *)init
{
    self = [super init];
    
    _equipages = [CrewData getData][@"CrewMember"];
    
    NSUInteger count = _equipages.count, i = 0;
    id cGrade[count], cName[count];
    
    for (NSDictionary *crewMember in _equipages) {
        
        cName[i] = crewMember[@"Name"];
        cGrade[i] = crewMember[@"Grade"];
        
        if (!cName[i])
            cName[i] = @"";
        if (!cGrade[i])
            cGrade[i] = @"";
        
        i++;
    }
    
    _nameListe = [NSArray arrayWithObjects:cName count:count];
    _gradeListe = [NSArray arrayWithObjects:cGrade count:count];
    
    return self;
}

+ (NSDictionary*)getData
{
    NSString *path = [@"~/Documents/ListeEquipages.plist" stringByExpandingTildeInPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        path = [[NSBundle mainBundle] pathForResource:@"ListeEquipages" ofType:@"plist"];
    
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (void)updateDatabase:(NSString *)path
{
    NSDictionary *dico = [NSDictionary dictionaryWithXMLFile:path];
    
    [dico writeToFile:[@"~/Documents/ListeEquipages.plist" stringByExpandingTildeInPath] atomically:YES];
        
    [CrewData reset];

    [[[UIAlertView alloc] initWithTitle:@"Mise à jour" message:@"La base de donnée des équipages a été mise à jour." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

    [[NSFileManager defaultManager] removeItemAtPath:[@"~/Documents/Inbox" stringByExpandingTildeInPath] error:nil];
}


@end

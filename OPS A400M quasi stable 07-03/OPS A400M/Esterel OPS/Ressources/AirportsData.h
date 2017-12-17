//
//  AirportsData.h
//  Esterel-Alpha
//
//  Created by utilisateur on 20/12/2013.
//
//

#import <Foundation/Foundation.h>

@interface AirportsData : NSObject

+ (NSArray *)iataListe;
+ (NSArray *)oaciListe;
+ (NSArray *)nameListe;

+ (NSString*)iataForOaci:(NSString*)oaci;
+ (NSString*)nameForOaci:(NSString*)oaci;

+ (void)updateDatabase:(NSString*)path;

@end

//
//  Mission.h
//  Esterel-Alpha
//
//  Created by utilisateur on 13/12/13.
//
//

#import <Foundation/Foundation.h>



@protocol MissionDelegate <NSObject>
@optional
- (void)activeLegDidChange:(NSInteger)leg;

@end

@interface Mission : NSObject

@property (copy, nonatomic) NSString *path;

@property (readonly, nonatomic) NSMutableDictionary *root, *activeLeg;
@property (readonly, nonatomic) NSMutableArray *legs;
@property (nonatomic) NSInteger activeLegIndex;

//Ajout X15
@property (readwrite) id currentCargo;
@property NSMutableSet *Instances;
@property NSMutableDictionary * benefList;
//Fin Ajout X15

@property id<MissionDelegate> delegate;


- (Mission *)init;
- (Mission *)initWithFile:(NSString *)path;
- (void)save;

- (NSString*)route;
- (NSArray*)airportList;
- (NSString*)cdbForLeg:(NSInteger)l;
- (NSMutableArray*)loadCrewMembers;
+ (NSMutableDictionary*)crewMemberArray:(NSArray*)array contains:(NSString*)crewMemberName;


- (void)addLeg;
- (void)addPaxCargo;
- (void)deleteLegAtIndex:(NSInteger)index;
- (void)deletePaxCargoAtIndex:(NSInteger)index;


- (NSMutableDictionary*)getCrewMemberVierge;
- (NSMutableDictionary*)getMessageVierge;
- (NSMutableDictionary*)getMesVierge;



@end



// Deep Copying


@interface NSArray (Mission)

- (NSArray*) deepCopy;
- (NSMutableArray*) mutableDeepCopy;

@end

@interface NSDictionary (Mission)

- (NSDictionary*) deepCopy;
- (NSMutableDictionary*) mutableDeepCopy;

@end
//
//  TimeTools.h
//  Esterel-Alpha
//
//  Created by utilisateur on 13/02/2014.
//
//

#import <Foundation/Foundation.h>

@interface TimeTools : NSObject

+ (NSString *)stringFromTime:(NSDate *)time withDays:(bool)days;
+ (NSString*)stringFromDate:(NSDate*)date;
+ (NSString*)stringFromFullDate:(NSDate*)date;

+ (NSDate*)sumOfTimes:(NSArray*)times;

+ (NSDate*)dateFromString:(NSString*)str;
+ (NSDate*)correctDate:(NSDate*)date;

+ (NSString*)tempsToutesLettres:(NSTimeInterval)t;

+ (NSDate*)defaultDate;

@end

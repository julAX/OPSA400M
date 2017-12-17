//
//  TimeTools.m
//  Esterel OPS
//
//  Created by utilisateur on 13/02/2014.
//
//

/*
 Différents outils qui permettent de centraliser la gestion des dates et des temps
 */



#import "TimeTools.h"


@interface TimeTools ()

@property NSDateFormatter *timeFormatter, *dateFormatter, *fullDateFormatter;
@property NSDate *defaultDate;
@property NSArray *nombres, *dixaines;

@end

@implementation TimeTools


+ (TimeTools *)sharedInstance
{
    static dispatch_once_t once;
    static TimeTools *sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[TimeTools alloc] init];
    });
    return sharedInstance;
}


- (id)init
{
    self = [super init];
    
    _defaultDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    _timeFormatter = [NSDateFormatter new];
    _timeFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    _timeFormatter.defaultDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0.];
    _timeFormatter.dateFormat = @"HH':'mm";
    
    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    _dateFormatter.defaultDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0.];
    _dateFormatter.dateFormat = @"dd'/'MM'/'yyyy";
    
    _fullDateFormatter = [NSDateFormatter new];
    _fullDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    _fullDateFormatter.defaultDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0.];
    _fullDateFormatter.dateFormat = @"dd'/'MM'/'yyyy HH':'mm";
    
    _nombres = @[@"zero", @"une", @"deux", @"trois", @"quatre", @"cinq", @"six", @"sept", @"huit", @"neuf", @"dix", @"onze", @"douze", @"treize", @"quatorze", @"quinze", @"seize", @"dix-sept", @"dix-huit", @"dix-neuf"];
    _dixaines = @[@"zero", @"dix", @"vingt", @"trente", @"quarante", @"cinquante", @"soixante", @"soixante-dix", @"quatre-vingt", @"quatre-vingt-dix"];
    
    return self;
}


+ (NSString *)stringFromTime:(NSDate *)time withDays:(bool)days
{
    if (days) {
        NSTimeInterval timeInterval = [time timeIntervalSinceReferenceDate];
        
        if (timeInterval >= 0. && (timeInterval < 31536000. || !days)) {
            
            NSInteger minutes = floor(timeInterval/60.);
            
            return [NSString stringWithFormat:@"%02d:%02d", (int)((days) ? minutes/60 : (minutes/60) % 24) , (int)(minutes%60)];
        }
        else
            return @"Error";
    }
    else {
        if (time)
            return [[TimeTools sharedInstance].timeFormatter stringFromDate:time];
        else
            return @"";
    }
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    return ([date isEqualToDate:[TimeTools defaultDate]]) ? @"" : [[TimeTools sharedInstance].dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromFullDate:(NSDate *)date
{
    return ([date isEqualToDate:[TimeTools defaultDate]]) ? @"" : [[TimeTools sharedInstance].fullDateFormatter stringFromDate:date];
}

+ (NSDate*)sumOfTimes:(NSArray *)times
{
    NSTimeInterval sum = 0;
    
    for (NSDate *time in times)
        sum += [time timeIntervalSinceReferenceDate];
    
    return [NSDate dateWithTimeIntervalSinceReferenceDate:sum];
}

+ (NSDate *)dateFromString:(NSString *)str
{
    NSDate *date = [[TimeTools sharedInstance].fullDateFormatter dateFromString:str];
    
    if (!date)
        date = [[TimeTools sharedInstance].dateFormatter dateFromString:str];
    
    if (!date)
        date = [[TimeTools sharedInstance].timeFormatter dateFromString:str];
    
    if (!date)
        date = [[TimeTools sharedInstance].defaultDate copy];

    return date;
}

+ (NSDate *)correctDate:(NSDate *)date
{
    if ([date isEqualToDate:[TimeTools sharedInstance].defaultDate])
        return [NSDate dateWithTimeIntervalSinceReferenceDate:(floor([NSDate timeIntervalSinceReferenceDate]/60.) * 60.)];
    else
        return [NSDate dateWithTimeIntervalSinceReferenceDate:(floor([date timeIntervalSinceReferenceDate]/60.) * 60.)];
}

+ (NSDate*)defaultDate
{
    return [TimeTools sharedInstance].defaultDate;
}


+ (NSString*)tempsToutesLettres:(NSTimeInterval)t
{
    NSInteger m = round(t / 60.);
    NSInteger h = m / 60;
    m = m % 60;
    
    return [NSString stringWithFormat:@"%@%@%@%@%@",
            [TimeTools nombreEnToutesLettres:h],
            (h > 0) ? [NSString stringWithFormat:@" heure%@", (h == 1) ? @"" : @"s"] : @"",
            (h != 0 && m != 0) ? @" et " : @"",
            [TimeTools nombreEnToutesLettres:m],
            (m > 0) ? [NSString stringWithFormat:@" minute%@", (m == 1) ? @"" : @"s"] : @""];
}

+ (NSString*)nombreEnToutesLettres:(NSInteger)v
{
    NSInteger cent = (v / 100) % 10, val = v % 100;
    NSInteger dix = val / 10;
    
    if (dix == 1 || dix == 7 || dix == 9)
        dix--;
    
    NSInteger unit = val - dix * 10;
    
    NSMutableString *str = [NSMutableString new];
    
    if (cent > 0)
        [str appendFormat:@"%@%@cent", [TimeTools sharedInstance].nombres[cent], (cent == 1) ? @"" : @"-"];
    
    if (dix > 0)
        [str appendFormat:@"%@%@", (cent > 0) ? @"-" : @"", [TimeTools sharedInstance].dixaines[dix]];
    
    if (unit != 0)
    {
        if (dix != 0)
            [str appendString:@"-"];
        
        if (dix != 0 && dix != 8 && unit % 10 == 1)
            [str appendString:@"et-"];
        
        [str appendString:[TimeTools sharedInstance].nombres[unit]];
    }
    
    return str;
}


@end

//
//  DateConverter.m
//  Task Leader
//
//  Created by Balajibabu S.G. on 25/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import "DateConverter.h"

@implementation DateConverter

+ (NSString *)convertDateString:(NSString *)dateString FromFormat:(NSString *)fromFormat isFromUTC:(BOOL)isFromFormatUTC ToFormat:(NSString *)toFormat isUTC:(BOOL)isToFormatUTC
{
    NSDateFormatter *fromDateFormatter = [[NSDateFormatter alloc] init];
    [fromDateFormatter setDateFormat:fromFormat];
    
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    [toDateFormatter setDateFormat:toFormat];
    
    if (isFromFormatUTC) {
        NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [fromDateFormatter setTimeZone:inputTimeZone];
    }
    if (isToFormatUTC) {
        NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [toDateFormatter setTimeZone:inputTimeZone];
    }
    
    NSDate *fromDate = [fromDateFormatter dateFromString:dateString];
    NSString *toDateString = [toDateFormatter stringFromDate:fromDate];
    
    return toDateString;
}

+ (NSString *)convertDateString:(NSString *)dateString FromFormat:(NSString *)fromFormat ToFormat:(NSString *)toFormat
{
    NSDateFormatter *fromDateFormatter = [[NSDateFormatter alloc] init];
    [fromDateFormatter setDateFormat:fromFormat];
    
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    [toDateFormatter setDateFormat:toFormat];
    
    NSDate *fromDate = [fromDateFormatter dateFromString:dateString];
    NSString *toDateString = [toDateFormatter stringFromDate:fromDate];
    
    return toDateString;
}


+ (NSString *)convertDate:(NSDate *)fromDate ToFormat:(NSString *)toFormat
{
    NSDateFormatter *toDateFormatter = [[NSDateFormatter alloc] init];
    [toDateFormatter setDateFormat:toFormat];
    
    NSString *toDateString = [toDateFormatter stringFromDate:fromDate];
    
    return toDateString;
}

+ (NSDate *)convertDateString:(NSString *)dateString FromFormat:(NSString *)fromFormat
{
    NSDateFormatter *fromDateFormatter = [[NSDateFormatter alloc] init];
    [fromDateFormatter setDateFormat:fromFormat];
    
    NSDate *toDate = [fromDateFormatter dateFromString:dateString];
    
    return toDate;
}


@end

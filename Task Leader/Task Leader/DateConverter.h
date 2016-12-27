//
//  DateConverter.h
//  Task Leader
//
//  Created by Balajibabu S.G. on 25/12/16.
//  Copyright © 2016 Balajibabu S.G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateConverter : NSObject

+ (NSString *)convertDateString:(NSString *)dateString FromFormat:(NSString *)fromFormat ToFormat:(NSString *)toFormat;
+ (NSString *)convertDateString:(NSString *)dateString FromFormat:(NSString *)fromFormat isFromUTC:(BOOL)isFromFormatUTC ToFormat:(NSString *)toFormat isUTC:(BOOL)isToFormatUTC;
+ (NSString *)convertDate:(NSDate *)fromDate ToFormat:(NSString *)toFormat;
+ (NSDate *)convertDateString:(NSString *)dateString FromFormat:(NSString *)fromFormat;

@end

//
//  DateUtil.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/23/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy 'às' HH:mm"];
    return [formatter stringFromDate:date];
}

+ (NSString *)shortTimeFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    
    NSString *shortTime = @"";
    if ([components minute] == 0)
        shortTime = [NSString stringWithFormat:@"%dh", [components hour]];
    else
        shortTime = [NSString stringWithFormat:@"%dh%0d", [components hour], [components minute]];
    
    return shortTime;
}

+ (NSDate *)todaysMidnight
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
    return date;
}

@end

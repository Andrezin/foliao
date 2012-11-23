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

@end

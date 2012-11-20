//
//  FoliaoRankingTitle.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/19/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "FoliaoRankingTitle.h"

@implementation FoliaoRankingTitle

+ (NSString *)titleForBeingPresentIn:(int)numberOfParades
{
    if (numberOfParades <= 2)
        return @"Folião Amador";
    else if (numberOfParades <= 5)
        return @"Folião Zoador";
    else if (numberOfParades <= 8)
        return @"Folião Tá Danado";
    else
        return @"Folião Master";
}

@end

//
//  FoliaoTestController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 12/7/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "FoliaoTestController.h"
#import "KIFTestScenario+FoliaoAdditions.h"

@implementation FoliaoTestController

- (void)initializeScenarios
{
    [self addScenario:[KIFTestScenario scenarioToViewBlocosByLocation]];
    [self addScenario:[KIFTestScenario scenarioToViewBlocosByName]];
}

@end

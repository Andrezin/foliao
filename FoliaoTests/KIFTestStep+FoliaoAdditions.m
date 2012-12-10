//
//  KIFTestStep+FoliaoAdditions.m
//  Foliao
//
//  Created by Gustavo Barbosa on 12/7/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "KIFTestStep+FoliaoAdditions.h"
#import "UIView-KIFAdditions.h"

@implementation KIFTestStep (FoliaoAdditions)

+ (NSArray *)steptoCheckForBlocoInformations
{
    NSMutableArray *steps = [NSMutableArray array];
    
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Mapa do bloco"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Nome do bloco"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Informações do bloco"]];
    [steps addObject:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Confirmar presença no bloco"]];
    
    return steps;
}

@end

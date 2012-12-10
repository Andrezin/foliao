//
//  KIFTestScenario+FoliaoAdditions.m
//  Foliao
//
//  Created by Gustavo Barbosa on 12/7/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "KIFTestScenario+FoliaoAdditions.h"
#import "KIFTestStep+FoliaoAdditions.h"

@implementation KIFTestScenario (FoliaoAdditions)

+ (id)scenarioToViewBlocosByLocation
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully browse blocos by their location"];
    
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Mapa de blocos"]];
    
    // TODO: scrollar para um pin, clica nele, clicar no accessory view e ver as infos do bloco
    
    return scenario;
}

+ (id)scenarioToViewBlocosByName
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully browse blocos by their name"];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Botão Menu"]];
    [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Menu"
                                                                     atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Lista de blocos"]];
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Nome do bloco"]];
    [scenario addStep:[KIFTestStep stepToTapRowInTableViewWithAccessibilityLabel:@"Lista de blocos"
                                                                     atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    [scenario addStepsFromArray:[KIFTestStep steptoCheckForBlocoInformations]];
    return scenario;
}

@end

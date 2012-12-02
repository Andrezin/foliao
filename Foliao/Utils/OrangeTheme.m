//
//  OrangeTheme.m
//  Foliao
//
//  Created by Gustavo Barbosa on 12/2/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "OrangeTheme.h"
#import "UIColor+Foliao.h"

@implementation OrangeTheme

+ (UIColor *)color
{
    return [UIColor foliaoOrangeColor];
}

+ (UIImage *)menuButtonImage
{
    return [UIImage imageNamed:@"bt-menu-laranja"];
}

+ (UIImage *)backButtonImage
{
    return [UIImage imageNamed:@"bt-voltar-laranja"];
}

+ (UIImage *)accessoryViewImage
{
    return [UIImage imageNamed:@"seta-laranja"];
}

@end

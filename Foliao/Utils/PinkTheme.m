//
//  PinkTheme.m
//  Foliao
//
//  Created by Gustavo Barbosa on 12/2/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "PinkTheme.h"
#import "UIColor+Foliao.h"

@implementation PinkTheme

+ (UIColor *)color
{
    return [UIColor foliaoPinkColor];
}

+ (UIImage *)menuButtonImage
{
    return [UIImage imageNamed:@"bt-menu-rosa"];
}

+ (UIImage *)backButtonImage
{
    return [UIImage imageNamed:@"bt-voltar-rosa"];
}

+ (UIImage *)accessoryViewImage
{
    return [UIImage imageNamed:@"seta-rosa"];
}


@end

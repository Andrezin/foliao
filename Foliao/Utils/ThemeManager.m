//
//  ThemeManager.m
//  Foliao
//
//  Created by Gustavo Barbosa on 12/2/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "ThemeManager.h"

static Class<ThemeProtocol> _currentTheme;

@implementation ThemeManager

+ (Class<ThemeProtocol>)currentTheme
{
    return _currentTheme;
}

+ (void)setCurrentTheme:(Class<ThemeProtocol>)theme
{
    _currentTheme = theme;
}

@end

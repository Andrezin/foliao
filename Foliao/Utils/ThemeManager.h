//
//  ThemeManager.h
//  Foliao
//
//  Created by Gustavo Barbosa on 12/2/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ThemeProtocol <NSObject>

+ (UIColor *)color;
+ (UIImage *)menuButtonImage;
+ (UIImage *)backButtonImage;
+ (UIImage *)accessoryViewImage;

@end


@interface ThemeManager : NSObject

+ (Class<ThemeProtocol>)currentTheme;
+ (void)setCurrentTheme:(Class<ThemeProtocol>)theme;

@end

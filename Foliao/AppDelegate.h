//
//  AppDelegate.h
//  Foliao
//
//  Created by Gustavo Barbosa on 11/7/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@class ZUUIRevealController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ZUUIRevealController *mainViewController;

- (void)openSession;
- (void)logOut;

@end

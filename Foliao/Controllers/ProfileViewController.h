//
//  WhereAmIGoingViewController.h
//  Foliao
//
//  Created by Gustavo Barbosa on 11/19/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "NavigationRootLevelViewController.h"

@interface ProfileViewController : NavigationRootLevelViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) PFObject *user;

@end

//
//  BlocosByNameViewController.h
//  Foliao
//
//  Created by Gustavo Barbosa on 11/8/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NavigationRootLevelViewController.h"

@interface BlocosByNameViewController : NavigationRootLevelViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

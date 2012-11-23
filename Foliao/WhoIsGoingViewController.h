//
//  WhoIsGoingViewController.h
//  Foliao
//
//  Created by Gustavo Barbosa on 11/20/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "BaseViewController.h"

@interface WhoIsGoingViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *folioes;

@end

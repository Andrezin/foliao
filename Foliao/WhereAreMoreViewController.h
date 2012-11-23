//
//  RankingPeopleViewController.h
//  Foliao
//
//  Created by Gustavo Barbosa on 11/23/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "BaseViewController.h"

typedef enum whereAreMoreSomething {
    WhereAreMorePeople = 1,
    WhereAreMoreWomen = 2,
    WhereAreMoreMen = 3
} WhereAreMoreSomething;

@interface WhereAreMoreViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) WhereAreMoreSomething what;

@end

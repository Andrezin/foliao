//
//  BlocoViewController.h
//  Foliao
//
//  Created by Gustavo Barbosa on 11/9/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BlocoViewController : UIViewController

@property (strong, nonatomic) PFObject *bloco;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

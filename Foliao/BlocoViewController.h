//
//  BlocoViewController.h
//  Foliao
//
//  Created by Gustavo Barbosa on 11/9/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BlocoViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) PFObject *bloco; // if I came from a list of "blocos"
@property (strong, nonatomic) PFObject *parade; // if I came from a list of "parades"

@end

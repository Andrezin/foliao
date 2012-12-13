//
//  BlocoViewController.h
//  Foliao
//
//  Created by Gustavo Barbosa on 11/9/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "BaseViewController.h"

@interface ParadeViewController : BaseViewController <MKMapViewDelegate>

@property (strong, nonatomic) PFObject *parade;

@end

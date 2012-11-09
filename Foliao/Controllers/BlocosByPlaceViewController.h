//
//  BlocosByPlaceViewController.h
//  Foliao
//
//  Created by Gustavo Barbosa on 11/8/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "NavigationRootLevelViewController.h"

@interface BlocosByPlaceViewController : NavigationRootLevelViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

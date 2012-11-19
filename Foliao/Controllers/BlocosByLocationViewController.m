//
//  BlocosByPlaceViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/8/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "BlocosByLocationViewController.h"
#import "ParadeAnnotation.h"


@interface BlocosByLocationViewController(){
    MKUserLocation *userFirstLocation;
}
- (MKCoordinateRegion)regionThatFitsUserLocation:(MKUserLocation *)userLocation;
@end


@implementation BlocosByLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.userLocation.title = @"Tô pulando por aqui!";
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parade"];
    [query includeKey:@"bloco"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *parade in objects) {
                ParadeAnnotation *annotation = [[ParadeAnnotation alloc] initWithParade:parade];
                [self.mapView addAnnotation:annotation];
            }
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!userFirstLocation) {
        userFirstLocation = mapView.userLocation;
        [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        [mapView setRegion:[self regionThatFitsUserLocation:userLocation] animated:NO];
    }
}

- (MKCoordinateRegion)regionThatFitsUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = userLocation.coordinate;
    
    return region;
}

@end

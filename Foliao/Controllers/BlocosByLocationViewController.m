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
    CLLocationManager *locationManager;
}

- (MKCoordinateRegion)regionThatFitsUserLocation:(CLLocation *)userLocation;

@end


@implementation BlocosByLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.userLocation.title = @"Tô pulando por aqui!";
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 20; // in meters
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled] &&
                           [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
    if (locationAllowed)
        [locationManager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self.mapView setCenterCoordinate:newLocation.coordinate];
    [self.mapView setRegion:[self regionThatFitsUserLocation:newLocation]];
}

- (MKCoordinateRegion)regionThatFitsUserLocation:(CLLocation *)userLocation
{
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = userLocation.coordinate;
    
    return region;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    PFGeoPoint *southwest = [[PFGeoPoint alloc] init];
    southwest.latitude = mapView.centerCoordinate.latitude - mapView.region.span.latitudeDelta/2;
    southwest.longitude = mapView.centerCoordinate.longitude - mapView.region.span.longitudeDelta/2;
    
    PFGeoPoint *northeast = [[PFGeoPoint alloc] init];
    northeast.latitude = mapView.centerCoordinate.latitude + mapView.region.span.latitudeDelta/2;
    northeast.longitude = mapView.centerCoordinate.longitude + mapView.region.span.longitudeDelta/2;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parade"];
    [query whereKey:@"location" withinGeoBoxFromSouthwest:southwest toNortheast:northeast];
    [query includeKey:@"bloco"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            id userLocationAnnotation = self.mapView.userLocation;
            NSMutableArray *annotations = [NSMutableArray arrayWithArray:self.mapView.annotations];
            [annotations removeObject:userLocationAnnotation];
            [self.mapView removeAnnotations:annotations];
            
            for (PFObject *parade in objects) {
                ParadeAnnotation *annotation = [[ParadeAnnotation alloc] initWithParade:parade];
                [self.mapView addAnnotation:annotation];
            }
        }
    }];
}

@end

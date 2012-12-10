//
//  BlocosByPlaceViewController.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/8/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "BlocosByLocationViewController.h"
#import "MapSettingsViewController.h"
#import "BlocoViewController.h"
#import "ParadeAnnotation.h"


@interface BlocosByLocationViewController(){
    MKUserLocation *userFirstLocation;
    CLLocationManager *locationManager;
    
    BOOL locationLoaded;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *buttonLocateMe;

- (MKCoordinateRegion)regionThatFitsUserLocation:(CLLocation *)userLocation;
- (IBAction)buttonLocateMeTapped:(UIButton *)button;
- (IBAction)buttonSettingsTapped:(UIButton *)button;

@end


@implementation BlocosByLocationViewController

#pragma mark UIViewController life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.userLocation.title = @"Tô pulando por aqui!";
    self.mapView.accessibilityLabel = @"Mapa de blocos";
    
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
    [super viewDidUnload];
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}

#pragma mark CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (locationLoaded) return;
    
    if (newLocation.coordinate.latitude >= -90 && newLocation.coordinate.latitude <= 90 &&
        newLocation.coordinate.longitude >= -90 && newLocation.coordinate.longitude <= 90) {

        [self.mapView setCenterCoordinate:newLocation.coordinate];
        [self.mapView setRegion:[self regionThatFitsUserLocation:newLocation]];
        locationLoaded = YES;
    }
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

#pragma mark MKMapView delegate

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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil; // user location
    }
    
    static NSString *pinIdentifier = @"ParadePin";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.canShowCallout = YES;
        [(MKPinAnnotationView *)annotationView setPinColor:MKPinAnnotationColorPurple];
    }
    
    annotationView.annotation = annotation;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    BlocoViewController *blocoViewController = [[BlocoViewController alloc] init];
    blocoViewController.parade = [(ParadeAnnotation *)view.annotation parade];
    [self.navigationController pushViewController:blocoViewController animated:YES];
}

#pragma mark -

- (IBAction)buttonLocateMeTapped:(UIButton *)button
{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (IBAction)buttonSettingsTapped:(UIButton *)button
{
    MapSettingsViewController *mapSettings = [[MapSettingsViewController alloc] init];
    mapSettings.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentModalViewController:mapSettings animated:YES];
}

@end

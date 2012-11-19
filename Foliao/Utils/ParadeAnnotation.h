//
//  ParadeAnnotation.h
//  Foliao
//
//  Created by Gustavo Barbosa on 11/19/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface ParadeAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) PFObject *parade;

- (ParadeAnnotation *)initWithParade:(PFObject *)parade;

@end

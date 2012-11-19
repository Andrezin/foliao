//
//  ParadeAnnotation.m
//  Foliao
//
//  Created by Gustavo Barbosa on 11/19/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import "ParadeAnnotation.h"

@implementation ParadeAnnotation

- (ParadeAnnotation *)initWithParade:(PFObject *)aParade
{
    if (self = [super init]) {
        self.parade = aParade;
    }
    return self;
}

- (NSString *)title
{
    if (!self.parade)
        return @"";
    
    return self.parade[@"bloco"][@"name"];
}

- (NSString *)subtitle
{
    if (!self.parade)
        return @"";
    
    return [(NSDate *)self.parade[@"date"] description];
}

- (CLLocationCoordinate2D)coordinate
{
    if (!self.parade)
        return CLLocationCoordinate2DMake(0, 0);
    
    return CLLocationCoordinate2DMake([(PFGeoPoint *)self.parade[@"location"] latitude], [(PFGeoPoint *)self.parade[@"location"] longitude]);
}

@end

//
//  KalBlocosDataSource.h
//  Foliao
//
//  Created by Gustavo Barbosa on 11/19/12.
//  Copyright (c) 2012 7pixels. All rights reserved.
//

#import <Parse/Parse.h>

#import "Kal.h"

@interface KalBlocosDataSource : NSObject <KalDataSource>
{
    NSMutableArray *allParades;
    NSMutableArray *paradesInSelectedDay;
    id<KalDataSourceCallbacks> callback;
//    BOOL dataIsReady;
}

- (PFObject *)paradeAtIndexPath:(NSIndexPath *)indexPath;

@end

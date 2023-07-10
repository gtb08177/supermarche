//
//  RYNOptions.h
//  Supermarché
//
//  Created by Ryan McNulty on 22/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RYNOptions : NSManagedObject

@property (nonatomic, retain) NSNumber * shopMemEnabled;
@property (nonatomic, retain) NSNumber * priceCompEnabled;
@property (nonatomic, retain) NSNumber * autoremovalEnabled;

@end
//
//  RYNItem.h
//  Supermarché
//
//  Created by Ryan McNulty on 13/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RYNPurchasedList;

@interface RYNPurchasedItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * originalQuantity;
@property (nonatomic, retain) NSNumber * purchased;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) RYNPurchasedList *list;

@end

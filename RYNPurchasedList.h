//
//  RYNList.h
//  Supermarché
//
//  Created by Ryan McNulty on 13/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RYNPurchasedItem;

@interface RYNPurchasedList : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSOrderedSet *items;
@end

@interface RYNPurchasedList (CoreDataGeneratedAccessors)

- (void)insertObject:(RYNPurchasedItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(RYNPurchasedItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(RYNPurchasedItem *)value;
- (void)removeItemsObject:(RYNPurchasedItem *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end

//
//  RYNTemplateList.h
//  Supermarché
//
//  Created by Ryan McNulty on 16/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RYNTemplateItem;

@interface RYNTemplateList : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *items;
@end

@interface RYNTemplateList (CoreDataGeneratedAccessors)

- (void)insertObject:(RYNTemplateItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(RYNTemplateItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(RYNTemplateItem *)value;
- (void)removeItemsObject:(RYNTemplateItem *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end

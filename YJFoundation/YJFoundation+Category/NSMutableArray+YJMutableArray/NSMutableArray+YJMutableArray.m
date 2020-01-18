//
//  NSMutableArray+YJMutableArray.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSMutableArray+YJMutableArray.h"

@implementation NSMutableArray (YJMutableArray)

+ (NSMutableArray *)yj_mutableArrayWithPlistData:(NSData *)plist {
    
    if (!plist) {
        return nil;
    }
    
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist
                                                                      options:NSPropertyListMutableContainersAndLeaves
                                                                       format:NULL
                                                                        error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]]) {
        
        return array;
    }
    
    return nil;
}

#pragma mark - 增加对象
- (void)yj_addSafeObject:(id)object {
    
    if (object == nil) {
        
        return;
    } else {
        
        [self addObject:object];
    }
}

- (void)yj_insertSafeObject:(id)object
                      index:(NSUInteger)index {
    
    if (object == nil) {
        
        return;
        
    } else if (index > self.count) {
        
        [self insertObject:object
                   atIndex:self.count];
        
    } else {
        
        [self insertObject:object
                   atIndex:index];
    }
}

- (void)yj_insertSafeArray:(NSArray *)array {
    if (!array) {
        return;
    }
    
    [self addObjectsFromArray:array];
}

- (void)yj_insertSafeArray:(NSArray *)array
                  indexSet:(NSIndexSet *)indexSet {
    
    if (indexSet == nil) {
        
        return;
    } else if (indexSet.count != array.count || indexSet.firstIndex > array.count) {
        
        [self insertObject:array
                   atIndex:self.count];
        
    } else {
        
        [self insertObjects:array
                  atIndexes:indexSet];
    }
}

#pragma mark - 删除对象
- (void)yj_safeRemoveFirstObject {
    
    if (self.count) {
        
        [self removeObjectAtIndex:0];
    }
}

- (void)yj_safeRemoveLastObject {
    
    if (self.count) {
        
        [self removeObjectAtIndex:self.count - 1];
    }
}

- (void)yj_safeRemoveObjectAtIndex:(NSUInteger)index {
    
    if (index >= self.count) {
        
        return;
    } else {
        
        [self removeObjectAtIndex:index];
    }
}

- (void)yj_safeRemoveObjectsInRange:(NSRange)range {
    
    NSUInteger location = range.location;
    NSUInteger length   = range.length;
    
    if (location + length > self.count) {
        
        return;
    } else {
        
        [self removeObjectsInRange:range];
    }
}

#pragma mark - 数组排序
- (NSMutableArray *)yj_getReverseArray {
    
    NSUInteger yj_arrayCount = self.count;
    
    NSInteger yj_mid = floor(yj_arrayCount / 2.0);
    
    for (NSUInteger i = 0; i < yj_mid; i++) {
        
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:(yj_arrayCount - (i + 1))];
    }
    
    return self;
}

- (NSMutableArray *)yj_getDisorderArray {
    
    for (NSUInteger i = self.count; i > 1; i--) {
        
        [self exchangeObjectAtIndex:(i - 1)
                  withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
    
    return self;
}


@end

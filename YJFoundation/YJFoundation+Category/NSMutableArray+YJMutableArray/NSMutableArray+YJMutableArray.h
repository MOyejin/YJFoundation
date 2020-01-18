//
//  NSMutableArray+YJMutableArray.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (YJMutableArray)

/**
 序列化一个NSMutableArray
 
 @param plist NSData
 @return NSMutableArray
 */
+ (NSMutableArray *)yj_mutableArrayWithPlistData:(NSData *)plist;

#pragma mark - 增加对象
/**
 安全的添加一个对象
 
 @param object 对象
 */
- (void)yj_addSafeObject:(id)object;

/**
 根据索引安全的插入一个对象
 
 @param object 对象
 @param index NSUInteger
 */
- (void)yj_insertSafeObject:(id)object
                      index:(NSUInteger)index;

/**
 安全的插入一个数组
 
 @param array NSArray
 */
- (void)yj_insertSafeArray:(NSArray *)array;

/**
 根据索引安全的插入一个数组
 
 @param array NSArray
 @param indexSet NSIndexSet
 */
- (void)yj_insertSafeArray:(NSArray *)array
                  indexSet:(NSIndexSet *)indexSet;

#pragma mark - 删除对象
/**
 安全的删除第一个对象
 */
- (void)yj_safeRemoveFirstObject;

/**
 安全的删除最后一个对象
 */
- (void)yj_safeRemoveLastObject;

/**
 根据索引安全的删除一个对象
 
 @param index NSUInteger
 */
- (void)yj_safeRemoveObjectAtIndex:(NSUInteger)index;

/**
 根据范围安全的删除
 
 @param range NSRange
 */
- (void)yj_safeRemoveObjectsInRange:(NSRange)range;

#pragma mark - 数组排序
/**
 获取倒序排列的数组
 
 @return NSMutableArray
 */
- (NSMutableArray *)yj_getReverseArray;

/**
 获取乱序排列的数组
 
 @return NSMutableArray
 */
- (NSMutableArray *)yj_getDisorderArray;

@end

NS_ASSUME_NONNULL_END

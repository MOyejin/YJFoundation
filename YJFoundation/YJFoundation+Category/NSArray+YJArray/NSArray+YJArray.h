//
//  NSArray+YJArray.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (YJArray)

/**
 创建一个安全的Array
 
 @param object 对象, 可以为nil
 @return NSArray
 */
+ (instancetype)yj_initSafeArrayWithObject:(id)object;

/**
 序列化创建一个NSArray
 
 @param plist NSData
 @return NSArray
 */
+ (NSArray *)yj_arrayWithPlistData:(NSData *)plist;

/**
 从数组里获取一个id对象, 索引超出之后, 也不会崩掉
 
 @param index 对象索引
 @return id
 */
- (id)yj_safeObjectAtIndex:(NSUInteger)index;

/**
 根据Range返回对应的Array
 
 @param range range, 这里就算超出了索引也不会引起问题
 @return NSArray
 */
- (NSArray *)yj_safeArrayWithRange:(NSRange)range;

/**
 根据对象返回对应的索引
 
 @param object 对象
 @return NSUInteger
 */
- (NSUInteger)yj_safeIndexOfObject:(id)object;

/**
 根据给定的Plist文件名返回里面的数组
 
 @param name Plist文件名
 @return NSArray
 */
+ (NSArray *)yj_getArrayWithPlistName:(NSString *)name;

/**
 根据给定的JSON String转成NSArray
 
 @param jsonString NSString
 @return NSArray
 */
+ (NSArray *)yj_getArrayWithJSONString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END

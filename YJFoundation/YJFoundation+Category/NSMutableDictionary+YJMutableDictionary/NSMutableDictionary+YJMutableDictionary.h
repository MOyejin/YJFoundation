//
//  NSMutableDictionary+YJMutableDictionary.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (YJMutableDictionary)

/**
 安全的存储一个键值对
 
 @param object 值
 @param key 键
 */
- (void)yj_setSafeObject:(id)object
                  forKey:(id)key;

/**
 安全的根据一个键获取对应的对象
 
 @param key key
 @return id
 */
- (id)yj_safeObjectForKey:(id)key;

/**
 安全的根据value获取对应的key
 
 @param value id object
 @return id
 */
- (id)yj_safeKeyForValue:(id)value;

/**
 序列化创建一个NSMutableDictionary
 
 @param plist NSData
 @return NSMutableDictionary
 */
+ (NSMutableDictionary *)yj_mutableDictionaryWithPlistData:(NSData *)plist;

/**
 筛选出需要的Keys并组装成一个NSMutableDictionary, 其他的则会删除
 
 @param keys NSArray
 @return NSMutableDictionary
 */
- (NSMutableDictionary *)yj_popEntriesForKeys:(NSArray *)keys;

@end

NS_ASSUME_NONNULL_END

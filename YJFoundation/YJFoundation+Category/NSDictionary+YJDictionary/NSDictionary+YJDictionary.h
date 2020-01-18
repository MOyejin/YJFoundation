//
//  NSDictionary+YJDictionary.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (YJDictionary)

/**
 序列化创建一个NSDictionary
 
 @param plist NSData
 @return NSDictionary
 */
+ (NSDictionary *)yj_dictionaryWithPlistData:(NSData *)plist;

/**
 将指定的URL字符串转成NSDictionary
 
 @param urlString URL字符串, 格式: http://www.xxxx.com?a=1&b=2 || a=1&b=2
 @return NSDictionary
 */
+ (NSDictionary *)yj_dictionaryWithURLString:(NSString *)urlString;

/**
 根据给定的JSON String转成NSDictionary
 
 @param jsonString NSString
 @return NSDictionary
 */
+ (NSDictionary *)yj_dictionaryWithJSONString:(NSString *)jsonString;

/**
 获取NSDictionary的所有排序完成的Keys
 
 @return NSArray
 */
- (NSArray *)yj_getAllKeysSorted;

/**
 获取NSDictionary的所有排序完成的Value
 
 @return NSArray
 */
- (NSArray *)yj_getAllValuesSortedByKeys;

/**
 查看是否包含指定Key的Object
 
 @param key id
 @return BOOL
 */
- (BOOL)yj_containsObjectForKey:(id)key;

/**
 获取指定Keys的NSDictionary
 
 @param keys NSArray
 @return NSDictionary
 */
- (NSDictionary *)yj_getDictionaryForKeys:(NSArray *)keys;

@end

NS_ASSUME_NONNULL_END

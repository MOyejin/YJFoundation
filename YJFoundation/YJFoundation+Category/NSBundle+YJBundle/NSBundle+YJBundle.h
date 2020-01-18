//
//  NSBundle+YJBundle.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (YJBundle)

/**
 获取App名称
 
 @return NSString
 */
+ (NSString *)yj_getBundleDisplayName;

/**
 获取App版本号
 
 @return NSString
 */
+ (NSString *)yj_getBundleShortVersionString;

/**
 获取Build版本号
 
 @return NSString
 */
+ (NSString *)yj_getBundleVersion;

/**
 获取App Bundle Identifier
 
 @return NSString
 */
+ (NSString *)yj_getBundleIdentifier;

/**
 获取指定名字的Bundle
 
 @param name NSString
 @param type NSString
 @return NSString
 */
+ (NSString *)yj_getBundleFileWithName:(NSString *)name
                                  type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END

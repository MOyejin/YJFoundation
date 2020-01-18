//
//  YJLanguageManager.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJLanguageManager : NSObject

#pragma mark - 系统语言相关
/**
 获取系统当前的语言
 
 @return NSString
 */
+ (NSString *)yj_getSystemFistLanguage;

/**
 获取系统当前的可选语言
 
 @return NSArray
 */
+ (NSArray *)yj_getSystemPreferredLanguages;

/**
 获取系统所有的语言
 
 @return NSArray<NSString *>
 */
+ (NSArray<NSString *> *)yj_getAllSystemLanguages;

/**
 获取系统当前语言下的Key标签文字
 
 @param key NSString
 @return NSString
 */
+ (NSString *)yj_followSystemLanguageWithKey:(NSString *)key;

/**
 获取系统当前语言下的Key标签文字
 
 @param key NSString
 @param comment NSString, 备注
 @return NSString
 */
+ (NSString *)yj_followSystemLanguageWithKey:(NSString *)key
                                     comment:(NSString *)comment;

/**
 获取系统当前语言下的Key标签文字
 
 @param key NSString
 @param tablieName NSString, Language.strings文件名
 @param comment NSString, 备注
 @return NSString
 */
+ (NSString *)yj_followSystemLanguageWithKey:(NSString *)key
                                  tablieName:(NSString *)tablieName
                                     comment:(NSString *)comment;

/**
 获取系统当前语言下的Key标签文字
 
 @param key NSString
 @param tablieName NSString, Language.strings文件名
 @param bundle NSBundle
 @param comment NSString, 备注
 @return NSString
 */
+ (NSString *)yj_followSystemLanguageWithKey:(NSString *)key
                                  tablieName:(NSString *)tablieName
                                      bundle:(NSBundle *)bundle
                                     comment:(NSString *)comment;

/**
 获取系统当前语言下的Key标签文字
 
 @param key NSString
 @param tablieName NSString, Language.strings文件名
 @param bundle NSBundle
 @param value NSString
 @param comment NSString, 备注
 @return NSString
 */
+ (NSString *)yj_followSystemLanguageWithKey:(NSString *)key
                                  tablieName:(NSString *)tablieName
                                      bundle:(NSBundle *)bundle
                                       value:(NSString *)value
                                     comment:(NSString *)comment;

#pragma mark - 自定义语言相关
/**
 自定义多语言下的Key标签文字
 
 @param key NSString
 @param languageType NSString, 比如简体中文为: zh-Hans
 @param tablieName NSString, Language.strings文件名
 @return NSString
 */
+ (NSString *)yj_customLanguageWithKey:(NSString *)key
                          languageType:(NSString *)languageType
                            tablieName:(NSString *)tablieName;

/**
 自定义多语言下的Key标签文字
 
 @param key NSString
 @param languageType NSString, 比如简体中文为: zh-Hans
 @param tablieName NSString, Language.strings文件名
 @param comment NSString, 备注
 @return NSString
 */
+ (NSString *)yj_customLanguageWithKey:(NSString *)key
                          languageType:(NSString *)languageType
                            tablieName:(NSString *)tablieName
                               comment:(NSString *)comment;

/**
 自定义多语言下的Key标签文字
 
 @param key NSString
 @param languageType NSString, 比如简体中文为: zh-Hans
 @param tablieName NSString, Language.strings文件名
 @param value NSString, 如果Key找不到, 则使用该默认值
 @param comment NSString, 备注
 @return NSString
 */
+ (NSString *)yj_customLanguageWithKey:(NSString *)key
                          languageType:(NSString *)languageType
                            tablieName:(NSString *)tablieName
                                 value:(NSString *)value
                               comment:(NSString *)comment;

@end

NS_ASSUME_NONNULL_END

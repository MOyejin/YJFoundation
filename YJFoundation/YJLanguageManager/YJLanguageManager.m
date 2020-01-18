//
//  YJLanguageManager.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "YJLanguageManager.h"
#import "NSBundle+YJBundle.h"

@implementation YJLanguageManager

#pragma mark - 系统语言相关
+ (NSString *)yj_getSystemFistLanguage {
    
    return [NSLocale preferredLanguages].firstObject;
}

+ (NSArray *)yj_getSystemPreferredLanguages {
    
    return [NSLocale preferredLanguages];
}

+ (NSArray<NSString *> *)yj_getAllSystemLanguages {
    
    return [NSLocale availableLocaleIdentifiers];
}

+ (NSString *)yj_followSystemLanguageWithKey:(NSString *)key {
    
    return NSLocalizedString(key, nil);
}

+ (NSString *)yj_followSystemLanguageWithKey:(NSString *)key
                                     comment:(NSString *)comment {
    
    return NSLocalizedString(key, comment);
}

+ (NSString *)yj_followSystemLanguageWithKey:(NSString *)key
                                  tablieName:(NSString *)tablieName
                                     comment:(NSString *)comment {
    
    return NSLocalizedStringFromTable(key, tablieName, comment);
}

+ (NSString *)yj_followSystemLanguageWithKey:(NSString *)key
                                  tablieName:(NSString *)tablieName
                                      bundle:(NSBundle *)bundle
                                     comment:(NSString *)comment {
    
    return NSLocalizedStringFromTableInBundle(key, tablieName, bundle, comment);
}

+ (NSString *)yj_followSystemLanguageWithKey:(NSString *)key
                                  tablieName:(NSString *)tablieName
                                      bundle:(NSBundle *)bundle
                                       value:(NSString *)value
                                     comment:(NSString *)comment {
    
    return NSLocalizedStringWithDefaultValue(key, tablieName, bundle, value, comment);
}

#pragma mark - 自定义语言相关
+ (NSString *)yj_customLanguageWithKey:(NSString *)key
                          languageType:(NSString *)languageType
                            tablieName:(NSString *)tablieName {
    
    NSString *yj_bundlePath = [NSBundle yj_getBundleFileWithName:languageType
                                                            type:@"lproj"];
    
    NSBundle *yj_bundle = [NSBundle bundleWithPath:yj_bundlePath];
    
    return NSLocalizedStringFromTableInBundle(key, tablieName, yj_bundle, nil);
}

+ (NSString *)yj_customLanguageWithKey:(NSString *)key
                          languageType:(NSString *)languageType
                            tablieName:(NSString *)tablieName
                               comment:(NSString *)comment {
    
    NSString *yj_bundlePath = [NSBundle yj_getBundleFileWithName:languageType
                                                            type:@"lproj"];
    
    NSBundle *yj_bundle = [NSBundle bundleWithPath:yj_bundlePath];
    
    return NSLocalizedStringFromTableInBundle(key, tablieName, yj_bundle, comment);
}

+ (NSString *)yj_customLanguageWithKey:(NSString *)key
                          languageType:(NSString *)languageType
                            tablieName:(NSString *)tablieName
                                 value:(NSString *)value
                               comment:(NSString *)comment {
    
    NSString *yj_bundlePath = [NSBundle yj_getBundleFileWithName:languageType
                                                            type:@"lproj"];
    
    NSBundle *yj_bundle = [NSBundle bundleWithPath:yj_bundlePath];
    
    return NSLocalizedStringWithDefaultValue(key, tablieName, yj_bundle, value, comment);
}


@end

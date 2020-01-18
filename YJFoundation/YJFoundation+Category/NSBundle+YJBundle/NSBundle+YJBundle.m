//
//  NSBundle+YJBundle.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSBundle+YJBundle.h"

@implementation NSBundle (YJBundle)

+ (NSString *)yj_getBundleDisplayName {
    
    return [[[self mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)yj_getBundleShortVersionString {
    
    return [[[self mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)yj_getBundleVersion {
    
    return [[[self mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)yj_getBundleIdentifier {
    
    return [[self mainBundle] bundleIdentifier];
}

+ (NSString *)yj_getBundleFileWithName:(NSString *)name
                                  type:(NSString *)type {
    
    return [[self mainBundle] pathForResource:name
                                       ofType:type];
}

@end

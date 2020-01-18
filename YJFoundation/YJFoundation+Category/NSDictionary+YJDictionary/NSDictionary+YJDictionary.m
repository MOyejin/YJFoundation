//
//  NSDictionary+YJDictionary.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSDictionary+YJDictionary.h"
#import "NSString+YJString.h"

@implementation NSDictionary (YJDictionary)

+ (NSDictionary *)yj_dictionaryWithPlistData:(NSData *)plist {
    
    if (!plist) {
        return nil;
        
    }
    
    NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist
                                                                         options:NSPropertyListImmutable
                                                                          format:NULL
                                                                           error:NULL];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        
        return dictionary;
    }
    
    return nil;
}

+ (NSDictionary *)yj_dictionaryWithURLString:(NSString *)urlString {
    
    NSString *yj_queryString;
    
    if ([urlString containsString:@"?"]) {
        
        NSArray *yj_urlArray = [urlString componentsSeparatedByString:@"?"];
        
        yj_queryString = yj_urlArray.lastObject;
    } else {
        
        yj_queryString = urlString;
    }
    
    NSMutableDictionary *yj_queryDictionary = [NSMutableDictionary dictionary];
    
    NSArray *yj_parameters = [yj_queryString componentsSeparatedByString:@"&"];
    
    [yj_parameters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *yj_contents = [obj componentsSeparatedByString:@"="];
        
        NSString *yj_key   = yj_contents.firstObject;
        NSString *yj_value = yj_contents.lastObject;
        
        yj_value = [yj_value stringByRemovingPercentEncoding];
        
        if (yj_key && yj_value) {
            
            [yj_queryDictionary setObject:yj_value
                                   forKey:yj_key];
        }
    }];
    
    return [yj_queryDictionary copy];
}

+ (NSDictionary *)yj_dictionaryWithJSONString:(NSString *)jsonString {
    
    if ([NSString yj_checkEmptyWithString:jsonString]) {
        
        return nil;
    }
    
    NSData *yj_jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *yj_error;
    
    NSDictionary *yj_dictionary = [NSJSONSerialization JSONObjectWithData:yj_jsonData
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&yj_error];
    
    return yj_dictionary;
}

- (NSArray *)yj_getAllKeysSorted {
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)yj_getAllValuesSortedByKeys {
    
    NSArray *yj_sortedKeys = [self yj_getAllKeysSorted];
    
    NSMutableArray *yj_array = [NSMutableArray array];
    
    for (id yj_key in yj_sortedKeys) {
        
        [yj_array addObject:self[yj_key]];
    }
    
    return yj_array;
}

- (BOOL)yj_containsObjectForKey:(id)key {
    
    if (!key) {
        
        return NO;
    }
    
    return self[key] != nil;
}

- (NSDictionary *)yj_getDictionaryForKeys:(NSArray *)keys {
    
    NSMutableDictionary *yj_mutableDictionary = [NSMutableDictionary new];
    
    for (id key in keys) {
        
        id value = self[key];
        
        if (value) {
            
            yj_mutableDictionary[key] = value;
        }
    }
    
    return yj_mutableDictionary;
}


@end

//
//  NSMutableDictionary+YJMutableDictionary.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSMutableDictionary+YJMutableDictionary.h"

@implementation NSMutableDictionary (YJMutableDictionary)

- (void)yj_setSafeObject:(id)object
                  forKey:(id)key {
    
    if ([key isKindOfClass:[NSNull class]]) {
        
        return;
    }
    
    if ([object isKindOfClass:[NSNull class]]) {
        
        [self setValue:@""
                forKey:key];
        
    } else {
        [self setValue:object
                forKey:key];
    }
}

- (id)yj_safeObjectForKey:(id)key {
    
    if (key != nil) {
        
        return [self objectForKey:key];
        
    } else {
        
        return nil;
    }
}

- (id)yj_safeKeyForValue:(id)value {
    
    for (id key in self.allKeys) {
        
        if ([value isEqual:[self objectForKey:key]]) {
            
            return key;
        }
    }
    return nil;
}

+ (NSMutableDictionary *)yj_mutableDictionaryWithPlistData:(NSData *)plist {
    
    if (!plist) {
        
        return nil;
    }
    
    NSMutableDictionary *yj_mutableDictionary = [NSPropertyListSerialization propertyListWithData:plist
                                                                                          options:NSPropertyListMutableContainersAndLeaves
                                                                                           format:NULL
                                                                                            error:NULL];
    
    if ([yj_mutableDictionary isKindOfClass:[NSMutableDictionary class]]) {
        
        return yj_mutableDictionary;
    }
    
    return nil;
}

- (NSMutableDictionary *)yj_popEntriesForKeys:(NSArray *)keys {
    
    NSMutableDictionary *yj_mutableDictionary = [NSMutableDictionary dictionary];
    
    for (id key in keys) {
        
        id value = self[key];
        
        if (value) {
            
            [self removeObjectForKey:key];
            
            yj_mutableDictionary[key] = value;
        }
    }
    
    return yj_mutableDictionary;
}

@end

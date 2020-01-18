//
//  NSArray+YJArray.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSArray+YJArray.h"
#import "NSString+YJString.h"

@implementation NSArray (YJArray)

+ (instancetype)yj_initSafeArrayWithObject:(id)object {
    
    if (object == nil) {
        
        return [self array];
        
    } else {
        
        return [self arrayWithObject:object];
    }
}

+ (NSArray *)yj_arrayWithPlistData:(NSData *)plist {
    
    if (!plist) {
        
        return nil;
    }
    
    NSArray *yj_array = [NSPropertyListSerialization propertyListWithData:plist
                                                                  options:NSPropertyListImmutable
                                                                   format:NULL
                                                                    error:NULL];
    
    if ([yj_array isKindOfClass:[NSArray class]]) {
        
        return yj_array;
    }
    
    return nil;
}

- (id)yj_safeObjectAtIndex:(NSUInteger)index {
    
    if (index >= self.count) {
        
        return nil;
    } else {
        
        return [self objectAtIndex:index];
    }
}

- (NSArray *)yj_safeArrayWithRange:(NSRange)range {
    
    NSUInteger location = range.location;
    NSUInteger length   = range.length;
    
    if (location + length > self.count) {
        
        //超过了边界,就获取从loction开始所有的item
        if ((location + length) > self.count) {
            
            length = (self.count - location);
            
            return [self yj_safeArrayWithRange:NSMakeRange(location, length)];
        }
        
        return nil;
        
    } else {
        
        return [self subarrayWithRange:range];
    }
}

- (NSUInteger)yj_safeIndexOfObject:(id)object {
    
    if (object == nil) {
        
        return NSNotFound;
    } else {
        
        return [self indexOfObject:object];
    }
}

+ (NSArray *)yj_getArrayWithPlistName:(NSString *)name {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name
                                                     ofType:@"plist"];
    
    return [NSArray arrayWithContentsOfFile:path];
}

+ (NSArray *)yj_getArrayWithJSONString:(NSString *)jsonString {
    
    if ([NSString yj_checkEmptyWithString:jsonString]) {

        return nil;
    }
    
    NSData *yj_jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *yj_error;
    
    NSArray *yj_jsonArray = [NSJSONSerialization JSONObjectWithData:yj_jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&yj_error];
    
    return yj_jsonArray;
}

@end

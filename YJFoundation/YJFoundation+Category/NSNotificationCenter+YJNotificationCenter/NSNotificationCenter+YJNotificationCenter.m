//
//  NSNotificationCenter+YJNotificationCenter.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSNotificationCenter+YJNotificationCenter.h"
#import "NSDictionary+YJDictionary.h"
#include <pthread.h>

@implementation NSNotificationCenter (YJNotificationCenter)

- (void)yj_postNotificationOnMainThread:(NSNotification *)notification {
    
    if (pthread_main_np()) {
        
        return [self postNotification:notification];
    }
    
    [self yj_postNotificationOnMainThread:notification
                            waitUntilDone:NO];
}

- (void)yj_postNotificationOnMainThread:(NSNotification *)notification
                          waitUntilDone:(BOOL)wait {
    
    if (pthread_main_np()) {
        
        return [self postNotification:notification];
    }
    
    [[self class] performSelectorOnMainThread:@selector(yj_postNotification:)
                                   withObject:notification
                                waitUntilDone:wait];
}

- (void)yj_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(id)object {
    
    if (pthread_main_np()) {
        
        return [self postNotificationName:name
                                   object:object
                                 userInfo:nil];
    }
    
    [self yj_postNotificationOnMainThreadWithName:name
                                           object:object
                                         userInfo:[NSDictionary dictionary]
                                    waitUntilDone:NO];
}

- (void)yj_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(id)object
                                       userInfo:(NSDictionary *)userInfo {
    
    if (pthread_main_np()) {
        
        return [self postNotificationName:name
                                   object:object
                                 userInfo:userInfo];
    }
    
    [self yj_postNotificationOnMainThreadWithName:name
                                           object:object
                                         userInfo:userInfo
                                    waitUntilDone:NO];
}

- (void)yj_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(id)object
                                       userInfo:(NSDictionary *)userInfo
                                  waitUntilDone:(BOOL)wait {
    
    if (pthread_main_np()) {
        
        return [self postNotificationName:name
                                   object:object
                                 userInfo:userInfo];
    }
    
    NSMutableDictionary *info = [[NSMutableDictionary allocWithZone:nil] initWithCapacity:3];
    
    if (name) {
        [info setObject:name forKey:@"name"];
    }
    
    if (object) {
        
        [info setObject:object forKey:@"object"];
    }
    
    if (userInfo) {
        
        [info setObject:userInfo forKey:@"userInfo"];
    }
    
    [[self class] performSelectorOnMainThread:@selector(yj_postNotificationWithInfo:)
                                   withObject:info
                                waitUntilDone:wait];
}

+ (void)yj_postNotification:(NSNotification *)notification {
    
    [[self defaultCenter] postNotification:notification];
}

+ (void)yj_postNotificationWithInfo:(NSDictionary *)info {
    
    NSString *yj_name = [info objectForKey:@"name"];
    
    id yj_object = [info objectForKey:@"object"];
    
    NSDictionary *yj_userInfo = [info objectForKey:@"userInfo"];
    
    [[self defaultCenter] postNotificationName:yj_name
                                        object:yj_object
                                      userInfo:yj_userInfo];
}


@end

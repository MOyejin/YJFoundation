//
//  NSNotificationCenter+YJNotificationCenter.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationCenter (YJNotificationCenter)

/**
 在主线程上给指定的NSNotification发送通知, 如果当前线程为主线程, 则会同步发送, 否则就异步发送.
 
 @param notification NSNotification, 不能为空, 否则会发生异常
 */
- (void)yj_postNotificationOnMainThread:(NSNotification *)notification;

/**
 在主线程上给指定的NSNotification发送通知
 
 @param notification NSNotification, 不能为空, 否则会发生异常
 @param wait BOOL 是否阻塞当前的线程
 */
- (void)yj_postNotificationOnMainThread:(NSNotification *)notification
                          waitUntilDone:(BOOL)wait;

/**
 给指定的NSNotification发送通知
 
 @param name NSNotification Name
 @param object id
 */
- (void)yj_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(nullable id)object;

/**
 给指定的NSNotification发送通知
 
 @param name NSNotification Name
 @param object id
 @param userInfo NSDictionary
 */
- (void)yj_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(nullable id)object
                                       userInfo:(NSDictionary *)userInfo;

/**
 给指定的NSNotification发送通知
 
 @param name NSNotification Name
 @param object id
 @param userInfo NSDictionary
 @param wait BOOL 是否阻塞当前的线程
 */
- (void)yj_postNotificationOnMainThreadWithName:(NSString *)name
                                         object:(nullable id)object
                                       userInfo:(NSDictionary *)userInfo
                                  waitUntilDone:(BOOL)wait;

@end

NS_ASSUME_NONNULL_END

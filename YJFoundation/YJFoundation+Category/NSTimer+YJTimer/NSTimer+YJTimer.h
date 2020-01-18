//
//  NSTimer+YJTimer.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YJTimer)(void);

@interface NSTimer (YJTimer)

/**
 创建一个NSTimer对象, 并添加进当前线程
 
 @param timeInterval NSTimeInterval
 @param repeats BOOL
 @param complete YJTimer
 @return NSTimer
 */
+ (NSTimer *)yj_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                       repeats:(BOOL)repeats
                                      complete:(YJTimer)complete;

/**
 创建一个NSTimer对象
 
 @param timeInterval NSTimeInterval
 @param repeats BOOL
 @param complete YJTimer
 @return NSTimer
 */
+ (NSTimer *)yj_timerWithTimeInterval:(NSTimeInterval)timeInterval
                              repeats:(BOOL)repeats
                             complete:(YJTimer)complete;

/**
 开始NSTimer
 */
- (void)yj_resumeTimer;

/**
 暂停NSTimer
 */
- (void)yj_pauseTimer;

/**
 延迟指定的时间执行NSTimer
 
 @param timeInterval NSTimeInterval
 */
- (void)yj_resumeTimerAfterTimeInterval:(NSTimeInterval)timeInterval;


@end

NS_ASSUME_NONNULL_END

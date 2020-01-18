//
//  NSTimer+YJTimer.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSTimer+YJTimer.h"

@implementation NSTimer (YJTimer)

+ (NSTimer *)yj_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                       repeats:(BOOL)repeats
                                      complete:(YJTimer)complete {
    
    return [self scheduledTimerWithTimeInterval:timeInterval
                                         target:self
                                       selector:@selector(yj_timerBlock:)
                                       userInfo:complete
                                        repeats:repeats];
}

+ (NSTimer *)yj_timerWithTimeInterval:(NSTimeInterval)timeInterval
                              repeats:(BOOL)repeats
                             complete:(YJTimer)complete {
    
    return [self timerWithTimeInterval:timeInterval
                                target:self
                              selector:@selector(yj_timerBlock:)
                              userInfo:complete
                               repeats:repeats];
}

+ (void)yj_timerBlock:(NSTimer *)timer; {
    
    if([timer userInfo]) {
        
        void (^yj_block)(void) = (void (^)(void))[timer userInfo];
        
        yj_block();
    }
}

- (void)yj_resumeTimer {
    
    if (![self isValid]) {
        return ;
    }
    
    [self setFireDate:[NSDate date]];
}

- (void)yj_pauseTimer {
    
    if (![self isValid]) {
        
        return ;
    }
    
    [self setFireDate:[NSDate distantFuture]];
}

- (void)yj_resumeTimerAfterTimeInterval:(NSTimeInterval)timeInterval {
    
    if (![self isValid]) {
        
        return ;
    }
    
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
}


@end

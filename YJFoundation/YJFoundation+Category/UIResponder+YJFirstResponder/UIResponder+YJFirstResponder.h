//
//  UIResponder+YJFirstResponder.h
//  YJFoundationDemo
//
//  Created by EStrongerE023 on 2021/4/22.
//  Copyright © 2021 Moyejin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (YJFirstResponder)

/**
 * 获取当前界面键盘第一响应者
 */
+ (id)yj_getCurrentFirstResponder;

@end

NS_ASSUME_NONNULL_END

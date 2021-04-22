//
//  UIResponder+YJFirstResponder.m
//  YJFoundationDemo
//
//  Created by EStrongerE023 on 2021/4/22.
//  Copyright © 2021 Moyejin. All rights reserved.
//

#import "UIResponder+YJFirstResponder.h"

static __weak id currentFirstResponder;


@implementation UIResponder (YJFirstResponder)


+ (id)yj_getCurrentFirstResponder {

    currentFirstResponder = nil;

    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];

    return currentFirstResponder;

}

 

- (void)findFirstResponder:(id)sender {

    currentFirstResponder = self;

}

@end

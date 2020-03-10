//
//  YJFoundation.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/14.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#ifndef YJFoundation_h
#define YJFoundation_h

#pragma mark - NSString+YJString
#import "NSString+YJString.h"

#pragma mark - NSAttributedString+YJAttributedString
#import "NSAttributedString+YJAttributedString.h"

#pragma mark - NSArray+YJArray
#import "NSArray+YJArray.h"

#pragma mark - NSMutableArray+YJMutableArray
#import "NSMutableArray+YJMutableArray.h"

#pragma mark - NSMutableAttributedString+YJMutableAttributedStrin
#import "NSMutableAttributedString+YJMutableAttributedString.h"

#pragma mark - NSDictionary+YJDictionary
#import "NSDictionary+YJDictionary.h"

#pragma mark - NSMutableDictionary+YJMutableDictionary
#import "NSMutableDictionary+YJMutableDictionary.h"

#pragma mark - NSURL+YJURL
#import "NSURL+YJURL.h"

#pragma mark - NSData+YJData
#import "NSData+YJData.h"

#pragma mark - NSDate+YJDate
#import "NSDate+YJDate.h"

#pragma mark - NSBundle+YJBundle
#import "NSBundle+YJBundle.h"

#pragma mark - NSFileManager+YJFileManager
#import "NSFileManager+YJFileManager.h"

#pragma mark - NSTimer+YJTimer
#import "NSTimer+YJTimer.h"

#pragma mark - NSObject+YJObject
//#import "NSObject+YJObject.h"

#pragma mark - NSNumber+YJNumber
#import "NSNumber+YJNumber.h"

#pragma mark - NSNotificationCenter+YJNotificationCenter
#import "NSNotificationCenter+YJNotificationCenter.h"

#endif /* YJFoundation_h */


#pragma mark - Define

#define YJ_GET_METHOD_RETURN_OBJC(objc) if (objc) return objc

#define YJ_WEAK_SELF(type)  __weak __typeof(&*self)weakSelf = self
#define YJ_STRONG_SELF(type)  __strong __typeof(&*self)weakSelf = self

#define YJ_ANGLE_TO_RADIAN(x) (M_PI * (x) / 180.0)
#define YJ_RADIAN_TO_ANGLE(radian) (radian * 180.0) / (M_PI)

#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

//
//  NSNumber+YJNumber.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (YJNumber)

/**
 显示向最近的整数四舍五入取整的字符串
 
 @param number NSNumber
 @param digit NSUInteger, 限制位数
 @return NSString
 */
+ (NSString *)yj_displayDecimalWithNumber:(NSNumber *)number
                                    digit:(NSUInteger)digit;

/**
 显示向最近的整数四舍五入取整并添加了货币符号NSNumber的NSString
 
 @param number NSNumber
 @param digit NSUInteger, 限制位数
 @return NSString
 */
+ (NSString *)yj_displayCurrencyWithNumber:(NSNumber *)number
                                     digit:(NSUInteger)digit;

/**
 显示向最近的整数四舍五入取整并添加了百分号NSNumber的NSString
 
 @param number NSNumber
 @param digit NSUInteger, 限制位数
 @return NSString
 */
+ (NSString *)yj_displayPercentWithNumber:(NSNumber *)number
                                    digit:(NSUInteger)digit;

/**
 向最近的整数四舍五入取整
 
 @param number NSNumber
 @param digit NSUInteger, 限制位数
 @return NSNumber
 */
+ (NSNumber *)yj_roundingWithNumber:(NSNumber *)number
                              digit:(NSUInteger)digit;

/**
 正无穷的四舍五入取整
 
 @param number NSNumber
 @param digit NSUInteger, 最大限制多少位数
 @return NSNumber
 */
+ (NSNumber *)yj_roundCeilingWithNumber:(NSNumber *)number
                                  digit:(NSUInteger)digit;

/**
 负无穷的四舍五入取整
 
 @param number NSNumber
 @param digit NSUInteger, 最大限制多少位数
 @return NSNumber
 */
+ (NSNumber *)yj_roundFloorWithNumber:(NSNumber *)number
                                digit:(NSUInteger)digit;

#pragma mark - NSNumber转换
/**
 将字符串数字转换成NSNumber, 支持的格式为@"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string NSString
 @return NSNumber
 */
+ (NSNumber *)yj_numberWithString:(NSString *)string;


@end

NS_ASSUME_NONNULL_END

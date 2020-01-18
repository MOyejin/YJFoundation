//
//  NSAttributedString+YJAttributedString.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (YJAttributedString)


/**
 根据富文本的宽度返回文字的高度
 
 @param width 宽度
 @return CGFloat
 */
- (CGFloat)yj_attributedStringHeightWithContainWidth:(CGFloat)width;

/**
 修改指定Range字符串的颜色
 
 @param string 字符串
 @param color 颜色
 @param range NSRange
 @return NSAttributedString
 */
+ (NSAttributedString *)yj_attributeStringWithString:(NSString *)string
                                               color:(UIColor *)color
                                               range:(NSRange)range;

/**
 修改指定Range字符串的颜色
 
 @param attributedString attributedString字符串
 @param color 颜色
 @param range NSRange
 @return NSAttributedString
 */
+ (NSAttributedString *)yj_attributeStringWithAttributedString:(NSAttributedString *)attributedString
                                                         color:(UIColor *)color
                                                         range:(NSRange)range;
/**
 修改指定Range字符串的字体
 
 @param string 字符串
 @param font 字体
 @param range NSRange
 @return NSAttributedString
 */
+ (NSAttributedString *)yj_attributeStringWithString:(NSString *)string
                                                font:(UIFont *)font
                                               range:(NSRange)range;

/**
 修改指定Range字符串的字体
 
 @param attributedString attributedString字符串
 @param font 字体
 @param range NSRange
 @return NSAttributedString
 */
+ (NSAttributedString *)yj_attributeStringWithAttributedString:(NSAttributedString *)attributedString
                                                          font:(UIFont *)font
                                                         range:(NSRange)range;
/**
 返回设置好的NSAttributedString
 
 @param prefixString 前缀String
 @param prefixFont   前缀字体大小
 @param suffixString 尾缀String
 @param suffixFont   尾缀字体大小
 @return NSAttributedString
 */
+ (NSAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
                                                prefixFont:(UIFont *)prefixFont
                                              suffixString:(NSString *)suffixString
                                                suffixFont:(UIFont *)suffixFont;
/**
 返回设置好的NSAttributedString
 
 @param prefixString 前缀String
 @param prefixFont   前缀字体大小
 @param prefixColor  前缀字体颜色
 @param suffixString 尾缀String
 @param suffixFont   尾缀字体大小
 @param suffixColor  尾缀字体颜色
 @return NSAttributedString
 */
+ (NSAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
                                                prefixFont:(UIFont *)prefixFont
                                               prefixColor:(UIColor *)prefixColor
                                              suffixString:(NSString *)suffixString
                                                suffixFont:(UIFont *)suffixFont
                                               suffixColor:(UIColor *)suffixColor;


@end

NS_ASSUME_NONNULL_END

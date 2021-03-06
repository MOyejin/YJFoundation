//
//  NSMutableAttributedString+YJMutableAttributedString.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (YJMutableAttributedString)

/**
 添加图片在字符串之前
 
 @param subffixString 字符串
 @param subffixImage 图片
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributeStringWithSubffixString:(NSString *)subffixString
                                                      subffixImage:(UIImage *)subffixImage;

/**
 添加图片在字符串之前
 
 @param subffixString 字符串
 @param imageFrame CGRect
 @param subffixImage 图片
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributeStringWithSubffixString:(NSString *)subffixString
                                                        imageFrame:(CGRect)imageFrame
                                                      subffixImage:(UIImage *)subffixImage;

/**
 添加多张图片在字符串之前
 
 @param subffixString 字符串
 @param subffixImages 图片数组
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributeStringWithSubffixString:(NSString *)subffixString
                                                     subffixImages:(NSArray<UIImage *> *)subffixImages;
/**
 添加图片在字符串之后
 
 @param prefixString 富文本
 @param prefixImage 图片
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
                                                      prefixImage:(UIImage *)prefixImage;

/**
 添加图片在字符串之后
 
 @param prefixString 富文本
 @param imageFrame CGRect
 @param prefixImage 图片
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
                                                       imageFrame:(CGRect)imageFrame
                                                      prefixImage:(UIImage *)prefixImage;

/**
 添加多张图片在字符串之前
 
 @param prefixString 字符串
 @param prefixImages 图片数组
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
                                                     prefixImages:(NSArray<UIImage *> *)prefixImages;

/**
 给指定字符串设置行距
 
 @param string 字符串
 @param lineSpacing 行距
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributedStringWithString:(NSString *)string
                                                 lineSpacing:(CGFloat)lineSpacing;

/**
 给指定字符串设置行距
 
 @param string 字符串
 @param lineSpacing 行距
 @param alignment 字体位置
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributedStringWithString:(NSString *)string
                                                 lineSpacing:(CGFloat)lineSpacing
                                                   alignment:(NSTextAlignment)alignment;

/**
 给指定富文本字符串设置行距
 
 @param attributedString NSAttributedString
 @param lineSpacing 行距
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributedStringWithAttributedString:(NSAttributedString *)attributedString
                                                           lineSpacing:(CGFloat)lineSpacing;


/**
 给指定富文本字符串设置行距
 
 @param attributedString NSAttributedString
 @param lineSpacing 行距
 @param alignment 字体位置
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributedStringWithAttributedString:(NSAttributedString *)attributedString
                                                           lineSpacing:(CGFloat)lineSpacing
                                                             alignment:(NSTextAlignment)alignment;
/**
 给指定字符串添加下划线
 
 @param string NSString
 @param range NSRange
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributedStringAddLineWithString:(NSString *)string
                                                              range:(NSRange)range;

/**
 给指定富文本字符串添加下划线
 
 @param attributedString NSAttributedString
 @param range NSRange
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)yj_attributedStringAddLineWithAttributedString:(NSAttributedString *)attributedString
                                                                        range:(NSRange)range;


@end

NS_ASSUME_NONNULL_END

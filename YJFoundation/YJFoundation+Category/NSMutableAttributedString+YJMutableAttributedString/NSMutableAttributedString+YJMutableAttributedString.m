//
//  NSMutableAttributedString+YJMutableAttributedString.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSMutableAttributedString+YJMutableAttributedString.h"
#import "NSString+YJString.h"

@implementation NSMutableAttributedString (YJMutableAttributedString)

+ (NSMutableAttributedString *)yj_attributeStringWithSubffixString:(NSString *)subffixString
                                                      subffixImage:(UIImage *)subffixImage {
    
    return [self yj_attributeStringWithSubffixString:subffixString
                                          imageFrame:CGRectMake(0, -2, subffixImage.size.width, subffixImage.size.height)
                                        subffixImage:subffixImage];
}

+ (NSMutableAttributedString *)yj_attributeStringWithSubffixString:(NSString *)subffixString
                                                        imageFrame:(CGRect)imageFrame
                                                      subffixImage:(UIImage *)subffixImage {
    
    NSMutableAttributedString *yj_mutableAttributedString = [[NSMutableAttributedString alloc] init];
    
    NSTextAttachment *yj_backAttachment = [[NSTextAttachment alloc] init];
    
    yj_backAttachment.image  = subffixImage;
    yj_backAttachment.bounds = imageFrame;
    
    NSAttributedString *yj_backString = [NSAttributedString attributedStringWithAttachment:yj_backAttachment];
    NSAttributedString *yj_attributedString = [[NSAttributedString alloc] initWithString:subffixString];
    
    [yj_mutableAttributedString appendAttributedString:yj_backString];
    [yj_mutableAttributedString appendAttributedString:yj_attributedString];
    
    return yj_mutableAttributedString;
}

+ (NSMutableAttributedString *)yj_attributeStringWithSubffixString:(NSString *)subffixString
                                                     subffixImages:(NSArray<UIImage *> *)subffixImages {
    
    NSMutableAttributedString *yj_mutableAttributedString = [[NSMutableAttributedString alloc] init];
    
    [subffixImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSTextAttachment *yj_backAttachment = [[NSTextAttachment alloc] init];
        
        yj_backAttachment.image = obj;
        yj_backAttachment.bounds = CGRectMake(0, -2, obj.size.width, obj.size.height);
        
        NSAttributedString *yj_backString = [NSAttributedString attributedStringWithAttachment:yj_backAttachment];
        
        [yj_mutableAttributedString appendAttributedString:yj_backString];
    }];
    
    NSAttributedString *yj_attributedString = [[NSAttributedString alloc] initWithString:subffixString];
    
    [yj_mutableAttributedString appendAttributedString:yj_attributedString];
    
    return yj_mutableAttributedString;
}

+ (NSMutableAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
                                                      prefixImage:(UIImage *)prefixImage {
    
    return [self yj_attributeStringWithPrefixString:prefixString
                                         imageFrame:CGRectMake(0, -2, prefixImage.size.width, prefixImage.size.height)
                                        prefixImage:prefixImage];
}

+ (NSMutableAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
                                                       imageFrame:(CGRect)imageFrame
                                                      prefixImage:(UIImage *)prefixImage {
    
    NSMutableAttributedString *yj_mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:prefixString];
    
    NSTextAttachment *yj_backAttachment = [[NSTextAttachment alloc] init];
    
    yj_backAttachment.image  = prefixImage;
    yj_backAttachment.bounds = imageFrame;
    
    NSAttributedString *yj_backString = [NSAttributedString attributedStringWithAttachment:yj_backAttachment];
    
    [yj_mutableAttributedString appendAttributedString:yj_backString];
    
    return yj_mutableAttributedString;
}

+ (NSMutableAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
                                                     prefixImages:(NSArray<UIImage *> *)prefixImages {
    
    NSMutableAttributedString *yj_mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:prefixString];
    
    [prefixImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSTextAttachment *yj_backAttachment = [[NSTextAttachment alloc] init];
        
        yj_backAttachment.image = obj;
        yj_backAttachment.bounds = CGRectMake(0, -2, obj.size.width, obj.size.height);
        
        NSAttributedString *yj_backString = [NSAttributedString attributedStringWithAttachment:yj_backAttachment];
        
        [yj_mutableAttributedString appendAttributedString:yj_backString];
    }];
    
    return yj_mutableAttributedString;
}

+ (NSMutableAttributedString *)yj_attributedStringWithString:(NSString *)string
                                                 lineSpacing:(CGFloat)lineSpacing {
    
    if ([NSString yj_checkEmptyWithString:string]) {
        
        return nil;
    }
    
    NSMutableAttributedString *yj_attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [yj_attributedString addAttribute:NSParagraphStyleAttributeName
                                value:paragraphStyle
                                range:NSMakeRange(0, [string length])];
    
    return yj_attributedString;
}

+ (NSMutableAttributedString *)yj_attributedStringWithAttributedString:(NSAttributedString *)attributedString
                                                           lineSpacing:(CGFloat)lineSpacing {
    
    if (attributedString.length <= 0) {
        
        return nil;
    }
    
    NSMutableAttributedString *yj_attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [yj_attributedString addAttribute:NSParagraphStyleAttributeName
                                value:paragraphStyle
                                range:NSMakeRange(0, [attributedString length])];
    
    return yj_attributedString;
}

+ (NSMutableAttributedString *)yj_attributedStringAddLineWithAttributedString:(NSAttributedString *)attributedString
                                                                        range:(NSRange)range {
    
    if (attributedString.length <= 0) {
        
        return nil;
    }
    
    NSMutableAttributedString *yj_mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    [yj_mutableAttributedString addAttribute:NSUnderlineStyleAttributeName
                                       value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                                       range:range];
    
    return yj_mutableAttributedString;
}

+ (NSMutableAttributedString *)yj_attributedStringAddLineWithString:(NSString *)string
                                                              range:(NSRange)range {
    
    if ([NSString yj_checkEmptyWithString:string]) {
        
        return nil;
    }
    
    NSMutableAttributedString *yj_mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [yj_mutableAttributedString addAttribute:NSUnderlineStyleAttributeName
                                       value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                                       range:range];
    
    return yj_mutableAttributedString;
}


@end

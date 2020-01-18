//
//  NSNumber+YJNumber.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSNumber+YJNumber.h"
#import "NSString+YJString.h"

@implementation NSNumber (YJNumber)

#pragma mark - NSNumber显示字符串
+ (NSString *)yj_displayDecimalWithNumber:(NSNumber *)number
                                    digit:(NSUInteger)digit {
    
    NSNumberFormatter *yj_numberFormatter = [self yj_numberFormatterWithRoundingMode:NSNumberFormatterRoundHalfUp];
    
    yj_numberFormatter.numberStyle           = NSNumberFormatterDecimalStyle;
    yj_numberFormatter.maximumFractionDigits = digit;
    
    return [yj_numberFormatter stringFromNumber:number];
}

+ (NSString *)yj_displayCurrencyWithNumber:(NSNumber *)number
                                     digit:(NSUInteger)digit {
    
    NSNumberFormatter *yj_numberFormatter = [self yj_numberFormatterWithRoundingMode:NSNumberFormatterRoundHalfUp];
    
    yj_numberFormatter.numberStyle           = NSNumberFormatterCurrencyStyle;
    yj_numberFormatter.maximumFractionDigits = digit;
    
    return [yj_numberFormatter stringFromNumber:number];
}

+ (NSString *)yj_displayPercentWithNumber:(NSNumber *)number
                                    digit:(NSUInteger)digit {
    
    NSNumberFormatter *yj_numberFormatter = [self yj_numberFormatterWithRoundingMode:NSNumberFormatterRoundHalfUp];
    
    yj_numberFormatter.numberStyle           = NSNumberFormatterPercentStyle;
    yj_numberFormatter.maximumFractionDigits = digit;
    
    return [yj_numberFormatter stringFromNumber:number];
}

#pragma mark - NSNumber四舍五入
+ (NSNumber *)yj_roundingWithNumber:(NSNumber *)number
                              digit:(NSUInteger)digit {
    
    NSNumberFormatter *yj_numberFormatter = [self yj_numberFormatterWithRoundingMode:NSNumberFormatterRoundHalfUp];
    
    yj_numberFormatter.maximumFractionDigits = digit;
    yj_numberFormatter.minimumFractionDigits = digit;
    
    NSString *yj_numberString = [yj_numberFormatter stringFromNumber:number];
    
    return [NSNumber numberWithDouble:[yj_numberString doubleValue]];
}

+ (NSNumber *)yj_roundCeilingWithNumber:(NSNumber *)number
                                  digit:(NSUInteger)digit {
    
    NSNumberFormatter *yj_numberFormatter = [self yj_numberFormatterWithRoundingMode:NSNumberFormatterRoundCeiling];
    
    yj_numberFormatter.maximumFractionDigits = digit;
    
    NSString *yj_numberString = [yj_numberFormatter stringFromNumber:number];
    
    return [NSNumber numberWithDouble:[yj_numberString doubleValue]];
}

+ (NSNumber *)yj_roundFloorWithNumber:(NSNumber *)number
                                digit:(NSUInteger)digit {
    
    NSNumberFormatter *yj_numberFormatter = [self yj_numberFormatterWithRoundingMode:NSNumberFormatterRoundFloor];
    
    yj_numberFormatter.maximumFractionDigits = digit;
    
    NSString *yj_numberString = [yj_numberFormatter stringFromNumber:number];
    
    return [NSNumber numberWithDouble:[yj_numberString doubleValue]];
}

+ (NSNumberFormatter *)yj_numberFormatterWithRoundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    
    NSNumberFormatter *yj_numberFormatter = [[NSNumberFormatter alloc] init];
    
    yj_numberFormatter.roundingMode = roundingMode;
    
    return yj_numberFormatter;
}

#pragma mark - NSNumber转换
+ (NSNumber *)yj_numberWithString:(NSString *)string {
    
    NSString *yj_string = [[string yj_trimmedString] lowercaseString];
    
    if ([NSString yj_checkEmptyWithString:yj_string]) {
        
        return nil;
    }
    
    static NSDictionary *yj_dictionary;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        yj_dictionary = @{@"true" :   @(YES),
                          @"yes" :    @(YES),
                          @"false" :  @(NO),
                          @"no" :     @(NO),
                          @"nil" :    [NSNull null],
                          @"null" :   [NSNull null],
                          @"<null>" : [NSNull null]};
    });
    
    NSNumber *yj_number = yj_dictionary[yj_string];
    
    if (yj_number != nil) {
        
        if (yj_number == (id)[NSNull null])  {
            return nil;
        }
        
        return yj_number;
    }
    
    // hex number
    NSInteger yj_sign = 0;
    
    if ([yj_string hasPrefix:@"0x"]) {
        yj_sign = 1;
        
    } else if ([yj_string hasPrefix:@"-0x"]) {
        yj_sign = -1;
        
    }
    
    if (yj_sign != 0) {
        
        NSScanner *scan = [NSScanner scannerWithString:yj_string];
        
        unsigned num = -1;
        
        BOOL yj_suc = [scan scanHexInt:&num];
        
        if (yj_suc) {
            
            return [NSNumber numberWithLong:((long)num * yj_sign)];
            
        } else {
            return nil;
        }
    }
    
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [formatter numberFromString:string];
}


@end

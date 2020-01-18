//
//  NSString+YJString.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSString+YJString.h"
#import "NSData+YJData.h"
#import <CommonCrypto/CommonDigest.h>

static char yj_base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (YJString)


#pragma mark - 字符串计算
- (CGFloat)yj_heightWithFontSize:(CGFloat)fontSize
                           width:(CGFloat)width {
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    
    return  [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                            attributes:attributes
                               context:nil].size.height;
}

+ (CGFloat)yj_measureHeightWithMutilineString:(NSString *)string
                                         font:(UIFont *)font
                                        width:(CGFloat)width {
    
    if ([self yj_checkEmptyWithString:string] || width <= 0) {
        
        return 0;
    }
    
    CGSize yj_stringSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:font}
                                                context:nil].size;
    
    return ceil(yj_stringSize.height);
}

+ (CGFloat)yj_measureSingleLineStringWidthWithString:(NSString *)string
                                                font:(UIFont *)font {
    
    if ([self yj_checkEmptyWithString:string]) {
        
        return 0;
    }
    
    CGSize yj_stringSize = [string boundingRectWithSize:CGSizeMake(0, 0)
                                                options:NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName:font}
                                                context:nil].size;
    
    return ceil(yj_stringSize.width);
}

+ (CGSize)yj_measureStringSizeWithString:(NSString *)string
                                    font:(UIFont *)font {
    
    if ([self yj_checkEmptyWithString:string]) {
        
        return CGSizeZero;
    }
    
    CGSize yj_stringSize = [string boundingRectWithSize:CGSizeMake(0, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:font}
                                                context:nil].size;
    
    return yj_stringSize;
}

+ (CGSize)yj_measureStringWithString:(NSString *)string
                                font:(UIFont *)font
                                size:(CGSize)size
                                mode:(NSLineBreakMode)lineBreakMode {
    
    CGSize yj_stringSize;
    
    if (!font) {
        
        font = [UIFont systemFontOfSize:12];
    }
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        NSMutableDictionary *yj_mutableDictionary = [NSMutableDictionary dictionary];
        
        yj_mutableDictionary[NSFontAttributeName] = font;
        
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            
            NSMutableParagraphStyle *yj_mutableParagraphStyle = [NSMutableParagraphStyle new];
            
            yj_mutableParagraphStyle.lineBreakMode = lineBreakMode;
            
            yj_mutableDictionary[NSParagraphStyleAttributeName] = yj_mutableParagraphStyle;
            
        }
        
        CGRect rect = [string boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:yj_mutableDictionary
                                           context:nil];
        yj_stringSize = rect.size;
        
    } else {
        
#pragma YJang diagnostic push
#pragma YJang diagnostic ignored "-Wdeprecated-deYJarations"
        yj_stringSize = [string sizeWithFont:font
                           constrainedToSize:size
                               lineBreakMode:lineBreakMode];
#pragma YJang diagnostic pop
    }
    
    return yj_stringSize;
}

#pragma mark - 字符串过滤
- (NSString *)yj_removeUnwantedZero {
    
    if ([[self substringWithRange:NSMakeRange(self.length - 3, 3)] isEqualToString:@"000"]) {
        
        return [self substringWithRange:NSMakeRange(0, self.length - 4)]; // 多一个小数点
        
    } else if ([[self substringWithRange:NSMakeRange(self.length - 2, 2)] isEqualToString:@"00"]) {
        
        return [self substringWithRange:NSMakeRange(0, self.length - 2)];
        
    } else if ([[self substringWithRange:NSMakeRange(self.length - 1, 1)] isEqualToString:@"0"]) {
        
        return [self substringWithRange:NSMakeRange(0, self.length - 1)];
    } else {
        return self;
    }
}

- (NSString *)yj_trimmedString {
    
    NSCharacterSet *yj_characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    return [self stringByTrimmingCharactersInSet:yj_characterSet];
}

- (NSString *)yj_trimmedAllString {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)yj_removeStringCharacterWithCharacter:(NSString *)character {
    
    return [self stringByReplacingOccurrencesOfString:character
                                           withString:@""];
}

#pragma mark - 字符串转换
+ (NSString *)yj_urlQueryStringWithDictionary:(NSDictionary *)dictionary {
    
    NSMutableString *string = [NSMutableString string];
    
    for (NSString *key in [dictionary allKeys]) {
        
        if ([string length]) {
            
            [string appendString:@"&"];
        }
        
        NSString *yj_charactersToEscape = @"!*'();:@&=+$,/?%#[]";
        
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:yj_charactersToEscape]
                                             invertedSet];
        
        NSString *escaped = [[[dictionary objectForKey:key] description] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];

        [string appendFormat:@"%@=%@", key, escaped];

    }
    return string;
}

+ (NSString *)yj_jsonStringWithObject:(NSObject *)object {
    
    if ([NSJSONSerialization isValidJSONObject:object]) {
        
        NSError *yj_error;
        NSData *yj_JSONData = [NSJSONSerialization dataWithJSONObject:object
                                                              options:0
                                                                error:&yj_error];
        
        NSString *yj_jsonString = [[NSString alloc] initWithData:yj_JSONData
                                                        encoding:NSUTF8StringEncoding];
        return yj_jsonString;
    }
    
    return nil;
}

+ (NSString *)yj_jsonPrettyStringWithObject:(NSObject *)object {
    
    if ([NSJSONSerialization isValidJSONObject:object]) {
        
        NSError *yj_error;
        NSData *yj_JSONData = [NSJSONSerialization dataWithJSONObject:object
                                                              options:NSJSONWritingPrettyPrinted
                                                                error:&yj_error];
        
        NSString *yj_jsonString = [[NSString alloc] initWithData:yj_JSONData
                                                        encoding:NSUTF8StringEncoding];
        return yj_jsonString;
    }
    
    return nil;
}

+ (NSString *)yj_urlEncodeWithString:(NSString *)string {
    
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m
         
         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
         - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
         - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to inYJude a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
         - parameter string: The string to be percent-escaped.
         - returns: The percent-escaped string.
         */
        static NSString *const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not inYJude "?" or "/" due to RFC 3986 - Section 3.4
        static NSString *const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet *yj_mutableCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        
        NSString *yj_charactersInString = [kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode];
        
        [yj_mutableCharacterSet removeCharactersInString:yj_charactersInString];
        
        static NSUInteger const yj_batchSize = 50;
        
        NSUInteger yj_index = 0;
        
        NSMutableString *yj_escaped = @"".mutableCopy;
        
        while (yj_index < string.length) {
            
            NSUInteger yj_length = MIN(string.length - yj_index, yj_batchSize);
            
            NSRange yj_range = NSMakeRange(yj_index, yj_length);
            
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            yj_range = [string rangeOfComposedCharacterSequencesForRange:yj_range];
            
            NSString *yj_substring = [string substringWithRange:yj_range];
            
            NSString *yj_encodedString = [yj_substring stringByAddingPercentEncodingWithAllowedCharacters:yj_mutableCharacterSet];
            
            [yj_escaped appendString:yj_encodedString];
            
            yj_index += yj_range.length;
        }
        
        return yj_escaped;
        
    } else {
#pragma YJang diagnostic push
#pragma YJang diagnostic ignored "-Wdeprecated-deYJarations"
        
        CFStringEncoding yj_cfStringEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        
        NSString *yj_encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                           (__bridge CFStringRef)string,
                                                                                                           NULL,
                                                                                                           CFSTR("!#$&'()*+,/:;=?@[]"),
                                                                                                           yj_cfStringEncoding);
        return yj_encodedString;
#pragma YJang diagnostic pop
    }
}

+ (NSString *)yj_urlDecodeWithString:(NSString *)string {
    
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        
        return [string stringByRemovingPercentEncoding];
        
    } else {
#pragma YJang diagnostic push
#pragma YJang diagnostic ignored "-Wdeprecated-deYJarations"
        CFStringEncoding yj_cfStringEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *yj_decodedString = [string stringByReplacingOccurrencesOfString:@"+"
                                                                       withString:@" "];
        yj_decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                 (__bridge CFStringRef)yj_decodedString,
                                                                                                                 CFSTR(""),
                                                                                                                 yj_cfStringEncoding);
        return yj_decodedString;
#pragma YJang diagnostic pop
    }
}

+ (NSString *)yj_escapingHTMLWithString:(NSString *)string {
    
    NSUInteger yj_stringLength = string.length;
    
    if (!yj_stringLength) {
        return string;
    }
    
    unichar *yj_unicharBuf = malloc(sizeof(unichar) * yj_stringLength);
    
    if (!yj_unicharBuf) {
        return string;
    }
    
    [string getCharacters:yj_unicharBuf
                    range:NSMakeRange(0, yj_stringLength)];
    
    NSMutableString *yj_mutableString = [NSMutableString string];
    
    for (NSUInteger i = 0; i < yj_stringLength; i++) {
        
        unichar yj_unichar = yj_unicharBuf[i];
        
        NSString *yj_escString = nil;
        
        switch (yj_unichar) {
            case 34: yj_escString = @"&quot;"; break;
            case 38: yj_escString = @"&amp;"; break;
            case 39: yj_escString = @"&apos;"; break;
            case 60: yj_escString = @"&lt;"; break;
            case 62: yj_escString = @"&gt;"; break;
            default: break;
        }
        
        if (yj_escString) {
            
            [yj_mutableString appendString:yj_escString];
        } else {
            
            CFStringAppendCharacters((CFMutableStringRef)yj_mutableString, &yj_unichar, 1);
        }
    }
    
    free(yj_unicharBuf);
    
    return yj_mutableString;
}

+ (BOOL)yj_checkEmptyWithString:(NSString *)string {
    
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [string length] == 0 || [string isEqualToString: @"(null)"]) {
        
        return YES;
    }
    return NO;
}

- (BOOL)yj_checkStringEmpty {
    
    if (self == nil || self == NULL || [self isKindOfClass:[NSNull class]] || [self length] == 0 || [self isEqualToString: @"(null)"]) {
        
        return YES;
    }
    return NO;
}

#pragma mark - 进制字符串转换
+ (NSString *)yj_formatBinaryWithHexadecimal:(NSString *)hexadecimal {
    
    NSDictionary *yj_hexadecimalDictionary = @{@"0":@"0000",
                                               @"1":@"0001",
                                               @"2":@"0010",
                                               @"3":@"0011",
                                               @"4":@"0100",
                                               @"5":@"0101",
                                               @"6":@"0110",
                                               @"7":@"0111",
                                               @"8":@"1000",
                                               @"9":@"1001",
                                               @"A":@"1010",
                                               @"B":@"1011",
                                               @"C":@"1100",
                                               @"D":@"1101",
                                               @"E":@"1110",
                                               @"F":@"1111"};
    
    NSString *yj_binaryString = @"";
    
    for (NSInteger i = 0; i < hexadecimal.length; i++) {
        
        NSString *yj_hexadecimalKey   = [hexadecimal substringWithRange:NSMakeRange(i, 1)];
        NSString *yj_hexadecimalValue = yj_hexadecimalDictionary[yj_hexadecimalKey];
        
        if (yj_hexadecimalValue) {
            
            yj_binaryString = [yj_binaryString stringByAppendingString:yj_hexadecimalValue];
        }
    }
    return yj_binaryString;
}

+ (NSString *)yj_formatBinaryWithDecimal:(NSInteger)decimal {
    
    NSString *yj_binaryString = @"";
    
    while (decimal) {
        
        NSString *yj_decimalString = [NSString stringWithFormat:@"%ld", decimal % 2];
        
        yj_binaryString = [yj_decimalString stringByAppendingString:yj_binaryString];
        
        if (decimal / 2 < 1) {
            break;
        }
        
        decimal = decimal / 2;
    }
    
    if (yj_binaryString.length % 4 != 0) {
        
        NSMutableString *yj_mutableString = [[NSMutableString alloc] init];;
        
        for (NSInteger i = 0; i < 4 - yj_binaryString.length % 4; i++) {
            
            [yj_mutableString appendString:@"0"];
        }
        
        yj_binaryString = [yj_mutableString stringByAppendingString:yj_binaryString];
    }
    
    return yj_binaryString;
}

+ (NSString *)yj_formatHexadecimalWithBinary:(NSString *)binary {
    
    NSDictionary *yj_hexadecimalDictionary = @{@"0000":@"0",
                                               @"0001":@"1",
                                               @"0010":@"2",
                                               @"0011":@"3",
                                               @"0100":@"4",
                                               @"0101":@"5",
                                               @"0110":@"6",
                                               @"0111":@"7",
                                               @"1000":@"8",
                                               @"1001":@"9",
                                               @"1010":@"A",
                                               @"1011":@"B",
                                               @"1100":@"C",
                                               @"1101":@"D",
                                               @"1110":@"E",
                                               @"1111":@"F"};
    
    if (binary.length % 4 != 0) {
        
        NSMutableString *yj_mutableString = [[NSMutableString alloc] init];;
        
        for (NSInteger i = 0; i < 4 - binary.length % 4; i++) {
            
            [yj_mutableString appendString:@"0"];
        }
        
        binary = [yj_mutableString stringByAppendingString:binary];
    }
    
    NSString *yj_hexadecimalString = @"";
    
    for (NSInteger i = 0; i < binary.length; i += 4) {
        
        NSString *yj_hexadecimalKey = [binary substringWithRange:NSMakeRange(i, 4)];
        NSString *yj_hexadecimalValue = yj_hexadecimalDictionary[yj_hexadecimalKey];
        
        if (yj_hexadecimalValue) {
            
            yj_hexadecimalString = [yj_hexadecimalString stringByAppendingString:yj_hexadecimalValue];
        }
    }
    
    return yj_hexadecimalString;
}

+ (NSString *)yj_formatDecimalWithBinary:(NSString *)binary {
    
    NSInteger decimal = 0;
    
    for (NSInteger i = 0; i < binary.length; i++) {
        
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        
        if ([number isEqualToString:@"1"]) {
            
            decimal += pow(2, i);
        }
    }
    
    return [NSString stringWithFormat:@"%ld", decimal];
}

+ (NSString *)yj_formatHexadecimalWithData:(NSData *)data {
    
    if (!data) {
        return @"";
    }
    
    Byte *yj_dataByte = (Byte *)[data bytes];
    
    NSString *yj_formatHexString = @"";
    
    for (NSInteger i = 0; i < [data length]; i++) {
        
        NSString *yj_hexString = [NSString stringWithFormat:@"%x", yj_dataByte[i]&0xff];
        
        if([yj_hexString length] == 1)
            
            yj_formatHexString = [NSString stringWithFormat:@"%@0%@", yj_formatHexString, yj_hexString];
        else
            yj_formatHexString = [NSString stringWithFormat:@"%@%@", yj_formatHexString, yj_hexString];
    }
    
    return yj_formatHexString;
}

+ (NSString *)yj_formatHexadecimalWithDecimal:(NSInteger)decimal {
    
    NSString *yj_hexadecimalString = @"";
    
    NSString *yj_complementString;
    
    for (NSInteger i = 0; i < 9; i++) {
        
        NSInteger yj_number = decimal % 16;
        
        decimal = decimal / 16;
        
        switch (yj_number) {
                
            case 10:
                yj_complementString = @"A";
                break;
            case 11:
                yj_complementString = @"B";
                break;
            case 12:
                yj_complementString = @"C";
                break;
            case 13:
                yj_complementString = @"D";
                break;
            case 14:
                yj_complementString = @"E";
                break;
            case 15:
                yj_complementString = @"F";
                break;
            default:
                yj_complementString = [NSString stringWithFormat:@"%ld", yj_number];
        }
        
        yj_hexadecimalString = [yj_complementString stringByAppendingString:yj_hexadecimalString];
        
        if (decimal == 0) {
            
            break;
        }
    }
    
    return yj_hexadecimalString;
}

#pragma mark - 字符串格式化
+ (NSString *)yj_getNumberWithString:(NSString *)string {
    
    NSMutableString *yj_string = [[NSMutableString alloc] init];
    
    for (NSInteger i = 0; i < string.length; i++) {
        
        NSString *yj_numberString = [string substringWithRange:NSMakeRange(i, 1)];
        
        if ([yj_numberString yj_isNumber]) {
            
            [yj_string appendString:yj_numberString];
        }
    }
    
    return yj_string;
}

+ (NSString *)yj_getSecrectStringWithCardNumber:(NSString *)cardNumber {
    
    if (cardNumber.length < 8) {
        
        return nil;
    }
    
    NSMutableString *yj_cardNumber = [NSMutableString stringWithString:cardNumber];
    
    NSRange yj_cardRange = NSMakeRange(4, 8);
    
    [yj_cardNumber replaceCharactersInRange:yj_cardRange
                                 withString:@" **** **** "];
    
    return yj_cardNumber;
}

+ (NSString *)yj_getSecrectStringWithPhoneNumber:(NSString *)phoneNumber {
    
    if (![phoneNumber yj_checkPhoneNumber]) {
        
        return nil;
    }
    
    NSMutableString *yj_phoneNumberString = [NSMutableString stringWithString:phoneNumber];
    
    NSRange yj_phoneNumberRange = NSMakeRange(3, 4);
    
    [yj_phoneNumberString replaceCharactersInRange:yj_phoneNumberRange
                                        withString:@"****"];
    
    return yj_phoneNumberString;
}

+ (NSString *)yj_stringMobileFormat:(NSString *)phoneNumber {
    
    return [self yj_stringMobileFormat:phoneNumber
                             separator:@" "];
}

+ (NSString *)yj_stringMobileFormat:(NSString *)phoneNumber
                          separator:(NSString *)separator {
    
    if ([phoneNumber yj_checkPhoneNumber]) {
        
        NSMutableString *value = [[NSMutableString alloc] initWithString:phoneNumber];
        
        [value insertString:separator
                    atIndex:3];
        [value insertString:separator
                    atIndex:8];
        
        return value;
    }
    
    return nil;
}

+ (NSString *)yj_stringUnitFormat:(CGFloat)value
                       unitString:(NSString *)unitString {
    
    if (value / 100000000 >= 1) {
        
        return [NSString stringWithFormat:@"%.0f%@", value / 100000000, unitString];
        
    } else if (value / 10000 >= 1 && value / 100000000 < 1) {
        
        return [NSString stringWithFormat:@"%.0f%@", value / 10000, unitString];
        
    } else {
        
        return [NSString stringWithFormat:@"%.0f", value];
    }
}

#pragma mark - Base 64加密
+ (NSString *)yj_base64StringFromData:(NSData *)data
                               length:(NSUInteger)length {
    
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    
    NSMutableString *result;
    
    lentext = [data length];
    
    if (lentext < 1) {
        return @"";
    }
    result = [NSMutableString stringWithCapacity: lentext];
    
    raw = [data bytes];
    
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) {
            break;
        }
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext) {
                input[i] = raw[ix];
            }
            else {
                input[i] = 0;
            }
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++) {
            
            [result appendString: [NSString stringWithFormat: @"%c", yj_base64EncodingTable[output[i]]]];
        }
        
        for (i = ctcopy; i < 4; i++) {
            
            [result appendString: @"="];
        }
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length)) {
            
            charsonline = 0;
        }
    }
    return result;
}

+ (NSString *)yj_encodingBase64WithString:(NSString *)string {
    
    NSData *yj_stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *yj_encodedString = [yj_stringData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return yj_encodedString;
}

+ (NSString *)yj_decodedBase64WithString:(NSString *)string {
    
    NSData *yj_stringData = [[NSData alloc] initWithBase64EncodedString:string
                                                                options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSString *yj_decodedString = [[NSString alloc] initWithData:yj_stringData
                                                       encoding:NSUTF8StringEncoding];
    return yj_decodedString;
}

#pragma mark - MD加密字符串
+ (NSString *)yj_encodingMD2WithString:(NSString *)string {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_encryptredMD2String];
}

+ (NSString *)yj_encodingMD4WithString:(NSString *)string {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_encryptredMD4String];
}

+ (NSString *)yj_encodingMD5WithString:(NSString *)string {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_encryptredMD5String];
}

+ (NSString *)yj_hmacEncodingMD5StringWithString:(NSString *)string
                                             key:(NSString *)key {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_hmacEncryptredMD5StringWithKey:key];
}

#pragma mark - SHA加密字符串
+ (NSString *)yj_encodingSHA1WithString:(NSString *)string {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_encryptredSHA1String];
}

+ (NSString *)yj_hmacEncodingSHA1StringWithString:(NSString *)string
                                              key:(NSString *)key {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_hmacEncryptredSHA1StringWithKey:key];
}

+ (NSString *)yj_encodingSHA224WithString:(NSString *)string {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_encryptredSHA224String];
}

+ (NSString *)yj_hmacEncodingSHA224StringWithString:(NSString *)string
                                                key:(NSString *)key {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_hmacEncryptredSHA224StringWithKey:key];
}

+ (NSString *)yj_encodingSHA256WithString:(NSString *)string {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_encryptredSHA256String];
}

+ (NSString *)yj_hmacEncodingSHA256StringWithString:(NSString *)string
                                                key:(NSString *)key {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_hmacEncryptredSHA256StringWithKey:key];
}

+ (NSString *)yj_encodingSHA384WithString:(NSString *)string {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_encryptredSHA384String];
}

+ (NSString *)yj_hmacEncodingSHA384StringWithString:(NSString *)string
                                                key:(NSString *)key {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_hmacEncryptredSHA384StringWithKey:key];
}

+ (NSString *)yj_encodingSHA512WithString:(NSString *)string {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_encryptredSHA512String];
}

+ (NSString *)yj_hmacEncodingSHA512StringWithString:(NSString *)string
                                                key:(NSString *)key {
    
    return [[string dataUsingEncoding:NSUTF8StringEncoding] yj_hmacEncryptredSHA512StringWithKey:key];
}

#pragma mark - 获取字符串首字母
+ (NSString *)yj_transformPinYinWithString:(NSString *)string {
    
    NSMutableString *yj_string = [string mutableCopy];
    
    CFStringTransform((CFMutableStringRef)yj_string,
                      NULL,
                      kCFStringTransformMandarinLatin,
                      NO);
    
    CFStringTransform((CFMutableStringRef)yj_string,
                      NULL,
                      kCFStringTransformStripDiacritics,
                      NO);
    
    return yj_string;
}

#pragma mark - NSString获取首字母
+ (NSString *)yj_getFirstCharactorWithString:(NSString *)string {
    
    NSString *yj_pinYin = [[self yj_transformPinYinWithString:string] uppercaseString];
    
    if (!yj_pinYin || [self yj_checkEmptyWithString:string]) {
        
        return @"#";
    }
    
    return [yj_pinYin substringToIndex:1];
}

+ (NSString *)yj_getFirstPinYinWithString:(NSString *)string {
    
    NSString *yj_pinYin = [[self yj_transformPinYinWithString:string] uppercaseString];
    
    if (!yj_pinYin || [self yj_checkEmptyWithString:string]) {
        
        return @"#";
    }
    
    yj_pinYin = [yj_pinYin substringToIndex:1];
    
    if ([yj_pinYin compare:@"A"] == NSOrderedAscending || [yj_pinYin compare:@"Z"] == NSOrderedDescending) {
        
        yj_pinYin = @"#";
    }
    
    return yj_pinYin;
}

#pragma mark - 正则表达式

- (BOOL)yj_realContainDecimal {
    
    NSString *rules = @"^(\\-|\\+)?\\d+(\\.\\d+)?$";
    
    return [self yj_regularWithRule:rules];
}

#pragma mark - 整数相关
- (BOOL)yj_isNumber {
    
    NSString *rules = @"^[0-9]*$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkMostNumber:(NSInteger)quantity {
    
    NSString *rules = [NSString stringWithFormat:@"^\\d{%ld}$", (long)quantity];
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkAtLeastNumber:(NSInteger)quantity {
    
    NSString *rules = [NSString stringWithFormat:@"^\\d{%ld,}$", (long)quantity];
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkLeastNumber:(NSInteger)leastNumber
                 mostNumber:(NSInteger)mostNumber {
    
    NSString *rules = [NSString stringWithFormat:@"^\\d{%ld,%ld}$", (long)leastNumber, (long)mostNumber];
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isNotZeroStartNumber {
    
    NSString *rules = @"^(0|[1-9][0-9]*)$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isNotZeroPositiveInteger {
    
    NSString *rules = @"^[1-9]\\d*$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isNotZeroNegativeInteger {
    
    NSString *rules = @"^-[1-9]\\d*$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isPositiveInteger {
    
    NSString *rules = @"^\\d+$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isNegativeInteger {
    
    NSString *rules = @"^-[1-9]\\d*";
    
    return [self yj_regularWithRule:rules];
}

#pragma mark - 浮点数相关
- (BOOL)yj_isFloat {
    
    NSString *rules = @"^(-?\\d+)(\\.\\d+)?$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isPositiveFloat {
    
    NSString *rules = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isNagativeFloat {
    
    NSString *rules = @"^-([1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*)$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isNotZeroStartNumberHaveOneOrTwoDecimal {
    
    NSString *rules = @"^([1-9][0-9]*)+(.[0-9]{1,2})?$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isHaveOneOrTwoDecimalPositiveOrNegative {
    
    NSString *rules = @"^(\\-)?\\d+(\\.\\d{1,2})?$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isPositiveRealHaveTwoDecimal {
    
    NSString *rules = @"^[0-9]+(.[0-9]{2})?$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isHaveOneOrThreeDecimalPositiveOrNegative {
    
    NSString *rules = @"^[0-9]+(.[0-9]{1,3})?$";
    
    return [self yj_regularWithRule:rules];
}

#pragma mark - 字符串相关
- (BOOL)yj_isChineseCharacter {
    
    NSString *rules = @"^[\u4e00-\u9fa5]{0,}$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isEnglishOrNumbers {
    
    NSString *rules = @"^[A-Za-z0-9]+$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_limitinglength:(NSInteger)fistRange
                lastRange:(NSInteger)lastRange {
    
    NSString *rules = [NSString stringWithFormat:@"^.{%ld,%ld}$", (long)fistRange, (long)lastRange];
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkString:(NSInteger)length {
    
    NSString *rules = @"^[A-Za-z0-9]+$";
    
    if (self.length == length) {
        
        return [self yj_regularWithRule:rules];
    }
    
    return NO;
}

- (BOOL)yj_isLettersString {
    
    NSString *rules = @"^[A-Za-z]+$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isCapitalLetters {
    
    NSString *rules = @"^[A-Z]+$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isLowercaseLetters {
    
    NSString *rules = @"^[a-z]+$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isNumbersOrLettersOrLineString {
    
    NSString *rules = @"^[A-Za-z0-9_]+$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isChineseCharacterOrEnglishOrNumbersOrLineString {
    
    NSString *rules = @"^[\u4E00-\u9FA5A-Za-z0-9_]+$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isDoesSpecialCharactersString {
    
    NSString *rules = @"^[\u4E00-\u9FA5A-Za-z0-9]+$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isContainSpecialCharacterString {
    
    NSString *rules = @"[^%&',;=?$\x22]+";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isContainCharacter:(NSString *)charater{
    
    NSString *rules = [NSString stringWithFormat:@"[^%@\x22]+", charater];
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_isLetterStar {
    
    NSString *rules = @"^[a-zA-Z][a-zA-Z0-9_]*$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkStringIsStrong {
    
    NSString *rules = @"^\\w*(?=\\w*\\d)(?=\\w*[a-zA-Z])\\w*$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkChineseCharacter {
    
    NSString *rules = @"[\u4e00-\u9fa5]";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkDoubleByteCharacters {
    
    NSString *rules = @"[^\\x00-\\xff]";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkBlankLines {
    
    NSString *rules = @"\\n\\s*\\r";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkFirstAndLastSpaceCharacters {
    
    NSString *rules = @"(^\\s*)|(\\s*$)";//@"^\\s*|\\s*$";
    
    return [self yj_regularWithRule:rules];
}

#pragma mark - 号码相关
- (BOOL)yj_checkPhoneNumber {
    
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    
    return [self yj_regularWithRule:MOBILE] ||
    [self yj_checkChinaMobelPhoneNumber] ||
    [self yj_checkChinaUnicomPhoneNumber] ||
    [self yj_checkChinaTelecomPhoneNumber];
}

- (BOOL)yj_checkChinaMobelPhoneNumber {
    
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *rules = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkChinaUnicomPhoneNumber {
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *rules = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkChinaTelecomPhoneNumber {
    
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *rules = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkTelePhoneNumber {
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    NSString *rules = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkFormatTelePhoneNumber {
    
    NSString *rules = @"^\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{7}|\\d{4}-\\d{8}";
    
    return [self yj_regularWithRule:rules];
}

#pragma mark - 身份证相关
- (BOOL)yj_checkIdentityCard {
    
    NSString *rules = @"^\\d{15}|\\d{18}$|^([0-9]){7,18}(x|X)?$";
    
    return [self yj_regularWithRule:rules];
}

#pragma mark - 账号相关
- (BOOL)yj_checkAccount {
    
    NSString *rules = @"^[a-zA-Z][a-zA-Z0-9_]{4,15}$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkPassword {
    
    NSString *rules = @"^[a-zA-Z]\\w{5,17}$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkStrongPassword:(NSInteger)briefest
                       longest:(NSInteger)longest {
    
    NSString *rules = [NSString stringWithFormat:@"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{%ld,%ld}$", (long)briefest, (long)longest];
    
    return [self yj_regularWithRule:rules];
}

#pragma mark - 日期相关
- (BOOL)yj_checkChinaDateFormat {
    
    NSString *rules = @"^\\d{4}-\\d{1,2}-\\d{1,2}";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkAbroadDateFormat {
    
    NSString *rules = @"^\\d{1,2}-\\d{1,2}-\\d{4}";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkMonth {
    
    NSString *rules = @"^(0?[1-9]|1[0-2])$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkDay {
    
    NSString *rules = @"^((0?[1-9])|((1|2)[0-9])|30|31)$";
    
    return [self yj_regularWithRule:rules];
}

#pragma mark - 特殊正则
- (BOOL)yj_checkEmailAddress {
    
    NSString *rules = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkDomainName {
    
    NSString *rules = @"[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(/.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+/.?";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkURL {
    
    NSString *rules = @"[a-zA-z]+://[^\\s]*";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkXMLFile {
    
    NSString *rules = @"^([a-zA-Z]+-?)+[a-zA-Z0-9]+\\.[x|X][m|M][l|L]$";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkHTMLSign {
    
    NSString *rules = @"<(\\S*?)[^>]*>.*?</\\1>|<.*? />";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkQQNumber {
    
    NSString *rules = @"[1-9][0-9]{4}";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkPostalCode {
    
    NSString *rules = @"[1-9]\\d{5}(?!\\d)";
    
    return [self yj_regularWithRule:rules];
}

- (BOOL)yj_checkIPv4InternetProtocol {
    
    NSString *rules = @"((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))";
    
    return [self yj_regularWithRule:rules];
}

#pragma mark - Rule Method
- (BOOL)yj_regularWithRule:(NSString *)rule {
    
    NSPredicate *stringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    
    return [stringPredicate evaluateWithObject:self];
}


@end

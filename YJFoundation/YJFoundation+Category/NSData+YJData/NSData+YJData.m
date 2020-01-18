//
//  NSData+YJData.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSData+YJData.h"
#import "NSString+YJString.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (YJData)

+ (NSData *)yj_compressOriginalImage:(UIImage *)image
                  compressionQuality:(CGFloat)compressionQuality {
    
    NSData *yj_data = UIImageJPEGRepresentation(image, compressionQuality);
    
    CGFloat yj_dataKBytes = yj_data.length / 1000.0;
    CGFloat yj_maxQuality = 0.9f;
    CGFloat yj_lastData   = yj_dataKBytes;
    
    while (yj_dataKBytes > compressionQuality && yj_maxQuality > 0.01f) {
        
        yj_maxQuality = yj_maxQuality - 0.01f;
        
        yj_data = UIImageJPEGRepresentation(image, yj_maxQuality);
        
        yj_dataKBytes = yj_data.length / 1000.0;
        
        if (yj_lastData == yj_dataKBytes) {
            
            break;
            
        } else {
            
            yj_lastData = yj_dataKBytes;
        }
    }
    
    return yj_data;
}

+ (NSString *)yj_replacingAPNsTokenWithData:(NSData *)data {
    
    NSString *yj_replacingStringOne   = [[data description] stringByReplacingOccurrencesOfString:@"<" withString: @""];
    NSString *yj_replacingStringTwo   = [yj_replacingStringOne stringByReplacingOccurrencesOfString: @">" withString: @""];
    NSString *yj_replacingStringThree = [yj_replacingStringTwo stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    return yj_replacingStringThree;
}

#pragma mark - Base 64
+ (NSData *)yj_transformDataWithBase64EncodedString:(NSString *)string {
    
    if ([NSString yj_checkEmptyWithString:string]) {
        
        return nil;
    }
    
    NSData *yj_decodedData = [[NSData alloc] initWithBase64EncodedString:string
                                                                 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [yj_decodedData length] ? yj_decodedData: nil;
}

+ (NSString *)yj_transformBase64EncodedStringWithData:(NSData *)data
                                            wrapWidth:(YJEncodedType)wrapWidth {
    
    if (![data length]) {
        
        return nil;
    }
    
    NSString *yj_dataEncodedString = nil;
    
    switch (wrapWidth) {
        case YJEncodedType64: {
            
            return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } case YJEncodedType76: {
            
            return [data base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            
        } default: {
            
            yj_dataEncodedString = [data base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
        }
    }
    
    if (!wrapWidth || wrapWidth >= [yj_dataEncodedString length]) {
        
        return yj_dataEncodedString;
    }
    
    wrapWidth = (wrapWidth / 4) * 4;
    
    NSMutableString *yj_resultString = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [yj_dataEncodedString length]; i+= wrapWidth) {
        
        if (i + wrapWidth >= [yj_dataEncodedString length]) {
            
            [yj_resultString appendString:[yj_dataEncodedString substringFromIndex:i]];
            
            break;
        }
        
        [yj_resultString appendString:[yj_dataEncodedString
                                       substringWithRange:NSMakeRange(i, wrapWidth)]];
        
        [yj_resultString appendString:@"\r\n"];
    }
    
    return yj_resultString;
}

#pragma mark - AES
- (NSData *)yj_encryptedDataWithAESKey:(NSString *)key
                           encryptData:(NSData *)encryptData {
    
    return [self yj_formatAES128DataWithOperation:kCCEncrypt
                                          options:kCCOptionPKCS7Padding
                                              key:key
                                             data:encryptData];
}

- (NSData *)yj_decryptedDataWithAESKey:(NSString *)key
                           decryptData:(NSData *)decryptData {
    
    return [self yj_formatAES128DataWithOperation:kCCDecrypt
                                          options:kCCOptionPKCS7Padding
                                              key:key
                                             data:decryptData];
}

- (NSData *)yj_encryptedECBDataWithAESKey:(NSString *)key
                              encryptData:(NSData *)encryptData {
    
    return [self yj_formatAES128DataWithOperation:kCCEncrypt
                                          options:kCCOptionPKCS7Padding|kCCOptionECBMode
                                              key:key
                                             data:encryptData];
}

- (NSData *)yj_decryptedECBDataWithAESKey:(NSString *)key
                              decryptData:(NSData *)decryptData {
    
    return [self yj_formatAES128DataWithOperation:kCCDecrypt
                                          options:kCCOptionPKCS7Padding|kCCOptionECBMode
                                              key:key
                                             data:decryptData];
}

#pragma mark - AES通用加密/解密私有方法, 私有
- (NSData *)yj_formatAES128DataWithOperation:(CCOperation)operation
                                     options:(CCOptions)options
                                         key:(NSString *)key
                                        data:(NSData *)data {
    
    NSData *yj_keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t yj_dataMoved;
    
    NSMutableData *yj_mutableData = [NSMutableData dataWithLength:self.length + kCCBlockSizeAES128];
    
    CCCryptorStatus yj_cryptorStatus = CCCrypt(operation,
                                               kCCAlgorithmAES128,
                                               options,
                                               yj_keyData.bytes,
                                               yj_keyData.length,
                                               data.bytes,
                                               self.bytes,
                                               self.length,
                                               yj_mutableData.mutableBytes,
                                               yj_mutableData.length,
                                               &yj_dataMoved);
    
    if (yj_cryptorStatus == kCCSuccess) {
        
        yj_mutableData.length = yj_dataMoved;
        
        return yj_mutableData;
    }
    
    return nil;
}

#pragma mark - 3DES
- (NSData *)yj_encryptedDataWith3DESKey:(NSString *)key
                            encryptData:(NSData *)encryptData {
    
    return [self yj_format3DESDataWithOperation:kCCEncrypt
                                        options:kCCOptionPKCS7Padding
                                            key:key
                                           data:encryptData];
}

- (NSData *)yj_decryptedDataWith3DESKey:(NSString *)key
                            decryptData:(NSData *)decryptData {
    
    return [self yj_format3DESDataWithOperation:kCCDecrypt
                                        options:kCCOptionPKCS7Padding
                                            key:key
                                           data:decryptData];
}

- (NSData *)yj_encryptedECBDataWith3DESKey:(NSString *)key
                               encryptData:(NSData *)encryptData {
    
    return [self yj_format3DESDataWithOperation:kCCEncrypt
                                        options:kCCOptionPKCS7Padding|kCCOptionECBMode
                                            key:key
                                           data:encryptData];
}

- (NSData *)yj_decryptedECBDataWith3DESKey:(NSString *)key
                               decryptData:(NSData *)decryptData {
    
    return [self yj_format3DESDataWithOperation:kCCDecrypt
                                        options:kCCOptionPKCS7Padding|kCCOptionECBMode
                                            key:key
                                           data:decryptData];
}

#pragma mark - 3DES加密/解密通用方法, 私有
- (NSData *)yj_format3DESDataWithOperation:(CCOperation)operation
                                   options:(CCOptions)options
                                       key:(NSString *)key
                                      data:(NSData *)data {
    
    NSData *yj_keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t yj_dataMoved;
    
    NSMutableData *yj_mutableData = [NSMutableData dataWithLength:self.length + kCCBlockSize3DES];
    
    CCCryptorStatus yj_cryptorStatus = CCCrypt(operation,
                                               kCCAlgorithm3DES,
                                               options,
                                               yj_keyData.bytes,
                                               kCCKeySize3DES,
                                               data.bytes,
                                               self.bytes,
                                               self.length,
                                               yj_mutableData.mutableBytes,
                                               yj_mutableData.length,
                                               &yj_dataMoved);
    
    if (yj_cryptorStatus == kCCSuccess) {
        
        yj_mutableData.length = yj_dataMoved;
        
        return yj_mutableData;
    }
    
    return nil;
}

#pragma mark - MD加密
- (NSString *)yj_encryptredMD2String {
    
    unsigned char yj_result[CC_MD2_DIGEST_LENGTH];
    
    CC_MD2(self.bytes, (CC_LONG)self.length, yj_result);
    
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", yj_result[0], yj_result[1], yj_result[2], yj_result[3],
            yj_result[4], yj_result[5], yj_result[6], yj_result[7],
            yj_result[8], yj_result[9], yj_result[10], yj_result[11],
            yj_result[12], yj_result[13], yj_result[14], yj_result[15]];
}

- (NSData *)yj_encryptredMD2Data {
    
    unsigned char yj_result[CC_MD2_DIGEST_LENGTH];
    
    CC_MD2(self.bytes,
           (CC_LONG)self.length,
           yj_result);
    
    return [NSData dataWithBytes:yj_result
                          length:CC_MD2_DIGEST_LENGTH];
}

- (NSString *)yj_encryptredMD4String {
    
    unsigned char yj_result[CC_MD4_DIGEST_LENGTH];
    
    CC_MD4(self.bytes,
           (CC_LONG)self.length,
           yj_result);
    
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", yj_result[0], yj_result[1], yj_result[2], yj_result[3],
            yj_result[4], yj_result[5], yj_result[6], yj_result[7],
            yj_result[8], yj_result[9], yj_result[10], yj_result[11],
            yj_result[12], yj_result[13], yj_result[14], yj_result[15]];
}

- (NSData *)yj_encryptredMD4Data {
    
    unsigned char yj_result[CC_MD4_DIGEST_LENGTH];
    
    CC_MD4(self.bytes,
           (CC_LONG)self.length,
           yj_result);
    
    return [NSData dataWithBytes:yj_result
                          length:CC_MD4_DIGEST_LENGTH];
}

- (NSString *)yj_encryptredMD5String {
    
    unsigned char yj_result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(self.bytes,
           (CC_LONG)self.length,
           yj_result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", yj_result[0], yj_result[1], yj_result[2], yj_result[3],
            yj_result[4], yj_result[5], yj_result[6], yj_result[7],
            yj_result[8], yj_result[9], yj_result[10], yj_result[11],
            yj_result[12], yj_result[13], yj_result[14], yj_result[15]];
}

- (NSString *)yj_hmacEncryptredMD5StringWithKey:(NSString *)key {
    
    return [self yj_hmacStringUsingWithHmacAlgorithm:kCCHmacAlgMD5
                                                 key:key];
}

- (NSData *)yj_encryptredMD5Data {
    
    unsigned char yj_result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(self.bytes,
           (CC_LONG)self.length,
           yj_result);
    
    return [NSData dataWithBytes:yj_result
                          length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *)yj_hmacEncryptredMD5DataWithKey:(NSData *)key {
    
    return [self yj_hmacDataUsingWithHmacAlgorithm:kCCHmacAlgMD5
                                               key:key];
}

#pragma mark - SHA加密
- (NSString *)yj_encryptredSHA1String {
    
    unsigned char yj_result[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(self.bytes,
            (CC_LONG)self.length,
            yj_result);
    
    NSMutableString *yj_hashString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        
        [yj_hashString appendFormat:@"%02x", yj_result[i]];
    }
    
    return yj_hashString;
}

- (NSString *)yj_hmacEncryptredSHA1StringWithKey:(NSString *)key {
    
    return [self yj_hmacStringUsingWithHmacAlgorithm:kCCHmacAlgSHA1
                                                 key:key];
}

- (NSData *)yj_encryptredSHA1Data {
    
    unsigned char yj_result[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(self.bytes,
            (CC_LONG)self.length,
            yj_result);
    
    return [NSData dataWithBytes:yj_result
                          length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData *)yj_hmacEncryptredSHA1DataWithKey:(NSData *)key {
    
    return [self yj_hmacDataUsingWithHmacAlgorithm:kCCHmacAlgSHA1
                                               key:key];
}

- (NSString *)yj_encryptredSHA224String {
    
    unsigned char yj_result[CC_SHA224_DIGEST_LENGTH];
    
    CC_SHA224(self.bytes,
              (CC_LONG)self.length,
              yj_result);
    
    NSMutableString *yj_hashString = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++) {
        
        [yj_hashString appendFormat:@"%02x", yj_result[i]];
    }
    
    return yj_hashString;
}

- (NSString *)yj_hmacEncryptredSHA224StringWithKey:(NSString *)key {
    
    return [self yj_hmacStringUsingWithHmacAlgorithm:kCCHmacAlgSHA224
                                                 key:key];
}

- (NSData *)yj_encryptredSHA224Data {
    
    unsigned char yj_result[CC_SHA224_DIGEST_LENGTH];
    
    CC_SHA224(self.bytes,
              (CC_LONG)self.length,
              yj_result);
    
    return [NSData dataWithBytes:yj_result
                          length:CC_SHA224_DIGEST_LENGTH];
}

- (NSData *)yj_hmacEncryptredSHA224DataWithKey:(NSData *)key {
    
    return [self yj_hmacDataUsingWithHmacAlgorithm:kCCHmacAlgSHA224
                                               key:key];
}

- (NSString *)yj_encryptredSHA256String {
    
    unsigned char yj_result[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(self.bytes,
              (CC_LONG)self.length,
              yj_result);
    
    NSMutableString *yj_hashString = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        
        [yj_hashString appendFormat:@"%02x", yj_result[i]];
    }
    
    return yj_hashString;
}

- (NSString *)yj_hmacEncryptredSHA256StringWithKey:(NSString *)key {
    
    return [self yj_hmacStringUsingWithHmacAlgorithm:kCCHmacAlgSHA256
                                                 key:key];
}

- (NSData *)yj_encryptredSHA256Data {
    
    unsigned char yj_result[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(self.bytes,
              (CC_LONG)self.length,
              yj_result);
    
    return [NSData dataWithBytes:yj_result
                          length:CC_SHA256_DIGEST_LENGTH];
}

- (NSData *)yj_hmacEncryptredSHA256DataWithKey:(NSData *)key {
    
    return [self yj_hmacDataUsingWithHmacAlgorithm:kCCHmacAlgSHA256
                                               key:key];
}

- (NSString *)yj_encryptredSHA384String {
    
    unsigned char yj_result[CC_SHA384_DIGEST_LENGTH];
    
    CC_SHA384(self.bytes,
              (CC_LONG)self.length,
              yj_result);
    
    NSMutableString *yj_hashString = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        
        [yj_hashString appendFormat:@"%02x", yj_result[i]];
    }
    
    return yj_hashString;
}

- (NSString *)yj_hmacEncryptredSHA384StringWithKey:(NSString *)key {
    
    return [self yj_hmacStringUsingWithHmacAlgorithm:kCCHmacAlgSHA384
                                                 key:key];
}

- (NSData *)yj_encryptredSHA384Data {
    
    unsigned char yj_result[CC_SHA384_DIGEST_LENGTH];
    
    CC_SHA384(self.bytes,
              (CC_LONG)self.length,
              yj_result);
    
    return [NSData dataWithBytes:yj_result
                          length:CC_SHA384_DIGEST_LENGTH];
}

- (NSData *)yj_hmacEncryptredSHA384DataWithKey:(NSData *)key {
    
    return [self yj_hmacDataUsingWithHmacAlgorithm:kCCHmacAlgSHA384
                                               key:key];
}

- (NSString *)yj_encryptredSHA512String {
    
    unsigned char yj_result[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(self.bytes,
              (CC_LONG)self.length,
              yj_result);
    
    NSMutableString *yj_hashString = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        
        [yj_hashString appendFormat:@"%02x", yj_result[i]];
    }
    
    return yj_hashString;
}

- (NSString *)yj_hmacEncryptredSHA512StringWithKey:(NSString *)key {
    
    return [self yj_hmacStringUsingWithHmacAlgorithm:kCCHmacAlgSHA512
                                                 key:key];
}

- (NSData *)yj_encryptredSHA512Data {
    
    unsigned char yj_result[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(self.bytes,
              (CC_LONG)self.length,
              yj_result);
    
    return [NSData dataWithBytes:yj_result
                          length:CC_SHA512_DIGEST_LENGTH];
}

- (NSData *)yj_hmacEncryptredSHA512DataWithKey:(NSData *)key {
    
    return [self yj_hmacDataUsingWithHmacAlgorithm:kCCHmacAlgSHA512
                                               key:key];
}

- (id)yj_dataJSONValueDecoded {
    
    NSError *error = nil;
    
    id value = [NSJSONSerialization JSONObjectWithData:self
                                               options:kNilOptions
                                                 error:&error];
    
    if (error) {
        NSLog(@"Data Json Value Decoded Error:%@", error);
    }
    
    return value;
}

+ (NSData *)yj_getDataWithBundleNamed:(NSString *)name {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name
                                                     ofType:@""];
    
    if (!path) return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return data;
}

#pragma mark - Hash加密的API
- (NSString *)yj_hmacStringUsingWithHmacAlgorithm:(CCHmacAlgorithm)hmacAlgorithm
                                              key:(NSString *)key {
    size_t yj_size;
    switch (hmacAlgorithm) {
            
        case kCCHmacAlgMD5: yj_size    = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: yj_size   = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: yj_size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: yj_size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: yj_size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: yj_size = CC_SHA512_DIGEST_LENGTH; break;
            
        default: return nil;
    }
    
    unsigned char yj_result[yj_size];
    
    const char *yj_hasKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(hmacAlgorithm,
           yj_hasKey,
           strlen(yj_hasKey),
           self.bytes,
           self.length,
           yj_result);
    
    NSMutableString *yj_hashString = [NSMutableString stringWithCapacity:yj_size * 2];
    
    for (int i = 0; i < yj_size; i++) {
        
        [yj_hashString appendFormat:@"%02x", yj_result[i]];
    }
    
    return yj_hashString;
}

- (NSData *)yj_hmacDataUsingWithHmacAlgorithm:(CCHmacAlgorithm)hmacAlgorithm
                                          key:(NSData *)key {
    size_t yj_size;
    
    switch (hmacAlgorithm) {
        case kCCHmacAlgMD5: yj_size    = CC_MD5_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA1: yj_size   = CC_SHA1_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA224: yj_size = CC_SHA224_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA256: yj_size = CC_SHA256_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA384: yj_size = CC_SHA384_DIGEST_LENGTH; break;
        case kCCHmacAlgSHA512: yj_size = CC_SHA512_DIGEST_LENGTH; break;
        default: return nil;
    }
    
    unsigned char yj_result[yj_size];
    
    CCHmac(hmacAlgorithm,
           [key bytes],
           key.length,
           self.bytes,
           self.length,
           yj_result);
    
    return [NSData dataWithBytes:yj_result
                          length:yj_size];
}

@end

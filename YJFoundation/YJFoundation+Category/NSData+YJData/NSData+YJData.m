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
#import <Security/Security.h>

@implementation NSData (YJData)

static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

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

+ (NSData *)yj_compressOriginalImage:(UIImage *)image
                  compressionQuality:(CGFloat)compressionQuality
           compressionSizeWithKBytes:(CGFloat)KBytes{
    
    NSData *yj_data = UIImageJPEGRepresentation(image, compressionQuality);
    
    if (!KBytes||KBytes <= 0) {
        KBytes = 500;
    }
    //优先压缩图片质量------开始
    CGFloat yj_maxQuality = compressionQuality;//0.5最接近原图
    if (yj_data.length>KBytes*1024) {//减少压缩次数 降低卡顿时长 直接跳转到所需要压缩的内存相近值
        if (yj_data.length>2*1024*1024) {//2M以及以上
            yj_maxQuality = 0.05;
        }else if (yj_data.length>1024*1024) {//1M-2M
            yj_maxQuality = 0.1;
        }else if (yj_data.length>512*1024) {//0.5M-1M
            yj_maxQuality = 0.2;
        }else if (yj_data.length>200*1024) {//0.25M-0.5M
            yj_maxQuality = 0.4;
        }
        yj_data = UIImageJPEGRepresentation(image, yj_maxQuality);
    }
    
    CGFloat yj_dataKBytes = yj_data.length / 1024;//KB
    CGFloat yj_lastData   = yj_dataKBytes;
    
    while (yj_dataKBytes > KBytes && yj_maxQuality > 0.02f) {
        yj_maxQuality = yj_maxQuality - 0.02f;
        yj_data = UIImageJPEGRepresentation(image, yj_maxQuality);
        yj_dataKBytes = yj_data.length / 1024;
        if (yj_lastData == yj_dataKBytes) {
            break;
        } else {
            yj_lastData = yj_dataKBytes;
        }
    }
    //优先压缩图片质量------结束
    
    //图片质量压缩到了底线 通过缩小图片尺寸来达到指定压缩大小
    CGFloat lastDataLength = 0;
    while (yj_data.length/1024 > KBytes && yj_data.length != lastDataLength) {
        lastDataLength = yj_data.length;
        CGFloat ratio = KBytes*1024 / yj_data.length;//要求达到的大小和现在图片大小比
        CGSize size = CGSizeMake((NSUInteger)(image.size.width * sqrtf(ratio)),
                                 (NSUInteger)(image.size.height * sqrtf(ratio))); // 使用NSUInteger防止白色空白
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        yj_data = UIImageJPEGRepresentation(image, yj_maxQuality);
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


+ (NSData *)yj_stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

//credit: http://hg.mozilla.org/services/fx-home/file/tip/Sources/NetworkAndStorage/CryptoUtils.m#l1036
+ (NSData *)yj_stripPrivateKeyHeader:(NSData *)d_key{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);

    unsigned long len = [d_key length];
    if (!len) return(nil);

    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 22; //magic byte at offset 22

    if (0x04 != c_key[idx++]) return nil;

    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }

    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

+ (SecKeyRef)yj_addPublicKey:(NSString *)key{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self yj_stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }

    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }

    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (SecKeyRef)yj_addPrivateKey:(NSString *)key{
    NSRange spos;
    NSRange epos;
    spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    if(spos.length > 0){
        epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    }else{
        spos = [key rangeOfString:@"-----BEGIN PRIVATE KEY-----"];
        epos = [key rangeOfString:@"-----END PRIVATE KEY-----"];
    }
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];

    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self yj_stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }

    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PrivKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);

    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
     kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];

    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }

    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

/* START: Encryption & Decryption with RSA private key */

+ (NSData *)yj_encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef isSign:(BOOL)isSign {
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        
        if (isSign) {
            status = SecKeyRawSign(keyRef,
                                   kSecPaddingPKCS1,
                                   srcbuf + idx,
                                   data_len,
                                   outbuf,
                                   &outlen
                                   );
        } else {
            status = SecKeyEncrypt(keyRef,
                                   kSecPaddingPKCS1,
                                   srcbuf + idx,
                                   data_len,
                                   outbuf,
                                   &outlen
                                   );
        }
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

+ (NSString *)yj_encryptString:(NSString *)str privateKey:(NSString *)privKey{
    NSData *data = [self yj_encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] privateKey:privKey];
    NSString *ret = base64_encode_data(data);
    return ret;
}

+ (NSData *)yj_encryptData:(NSData *)data privateKey:(NSString *)privKey{
    if(!data || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [self yj_addPrivateKey:privKey];
    if(!keyRef){
        return nil;
    }
    return [self yj_encryptData:data withKeyRef:keyRef isSign:YES];
}

+ (NSData *)yj_decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}


+ (NSString *)yj_decryptString:(NSString *)str privateKey:(NSString *)privKey{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self yj_decryptData:data privateKey:privKey];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+ (NSData *)yj_decryptData:(NSData *)data privateKey:(NSString *)privKey{
    if(!data || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [self yj_addPrivateKey:privKey];
    if(!keyRef){
        return nil;
    }
    return [self yj_decryptData:data withKeyRef:keyRef];
}

/* END: Encryption & Decryption with RSA private key */

/* START: Encryption & Decryption with RSA public key */

+ (NSString *)yj_encryptString:(NSString *)str publicKey:(NSString *)pubKey{
    NSData *data = [self yj_encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    NSString *ret = base64_encode_data(data);
    return ret;
}

+ (NSData *)yj_encryptData:(NSData *)data publicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [self yj_addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    return [self yj_encryptData:data withKeyRef:keyRef isSign:NO];
}

+ (NSString *)yj_decryptString:(NSString *)str publicKey:(NSString *)pubKey{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self yj_decryptData:data publicKey:pubKey];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+ (NSData *)yj_decryptData:(NSData *)data publicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [self yj_addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    return [self yj_decryptData:data withKeyRef:keyRef];
}
@end

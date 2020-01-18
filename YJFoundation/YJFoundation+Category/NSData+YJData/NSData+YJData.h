//
//  NSData+YJData.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (YJData)

typedef NS_ENUM(NSInteger, YJEncodedType) {
    
    YJEncodedType64 = 64,
    YJEncodedType76 = 76
};


/**
 将指定的图片转成NSData, 可输入指定压缩比例
 
 @param image UIImage
 @param compressionQuality 压缩比例
 @return NSData
 */
+ (NSData *)yj_compressOriginalImage:(UIImage *)image
                  compressionQuality:(CGFloat)compressionQuality;

/**
 将制定的APNs NSData转成NSString
 
 @param data NSData
 @return NSString
 */
+ (NSString *)yj_replacingAPNsTokenWithData:(NSData *)data;

#pragma mark - Base 64加密/解密
/**
 将Base 64的字符串转成NSData
 
 @param string NSString
 @return NSData
 */
+ (NSData *)yj_transformDataWithBase64EncodedString:(NSString *)string;

/**
 将指定的NSData转成64或76的字符串
 
 @param data NSData
 @param wrapWidth YJEncodedType
 @return NSString
 */
+ (NSString *)yj_transformBase64EncodedStringWithData:(NSData *)data
                                            wrapWidth:(YJEncodedType)wrapWidth;

#pragma mark - AES加密/解密
/**
 加密AES 128 CBC数据
 
 @param key NSString
 @param encryptData NSData
 @return NSData
 */
- (NSData *)yj_encryptedDataWithAESKey:(NSString *)key
                           encryptData:(NSData *)encryptData;

/**
 解密AES 128 CBC数据
 
 @param key NSString
 @param decryptData NSData
 @return NSData
 */
- (NSData *)yj_decryptedDataWithAESKey:(NSString *)key
                           decryptData:(NSData *)decryptData;

/**
 加密AES 128 ECB数据
 
 @param key NSString
 @param encryptData NSData
 @return NSData
 */
- (NSData *)yj_encryptedECBDataWithAESKey:(NSString *)key
                              encryptData:(NSData *)encryptData;

/**
 解密ARS 128 ECB数据
 
 @param key NSString
 @param decryptData NSData
 @return NSData
 */
- (NSData *)yj_decryptedECBDataWithAESKey:(NSString *)key
                              decryptData:(NSData *)decryptData;

#pragma mark - 3DES加密/解密
/**
 加密3DES数据
 
 @param key NSString
 @param encryptData NSData
 @return NSData
 */
- (NSData *)yj_encryptedDataWith3DESKey:(NSString *)key
                            encryptData:(NSData *)encryptData;

/**
 解密3DES数据
 
 @param key NSString
 @param decryptData NSData
 @return NSData
 */
- (NSData *)yj_decryptedDataWith3DESKey:(NSString *)key
                            decryptData:(NSData *)decryptData;

/**
 加密3DES ECB数据
 
 @param key NSString
 @param encryptData NSData
 @return NSData
 */
- (NSData *)yj_encryptedECBDataWith3DESKey:(NSString *)key
                               encryptData:(NSData *)encryptData;

/**
 解密3DES ECB数据
 
 @param key NSString
 @param decryptData NSData
 @return NSData
 */
- (NSData *)yj_decryptedECBDataWith3DESKey:(NSString *)key
                               decryptData:(NSData *)decryptData;

#pragma mark - MD加密
/**
 获取MD2加密后的NSString
 
 @return NSString
 */
- (NSString *)yj_encryptredMD2String;

/**
 获取MD2加密后的NSData
 
 @return NSData
 */
- (NSData *)yj_encryptredMD2Data;

/**
 获取MD4加密后的NSString
 
 @return NSString
 */
- (NSString *)yj_encryptredMD4String;

/**
 获取MD4加密后的NSData
 
 @return NSData
 */
- (NSData *)yj_encryptredMD4Data;

/**
 获取MD5加密后的NSString
 
 @return NSString
 */
- (NSString *)yj_encryptredMD5String;

/**
 使用指定Key去哈希加密MD5
 
 @param key NSString
 @return NSString
 */
- (NSString *)yj_hmacEncryptredMD5StringWithKey:(NSString *)key;

/**
 获取MD5加密后的NSData
 
 @return NSData
 */
- (NSData *)yj_encryptredMD5Data;

/**
 获取使用指定Key HASH MD5加密后的NSData
 
 @param key NSData
 @return NSData
 */
- (NSData *)yj_hmacEncryptredMD5DataWithKey:(NSData *)key;

#pragma mark - SHA加密
/**
 获取SHA1加密后的NSString
 
 @return NSString
 */
- (NSString *)yj_encryptredSHA1String;

/**
 获取使用指定Key HASH SHA1加密后的NSString
 
 @param key NSString
 @return NSString
 */
- (NSString *)yj_hmacEncryptredSHA1StringWithKey:(NSString *)key;

/**
 获取SHA1加密后的NSData
 
 @return NSData
 */
- (NSData *)yj_encryptredSHA1Data;

/**
 获取使用指定Key HASH SHA1加密后的NSData
 
 @param key NSData
 @return NSData
 */
- (NSData *)yj_hmacEncryptredSHA1DataWithKey:(NSData *)key;

/**
 获取SHA224加密后的NSString
 
 @return NSString
 */
- (NSString *)yj_encryptredSHA224String;

/**
 获取使用指定Key HASH SHA224加密后的NSString
 
 @param key NSString
 @return NSString
 */
- (NSString *)yj_hmacEncryptredSHA224StringWithKey:(NSString *)key;

/**
 获取SHA224加密后的NSData
 
 @return NSData
 */
- (NSData *)yj_encryptredSHA224Data;

/**
 获取使用指定Key HASH SHA224加密后的NSData
 
 @param key NSData
 @return NSData
 */
- (NSData *)yj_hmacEncryptredSHA224DataWithKey:(NSData *)key;

/**
 获取SHA256加密后的NSString
 
 @return NSString
 */
- (NSString *)yj_encryptredSHA256String;

/**
 获取使用指定Key HASH SHA256加密后的NSString
 
 @param key NSString
 @return NSString
 */
- (NSString *)yj_hmacEncryptredSHA256StringWithKey:(NSString *)key;

/**
 获取SHA256加密后的NSData
 
 @return NSData
 */
- (NSData *)yj_encryptredSHA256Data;

/**
 获取使用指定Key HASH SHA256加密后的NSData
 
 @param key NSData
 @return NSData
 */
- (NSData *)yj_hmacEncryptredSHA256DataWithKey:(NSData *)key;

/**
 获取SHA384加密后的NSString
 
 @return NSString
 */
- (NSString *)yj_encryptredSHA384String;

/**
 获取使用指定Key HASH SHA384加密后的NSString
 
 @param key NSString
 @return NSString
 */
- (NSString *)yj_hmacEncryptredSHA384StringWithKey:(NSString *)key;

/**
 获取SHA384加密后的NSData
 
 @return NSData
 */
- (NSData *)yj_encryptredSHA384Data;

/**
 获取使用指定Key HASH SHA384加密后的NSData
 
 @param key NSData
 @return NSData
 */
- (NSData *)yj_hmacEncryptredSHA384DataWithKey:(NSData *)key;

/**
 获取SHA512加密后的NSString
 
 @return NSString
 */
- (NSString *)yj_encryptredSHA512String;

/**
 获取使用指定Key HASH SHA512加密后的NSString
 
 @param key NSString
 @return NSString
 */
- (NSString *)yj_hmacEncryptredSHA512StringWithKey:(NSString *)key;

/**
 获取SHA512加密后的NSData
 
 @return NSData
 */
- (NSData *)yj_encryptredSHA512Data;

/**
 获取使用指定Key HASH SHA512加密后的NSData
 
 @param key NSData
 @return NSData
 */
- (NSData *)yj_hmacEncryptredSHA512DataWithKey:(NSData *)key;

/**
 解析JSON数据
 
 @return id
 */
- (id)yj_dataJSONValueDecoded;

/**
 获取指定NSBundle获取NSData
 
 @param name NSString
 @return NSData
 */
+ (NSData *)yj_getDataWithBundleNamed:(NSString *)name;


@end

NS_ASSUME_NONNULL_END

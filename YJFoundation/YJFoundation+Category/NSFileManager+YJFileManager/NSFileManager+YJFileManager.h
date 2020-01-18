//
//  NSFileManager+YJFileManager.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (YJFileManager)

#pragma mark - Cache相关
/**
 存储NSData到YJDataCache文件夹
 
 @param data NSData
 @param identifier NSString
 @return BOOL
 */
+ (BOOL)yj_saveDataCacheWithData:(NSData *)data
                      identifier:(NSString *)identifier;

/**
 存储NSData到指定Cache文件夹
 
 @param data NSData
 @param cacheName NSString
 @param identifier NSString
 @return BOOL
 */
+ (BOOL)yj_saveDataCacheWithData:(NSData *)data
                       cacheName:(NSString *)cacheName
                      identifier:(NSString *)identifier;

/**
 获取YJDataCache里的NSData
 
 @param identifier NSString
 @return NSData
 */
+ (NSData *)yj_getDataCacheWithIdentifier:(NSString *)identifier;

/**
 获取指定Cache文件夹里的NSData
 
 @param cacheName NSString
 @param identifier NSString
 @return NSData
 */
+ (NSData *)yj_getDataCacheWithCacheName:(NSString *)cacheName
                              identifier:(NSString *)identifier;

/**
 删除YJDataCache里的数据
 */
+ (BOOL)yj_removeDataWithCache;

/**
 删除指定Cache文件夹里的数据
 
 @param cacheName NSString
 */
+ (BOOL)yj_removeDataWithCacheWithCacheName:(NSString *)cacheName;

#pragma mark - Document
/**
 存储指定fileName文件到Document
 
 @param object id
 @param fileName NSString
 @return BOOL
 */
+ (BOOL)yj_saveDocumentWithObject:(id)object
                         fileName:(NSString *)fileName;

/**
 删除Document里指定的fileName文件
 
 @param fileName NSString
 @return BOOL
 */
+ (BOOL)yj_removeDocumentObjectWithFileName:(NSString *)fileName;

/**
 获取Document里指定的fileName文件
 
 @param fileName NSString
 @return id
 */
+ (id)yj_getDocumentObjectWithFileName:(NSString *)fileName;

/**
 检查路径里的文件是否存在
 
 @param filePath NSString
 @return BOOL
 */
+ (BOOL)yj_checkFileExistWithFilePath:(NSString *)filePath;

#pragma mark - 获取App的沙盒大小
/**
 获取App的沙盒大小, 单位为字节
 
 @return NSUInteger
 */
+ (NSUInteger)yj_getApplicationDocumentSize;

/**
 获取App的Cache大小, 单位为字节
 
 @return NSUInteger
 */
+ (NSUInteger)yj_getApplicationCacheSize;

/**
 获取App的Library的大小, 单位为字节
 
 @return NSUInteger
 */
+ (NSUInteger)yj_getApplicationLibrarySize;

/**
 获取指定文件夹路径的大小, 单位为字节
 
 @param folderPath NSString
 @return NSUInteger
 */
+ (NSUInteger)yj_getApplicationFileSizeWithFilePath:(NSString *)folderPath;

@end

NS_ASSUME_NONNULL_END

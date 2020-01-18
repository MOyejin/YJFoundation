//
//  NSFileManager+YJFileManager.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSFileManager+YJFileManager.h"
#import "NSURL+YJURL.h"
#import "NSString+YJString.h"

@implementation NSFileManager (YJFileManager)

#pragma mark - 获取Cache Path
+ (NSString *)yj_checkCachePathWithCacheName:(NSString *)cacheName {
    
    NSString *yj_cachePath = [NSURL yj_getCachesPathURL];
    
    yj_cachePath = [yj_cachePath stringByAppendingPathComponent:cacheName];
    
    if (![[self defaultManager] fileExistsAtPath:yj_cachePath]) {
        
        [[self defaultManager] createDirectoryAtPath:yj_cachePath
                         withIntermediateDirectories:YES
                                          attributes:nil
                                               error:nil];
    }
    
    return yj_cachePath;
}

#pragma mark - 保存数据到Cache
+ (BOOL)yj_saveDataCacheWithData:(NSData *)data
                      identifier:(NSString *)identifier {
    
    return [self yj_saveDataCacheWithData:data
                                cacheName:@"YJDataCache"
                               identifier:identifier];
}

+ (BOOL)yj_saveDataCacheWithData:(NSData *)data
                       cacheName:(NSString *)cacheName
                      identifier:(NSString *)identifier {
    
    NSString *yj_cachePath = [self yj_checkCachePathWithCacheName:cacheName];
    
    NSString *path = [yj_cachePath stringByAppendingPathComponent:[NSString yj_encodingMD5WithString:identifier]];
    
    return [data writeToFile:path
                  atomically:YES];
}

#pragma mark - 获取Cache的数据
+ (NSData *)yj_getDataCacheWithIdentifier:(NSString *)identifier {
    
    return [self yj_getDataCacheWithCacheName:@"YJDataCache"
                                   identifier:identifier];
}

+ (NSData *)yj_getDataCacheWithCacheName:(NSString *)cacheName
                              identifier:(NSString *)identifier {
    
    NSString *yj_cachePath     = [self yj_checkCachePathWithCacheName:cacheName];
    NSString *yj_identifierMD5 = [NSString yj_encodingMD5WithString:identifier];
    NSString *yj_dataPath      = [yj_cachePath stringByAppendingPathComponent:yj_identifierMD5];
    
    NSData *yj_data = [NSData dataWithContentsOfFile:yj_dataPath];
    
    [self yj_appendFilePath:cacheName];
    
    return yj_data;
}

#pragma mark - 删除Cache里的数据
+ (BOOL)yj_removeDataWithCache {
    
    return [self yj_removeDataWithCacheWithCacheName:@"YJDataCache"];
}

+ (BOOL)yj_removeDataWithCacheWithCacheName:(NSString *)cacheName {
    
    NSString *yj_cachePath = [self yj_checkCachePathWithCacheName:cacheName];
    
    return [[self defaultManager] removeItemAtPath:yj_cachePath
                                             error:nil];
}

#pragma mark - Document
+ (NSString *)yj_appendFilePath:(NSString *)fileName {
    
    NSString *yj_documentsPath = [NSURL yj_getDocumentPathURL];
    
    NSString *yj_filePath = [NSString stringWithFormat:@"%@/%@.archiver", yj_documentsPath,fileName];
    
    return yj_filePath;
}

+ (BOOL)yj_saveDocumentWithObject:(id)object
                         fileName:(NSString *)fileName {
    
    NSString *yj_documentsPath = [self yj_appendFilePath:fileName];
    
    return [NSKeyedArchiver archiveRootObject:object
                                       toFile:yj_documentsPath];
}

+ (id)yj_getDocumentObjectWithFileName:(NSString *)fileName {
    
    NSString *yj_documentsPath = [self yj_appendFilePath:fileName];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:yj_documentsPath];
}

+ (BOOL)yj_removeDocumentObjectWithFileName:(NSString *)fileName {
    
    NSString *yj_documentsPath = [self yj_appendFilePath:fileName];
    
    return [[self defaultManager] removeItemAtPath:yj_documentsPath
                                             error:nil];
}

+ (BOOL)yj_checkFileExistWithFilePath:(NSString *)filePath {
    
    BOOL isDirectory;
    
    return [[self defaultManager] fileExistsAtPath:filePath
                                       isDirectory:&isDirectory];
}

+ (NSUInteger)yj_getApplicationDocumentSize {
    
    NSString *yj_documentPath = [NSString stringWithFormat:@"%@", [NSURL yj_getDocumentPathURL]];
    
    return [self yj_getApplicationFileSizeWithFilePath:yj_documentPath];
}

+ (NSUInteger)yj_getApplicationCacheSize {
    
    NSString *yj_cachesPath = [NSString stringWithFormat:@"%@", [NSURL yj_getCachesPathURL]];
    
    return [self yj_getApplicationFileSizeWithFilePath:yj_cachesPath];
}

+ (NSUInteger)yj_getApplicationLibrarySize {
    
    NSString *yj_libraryPath = [NSString stringWithFormat:@"%@", [NSURL yj_getLibraryPathURL]];
    
    return [self yj_getApplicationFileSizeWithFilePath:yj_libraryPath];
}

+ (NSUInteger)yj_getApplicationFileSizeWithFilePath:(NSString *)folderPath {
    
    NSArray *yj_contentArray = [[self defaultManager] contentsOfDirectoryAtPath:folderPath
                                                                          error:nil];
    
    NSEnumerator *yj_enumerator = [yj_contentArray objectEnumerator];
    
    NSString *yj_file;
    
    NSUInteger yj_folderSize = 0;
    
    while (yj_file = [yj_enumerator nextObject]) {
        
        NSString *yj_filePath = [folderPath stringByAppendingPathComponent:yj_file];
        
        NSDictionary *yj_fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:yj_filePath
                                                                                           error:nil];
        yj_folderSize += [[yj_fileDictionary objectForKey:NSFileSize] intValue];
    }
    
    return yj_folderSize;
}

@end

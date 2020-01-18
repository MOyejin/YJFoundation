//
//  NSURL+YJURL.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "NSURL+YJURL.h"

@implementation NSURL (YJURL)

+ (void)yj_openBrowserWithURL:(NSString *)urlString {
    
    [[UIApplication sharedApplication] openURL:[self URLWithString:urlString]];
}

#pragma mark - 获取Folder URL
+ (NSURL *)yj_getDocumentFileURL {
    
    return [self yj_getFileURLForDirectory:NSDocumentDirectory];
}

+ (NSURL *)yj_getLibraryFileURL {
    
    return [self yj_getFileURLForDirectory:NSLibraryDirectory];
}

+ (NSURL *)yj_getCachesFileURL {
    
    return [self yj_getFileURLForDirectory:NSCachesDirectory];
}

+ (NSURL *)yj_getFileURLForDirectory:(NSSearchPathDirectory)directory {
    
    NSArray *yj_urlArray = [NSFileManager.defaultManager URLsForDirectory:directory
                                                                inDomains:NSUserDomainMask];
    
    return yj_urlArray.lastObject;
}

#pragma mark - 获取Folder Path URL
+ (NSString *)yj_getDocumentPathURL {
    
    return [self yj_getPathURLForDirectory:NSDocumentDirectory];
}

+ (NSString *)yj_getLibraryPathURL {
    
    return [self yj_getPathURLForDirectory:NSLibraryDirectory];
}

+ (NSString *)yj_getCachesPathURL {
    
    return [self yj_getPathURLForDirectory:NSCachesDirectory];
}

+ (NSString *)yj_getPathURLForDirectory:(NSSearchPathDirectory)directory {
    
    NSArray *yj_urlArray = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    
    return [NSString stringWithFormat:@"%@", yj_urlArray.firstObject];
}

@end

//
//  NSURL+YJURL.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (YJURL)

/**
 通过传入的URL地址打开外部浏览器
 
 @param urlString URL地址
 */
+ (void)yj_openBrowserWithURL:(NSString *)urlString;

#pragma mark - 获取Folder URL
/**
 获取Document File URL
 
 @return NSURL
 */
+ (NSURL *)yj_getDocumentFileURL;

/**
 获取Library File URL
 
 @return NSURL
 */
+ (NSURL *)yj_getLibraryFileURL;

/**
 获取Caches File URL
 
 @return NSURL
 */
+ (NSURL *)yj_getCachesFileURL;

/**
 获取指定NSSearchPathDirectory的File URL
 
 @param directory NSSearchPathDirectory
 @return NSURL
 */
+ (NSURL *)yj_getFileURLForDirectory:(NSSearchPathDirectory)directory;

#pragma mark - 获取Folder Path URL

/**
 获取Document Path URL
 
 @return NSString
 */
+ (NSString *)yj_getDocumentPathURL;

/**
 获取Library Path URL
 
 @return NSString
 */
+ (NSString *)yj_getLibraryPathURL;

/**
 获取Caches Path URL
 
 @return NSString
 */
+ (NSString *)yj_getCachesPathURL;

/**
 获取指定NSSearchPathDirectory的Path URL
 
 @param directory NSSearchPathDirectory
 @return NSString
 */
+ (NSString *)yj_getPathURLForDirectory:(NSSearchPathDirectory)directory;

@end

NS_ASSUME_NONNULL_END

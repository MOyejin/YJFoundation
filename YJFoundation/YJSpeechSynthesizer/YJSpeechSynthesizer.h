//
//  YJSpeechSynthesizer.h
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJSpeechSynthesizer : NSObject

+ (instancetype)sharedSpeechSynthesizer;

/**
 是否正在进行语音播报
 
 @return BOOL
 */
- (BOOL)yj_isSpeaking;

/**
 输入指定的语音播报内容
 
 @param string 语音播报内容
 */
- (void)yj_speakString:(NSString *)string;

/**
 停止语音播报
 */
- (void)yj_stopSpeak;

/**
 选择语音播报的语言和播报速度
 
 @param language 语言, 默认中文
 @param speakSpeed 播报速度, 默认0.5
 */
- (void)yj_chooseVoiceWithLanguage:(NSString *)language
                        speakSpeed:(CGFloat)speakSpeed;

@end

NS_ASSUME_NONNULL_END

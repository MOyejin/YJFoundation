//
//  YJSpeechSynthesizer.m
//  YJFoundationDemo
//
//  Created by Moyejin168 on 2020/1/15.
//  Copyright © 2020 Moyejin. All rights reserved.
//

#import "YJSpeechSynthesizer.h"
#import <AVFoundation/AVFoundation.h>

@interface YJSpeechSynthesizer ()  <AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *yj_speechSynthesizer;
@property (nonatomic, strong) AVSpeechUtterance   *yj_avSpeechUtterance;

@end


@implementation YJSpeechSynthesizer

+ (instancetype)sharedSpeechSynthesizer {
    
    static YJSpeechSynthesizer *yj_sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        yj_sharedInstance = [[YJSpeechSynthesizer alloc] init];
    });
    
    return yj_sharedInstance;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        AVAudioSession *yj_avAudioSession = [AVAudioSession sharedInstance];
        
        [yj_avAudioSession setCategory:AVAudioSessionCategoryPlayback
                           withOptions:AVAudioSessionCategoryOptionDuckOthers
                                 error:NULL];
        
        self.yj_speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
        
        [self.yj_speechSynthesizer setDelegate:self];
    }
    
    return self;
}

- (BOOL)yj_isSpeaking {
    
    return self.yj_speechSynthesizer.isSpeaking;
}

- (void)yj_speakString:(NSString *)string {
    
    if (self.yj_speechSynthesizer) {
        
        self.yj_avSpeechUtterance = [AVSpeechUtterance speechUtteranceWithString:string];
        
        self.yj_avSpeechUtterance.rate  = 0.5;
        self.yj_avSpeechUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        
        if (self.yj_speechSynthesizer.isSpeaking) {
            
            [self.yj_speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        }
        
        [self.yj_speechSynthesizer speakUtterance:self.yj_avSpeechUtterance];
    }
}

- (void)yj_stopSpeak {
    
    if (self.yj_speechSynthesizer) {
        
        [self.yj_speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

- (void)yj_chooseVoiceWithLanguage:(NSString *)language
                        speakSpeed:(CGFloat)speakSpeed {
    
    self.yj_avSpeechUtterance.rate  = speakSpeed;
    self.yj_avSpeechUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:language];
}

@end

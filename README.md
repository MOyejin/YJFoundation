## YJFoundation
YJFoundation 是对系统 Foundation API 进行扩展的库

`YJFoundation`是对系统`Foundation API`进行扩展的库, `API`的用法全部都在`YJFoundationExample`里


支持`CocoaPod`管理

> pod 'YJFoundation'


## 目录

- [YJSpeechSynthesizer@](#YJSpeechSynthesizer)
- [NSArray+YJArray@](#NSArray+YJArray)
- [NSAttributedString+YJAttributedString@](#NSAttributedString+YJAttributedString)
- [NSBundle+YJBundle@](#NSBundle+YJBundle)
- [NSData+YJData@](#NSData+YJData)
- [NSDate+YJDate@](#NSDate+YJDate)
- [NSDate的属性@](NSDate的属性@)
- [时间戳处理/计算日期@](#时间戳处理/计算日期)
- [日期处理@](#日期处理)
- [日期格式化@](日期格式化@)
- [日期判断@](#日期判断)
- [获取NSDateComponents@](#获取NSDateComponents)
- [NSDictionary+YJDictionary@](#NSDictionary+YJDictionary)
- [NSFileManager+YJFileManager@](#NSFileManager+YJFileManager)
- [NSMutableArray+YJMutableArray@](#NSMutableArray+YJMutableArray)
- [NSMutableAttributedString+YJMutableAttributedString@](#NSMutableAttributedString+YJMutableAttributedString)
- [NSMutableDictionary+YJMutableDictionary@](#NSMutableDictionary+YJMutableDictionary)
- [NSNumber+YJNumber@](#NSNumber+YJNumber)
- [NSObject+YJObject@](#NSObject+YJObject)
- [RunTime@](#RunTime)
- [GCD@](#GCD)
- [NSString+YJString@](#NSString+YJString)
- [字符串计算@](#字符串计算)
- [字符串过滤@](#字符串过滤)
- [字符串转换@](#字符串转换)
- [字符串格式化@](#字符串格式化)
- [Base64加密字符串@](#Base64加密字符串)
- [MD加密字符串@](#MD加密字符串)
- [SHA加密字符串@](#SHA加密字符串)
- [NSString获取首字母@](#NSString获取首字母)
- [正则表达式(数字相关)@](#正则表达式(数字相关))
- [正则表达式验证(整数相关)@](#正则表达式验证(整数相关))
- [正则表达式验证(浮点数相关)@](#正则表达式验证(浮点数相关))
- [正则表达式验证(字符串相关)@](#正则表达式验证(字符串相关))
- [正则表达式验证(号码相关)@](#正则表达式验证(号码相关))
- [正则表达式验证(身份证相关)@](#正则表达式验证(身份证相关))
- [正则表达式验证(账号相关)@](#正则表达式验证(账号相关))
- [正则表达式验证(日期相关)@](#正则表达式验证(日期相关))
- [正则表达式验证(特殊相关)@](#正则表达式验证(特殊相关))
- [NSTimer+YJTimer@](#NSTimer+YJTimer)
- [NSURL+YJURL@](#NSURL+YJURL)




## YJSpeechSynthesizer@

**YJSpeechSynthesizer**基于**AVFoundation**实现的语音播报工具类:

```objective-c
+ (instancetype)sharedSpeechSynthesizer;

- (BOOL)yj_isSpeaking;

- (void)yj_speakString:(NSString *)string;

- (void)yj_stopSpeak;

- (void)yj_chooseVoiceWithLanguage:(NSString *)language
speakSpeed:(CGFloat)speakSpeed;
```



## NSArray+YJArray@

针对`Foundation`的`NSArray`进行系统外的方法补充:

```objective-c
+ (instancetype)yj_initSafeArrayWithObject:(id)object;

- (id)yj_safeObjectAtIndex:(NSUInteger)index;

- (NSArray *)yj_safeArrayWithRange:(NSRange)range;

- (NSUInteger)yj_safeIndexOfObject:(id)object;

+ (NSArray *)yj_getArrayWithPlistName:(NSString *)name;
```



## NSAttributedString+YJAttributedString@

针对`Foundation`的`NSAttributedString`进行系统外的方法补充:

```objective-c
- (CGFloat)yj_attributedStringHeightWithContainWidth:(CGFloat)width;

+ (NSAttributedString *)yj_attributeStringWithString:(NSString *)string
color:(UIColor *)color
range:(NSRange)range;

+ (NSAttributedString *)yj_attributeStringWithAttributedString:(NSAttributedString *)attributedString
color:(UIColor *)color
range:(NSRange)range;

+ (NSAttributedString *)yj_attributeStringWithString:(NSString *)string
font:(UIFont *)font
range:(NSRange)range;

+ (NSAttributedString *)yj_attributeStringWithAttributedString:(NSAttributedString *)attributedString
font:(UIFont *)font
range:(NSRange)range;

+ (NSAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
prefixFont:(UIFont *)prefixFont
suffixString:(NSString *)suffixString
suffixFont:(UIFont *)suffixFont;

+ (NSAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
prefixFont:(UIFont *)prefixFont
prefixColor:(UIColor *)prefixColor
suffixString:(NSString *)suffixString
suffixFont:(UIFont *)suffixFont
suffixColor:(UIColor *)suffixColor;
```



## NSBundle+YJBundle@

针对`Foundation`的`NSBundle`进行系统外的方法补充:

```objective-c
+ (NSString *)yj_getBundleDisplayName;

+ (NSString *)yj_getBundleShortVersionString;

+ (NSString *)yj_getBundleVersion;

+ (NSString *)yj_getBundleIdentifier;
```



## NSData+YJData@

针对`Foundation`的`NSData`进行系统外的方法补充:

```objective-c
typedef NS_ENUM(NSInteger, YJEncodedType) {

YJEncodedType64 = 64,
YJEncodedType76 = 76
};

+ (NSData *)yj_compressOriginalImage:(UIImage *)image
compressionQuality:(CGFloat)compressionQuality;

+ (NSString *)yj_replacingAPNsTokenWithData:(NSData *)data;

+ (NSData *)yj_transformDataWithBase64EncodedString:(NSString *)string;

+ (NSString *)yj_transformBase64EncodedStringWithData:(NSData *)data
wrapWidth:(YJEncodedType)wrapWidth;

- (NSData *)yj_encryptedDataWithAESKey:(NSString *)key
encryptData:(NSData *)encryptData;

- (NSData *)yj_decryptedDataWithAESKey:(NSString *)key
decryptData:(NSData *)decryptData;

- (NSData *)yj_encryptedDataWith3DESKey:(NSString *)key
encryptData:(NSData *)encryptData;

- (NSData *)yj_decryptedDataWith3DEKey:(NSString *)key
decryptData:(NSData *)decryptData;

- (NSString *)yj_encryptredMD2String;

- (NSData *)yj_encryptredMD2Data;

- (NSString *)yj_encryptredMD4String;

- (NSData *)yj_encryptredMD4Data;

- (NSString *)yj_encryptredMD5String;

- (NSString *)yj_hmacEncryptredMD5StringWithKey:(NSString *)key;

- (NSData *)yj_encryptredMD5Data;

- (NSData *)yj_hmacEncryptredMD5DataWithKey:(NSData *)key;

- (NSString *)yj_encryptredSHA1String;

- (NSString *)yj_hmacEncryptredSHA1StringWithKey:(NSString *)key;

- (NSData *)yj_encryptredSHA1Data;

- (NSData *)yj_hmacEncryptredSHA1DataWithKey:(NSData *)key;

- (NSString *)yj_encryptredSHA224String;

- (NSString *)yj_hmacEncryptredSHA224StringWithKey:(NSString *)key;

- (NSData *)yj_encryptredSHA224Data;

- (NSData *)yj_hmacEncryptredSHA224DataWithKey:(NSData *)key;

- (NSString *)yj_encryptredSHA256String;

- (NSString *)yj_hmacEncryptredSHA256StringWithKey:(NSString *)key;

- (NSData *)yj_encryptredSHA256Data;

- (NSData *)yj_hmacEncryptredSHA256DataWithKey:(NSData *)key;

- (NSString *)yj_encryptredSHA384String;

- (NSString *)yj_hmacEncryptredSHA384StringWithKey:(NSString *)key;

- (NSData *)yj_encryptredSHA384Data;

- (NSData *)yj_hmacEncryptredSHA384DataWithKey:(NSData *)key;

- (NSString *)yj_encryptredSHA512String;

- (NSString *)yj_hmacEncryptredSHA512StringWithKey:(NSString *)key;

- (NSData *)yj_encryptredSHA512Data;

- (NSData *)yj_hmacEncryptredSHA512DataWithKey:(NSData *)key;

- (id)yj_dataJSONValueDecoded;

+ (NSData *)yj_getDataWithBundleNamed:(NSString *)name;
```



## NSDate+YJDate@

针对`Foundation`的`NSDate`进行系统外的方法补充:

### NSDate的属性

```objective-c
@property (nonatomic, readonly) NSInteger yj_year;
@property (nonatomic, readonly) NSInteger yj_month;
@property (nonatomic, readonly) NSInteger yj_day;
@property (nonatomic, readonly) NSInteger yj_hour;
@property (nonatomic, readonly) NSInteger yj_minute;
@property (nonatomic, readonly) NSInteger yj_second;
@property (nonatomic, readonly) NSInteger yj_nanosecond;
@property (nonatomic, readonly) NSInteger yj_weekday;
@property (nonatomic, readonly) NSInteger yj_weekdayOrdinal;
@property (nonatomic, readonly) NSInteger yj_weekOfMonth;
@property (nonatomic, readonly) NSInteger yj_weekOfYear;
@property (nonatomic, readonly) NSInteger yj_yearForWeekOfYear;
@property (nonatomic, readonly) NSInteger yj_quarter;
@property (nonatomic, readonly) BOOL yj_isLeapMonth;
@property (nonatomic, readonly) BOOL yj_isLeapYear;
@property (nonatomic, readonly) BOOL yj_isToday;
@property (nonatomic, readonly) BOOL yj_isYesterday;
```




### 时间戳处理/计算日期@

```objective-c
+ (NSString *)yj_compareCureentTimeWithDate:(NSTimeInterval)timeStamp;

+ (NSString *)yj_getCurrentTimeStampString;

+ (NSTimeInterval)yj_getCurrentTimeStamp;

+ (NSString *)yj_displayTimeWithTimeStamp:(NSTimeInterval)timeStamp;

+ (NSString *)yj_calculateDaysWithDate:(NSDate *)date;

```


### 日期处理@

```objective-c
+ (NSUInteger)yj_getEraWithDate:(NSDate *)date;

+ (NSUInteger)yj_getYearWithDate:(NSDate *)date;

+ (NSUInteger)yj_getMonthWithDate:(NSDate *)date;

+ (NSUInteger)yj_getDayWithDate:(NSDate *)date;

+ (NSUInteger)yj_getHourWithDate:(NSDate *)date;

+ (NSUInteger)yj_getMinuteWithDate:(NSDate *)date;

+ (NSUInteger)yj_getSecondWithDate:(NSDate *)date;

+ (NSInteger)yj_getWeekdayStringFromDate:(NSDate *)date;

+ (NSInteger)yj_getDateTimeDifferenceWithBeginDate:(NSDate *)beginDate
endDate:(NSDate *)endDate;

+ (NSDate *)yj_getMonthFirstDeteWithDate:(NSDate *)date;

+ (NSDate *)yj_getMonthLastDayWithDate:(NSDate *)date;

+ (NSUInteger)yj_getWeekOfYearWithDate:(NSDate *)date;

+ (NSDate *)yj_getTomorrowDay:(NSDate *)date;

+ (NSDate *)yj_getYearDateWithDate:(NSDate *)date
years:(NSInteger)years;

+ (NSDate *)yj_getMonthDateWithDate:(NSDate *)date
months:(NSInteger)months;

+ (NSDate *)yj_getDaysDateWithDate:(NSDate *)date
days:(NSInteger)days;

+ (NSDate *)yj_getHoursDateWithDate:(NSDate *)date
hours:(NSInteger)hours;
```

### 日期格式化

```objective-c
+ (NSString *)yj_getStringDateWithTimeStamp:(NSTimeInterval)timeStamp
formatter:(NSString *)formatter;

- (NSString *)yj_getStringDateWithFormatter:(NSString *)formatter;

+ (NSString *)yj_getStringDateWithDate:(NSDate *)date
formatter:(NSString *)formatter;

+ (NSString *)yj_getStringDateWithDate:(NSDate *)date
formatter:(NSString *)formatter
timeZone:(NSTimeZone *)timeZone
locale:(NSLocale *)locale;

+ (NSDate *)yj_getDateWithDateString:(NSString *)dateString
formatter:(NSString *)formatter;

+ (NSDate *)yj_getDateWithDateString:(NSString *)dateString
formatter:(NSString *)formatter
timeZone:(NSTimeZone *)timeZone
locale:(NSLocale *)locale;
```



### 日期判断@

```objective-c
+ (BOOL)yj_isLeapYear:(NSDate *)date;

+ (BOOL)yj_checkTodayWithDate:(NSDate *)date;
```


### 获取NSDateComponents@

```objective-c
+ (NSDateComponents *)yj_getCalendarWithUnitFlags:(NSCalendarUnit)unitFlags
date:(NSDate *)date;
```



## NSDictionary+YJDictionary@

针对`Foundation`的`NSDictionary`进行系统外的方法补充:

```objective-c
+ (NSDictionary *)yj_dictionaryWithPlistData:(NSData *)plist;

+ (NSDictionary *)yj_dictionaryWithURLString:(NSString *)urlString;

- (NSArray *)yj_getAllKeysSorted;

- (NSArray *)yj_getAllValuesSortedByKeys;

- (BOOL)yj_containsObjectForKey:(id)key;

- (NSDictionary *)yj_getDictionaryForKeys:(NSArray *)keys;
```



## NSFileManager+YJFileManager@

针对`Foundation`的`NSFileManager`进行系统外的方法补充:

```objective-c
+ (BOOL)yj_saveDataCacheWithData:(NSData *)data
identifier:(NSString *)identifier;

+ (BOOL)yj_saveDataCacheWithData:(NSData *)data
cacheName:(NSString *)cacheName
identifier:(NSString *)identifier;

+ (NSData *)yj_getDataCacheWithIdentifier:(NSString *)identifier;

+ (NSData *)yj_getDataCacheWithCacheName:(NSString *)cacheName
identifier:(NSString *)identifier;

+ (BOOL)yj_removeDataWithCache;

+ (BOOL)yj_removeDataWithCacheWithCacheName:(NSString *)cacheName;

+ (BOOL)yj_saveDocumentWithObject:(id)object
fileName:(NSString *)fileName;

+ (BOOL)yj_removeDocumentObjectWithFileName:(NSString *)fileName;

+ (id)yj_getDocumentObjectWithFileName:(NSString *)fileName;

+ (BOOL)yj_checkFileExistWithFilePath:(NSString *)filePath;

+ (NSUInteger)yj_getApplicationDocumentSize;

+ (NSUInteger)yj_getApplicationCacheSize;

+ (NSUInteger)yj_getApplicationLibrarySize;

+ (NSUInteger)yj_getApplicationFileSizeWithFilePath:(NSString *)folderPath;
```



## NSMutableArray+YJMutableArray@

针对`Foundation`的`NSMutableArray`进行系统外的方法补充:

```objective-c
- (void)yj_addSafeObject:(id)object;

- (void)yj_insertSafeObject:(id)object
index:(NSUInteger)index;

- (void)yj_safeRemoveObjectAtIndex:(NSUInteger)index;

- (void)yj_safeRemoveObjectsInRange:(NSRange)range;
```



## NSMutableAttributedString+YJMutableAttributedString@

针对`Foundation`的`NSMutableAttributedString`进行系统外的方法补充:

```objective-c
+ (NSMutableAttributedString *)yj_attributeStringWithSubffixString:(NSString *)subffixString
subffixImage:(UIImage *)subffixImage;

+ (NSMutableAttributedString *)yj_attributeStringWithSubffixString:(NSString *)subffixString
subffixImages:(NSArray<UIImage *> *)subffixImages;

+ (NSMutableAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
prefixImage:(UIImage *)prefixImage;

+ (NSMutableAttributedString *)yj_attributeStringWithPrefixString:(NSString *)prefixString
prefixImages:(NSArray<UIImage *> *)prefixImages;

+ (NSMutableAttributedString *)yj_attributedStringWithString:(NSString *)string
lineSpacing:(CGFloat)lineSpacing;

+ (NSMutableAttributedString *)yj_attributedStringWithAttributedString:(NSAttributedString *)attributedString
lineSpacing:(CGFloat)lineSpacing;

+ (NSMutableAttributedString *)yj_attributedStringAddLineWithString:(NSString *)string
range:(NSRange)range;

+ (NSMutableAttributedString *)yj_attributedStringAddLineWithAttributedString:(NSAttributedString *)attributedString
range:(NSRange)range;
```



## NSMutableDictionary+YJMutableDictionary@

针对`Foundation`的`NSMutableDictionary`进行系统外的方法补充:

```objective-c
- (void)yj_setSafeObject:(id)object
forKey:(id)key;

- (id)yj_safeObjectForKey:(id)key;

- (id)yj_safeKeyForValue:(id)value;

+ (NSMutableDictionary *)yj_mutableDictionaryWithPlistData:(NSData *)plist;

- (NSMutableDictionary *)yj_popEntriesForKeys:(NSArray *)keys;
```



## NSNumber+YJNumber@

针对`Foundation`的`NSNumber`进行系统外的方法补充:

```objective-c
+ (NSString *)yj_displayDecimalWithNumber:(NSNumber *)number
digit:(NSUInteger)digit;

+ (NSString *)yj_displayCurrencyWithNumber:(NSNumber *)number
digit:(NSUInteger)digit;

+ (NSString *)yj_displayPercentWithNumber:(NSNumber *)number
digit:(NSUInteger)digit;

+ (NSNumber *)yj_roundingWithNumber:(NSNumber *)number
digit:(NSUInteger)digit;

+ (NSNumber *)yj_roundCeilingWithNumber:(NSNumber *)number
digit:(NSUInteger)digit;

+ (NSNumber *)yj_roundFloorWithNumber:(NSNumber *)number
digit:(NSUInteger)digit;
```

## NSObject+YJObject@

针对`Foundation`的`NSObject`进行系统外的方法补充:



### RunTime@

```objective-c
+ (void)yj_exchangeImplementationsWithYJass:(YJass)YJass
originalSelector:(SEL)originalSelector
swizzledSelector:(SEL)swizzledSelector;

+ (BOOL)yj_addMethodWithYJass:(YJass)YJass
originalSelector:(SEL)originalSelector
swizzledSelector:(SEL)swizzledSelector;

+ (void)yj_replaceMethodWithYJass:(YJass)YJass
originalSelector:(SEL)originalSelector
swizzledSelector:(SEL)swizzledSelector;

+ (NSArray <NSString *> *)yj_getYJassList;

+ (NSArray <NSString *> *)yj_getYJassMethodListWithYJass:(YJass)YJass;

+ (NSArray <NSString *> *)yj_getPropertyListWithYJass:(YJass)YJass;

+ (NSArray <NSString *> *)yj_getIVarListWithYJass:(YJass)YJass;

+ (NSArray <NSString *> *)yj_getProtocolListWithYJass:(YJass)YJass;

- (BOOL)yj_hasPropertyWithKey:(NSString *)key;

- (BOOL)yj_hasIvarWithKey:(NSString *)key;
```



### GCD@

```objective-c
- (void)yj_performAsyncWithComplete:(YJObject)complete;

- (void)yj_performMainThreadWithComplete:(YJObject)complete
isWait:(BOOL)isWait;

- (void)yj_performWithAfterSecond:(NSTimeInterval)afterSecond
complete:(YJObject)complete;
```



## NSString+YJString@

针对`Foundation`的`NSString`进行系统外的方法补充:



### 字符串计算

```objective-c
- (CGFloat)yj_heightWithFontSize:(CGFloat)fontSize
width:(CGFloat)width;

+ (CGFloat)yj_measureHeightWithMutilineString:(NSString *)string
font:(UIFont *)font
width:(CGFloat)width;

+ (CGFloat)yj_measureSingleLineStringWidthWithString:(NSString *)string
font:(UIFont *)font;

+ (CGSize)yj_measureStringSizeWithString:(NSString *)string
font:(UIFont *)font;

+ (CGSize)yj_measureStringWithString:(NSString *)string
font:(UIFont *)font
size:(CGSize)size
mode:(NSLineBreakMode)lineBreakMode;
```



### 字符串过滤

```objective-c
- (NSString *)yj_removeUnwantedZero;

- (NSString *)yj_trimmedString;

- (NSString *)yj_trimmedAllString;

- (NSString *)yj_removeStringCharacterWithCharacter:(NSString *)character;
```



### 字符串格式化

```objective-c
+ (NSString *)yj_getNumberWithString:(NSString *)string;

+ (NSString *)yj_getSecrectStringWithCardNumber:(NSString *)cardNumber;

+ (NSString *)yj_getSecrectStringWithPhoneNumber:(NSString *)phoneNumber;

+ (NSString *)yj_stringMobileFormat:(NSString *)phoneNumber;

+ (NSString *)yj_stringMobileFormat:(NSString *)phoneNumber
separator:(NSString *)separator;

+ (NSString *)yj_stringUnitFormat:(CGFloat)value
unitString:(NSString *)unitString;
```



### Base64加密字符串

```objective-c
+ (NSString *)yj_base64StringFromData:(NSData *)data
length:(NSUInteger)length;

+ (NSString *)yj_encodingBase64WithString:(NSString *)string;

+ (NSString *)yj_decodedBase64WithString:(NSString *)string;
```



### MD加密字符串@

```objective-c
+ (NSString *)yj_encodingMD2WithString:(NSString *)string;

+ (NSString *)yj_encodingMD4WithString:(NSString *)string;

+ (NSString *)yj_encodingMD5WithString:(NSString *)string;

+ (NSString *)yj_hmacEncodingMD5StringWithString:(NSString *)string
key:(NSString *)key;
```



### SHA加密字符串@

```objective-c
+ (NSString *)yj_encodingSHA1WithString:(NSString *)string;

+ (NSString *)yj_hmacEncodingSHA1StringWithString:(NSString *)string
key:(NSString *)key;

+ (NSString *)yj_encodingSHA224WithString:(NSString *)string;

+ (NSString *)yj_hmacEncodingSHA224StringWithString:(NSString *)string
key:(NSString *)key;

+ (NSString *)yj_encodingSHA256WithString:(NSString *)string;

+ (NSString *)yj_hmacEncodingSHA256StringWithString:(NSString *)string
key:(NSString *)key;

+ (NSString *)yj_encodingSHA384WithString:(NSString *)string;

+ (NSString *)yj_hmacEncodingSHA384StringWithString:(NSString *)string
key:(NSString *)key;

+ (NSString *)yj_encodingSHA512WithString:(NSString *)string;

+ (NSString *)yj_hmacEncodingSHA512StringWithString:(NSString *)string
key:(NSString *)key;
```



### NSString获取首字母@

```objective-c
+ (NSString *)yj_getFirstCharactorWithString:(NSString *)string;

+ (NSString *)yj_getFirstPinYinWithString:(NSString *)string;
```



### 正则表达式(数字相关)@

```objective-c
- (BOOL)yj_realContainDecimal;
```



### 正则表达式验证(整数相关)@

```objective-c
- (BOOL)yj_isNumber;

- (BOOL)yj_checkMostNumber:(NSInteger)quantity;

- (BOOL)yj_checkAtLeastNumber:(NSInteger)quantity;

- (BOOL)yj_checkLeastNumber:(NSInteger)leastNumber
mostNumber:(NSInteger)mostNumber;

- (BOOL)yj_isNotZeroStartNumber;

- (BOOL)yj_isNotZeroPositiveInteger;

- (BOOL)yj_isNotZeroNegativeInteger;

- (BOOL)yj_isPositiveInteger;

- (BOOL)yj_isNegativeInteger;
```



### 正则表达式验证(浮点数相关)@

```objective-c
- (BOOL)yj_isFloat;

- (BOOL)yj_isPositiveFloat;

- (BOOL)yj_isNagativeFloat;

- (BOOL)yj_isNotZeroStartNumberHaveOneOrTwoDecimal;

- (BOOL)yj_isHaveOneOrTwoDecimalPositiveOrNegative;

- (BOOL)yj_isPositiveRealHaveTwoDecimal;

- (BOOL)yj_isHaveOneOrThreeDecimalPositiveOrNegative;
```



### 正则表达式验证(字符串相关)@

```objective-c
- (BOOL)yj_isChineseCharacter;

- (BOOL)yj_isEnglishOrNumbers;

- (BOOL)yj_limitinglength:(NSInteger)fistRange
lastRange:(NSInteger)lastRange;

- (BOOL)yj_checkString:(NSInteger)length;

- (BOOL)yj_isLettersString;

- (BOOL)yj_isCapitalLetters;

- (BOOL)yj_isLowercaseLetters;

- (BOOL)yj_isNumbersOrLettersOrLineString;

- (BOOL)yj_isChineseCharacterOrEnglishOrNumbersOrLineString;

- (BOOL)yj_isDoesSpecialCharactersString;

- (BOOL)yj_isContainSpecialCharacterString;

- (BOOL)yj_isContainCharacter:(NSString *)charater;

- (BOOL)yj_isLetterStar;

- (BOOL)yj_checkStringIsStrong;

- (BOOL)yj_checkChineseCharacter;

- (BOOL)yj_checkDoubleByteCharacters;

- (BOOL)yj_checkBlankLines;

- (BOOL)yj_checkFirstAndLastSpaceCharacters;
```



### 正则表达式验证(号码相关)@

```objective-c
- (BOOL)yj_checkPhoneNumber;

- (BOOL)yj_checkChinaMobelPhoneNumber;

- (BOOL)yj_checkChinaUnicomPhoneNumber;

- (BOOL)yj_checkChinaTelecomPhoneNumber;

- (BOOL)yj_checkTelePhoneNumber;

- (BOOL)yj_checkFormatTelePhoneNumber;
```



### 正则表达式验证(身份证相关)@

```objective-c
- (BOOL)yj_checkIdentityCard;
```



### 正则表达式验证(账号相关)@

```objective-c
- (BOOL)yj_checkAccount;

- (BOOL)yj_checkPassword;

- (BOOL)yj_checkStrongPassword:(NSInteger)briefest
longest:(NSInteger)longest;
```



### 正则表达式验证(日期相关)@

```objective-c
- (BOOL)yj_checkChinaDateFormat;

- (BOOL)yj_checkAbroadDateFormat;

- (BOOL)yj_checkMonth;

- (BOOL)yj_checkDay;
```



### 正则表达式验证(特殊正则)@

```objective-c
- (BOOL)yj_checkEmailAddress;

- (BOOL)yj_checkDomainName;

- (BOOL)yj_checkURL;

- (BOOL)yj_checkXMLFile;

- (BOOL)yj_checkHTMLSign;

- (BOOL)yj_checkQQNumber;

- (BOOL)yj_checkPostalCode;

- (BOOL)yj_checkIPv4InternetProtocol;

- (BOOL)yj_regularWithRule:(NSString *)rule;
```



## NSTimer+YJTimer@

针对`Foundation`的`NSTimer`进行系统外的方法补充:

```objective-c
+ (NSTimer *)yj_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
repeats:(BOOL)repeats
complete:(YJTimer)complete;

+ (NSTimer *)yj_timerWithTimeInterval:(NSTimeInterval)timeInterval
repeats:(BOOL)repeats
complete:(YJTimer)complete;

- (void)yj_resumeTimer;

- (void)yj_pauseTimer;

- (void)yj_resumeTimerAfterTimeInterval:(NSTimeInterval)timeInterval;
```



## NSURL+YJURL@

针对`Foundation`的`NSURL`进行系统外的方法补充:

```objective-c
+ (void)yj_openBrowserWithURL:(NSString *)urlString;

+ (NSURL *)yj_getDocumentFileURL;

+ (NSURL *)yj_getLibraryFileURL;

+ (NSURL *)yj_getCachesFileURL;

+ (NSURL *)yj_getFileURLForDirectory:(NSSearchPathDirectory)directory;

+ (NSString *)yj_getDocumentPathURL;

+ (NSString *)yj_getLibraryPathURL;

+ (NSString *)yj_getCachesPathURL;

+ (NSString *)yj_getPathURLForDirectory:(NSSearchPathDirectory)directory;
```

[向CainLuo学习](https://github.com/CainLuo/CLFoundation)

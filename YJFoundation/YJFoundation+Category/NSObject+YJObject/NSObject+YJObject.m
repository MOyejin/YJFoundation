//
//  NSObject+YJObject.m
//  YJFoundationExample
//
//  Created by Moyejin168 on 2018/2/21.
//  Copyright © 2018年 Moyejin168. All rights reserved.
//

#import "NSObject+YJObject.h"
#import "NSString+YJString.h"
#import <objc/objc.h>

static const int YJObjectKVOBlockCategoryKey;

#pragma mark - KVO Block Object Category
@interface YJObjectKVOBlockCategory : NSObject

@property (nonatomic, copy) YJObjectKVOBlock yj_objectKVOBlock;

- (instancetype)initWithObjectKVOBlock:(YJObjectKVOBlock)block;

@end

@implementation YJObjectKVOBlockCategory

- (instancetype)initWithObjectKVOBlock:(YJObjectKVOBlock)block {
    
    self = [super init];
    
    if (self) {
        
        self.yj_objectKVOBlock = block;
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if (!self.yj_objectKVOBlock) {
        return;
    }
    
    BOOL yj_isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    
    if (yj_isPrior) {
        
        return;
    }
    
    NSKeyValueChange yj_keyValueChange = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    
    if (yj_keyValueChange != NSKeyValueChangeSetting) {
        return;
    }
    
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    
    if (oldValue == [NSNull null]) {
        
        oldValue = nil;
    }
    
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    
    if (newValue == [NSNull null]) {
        
        newValue = nil;
    }
    
    if (self.yj_objectKVOBlock) {
        
        self.yj_objectKVOBlock(object, oldValue, newValue);
    }
}

@end

@implementation NSObject (YJObject)

#pragma mark - Runtime
+ (void)yj_exchangeImplementationsWithClass:(Class)Class
                           originalSelector:(SEL)originalSelector
                           swizzledSelector:(SEL)swizzledSelector {
    
    Method yj_originalMethod = class_getInstanceMethod(Class, originalSelector);
    Method yj_swizzledSelector = class_getInstanceMethod(Class, swizzledSelector);
    
    BOOL yj_didAddMethod = [self yj_addMethodWithClass:Class
                                      originalSelector:originalSelector
                                      swizzledSelector:swizzledSelector];
    
    if (yj_didAddMethod) {

        class_replaceMethod(Class,
                            swizzledSelector,
                            method_getImplementation(yj_originalMethod),
                            method_getTypeEncoding(yj_originalMethod));
    } else {
        
        method_exchangeImplementations(yj_originalMethod, yj_swizzledSelector);
    }
}

+ (BOOL)yj_addMethodWithClass:(Class)Class
             originalSelector:(SEL)originalSelector
             swizzledSelector:(SEL)swizzledSelector {
    
    Method yj_swizzledSelector = class_getInstanceMethod(Class, swizzledSelector);

    BOOL yj_didAddMethod = class_addMethod(Class,
                                           originalSelector,
                                           class_getMethodImplementation(Class, swizzledSelector),
                                           method_getTypeEncoding(yj_swizzledSelector));

    
    return yj_didAddMethod;
}

+ (void)yj_replaceMethodWithClass:(Class)Class
                 originalSelector:(SEL)originalSelector
                 swizzledSelector:(SEL)swizzledSelector {
    
    Method yj_originalMethod = class_getInstanceMethod(Class, originalSelector);

    class_replaceMethod(Class,
                        swizzledSelector,
                        method_getImplementation(yj_originalMethod),
                        method_getTypeEncoding(yj_originalMethod));
}

+ (NSArray <NSString *> *)yj_getClassList {
    
    NSMutableArray *yj_classArray = [NSMutableArray array];
    
    unsigned int yj_classCount;
    
    Class *yj_class = objc_copyClassList(&yj_classCount);
    
    for (int i = 0; i < yj_classCount; i++) {
        
        [yj_classArray addObject:NSStringFromClass(yj_class[i])];
    }
    
    free(yj_class);
    
    [yj_classArray sortedArrayUsingSelector:@selector(compare:)];
    
    return yj_classArray;
}

+ (NSArray <NSString *> *)yj_getClassMethodListWithClass:(Class)class {
    
    NSMutableArray *yj_selectorArray = [NSMutableArray array];
    
    unsigned int yj_methodCount = 0;
    
    const char *yj_className = class_getName(class);
    
    Class yj_metaClass = objc_getMetaClass(yj_className);
    
    Method *yj_methodList = class_copyMethodList(yj_metaClass, &yj_methodCount);
    
    for (int i = 0; i < yj_methodCount; i++) {
        
        Method yj_method = yj_methodList[i];
        
        SEL yj_selector = method_getName(yj_method);
        
        const char *yj_constCharMethodName = sel_getName(yj_selector);
        
        NSString *yj_methodName = [[NSString alloc] initWithUTF8String:yj_constCharMethodName];
        
        [yj_selectorArray addObject:yj_methodName];
    }
    
    free(yj_methodList);

    return yj_selectorArray;
}

+ (NSArray <NSString *> *)yj_getPropertyListWithClass:(Class)Class {
    
    unsigned int yj_propertyCount;
    
    objc_property_t *yj_propertyList = class_copyPropertyList(Class, &yj_propertyCount);
    
    NSMutableArray *yj_propertyArray = [NSMutableArray array];
    
    for (int i = 0; i < yj_propertyCount; i++) {

        objc_property_t yj_property = yj_propertyList[i];
        
        const char *yj_constCharProperty = property_getName(yj_property);

        NSString *yj_propertyName = [NSString stringWithCString:yj_constCharProperty
                                                       encoding:NSUTF8StringEncoding];
        
        [yj_propertyArray addObject:yj_propertyName];
    }
    
    free(yj_propertyList);

    return yj_propertyArray;
}

+ (NSArray <NSString *> *)yj_getIVarListWithClass:(Class)Class {
    
    unsigned int yj_ivarCount;
    
    Ivar *yj_ivarList = class_copyIvarList(Class, &yj_ivarCount);
    
    NSMutableArray *yj_ivarArray = [NSMutableArray array];
    
    for (int i = 0; i < yj_ivarCount; i++) {
        
        Ivar yj_ivar = yj_ivarList[i];
        
        const char *yj_constCharIvar = ivar_getName(yj_ivar);
        
        NSString *yj_ivarName = [NSString stringWithCString:yj_constCharIvar
                                                   encoding:NSUTF8StringEncoding];
        
        [yj_ivarArray addObject:yj_ivarName];
    }
    
    free(yj_ivarList);

    return yj_ivarArray;
}

+ (NSArray <NSString *> *)yj_getProtocolListWithClass:(Class)Class {
    
    unsigned int yj_protocolCount;
    
    NSMutableArray *yj_protocolArray = [NSMutableArray array];
    
    __unsafe_unretained Protocol **yj_protocolList = class_copyProtocolList(Class, &yj_protocolCount);
    
    for (int i = 0; i < yj_protocolCount; i++) {
        
        Protocol *yj_protocal = yj_protocolList[i];
        
        const char *yj_constCharProtocolName = protocol_getName(yj_protocal);
        
        NSString *yj_protocolName = [NSString stringWithCString:yj_constCharProtocolName
                                                   encoding:NSUTF8StringEncoding];

        [yj_protocolArray addObject:yj_protocolName];
    }
    
    free(yj_protocolList);
    
    return yj_protocolArray;
}

- (BOOL)yj_hasPropertyWithKey:(NSString *)key {
    
    objc_property_t yj_property = class_getProperty([self class], [key UTF8String]);
    
    return (BOOL)yj_property;
}

- (BOOL)yj_hasIvarWithKey:(NSString *)key {
    
    Ivar yj_ivar = class_getInstanceVariable([self class], [key UTF8String]);
    
    return (BOOL)yj_ivar;
}

#pragma mark - GCD
- (void)yj_performAsyncWithComplete:(YJObject)complete {

    dispatch_queue_t yj_globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(yj_globalQueue, complete);
}

- (void)yj_performMainThreadWithWait:(BOOL)wait
                            complete:(YJObject)complete {
    
    if (wait) {
        
        dispatch_sync(dispatch_get_main_queue(), complete);
    } else {
        
        dispatch_async(dispatch_get_main_queue(), complete);
    }
}

- (void)yj_performWithAfterSecond:(NSTimeInterval)afterSecond
                         complete:(YJObject)complete {

    dispatch_time_t yj_time = dispatch_time(DISPATCH_TIME_NOW, afterSecond * NSEC_PER_SEC);
    
    dispatch_after(yj_time, dispatch_get_main_queue(), complete);
}

- (void)yj_addObserverWithKeyPath:(NSString *)keyPath
                         complete:(YJObjectKVOBlock)complete {
    
    if ([NSString yj_checkEmptyWithString:keyPath] || !complete) {
        return;
    }
    
    YJObjectKVOBlockCategory *yj_objectKVOBlockCategory = [[YJObjectKVOBlockCategory alloc] initWithObjectKVOBlock:complete];
    
    NSMutableDictionary *yj_mutableDictionary = [self yj_allObjectObserverBlocks];
    
    NSMutableArray *yj_mutableArray = yj_mutableDictionary[keyPath];
    
    if (!yj_mutableArray) {
        
        yj_mutableArray = [NSMutableArray array];
        
        yj_mutableDictionary[keyPath] = yj_mutableArray;
    }
    
    [yj_mutableArray addObject:yj_objectKVOBlockCategory];
    
    [self addObserver:yj_objectKVOBlockCategory
           forKeyPath:keyPath
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
}

- (void)yj_removeObserverWithKeyPath:(NSString *)keyPath {
    
    if ([NSString yj_checkEmptyWithString:keyPath]) {
        return;
    }
    
    NSMutableDictionary *yj_mutableDictionary = [self yj_allObjectObserverBlocks];
    
    NSMutableArray *yj_mutableArray = yj_mutableDictionary[keyPath];
    
    [yj_mutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self removeObserver:obj
                  forKeyPath:keyPath];
    }];
    
    [yj_mutableDictionary removeObjectForKey:keyPath];
}

- (void)yj_removeAllObserver {
    
    NSMutableDictionary *yj_mutableDictionary = [self yj_allObjectObserverBlocks];

    [yj_mutableDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *obj, BOOL * _Nonnull stop) {
        
        [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self removeObserver:obj
                      forKeyPath:key];
        }];
    }];
    
    [yj_mutableDictionary removeAllObjects];
}

- (NSMutableDictionary *)yj_allObjectObserverBlocks {
    
    NSMutableDictionary *yj_mutableDictionary = objc_getAssociatedObject(self, &YJObjectKVOBlockCategoryKey);
    
    if (!yj_mutableDictionary) {
        
        yj_mutableDictionary = [NSMutableDictionary dictionary];
        
        objc_setAssociatedObject(self, &YJObjectKVOBlockCategoryKey, yj_mutableDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return yj_mutableDictionary;
}

@end


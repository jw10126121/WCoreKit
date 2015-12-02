//
//  NSNull+WTool.m
//  Worker
//
//  Created by Linjw on 14-4-8.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import "NSNull+WTool.h"

@implementation NSNull (WTool)

+ (id)idNull
{
    return [NSNull null];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *sig = [[NSNull class] instanceMethodSignatureForSelector:selector];
    if(sig == nil) {
        sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    }
    return sig;
}

#pragma mark - 类型转化
- (NSInteger) integerValue {
    return 0;
}

- (NSUInteger) unsignedIntegerValue {
    return 0;
}

- (int) intValue {
    return 0;
}

- (double) doubleValue {
    return 0.0;
}

- (BOOL) boolValue {
    return NO;
}

- (float) floatValue {
    return 0.0;
}

- (CGFloat) CGFloatValue {
    return 0.0;
}

- (NSString*) description {
    return @"";
}

- (NSString*) descriptionWithLocale:(NSLocale*)locale {
    return @"";
}

@end

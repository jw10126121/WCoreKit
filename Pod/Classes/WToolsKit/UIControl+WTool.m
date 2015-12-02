//
//  UIControl+WTool.m
//  
//
//  Created by Linjw on 14-3-18.
//  Copyright (c) 2014年 Linjw QQ:10126121. All rights reserved.
//

#import "UIControl+WTool.h"
#import <objc/runtime.h>
char const kPropertyIdentificationKey_ControlEventCBKKey;

@implementation UIControl (WTool)

-(void)wSetEvent:(UIControlEvents)event ControlEventCBK:(void(^)(id sender))callback
{
    NSString *methodName = [UIControl wEventName:event];
    objc_setAssociatedObject(self, &kPropertyIdentificationKey_ControlEventCBKKey, callback, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

-(void)wRemoveHandlerForEvent:(UIControlEvents)event
{
     NSString * methodName = [UIControl wEventName:event];
    [self removeTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

- (void)wActionCallBack:(UIControlEvents)event {
    void(^eventCBK)(id sender) = objc_getAssociatedObject(self, &kPropertyIdentificationKey_ControlEventCBKKey);
    if (eventCBK)
    {
        eventCBK(self);
    }
}

-(void)UIControlEventTouchDown{[self wActionCallBack:UIControlEventTouchDown];}
-(void)UIControlEventTouchDownRepeat{[self wActionCallBack:UIControlEventTouchDownRepeat];}
-(void)UIControlEventTouchDragInside{[self wActionCallBack:UIControlEventTouchDragInside];}
-(void)UIControlEventTouchDragOutside{[self wActionCallBack:UIControlEventTouchDragOutside];}
-(void)UIControlEventTouchDragEnter{[self wActionCallBack:UIControlEventTouchDragEnter];}
-(void)UIControlEventTouchDragExit{[self wActionCallBack:UIControlEventTouchDragExit];}
-(void)UIControlEventTouchUpInside{[self wActionCallBack:UIControlEventTouchUpInside];}
-(void)UIControlEventTouchUpOutside{[self wActionCallBack:UIControlEventTouchUpOutside];}
-(void)UIControlEventTouchCancel{[self wActionCallBack:UIControlEventTouchCancel];}
-(void)UIControlEventValueChanged{[self wActionCallBack:UIControlEventValueChanged];}
-(void)UIControlEventEditingDidBegin{[self wActionCallBack:UIControlEventEditingDidBegin];}
-(void)UIControlEventEditingChanged{[self wActionCallBack:UIControlEventEditingChanged];}
-(void)UIControlEventEditingDidEnd{[self wActionCallBack:UIControlEventEditingDidEnd];}
-(void)UIControlEventEditingDidEndOnExit{[self wActionCallBack:UIControlEventEditingDidEndOnExit];}
-(void)UIControlEventAllTouchEvents{[self wActionCallBack:UIControlEventAllTouchEvents];}
-(void)UIControlEventAllEditingEvents{[self wActionCallBack:UIControlEventAllEditingEvents];}
-(void)UIControlEventApplicationReserved{[self wActionCallBack:UIControlEventApplicationReserved];}
-(void)UIControlEventSystemReserved{[self wActionCallBack:UIControlEventSystemReserved];}
-(void)UIControlEventAllEvents{[self wActionCallBack:UIControlEventAllEvents];}

+(NSString *)wEventName:(UIControlEvents)event
{
    switch (event) {
        case UIControlEventTouchDown:          return @"UIControlEventTouchDown";
        case UIControlEventTouchDownRepeat:    return @"UIControlEventTouchDownRepeat";
        case UIControlEventTouchDragInside:    return @"UIControlEventTouchDragInside";
        case UIControlEventTouchDragOutside:   return @"UIControlEventTouchDragOutside";
        case UIControlEventTouchDragEnter:     return @"UIControlEventTouchDragEnter";
        case UIControlEventTouchDragExit:      return @"UIControlEventTouchDragExit";
        case UIControlEventTouchUpInside:      return @"UIControlEventTouchUpInside";
        case UIControlEventTouchUpOutside:     return @"UIControlEventTouchUpOutside";
        case UIControlEventTouchCancel:        return @"UIControlEventTouchCancel";
        case UIControlEventValueChanged:       return @"UIControlEventValueChanged";
        case UIControlEventEditingDidBegin:    return @"UIControlEventEditingDidBegin";
        case UIControlEventEditingChanged:     return @"UIControlEventEditingChanged";
        case UIControlEventEditingDidEnd:      return @"UIControlEventEditingDidEnd";
        case UIControlEventEditingDidEndOnExit:return @"UIControlEventEditingDidEndOnExit";
        case UIControlEventAllTouchEvents:     return @"UIControlEventAllTouchEvents";
        case UIControlEventAllEditingEvents:   return @"UIControlEventAllEditingEvents";
        case UIControlEventApplicationReserved:return @"UIControlEventApplicationReserved";
        case UIControlEventSystemReserved:     return @"UIControlEventSystemReserved";
        case UIControlEventAllEvents:          return @"UIControlEventAllEvents";
        default:
            return @"description";
    }
}

+(UIControlEvents)wEventWithName:(NSString *)name
{
    if([name isEqualToString:@"UIControlEventTouchDown"])           return UIControlEventTouchDown;
    if([name isEqualToString:@"UIControlEventTouchDownRepeat"])     return UIControlEventTouchDownRepeat;
    if([name isEqualToString:@"UIControlEventTouchDragInside"])     return UIControlEventTouchDragInside;
    if([name isEqualToString:@"UIControlEventTouchDragOutside"])    return UIControlEventTouchDragOutside;
    if([name isEqualToString:@"UIControlEventTouchDragEnter"])      return UIControlEventTouchDragEnter;
    if([name isEqualToString:@"UIControlEventTouchDragExit"])       return UIControlEventTouchDragExit;
    if([name isEqualToString:@"UIControlEventTouchUpInside"])       return UIControlEventTouchUpInside;
    if([name isEqualToString:@"UIControlEventTouchUpOutside"])      return UIControlEventTouchUpOutside;
    if([name isEqualToString:@"UIControlEventTouchCancel"])         return UIControlEventTouchCancel;
    if([name isEqualToString:@"UIControlEventTouchDown"])           return UIControlEventTouchDown;
    if([name isEqualToString:@"UIControlEventValueChanged"])        return UIControlEventValueChanged;
    if([name isEqualToString:@"UIControlEventEditingDidBegin"])     return UIControlEventEditingDidBegin;
    if([name isEqualToString:@"UIControlEventEditingChanged"])      return UIControlEventEditingChanged;
    if([name isEqualToString:@"UIControlEventEditingDidEnd"])       return UIControlEventEditingDidEnd;
    if([name isEqualToString:@"UIControlEventEditingDidEndOnExit"]) return UIControlEventEditingDidEndOnExit;
    if([name isEqualToString:@"UIControlEventAllTouchEvents"])      return UIControlEventAllTouchEvents;
    if([name isEqualToString:@"UIControlEventAllEditingEvents"])    return UIControlEventAllEditingEvents;
    if([name isEqualToString:@"UIControlEventApplicationReserved"]) return UIControlEventApplicationReserved;
    if([name isEqualToString:@"UIControlEventSystemReserved"])      return UIControlEventSystemReserved;
    if([name isEqualToString:@"UIControlEventAllEvents"])           return UIControlEventAllEvents;
    return UIControlEventAllEvents;
}

@end

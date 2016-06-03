//
//  NSTimer+WTool.m(Pods)
//
//
//  Created by linjiawei on 16/6/3.
//
//

#import "NSTimer+WTool.h"

@implementation NSTimer (WTool)

+(NSTimer *)wTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)())block repeats:(BOOL)yesOrNo
{
    return [self timerWithTimeInterval:ti target:self selector:@selector(___blockInvoke:) userInfo:[block copy] repeats:yesOrNo];
}

+ (NSTimer *)wScheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)())block repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:ti
                                         target:self
                                       selector:@selector(___blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)___blockInvoke:(NSTimer *)timer
{
    
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
}


@end

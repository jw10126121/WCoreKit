//
//  NSTimer+WTool.h(Pods)
//
//
//  Created by linjiawei on 16/6/3.
//
//

#import <Foundation/Foundation.h>

@interface NSTimer (WTool)



+ (NSTimer *)wScheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)())block repeats:(BOOL)repeats;

+ (NSTimer *)wTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)())block repeats:(BOOL)yesOrNo;


@end




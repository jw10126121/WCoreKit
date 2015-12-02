//
//  NSArray+WTool.m
//
//
//  Created by Linjw on 13-11-27.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import "NSArray+WTool.h"




@implementation NSArray (WTool)

-(id)wObjSafeAtIndex:(NSInteger)index
{
    if (index < self.count) {
        return self[index];
    }
    return nil;
}

-(id)wFirstObjSafe
{
    if (self.count)
    {
        return [self firstObject];
    }
    return nil;
}

-(id)wLastObjSafe
{
    if (self.count)
    {
        return [self lastObject];
    }
    return nil;
}







@end







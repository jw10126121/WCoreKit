//
//  NSArray+WTool.h
//
//
//  Created by Linjw on 13-11-27.
//  Copyright (c) 2013年 Linjw QQ:10126121. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



/**
 *  数组拓展
 */
@interface NSArray (WTool)


-(id)wObjSafeAtIndex:(NSInteger)index;

-(id)wFirstObjSafe;
-(id)wLastObjSafe;

@end

//
//  UIView+NibWTool.h
//
//
//  Created by linjiawei on 16/6/24.
//  Copyright © 2016年 Linjw. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  Nib加载(子视图必须要有确定的约束,nib文件的owner类型为self.class
 *
 */
@interface UIView (NibWTool)


/**
 *  加载Owner为self的nib文件
 *
 *  @param nibName nib名
 */
- (void) wLoadContentsForSelfOwnerFromNibNamed:(NSString*)nibName;


/**
 *  加载Owner为self的nib文件(文件名与自身类名相同)
 */
- (void) wLoadContentsForSelfOwnerFromNib;





@end
























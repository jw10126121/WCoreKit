//
//  UIView+NibWTool.m
//
//
//  Created by linjiawei on 16/6/24.
//  Copyright © 2016年 Linjw. All rights reserved.
//

#import "UIView+NibWTool.h"
#import <objc/runtime.h>


@implementation UIView (NibWTool)

static char kUIViewNibLoading_outletsKey;


+ (UINib*) _nibLoadingAssociatedNibWithName:(NSString*)nibName
{
    static char kUIViewNibLoading_associatedNibsKey;
    
    NSDictionary * associatedNibs = objc_getAssociatedObject(self, &kUIViewNibLoading_associatedNibsKey);
    UINib * nib = associatedNibs[nibName];
    if(nil==nib)
    {
        nib = [UINib nibWithNibName:nibName bundle:[NSBundle bundleForClass:self]];
        if(nib)
        {
            NSMutableDictionary * newNibs = [NSMutableDictionary dictionaryWithDictionary:associatedNibs];
            newNibs[nibName] = nib;
            objc_setAssociatedObject(self, &kUIViewNibLoading_associatedNibsKey, [NSDictionary dictionaryWithDictionary:newNibs], OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    return nib;
}


/**
 *  加载Owner为self的nib文件
 *
 *  @param nibName nib名
 */
- (void) wLoadContentsForSelfOwnerFromNibNamed:(NSString*)nibName
{
    
    // 加载Owner为self的nib文件
    // nib文件中的根视图只是一个容器，加载完成后，不会被使用。
    UINib * nib = [[self class] _nibLoadingAssociatedNibWithName:nibName];
    NSAssert(nib!=nil, @"UIView+NibWTool : 无法加载nib文件: %@.",nibName);
    
    // 把所有的outlets保存起来
    NSMutableDictionary * outlets = [NSMutableDictionary new];
    objc_setAssociatedObject(self, &kUIViewNibLoading_outletsKey, outlets, OBJC_ASSOCIATION_RETAIN);
    NSArray * views = [nib instantiateWithOwner:self options:nil];
    NSAssert(views!=nil, @"UIView+NibWTool : 不能实例化nib文件: %@,必须设置nib文件的Owner类型为%@",nibName,[self class]);
    objc_setAssociatedObject(self, &kUIViewNibLoading_outletsKey, nil, OBJC_ASSOCIATION_RETAIN);
    
    // Search for the first encountered UIView base object
    //把nib文件里面，根视图也就是第一个View当作容器
    UIView * containerView = nil;
    for (id v in views)
    {
        if ([v isKindOfClass:[UIView class]])
        {
            containerView = v;
            break;
        }
    }
    NSAssert(containerView!=nil, @"UIView+NibWTool : 没有找到nib文件的根视图容器: %@.",nibName);
    
    //设置启用Autolayout
    [containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    if(CGRectEqualToRect(self.bounds, CGRectZero))
    {
        //如果self没有大小，就设置为根视图容器的大小
        self.bounds = containerView.bounds;
    }
    else
    {
        //如果self有大小，就设置根视图容器的大小为self的大小
        containerView.bounds = self.bounds;
    }
    
    //--------------------------- 转移根视图容器的子视图到self上 ---------------------------
    
    NSArray * constraints = containerView.constraints;
    
    //根视图容器的所有子视图到self上面
    for (UIView * view in containerView.subviews)
    {
        [self addSubview:view];
    }
    
    //把根视图容器的所有子视图约束加到self上面
    for (NSLayoutConstraint *oldConstraint in constraints)
    {
        
        id firstItem = oldConstraint.firstItem;
        id secondItem = oldConstraint.secondItem;
        if (firstItem == containerView)
        {
            firstItem = self;
        }
        if (secondItem == containerView)
        {
            secondItem = self;
        }
        
        NSLayoutConstraint * newConstraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                          attribute:oldConstraint.firstAttribute
                                                                          relatedBy:oldConstraint.relation
                                                                             toItem:secondItem
                                                                          attribute:oldConstraint.secondAttribute
                                                                         multiplier:oldConstraint.multiplier
                                                                           constant:oldConstraint.constant];
        [self addConstraint:newConstraint];
        
        for (NSString * key in outlets)
        {
            if (outlets[key]==oldConstraint)
            {
                NSAssert([self valueForKey:key]==oldConstraint, @"UIView+NibWTool : Unexpected value for outlet %@ of view %@. Expected %@, found %@.", key, self, oldConstraint, [self valueForKey:key]);
                [self setValue:newConstraint forKey:key];
            }
        }
        
    }
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    NSMutableDictionary * outlets = objc_getAssociatedObject(self, &kUIViewNibLoading_outletsKey);
    if ([outlets isKindOfClass:[NSMutableDictionary class]] && key) outlets[key] = value;
    [super setValue:value forKey:key];
    
    
    
    
    
    
}

/**
 *  加载Owner为self的nib文件(文件名与自身类名相同)
 */
- (void) wLoadContentsForSelfOwnerFromNib
{
    NSString *className = NSStringFromClass([self class]);
    NSRange range = [className rangeOfString:@"."];
    if (range.location != NSNotFound) {
        className = [className substringFromIndex:range.location + range.length];
    }
    [self wLoadContentsForSelfOwnerFromNibNamed:className];
}








@end





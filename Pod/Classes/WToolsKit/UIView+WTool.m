
#import "UIView+WTool.h"
#import <objc/runtime.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000
#import <QuartzCore/QuartzCore.h>
#endif

static char kDTActionHandlerTapBlockKey;
static char kDTActionHandlerTapGestureKey;
static char kDTActionHandlerLongPressBlockKey;
static char kDTActionHandlerLongPressGestureKey;
static char cSelForKeyboardAnimationFinish;

@implementation UIView (WTool)

char * const kPropertyIdentificationKey_wAdditionalProperty = "kPropertyIdentificationKey_wAdditionalProperty";
-(void)wSetAdditionalProperty:(id)wAdditionalProperty
{
    objc_setAssociatedObject(self,kPropertyIdentificationKey_wAdditionalProperty,wAdditionalProperty,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)wAdditionalProperty
{
    return objc_getAssociatedObject(self,kPropertyIdentificationKey_wAdditionalProperty);
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right
{
//    return self.frame.origin.x + self.frame.size.width;
    return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)bottom
{
//    return self.frame.origin.y + self.frame.size.height;
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)width
{
//    return self.frame.size.width;
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
//    return self.frame.size.height;
        return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    self.frame = (CGRect){
        .origin = self.frame.origin,
        .size=size
    };
}

- (CGPoint)origin { return self.frame.origin; }
- (void)setOrigin:(CGPoint)origin {
    self.frame = (CGRect){
        .origin = origin,
        .size = self.frame.size
    };
}


- (CGFloat)centerX {
    return self.center.x;
}



- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}



- (CGFloat)centerY {
    return self.center.y;
}



- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)screenX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}



- (CGFloat)screenY {
    CGFloat y = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
- (CGFloat)screenViewX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}



- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}



- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


//bounds accessors

- (CGSize)boundsSize
{
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)size
{
    CGRect bounds = self.bounds;
    bounds.size = size;
    self.bounds = bounds;
}

- (CGFloat)boundsWidth
{
    return self.boundsSize.width;
}

- (void)setBoundsWidth:(CGFloat)width
{
    CGRect bounds = self.bounds;
    bounds.size.width = width;
    self.bounds = bounds;
}

- (CGFloat)boundsHeight
{
    return self.boundsSize.height;
}

- (void)setBoundsHeight:(CGFloat)height
{
    CGRect bounds = self.bounds;
    bounds.size.height = height;
    self.bounds = bounds;
}

- (CGFloat)orientationWidth
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.height : self.width;
}



- (CGFloat)orientationHeight
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.width : self.height;
}

-(id)initWithOrigin:(CGPoint)origin Size:(CGSize)size
{
    if (self == [self init])
    {
        CGRect frame = wCGRectMakeWithOrigin(origin, size);
        self.frame = frame;
    }return self;
}


-(id)initWithCenter:(CGPoint)center Size:(CGSize)size
{
    if (self == [self init]) {
        CGRect frame = wCGRectMakeWithCenter(center, size);
        self.frame = frame;
    }return self;
}

-(void)wConfigViewWithFrame:(CGRect)frame
                    BgColor:(UIColor *)bgColor
                      BgImg:(UIImage *)bgImg
{
    self.frame = frame;
    if (bgColor) {
        self.backgroundColor = bgColor;
    }
    if (bgImg) {
        self.wBackgroundImage = bgImg;
    }
}

- (UIView*)descendantOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}



- (UIView*)ancestorOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}



- (void)wRemoveAllSubviews
{
    while (self.subviews.count)
    {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}



- (CGPoint)wOffsetFromView:(UIView*)otherView
{
    CGFloat x = 0.0f, y = 0.0f;
    for (UIView* view = self; view && view != otherView; view = view.superview)
    {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}


- (void)wSetTapActionWithBlock:(void (^)(void))block
{
	UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    
	if (!gesture)
	{
		gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
		[self addGestureRecognizer:gesture];
        self.userInteractionEnabled = YES;
		objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
	}
    
	objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        
		if (action)
		{
			action();
		}
	}
}

- (void)wSetLongPressActionWithBlock:(void (^)(void))block
{
	UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerLongPressGestureKey);
	if (!gesture)
	{
		gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForLongPressGesture:)];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kDTActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
	}
    
	objc_setAssociatedObject(self, &kDTActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerLongPressBlockKey);
        
		if (action)
		{
			action();
		}
	}
}

//content getters

- (CGRect)contentBounds
{
    return CGRectMake(0.0f, 0.0f, self.boundsWidth, self.boundsHeight);
}

- (CGPoint)contentCenter
{
    return CGPointMake(self.boundsWidth/2.0f, self.boundsHeight/2.0f);
}

//additional frame setters

- (void)wSetLeft:(CGFloat)left right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    frame.size.width = right - left;
    self.frame = frame;
}

- (void)wSetWidth:(CGFloat)width right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - width;
    frame.size.width = width;
    self.frame = frame;
}

- (void)wSetTop:(CGFloat)top bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    frame.size.height = bottom - top;
    self.frame = frame;
}

- (void)wSetHeight:(CGFloat)height bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - height;
    frame.size.height = height;
    self.frame = frame;
}


#pragma mark - CGRect
CGRect wCGRectMakeWithCenter( CGPoint center, CGSize size )
{
	CGPoint upperLeft = CGPointMake( center.x - (size.width / 2.0), center.y - (size.height / 2.0) );
	return CGRectMake( upperLeft.x, upperLeft.y, size.width, size.height );
}

CGRect wCGRectMakeWithOrigin( CGPoint origin, CGSize size )
{
	return CGRectMake( origin.x, origin.y, size.width, size.height );
}

CGFloat	wCGRectMaxX( CGRect rect )
{
	return rect.origin.x + rect.size.width;
}

CGFloat wCGRectMaxY( CGRect rect )
{
	return rect.origin.y + rect.size.height;
}

CGRect	wCGRectMakeIntegral( CGRect rect )
{
	return CGRectMake( floor(rect.origin.x), floor(rect.origin.y), floor(rect.size.width), floor(rect.size.height) );
}

CGRect	wCGRectMakeCenteredRect( CGRect superviewRect, CGSize subviewSize )
{
	return  CGRectIntegral( CGRectMake( (superviewRect.size.width - subviewSize.width) / 2.0,
                                       (superviewRect.size.height - subviewSize.height) / 2.0,
									   subviewSize.width, subviewSize.height) );
}

CGRect  wCGRectMakeWithEdgeInsets( CGRect rect, UIEdgeInsets insets )
{
	return CGRectIntegral( CGRectMake( rect.origin.x+insets.left,
                                      rect.origin.y+insets.top,
                                      rect.size.width - (insets.left+insets.right),
									  rect.size.height - (insets.top+insets.bottom)) );
}

BOOL wCGRectIsInvalid( CGRect r )
{
	return isnan(r.origin.x) || isnan(r.origin.y) || isnan(r.size.width) || isnan(r.size.height);
}

-(UIViewController *)wFirstResponderViewController
{
    UIResponder *next = self.nextResponder;
    do {
        
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = [next nextResponder];
        
    } while (next != nil);
    
    return nil;
//    for (UIView * next = self.superview; next; next = next.superview)
//    {
//        UIResponder* nextResponder = [next nextResponder];
//        
//        if ([nextResponder isKindOfClass:[UIViewController class]])
//        {
//            return (UIViewController*)nextResponder;
//        }
//    }
//    return nil;
}



#pragma mark --

//查找当前焦点所在的VIEW
+(UIView *)wViewForFirstResponderWithSuperView:(UIView *)viewSuper
{
    for ( UIView *childView in viewSuper.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView * result = [self wViewForFirstResponderWithSuperView:childView];
        if ( result ) return result;
    }
    return nil;
}

//查找当前焦点所在的view在keyWindow上面的位置
+(CGRect)wRectForFirstResponderViewInKeyWindow
{
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView * viewFirstResponder = [self wViewForFirstResponderWithSuperView:keyWindow];
    CGRect rect = [viewFirstResponder convertRect:viewFirstResponder.bounds toView:keyWindow];
    return rect;
}

//查找当前焦点所在的VIEW
+(CGRect)wRectForFirstResponderViewWithSuperView:(UIView *)viewSuper
{
    UIView * viewFirstResponder = [self wViewForFirstResponderWithSuperView:viewSuper];
    CGRect rect = [viewFirstResponder convertRect:viewFirstResponder.bounds toView:viewSuper];
    return rect;
}

//得到在 superView 上的位置
- (CGRect)wRectInSuperView:(UIView *)viewSuper{
    CGRect rect = [self convertRect:self.bounds toView:viewSuper];
    return rect;
}

//所有子视图下偏移20像素
-(CGFloat)wIsSubViewMoveDown20:(BOOL)isMove
{
    CGFloat sbar = 0.0;
    if (isMove) {
        sbar = [UIApplication sharedApplication].statusBarFrame.size.height;
        self.bounds = CGRectMake(0, - sbar, self.frame.size.width, self.frame.size.height - sbar);
    }
    return sbar;
}

+ (UIImage *) wImageScreenShotWithView:(UIView *)aView
{
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, aView.opaque, 0.0);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *) wImageScreenShot{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIView *)wAddBottomLineWithWidth:(CGFloat)width color:(UIColor *)color
{
    CGRect f = self.frame;
    f.size.height += width;
    self.frame = f;
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - width,
                                                                   self.frame.size.width, width)];
    bottomLine.backgroundColor = color;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:bottomLine];
    
#if ! __has_feature(objc_arc)
   return [bottomLine autorelease];
#else
    return bottomLine;
#endif
}

- (UIView *)wAddVerticalLineWithWidth:(CGFloat)width color:(UIColor *)color atX:(CGFloat)x
{
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(x, 0.0f, width, self.frame.size.height)];
    vLine.backgroundColor = color;
    vLine.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:vLine];
#if ! __has_feature(objc_arc)
    return [vLine autorelease];
#else
    return vLine;
#endif
}

-(UIView *)wAddLineTopOrBottom:(NSInteger)direction Height:(CGFloat)height Color:(UIColor *)aColor
{
    CGFloat y = (direction == 0) ? (self.height - height) : 0;
    
    UIView * lineBottm = [[UIView alloc]initWithFrame:(CGRect){0, y ,self.width,height}];
    lineBottm.backgroundColor = aColor;
    if (direction == 0)
    {
        lineBottm.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    }else
    {
        lineBottm.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    
    [self addSubview:lineBottm];
#if ! __has_feature(objc_arc)
    return [lineBottm autorelease];
#else
    return lineBottm;
#endif
    
}


@end

@implementation UIView(LayerEffects)


-(void)wSetBackgroundImage:(UIImage *)backgroundImage
{
    if (backgroundImage) {
        self.layer.contents = (__bridge id)(backgroundImage.CGImage);
    }
}

-(UIImage *)wBackgroundImage
{
    if (!self.layer.contents) {
        return nil;
    }
#if !__has_feature(objc_arc)
    return [UIImage imageWithCGImage: (__bridge CGImageRef)(self.layer.contents)];
#else
    return [[UIImage alloc] initWithCGImage: (__bridge CGImageRef)(self.layer.contents)];
#endif
}

/* simple setting using the layer */
- (void) wSetCornerRadius : (CGFloat) radius {
	self.layer.cornerRadius = radius;
}

- (void) wSetBorder : (UIColor *) color Width : (CGFloat) width  {
    if (color) {
        self.layer.borderColor = [color CGColor];
    }
	self.layer.borderWidth = width;
}

- (void) wSetShadow : (UIColor *)color Opacity:(CGFloat)opacity Offset:(CGSize)offset BlurRadius:(CGFloat)blurRadius {
	CALayer *l = self.layer;
    if (color) {
        l.shadowColor = [color CGColor];
    }
	l.shadowOpacity = opacity;
	l.shadowOffset = offset;
	l.shadowRadius = blurRadius;
}


@end



@implementation UIView(Animation)


+ (void)wAnimationWithKeyboardNotification:(NSNotification *)aNotification
                                 Animation:(void (^)(void))animation
                                CompletionSel:(SEL)completionSel
{
    if (aNotification) {
        NSDictionary * info = [aNotification userInfo];
        //动画时间
        NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        //动画效果
        NSValue *animationCurveValue = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        UIViewAnimationCurve animationCurve;
        [animationCurveValue getValue:&animationCurve];
        //动画
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        if (completionSel) {
            [UIView setAnimationDidStopSelector:completionSel];
        }
        if (animation) {
            animation();
        }
        [UIView commitAnimations];
    }
}

+ (void)wAnimationWithKeyboardNotification:(NSNotification *)aKeyboardNotification
                                 Animation:(void(^)(void))animation
                                Completion:(void (^)(void))completion
{
    if (aKeyboardNotification) {
        NSDictionary * info = [aKeyboardNotification userInfo];
        //动画时间
        NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration;
        [animationDurationValue getValue:&animationDuration];
        //动画效果
        NSValue *animationCurveValue = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        UIViewAnimationCurve animationCurve;
        [animationCurveValue getValue:&animationCurve];
        //动画
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];

        //动画结束后运行
        if (animation) {
            animation();
        }
        
        if (completion) {
            objc_setAssociatedObject(self, &cSelForKeyboardAnimationFinish, completion, OBJC_ASSOCIATION_COPY);
            [UIView setAnimationDidStopSelector:@selector(__handleActionForKeyboardAnimationDidStop)];
        }
        
        [UIView commitAnimations];
        
//        if (completion) {
//            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, animationDuration * NSEC_PER_SEC);
//            dispatch_after(time, dispatch_get_main_queue(), completion);
//        }
        
    }
}

-(void)__handleActionForKeyboardAnimationDidStop
{
   void(^KeyboardFinishBLK)(void) = objc_getAssociatedObject(self, &cSelForKeyboardAnimationFinish);
    if (KeyboardFinishBLK) {
        KeyboardFinishBLK();
    }
}

/*
 - (void)wSetLongPressActionWithBlock:(void (^)(void))block
 {
 UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerLongPressGestureKey);
 if (!gesture)
 {
 gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForLongPressGesture:)];
 [self addGestureRecognizer:gesture];
 objc_setAssociatedObject(self, &kDTActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
 }
 
 objc_setAssociatedObject(self, &kDTActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
 }
 
 - (void)__handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture
 {
 if (gesture.state == UIGestureRecognizerStateBegan)
 {
 void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerLongPressBlockKey);
 
 if (action)
 {
 action();
 }
 }
 }
 */
//animation

- (void)wCrossfadeWithDuration:(NSTimeInterval)duration
{
    //jump through a few hoops to avoid QuartzCore framework dependency
    CAAnimation *animation = [NSClassFromString(@"CATransition") animation];
    [animation setValue:@"kCATransitionFade" forKey:@"type"];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)wCrossfadeWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion
{
    [self wCrossfadeWithDuration:duration];
    if (completion)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}



@end

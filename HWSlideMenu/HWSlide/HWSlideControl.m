//
//  HWSlideControl.m
//  iMagReader
//
//  Created by Howe on 16/5/4.
//
//  抽屉控制器



#import "HWSlideControl.h"
#import "XTBlurView.h"
#import "UIView+Frame.h"
#import "HWBlurViewController.h"

@interface HWSlideControl()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) HWBlurViewController *blurVC ;

@property (nonatomic, weak) XTBlurView *blurView ;

@property (nonatomic, strong) UIViewController *containerVC;

@property (nonatomic, strong) UIViewController  *leftVC;

@property (nonatomic, assign) CGPoint startPoint ;

@property (nonatomic, assign) CGPoint oldChangePoint;


@end

@implementation HWSlideControl

/**
 *  Class Method initialize
 *
 *  @return
 */
+ (instancetype)hwSlideControl:(UIViewController *)rootViewController
{
    
    return [[HWSlideControl alloc]initWithRootVC:rootViewController];;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    __block HWSlideControl *instace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [super allocWithZone:zone];
    });
    return instace;
}

- (instancetype)initWithRootVC:(UIViewController *)rootVC;
{
    self = [super init];
    if (self)
    {
        self.rootVC = rootVC;
        self.toLeftProportion = 0.5f;
        self.toRightProportion = 0.5f;
        [self hwSetupGes];
    }
    return self;
}
#pragma mark 懒加载 methods

- (HWBlurViewController *)blurVC
{
    if (_blurVC == nil)
    {
        HWBlurViewController *blurVC = [[HWBlurViewController alloc]init];
        self.blurVC = blurVC;
        blurVC.view.frame = CGRectMake(-self.rootVC.view.w, 0.0f, self.rootVC.view.w, self.rootVC.view.h);
        [self.rootVC.view addSubview:blurVC.view];
        [self.rootVC.view bringSubviewToFront: blurVC.view];
    }
    return _blurVC;
}

- (XTBlurView *)blurView
{
    if (_blurView == nil)
    {
        XTBlurView *blurView = [[XTBlurView alloc]initWithFrame:self.blurVC.view.bounds];
        [self.blurVC.view addSubview:blurView];
        self.blurView = blurView;
        blurView.viewToBlur = self.rootVC.view;
        [self.blurVC.view sendSubviewToBack:blurView];
        blurView.alpha = 0.3f;
        blurView.blur = YES;
        blurView.tintColor = [UIColor colorWithWhite:0.7f alpha:0.73];
        [blurView updateBlur];
    }
    return _blurView;
}

- (UIViewController *)containerVC
{
    if (_containerVC == nil)
    {
        UIViewController *containerVC = [[UIViewController alloc]init];
         self.containerVC = containerVC;
        [self.blurVC.view addSubview:containerVC.view];
    }
    return _containerVC;
}

- (UIViewController *)leftVC
{
    if (_leftVC == nil)
    {
        UIViewController  *leftVC = [[NSClassFromString(self.leftControllerClassName) alloc]init];
        leftVC.view.frame = CGRectMake(-kSlideWith, 0.0f, kSlideWith, self.containerVC.view.frame.size.height);
        [self.containerVC.view addSubview:leftVC.view];
        [leftVC.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        self.leftVC = leftVC;
        

    }
    return _leftVC;
}

#pragma mark private method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"])
    {
        CGRect leftVCFrame = [[change objectForKey:NSKeyValueChangeNewKey]CGRectValue];
        CGFloat changeBlurValue = (leftVCFrame.size.width - ABS(leftVCFrame.origin.x))/leftVCFrame.size.width;
        self.blurView.alpha = changeBlurValue;
        
    }
}

- (void)dealloc
{
    [self.leftVC removeObserver:self forKeyPath:@"frame"];

}
- (void)hwSetupGes
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    [self.rootVC.view addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint touchPoint = [pan locationInView:self.rootVC.view];
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        [self.leftVC.view bringSubviewToFront: self.rootVC.view];
        self.startPoint = touchPoint;
        self.oldChangePoint = touchPoint;
        [self beginPan];
    }
    //改变中
    CGPoint changePoint = [pan translationInView:self.rootVC.view];
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        
        [self changePan:touchPoint changePoint:changePoint];
        
    }
    
    //结束中
    if (pan.state == UIGestureRecognizerStateEnded)
    {
       [self endPan:touchPoint changePoint:changePoint];
    }
    
    [pan setTranslation:CGPointZero inView:self.rootVC.view];
    
    self.oldChangePoint = touchPoint;
}

/**
 *  开始滑动
 */
- (void)beginPan
{
    self.blurVC.view.x = 0.0f;
    [self leftVC];
}
/**
 *  手指滑动
 *
 *  @param movePoint   手指对于原点移动的位置
 *  @param changePoint 手指对于上次移动的移动位置
 */
- (void)changePan:(CGPoint)movePoint changePoint:(CGPoint)changePoint
{
    BOOL isRightSlide = (movePoint.x - self.oldChangePoint.x)> 0 ? YES : NO;
    [UIView animateWithDuration:0.25f animations:^{

        if (isRightSlide)
        {
            if (self.leftVC.view.x >= 0.0f || (self.leftVC.view.x + changePoint.x) >= 0.0f)
            {
                self.leftVC.view.x = 0.0f;
            }else
            {
                self.leftVC.view.x += changePoint.x;
            }
            
        }else
        {
            if (self.leftVC.view.x <= -kSlideWith || (self.leftVC.view.x + changePoint.x) <= -kSlideWith)
            {
                self.leftVC.view.x = -kSlideWith;
            }else
            {
                self.leftVC.view.x += changePoint.x;
            }
        }
    }];
}

- (void)endPan:(CGPoint)movePoint changePoint:(CGPoint)changePoint
{
    BOOL isRightSlide = (movePoint.x - self.oldChangePoint.x)> 0 ? YES : NO;
    if (isRightSlide)
    {
        if (ABS(self.leftVC.view.x) <= kSlideWith * 0.5f)
        {
            [self openView];
        }else
        {
            [self closeView];
        }
    }else
    {
        if (ABS(self.leftVC.view.x) > kSlideWith * 0.5f)
        {
            [self closeView];
        }else
        {
            [self openView];
        }
    }
}
- (void)openView
{
    self.blurVC.view.x = 0.0f;
    [UIView animateWithDuration:0.25f animations:^{
        self.leftVC.view.x = 0.0f;
    }];
}
- (void)closeView
{
    [UIView animateWithDuration:0.25f animations:^{
        self.leftVC.view.x = - self.leftVC.view.w;
    } completion:^(BOOL finished)
    {
       self.blurVC.view.x =  - self.blurVC.view.w;
    }];
    
}
- (void)changeViewWithPoint:(CGPoint)changePoint
{
    
}
#pragma mark ges delegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    UINavigationController *rootVC = MainTabbarController.selectedViewController;
//    if (![rootVC isKindOfClass:[UINavigationController class]])
//    {
//        return NO;
//    }
//    return rootVC.viewControllers.count<2;
//}

//- (void)hwSetupView
//{
//    if (_blurVC == nil)
//    {
//
//        [MainTabbarController setHidesBottomBarWhenPushed:YES];
//        HWBlurViewController *blurVC = HWBlurViewController.new;
//        self.blurVC = blurVC;
//        blurVC.view.frame = MainTabbarController.view.bounds;
//        blurVC.view.x = - MainTabbarController.view.width;
//
//        [MainTabbarController.view addSubview:blurVC.view];
//        XTBlurView *blurView = [[XTBlurView alloc]initWithFrame:blurVC.view.bounds];
//        [blurVC.view addSubview:blurView];
//        self.blurView = blurView;
//        blurView.viewToBlur = MainTabbarController.view;
//        [blurVC.view sendSubviewToBack:blurView];
//        blurView.alpha = 0.99f;
//        blurView.blur = YES;
//        blurView.tintColor = [UIColor colorWithWhite:1.0f alpha:0.73];
//        [blurView updateBlur];
//
//        UIViewController *vc = [[UIViewController alloc]init];
//        self.vc = vc;
//        HUUserCenterController  *userCenterVC = HUUserCenterController.new;
//        self.userCenterVC = userCenterVC;
//        userCenterVC.view.frame = CGRectMake(-kSlideWith, 0.0f, kSlideWith, vc.view.frame.size.height);
//        [vc.view addSubview:userCenterVC.view];
//        MyNavigationController *myNav = [[MyNavigationController alloc]initWithRootViewController:vc];
//        self.nav = myNav;
//        [blurVC.view addSubview:myNav.view];
//    }
//}

@end

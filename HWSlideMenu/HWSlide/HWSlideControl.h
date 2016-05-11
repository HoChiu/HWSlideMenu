//
//  HWSlideControl.h
//  iMagReader
//
//  Created by Howe on 16/5/4.
//
//  抽屉控制器

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define kSlideWith ((320.0f/375.0f) * [UIScreen mainScreen].bounds.size.width)

NS_ASSUME_NONNULL_BEGIN

@interface HWSlideControl : NSObject

/**
 * 类方法 必须被强引用
 */
+ (instancetype)hwSlideControl:(UIViewController *)rootViewController;
/**
 *  向右滑动时手放开 自动滑出的比例0-1 default 0.5f
 */
@property (nonatomic, assign)CGFloat toRightProportion;
/**
 *  向左滑动时手放开 自动滑进的比例0-1 default 0.5f
 */
@property (nonatomic, assign) CGFloat toLeftProportion;

/**
 *  左视图控制器类名
 */
@property (nonatomic, copy) NSString *leftControllerClassName;


@property (nonatomic, weak) UIViewController *rootVC;
@end

NS_ASSUME_NONNULL_END
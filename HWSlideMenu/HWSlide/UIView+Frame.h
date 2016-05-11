//
//  UIView+Frame.h
//
//  Created by Howe on 15/3/20.
//  Copyright (c) 2015年 Howe. All rights reserved.
//  视图尺寸直接获取

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property (nonatomic,assign)CGFloat x;
@property (nonatomic,assign)CGFloat y;
@property (nonatomic,assign)CGFloat w;
@property (nonatomic,assign)CGFloat h;
@property (nonatomic,assign)CGFloat centerX;
@property (nonatomic,assign)CGFloat centerY;
@property (nonatomic,assign)CGSize  size;
@end

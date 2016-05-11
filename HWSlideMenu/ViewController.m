//
//  ViewController.m
//  HWSlideMenu
//
//  Created by Howe on 16/5/11.
//  Copyright © 2016年 Howe. All rights reserved.
//

#import "ViewController.h"
#import "HWSlide/HWSlideControl.h"

@interface ViewController ()
@property (nonatomic, strong) HWSlideControl *hwSlide;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HWSlideControl *hwSlide = [HWSlideControl hwSlideControl:self];
    self.hwSlide = hwSlide;
    
    hwSlide.leftControllerClassName = @"LeftViewController";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

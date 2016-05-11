# HWSlideMenu

![image](https://github.com/HoChiu/HWGIF/blob/master/hwSlideMin.gif )  

左滑动抽屉，在抽屉动画中时 背景有毛玻璃的效果
毛玻璃借用了 XTBlurView
##使用方法
```objc
    HWSlideControl *hwSlide = [HWSlideControl hwSlideControl:self];
    self.hwSlide = hwSlide;
    hwSlide.leftControllerClassName = @"LeftViewController";
```

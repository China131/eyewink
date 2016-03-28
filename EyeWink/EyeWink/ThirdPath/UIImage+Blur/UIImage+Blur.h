//
//  UIImage+Blur.h
//  UI第9课UITableview
//
//  Created by yutao on 15/9/3.
//  Copyright (c) 2015年 yutao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;

@end

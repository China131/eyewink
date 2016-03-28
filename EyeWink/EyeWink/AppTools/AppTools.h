//
//  AppTools.h
//  EyeWink
//
//  Created by dllo on 15/9/28.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^postDataFromAFNBlock)(id data);
typedef void(^failureBlock)(NSError *error);

@interface AppTools : NSObject

/**
 *  文本自适应高度
 *
 *  @param text  需要设置的文本的内容
 *  @param width 放置的控件宽度
 *  @param font  控件上文本的字体大小
 *
 *  @return 返回值是一个CGFloat型  是这个控件所适应的高度
 */
+(CGFloat)heightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;


/**
 *  设置轮播图的图片内容
 *
 *  @param carouselArray 传进来一个数组,里面存放的是轮播图的所需要的图片
 *
 *  @return 返回一个数组,里面存放的是轮播图的所有图片,并且已经按顺序排序
 */
+(NSMutableArray *)getImageArrayWithCarouselArray:(NSMutableArray *)carouselArray;


/**
 *  封装一个AFN请求的Block
 *
 *  @param url    接口路径
 *  @param para   接口body体
 *  @param cookie 接口cookie值
 *  @param block  用来回调数据
 */
+(void)postDataFromAFN:(NSString *)url WithParameters:(NSDictionary *)para AndCookie:(NSString *)cookie AndBlock:(postDataFromAFNBlock)block failure:(failureBlock)failureBlock;

@end

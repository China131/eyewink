//
//  AppTools.m
//  EyeWink
//
//  Created by dllo on 15/9/28.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "AppTools.h"

#import "Carousel.h"

#import "AFNetworking.h"

@implementation AppTools

+(CGFloat)heightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font{
    CGSize size = CGSizeMake(width, 100);
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
    
}


+(NSMutableArray *)getImageArrayWithCarouselArray:(NSMutableArray *)carouselArray{
    NSMutableArray *muArray = [NSMutableArray array];
    for(int i = 0 ; i < carouselArray.count ; i++){
        Carousel *carousel = [carouselArray objectAtIndex:i];
        [muArray addObject:carousel.img];
    }
    UIImage *firstImage = [muArray firstObject];
    UIImage *lastImage = [muArray lastObject];
    [muArray insertObject:lastImage atIndex:0];
    [muArray addObject:firstImage];
    
    return muArray;
}

+(void)postDataFromAFN:(NSString *)url WithParameters:(NSDictionary *)para AndCookie:(NSString *)cookie AndBlock:(postDataFromAFNBlock)block failure:(failureBlock)failureBlock{
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",@"application/x-javascript",nil];
    
    [manager POST:url parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        block(responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failureBlock(error);
    }];

}



@end

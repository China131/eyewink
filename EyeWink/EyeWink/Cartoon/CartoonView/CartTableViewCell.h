//
//  CartTableViewCell.h
//  EyeWink
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Cartoon;

@protocol shareProtocol <NSObject>

-(void)showLikeAction:(NSString *)info;

@optional

-(void)share:(NSString *)url;

@end


@interface CartTableViewCell : UITableViewCell

@property (nonatomic,retain) Cartoon *cartoon;

@property (nonatomic,assign) id < shareProtocol > delegate;



@end

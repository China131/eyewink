//
//  Shop_TableViewCell.h
//  EyeWink
//
//  Created by dllo on 15/10/9.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Shop;

@protocol goShopingProtocol < NSObject >

-(void)goShopingWithUrl:(NSString *)url;

@end


@interface Shop_TableViewCell : UITableViewCell

@property (nonatomic,retain) Shop *shop;

@property (nonatomic,assign) id < goShopingProtocol > delegate;

@end

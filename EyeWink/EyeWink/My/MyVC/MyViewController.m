//
//  MyViewController.m
//  EyeWink
//
//  Created by dllo on 15/9/30.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "MyViewController.h"
#import "DataBaseSingleton.h"
#import "CartTableViewCell.h"
#import "Shop_DetailViewController.h"

#import "Cartoon.h"

@interface MyViewController () < UITableViewDataSource , UITableViewDelegate , shareProtocol >

@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,retain) NSMutableArray *likeArray;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -40 * WIDTH, WIDTH * 375, WIDTH * 667 + WIDTH * 5) style:UITableViewStyleGrouped];
    [self.view addSubview:self.myTableView];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.showsHorizontalScrollIndicator = NO;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.myTableView release];
    
    self.likeArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllisLikeComic];
}

/**
 自定义协议方法
 *      显示点击收藏按钮之后的提示框
 */
-(void)showLikeAction:(NSString *)info{
    
    UIView *likeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.view addSubview:likeView];
    
    UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.view addSubview:likeLabel];
    
    likeView.center = CGPointMake(375 / 2 * WIDTH, 667 * WIDTH / 2);
    likeLabel.center = CGPointMake(375 / 2 * WIDTH, 667 * WIDTH / 2);
    
    likeView.backgroundColor = [UIColor grayColor];
    likeView.alpha = 0.5;
    likeView.layer.masksToBounds = YES;
    likeView.layer.cornerRadius = 10 * WIDTH;
    
    likeLabel.text = info;
    
    [UIView animateWithDuration:2 animations:^{
        
        likeView.alpha = 0;
        likeLabel.alpha = 0;
        
    }
    completion:^(BOOL finished) {
                         
        [likeLabel release];
        [likeView release];
        
        [likeLabel removeFromSuperview];
        [likeView removeFromSuperview];
        
    }];

}

#pragma 设置cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.likeArray.count == 0){
        return 1;
    }
    return self.likeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"like";
    CartTableViewCell *cartoonCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cartoonCell == nil){
        cartoonCell = [[CartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cartoonCell.cartoon = [self.likeArray objectAtIndex:indexPath.row];
    cartoonCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cartoonCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Shop_DetailViewController *shop_DetailVC = [[Shop_DetailViewController alloc] init];
    Cartoon *cartoon = [self.likeArray objectAtIndex:indexPath.row];
    shop_DetailVC.url = cartoon.url;
    [self.navigationController pushViewController:shop_DetailVC animated:YES];
    
    [shop_DetailVC release];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.likeArray.count == 0)
        return 0;
    return WIDTH * 250;
}


@end

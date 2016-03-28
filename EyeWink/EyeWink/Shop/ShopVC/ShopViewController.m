//
//  ShopViewController.m
//  EyeWink
//
//  Created by dllo on 15/9/30.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "ShopViewController.h"
#import "Shop_DetailViewController.h"
#import "DataBaseSingleton.h"
#import "Shop_deViewController.h"
#import "Shop.h"
#import "AppTools.h"

#import "MJRefresh.h"
#import "AFNetworking.h"

@interface ShopViewController ()

@property (nonatomic,retain) UITableView *myTableView;

@property (nonatomic,assign) BOOL isUploading;
@property (nonatomic,assign) NSInteger dataIndex;
@property (nonatomic,retain) NSMutableArray *listArray;

@end

@implementation ShopViewController

- (void)dealloc
{
    [_myTableView release];
    [_listArray release];
    
    [super dealloc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isUploading = NO;
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -40 * WIDTH, WIDTH * 375, WIDTH * 667 + WIDTH * 18) style:UITableViewStyleGrouped];
    [self.view addSubview:self.myTableView];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.myTableView release];
    
    [[DataBaseSingleton shareDataBaseSingleton] openDB];
    [[DataBaseSingleton shareDataBaseSingleton] creatShopTable];
    self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllShop];
    
    [self headerFresh];
    [self footerFresh];
    
}

-(void)headerFresh{
    [self.myTableView addHeaderWithCallback:^{
        self.isUploading = YES;
        self.dataIndex = 0;
        
        [self getDataFromAFN];
    }];
    [self.myTableView headerBeginRefreshing];
}

-(void)footerFresh{
    [self.myTableView addFooterWithCallback:^{
        self.isUploading = NO;
        self.dataIndex += 10;
        
        [self getDataFromAFN];
    }];
}

-(void)getDataFromAFN{
    
    NSString *url_string = @"http://api2.pianke.me/pub/shop";
    NSDictionary *para = @{@"start":[NSString stringWithFormat:@"%ld",self.dataIndex],@"client":@"2",@"auth":@"B8Y4En3h8f1DC8Z8GcHulTJxQMOuNLCNojtsUT0xcWP22NVFSh9U6fo",@"limit":@"10"};
    NSString *cookie = @"PHPSESSID=58ts41v1nohdn89damknm0vdt5";
    
    [AppTools postDataFromAFN:url_string WithParameters:para AndCookie:cookie AndBlock:^(id data) {
        
        if(self.isUploading){
            [[DataBaseSingleton shareDataBaseSingleton] dropShopTable];
            [[DataBaseSingleton shareDataBaseSingleton] creatShopTable];
            [self.listArray removeAllObjects];
        }
        
        
        NSDictionary *dic = data;
        NSArray *listArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
        for(NSDictionary *dictionary in listArray){
            Shop *shop = [[Shop alloc] init];
            [shop setValuesForKeysWithDictionary:dictionary];
            [[DataBaseSingleton shareDataBaseSingleton] insertShopTable:shop];
            [shop release];
        }
        self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllShop];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
        
    } failure:^(NSError *error) {
        
        self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllShop];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
        
    }];
    
}

#pragma mark-  设置cell

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH * 220;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"shop";
    Shop_TableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(shopCell == nil){
        shopCell = [[Shop_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    shopCell.delegate = self;
    shopCell.shop = [self.listArray objectAtIndex:indexPath.row];
    shopCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return shopCell;
    
}

/**
 *  系统的协议方法,点击cell时调用
 *
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Shop_deViewController *shop_deVC = [[Shop_deViewController alloc] init];
    shop_deVC.contentid = [[self.listArray objectAtIndex:indexPath.row] contentid];
    [self.navigationController pushViewController:shop_deVC animated:YES];
    [shop_deVC release];
    
}


/**
 *  自定义协议方法,当点击购买按钮的时候调用
 *
 *  @param url  购买的链接
 */
-(void)goShopingWithUrl:(NSString *)url{
    Shop_DetailViewController *shopDetailVC = [[Shop_DetailViewController alloc] init];
    shopDetailVC.url = url;
    [self.navigationController pushViewController:shopDetailVC animated:YES];
    [shopDetailVC release];
}


@end

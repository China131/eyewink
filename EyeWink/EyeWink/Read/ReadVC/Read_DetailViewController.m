//
//  Read_DetailViewController.m
//  EyeWink
//
//  Created by dllo on 15/10/6.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Read_DetailViewController.h"
#import "ReadDetailTableViewCell.h"
#import "Read_ArticleViewController.h"
#import "DataBaseSingleton.h"
#import "AppTools.h"

#import "Read.h"

#import "MJRefresh.h"
#import "AFNetworking.h"

@interface Read_DetailViewController () < UITableViewDataSource , UITableViewDelegate >

@property (nonatomic,retain) UITableView *myTableView;

@property (nonatomic,assign) BOOL isUploading;
@property (nonatomic,assign) NSInteger dataIndex;
@property (nonatomic,retain) NSMutableArray *listArray;

@end

@implementation Read_DetailViewController

- (void)dealloc
{
    [_myTableView release];
    [_listArray release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -35 * WIDTH, WIDTH * 375, WIDTH * 667 + WIDTH * 5) style:UITableViewStyleGrouped];
    [self.view addSubview:self.myTableView];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    [self.myTableView release];
    
    [[DataBaseSingleton shareDataBaseSingleton] creatReadDetailTable];

    self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectReadDetailWithTypeID:self.typeID];
    
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
    
    NSString *url_string = @"http://api2.pianke.me/read/columns_detail";
    NSDictionary *para = @{@"auth":@"C807FCuwm36lDC8l3HMTslDJxQMKpNLeNoj1vCGMzcWP22NZLTRhY4fI",@"client":@"1",@"deviceid":@"63900960-1ED5-47D0-B561-86C09F41ED08",@"limit":@"10",@"sort":@"addtime",@"start":[NSString stringWithFormat:@"%ld",self.dataIndex],@"typeid":[NSString stringWithFormat:@"%ld",self.typeID],@"version":@"3.0.6"};
    NSString *cookie = @"PHPSESSID=3sfpdqlrjk2fghcf3vh82qt995";
    
    [AppTools postDataFromAFN:url_string WithParameters:para AndCookie:cookie AndBlock:^(id data) {
        if(self.isUploading){
            [[DataBaseSingleton shareDataBaseSingleton] deleteReadDetailWithTypeID:self.typeID];
            [self.listArray removeAllObjects];
        }
        
        NSDictionary *dic = data;
        NSArray *listArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
        for(NSDictionary *dictionary in listArray){
            Read *read = [[Read alloc] init];
            read.detail_id = [dictionary objectForKey:@"id"];
            read.detail_coverimg = [dictionary objectForKey:@"coverimg"];
            read.detail_name = [dictionary objectForKey:@"name"];
            read.detail_title = [dictionary objectForKey:@"title"];
            read.detail_content = [dictionary objectForKey:@"content"];
            [[DataBaseSingleton shareDataBaseSingleton] insertReadDetailTable:read AndTypeID:self.typeID];
            [read release];
        }
        self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectReadDetailWithTypeID:self.typeID];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
        
    } failure:^(NSError *error) {
        self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectReadDetailWithTypeID:self.typeID];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
    }];
    
}

#pragma mark-  设置cell

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"read";
    ReadDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[ReadDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.read = [self.listArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH * 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Read_ArticleViewController *read_ArticleVC = [[Read_ArticleViewController alloc] init];
    read_ArticleVC.contentid = [[self.listArray objectAtIndex:indexPath.row] detail_id];
    [self.navigationController pushViewController:read_ArticleVC animated:YES];
    [read_ArticleVC release];
    
}


@end

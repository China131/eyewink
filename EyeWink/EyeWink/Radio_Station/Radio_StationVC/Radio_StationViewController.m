//
//  Radio_StationViewController.m
//  EyeWink
//
//  Created by dllo on 15/9/28.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Radio_StationViewController.h"
#import "Radio_TableViewCell.h"
#import "Radio_topTableViewCell.h"
#import "Radio_DetailViewController.h"
#import "CarouselScrollView.h"
#import "AppTools.h"

#import "DataBaseSingleton.h"
#import "Radio.h"
#import "Carousel.h"

#import "AFNetworking.h"
#import "MJRefresh.h"


@interface Radio_StationViewController () < selectProtocol >

@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,retain) CarouselScrollView *myScrollView;

@property (nonatomic,retain) NSMutableArray *alllistArray;
@property (nonatomic,retain) NSMutableArray *hotlistArray;
@property (nonatomic,retain) NSMutableArray *carouselArray;

@property (nonatomic,assign) NSInteger dataIndex;

@end

@implementation Radio_StationViewController

- (void)dealloc
{
    [_myTableView release];
    [_myScrollView release];
    [_alllistArray release];
    [_hotlistArray release];
    [_carouselArray release];
    
    [super dealloc];
    
}

/**
 *  WIDTH  用来适配的参数,在iPhone 6运行时的值为1,在iPhone 5s运行时是0.83333
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 667 - 30 * WIDTH) style:UITableViewStyleGrouped];
    [self.view addSubview:self.myTableView];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.myTableView release];

    
    [[DataBaseSingleton shareDataBaseSingleton] openDB];
    [[DataBaseSingleton shareDataBaseSingleton] creatRadioTable];
    [[DataBaseSingleton shareDataBaseSingleton] creatCarouselTable];
    
    self.alllistArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioWithString:@"alllist"];
    self.hotlistArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioWithString:@"hotlist"];
    self.carouselArray = [[DataBaseSingleton shareDataBaseSingleton] selectCarouselWithKind:@"radio"];
    
    [self headerFresh];
    [self footerFresh];
    
}

-(void)headerFresh{
    [self.myTableView addHeaderWithCallback:^{

        self.dataIndex = 0;
        [self reloadDataFromAFN];
    }];
    [self.myTableView headerBeginRefreshing];
}

-(void)footerFresh{
    [self.myTableView addFooterWithCallback:^{
        self.dataIndex += 9;
        
        [self getDataFromAFN];
    }];
}

/**
 *  上拉刷新下拉加载更多是两个借口,所以用了2个Block请求
    Block里面封装的是AFN请求
    
    reloadDataFromAFN   上拉刷新
    getDataFromAFN      下拉加载更多
 */
-(void)reloadDataFromAFN{
    /**
     *  POST解析,带有Cookie值,并且Cookie值变化,但是不影响之前的数据
     */
    NSString *url_string = @"http://api2.pianke.me/ting/radio";
    NSDictionary *para = @{@"client":@"2",@"auth":@"B8Y4En3h8f1DC8Z8GcHulTJxQMOuNLCNojtsUT0xcWP22NVFSh9U6fo"};
    NSString *cookie = @"PHPSESSID=58ts41v1nohdn89damknm0vdt5";
    
    [AppTools postDataFromAFN:url_string WithParameters:para AndCookie:cookie AndBlock:^(id data) {
        NSDictionary *dic = data;
        
        /**
         *      上拉刷新时:
         1.请求成功后更新本地数据库里面的数据
         2.移除所有数组里面的所有数据
         3.重新解析然后将解析出来的数据加载到数据库中
         4.给所有数组重新赋值
         */
        [[DataBaseSingleton shareDataBaseSingleton] dropRadioTable];
        [[DataBaseSingleton shareDataBaseSingleton] creatRadioTable];
        [[DataBaseSingleton shareDataBaseSingleton] deleteCarouselWithKind:@"radio"];
        [[DataBaseSingleton shareDataBaseSingleton] creatCarouselTable];
        [self.alllistArray removeAllObjects];
        [self.hotlistArray removeAllObjects];
        [self.carouselArray removeAllObjects];
        
        //  解析的是 alllist      :普通电台的数据
        
        NSArray *arrayAlllist = [[dic objectForKey:@"data"] objectForKey:@"alllist"];
        for(NSDictionary *dictionary in arrayAlllist){
            Radio *radio = [[Radio alloc] init];
            [radio setValuesForKeysWithDictionary:dictionary];
            radio.uname = [[dictionary objectForKey:@"userinfo"] objectForKey:@"uname"];
            [[DataBaseSingleton shareDataBaseSingleton] insertRadioTable:radio AndKind:@"alllist"];
            [radio release];
        }
        //  给alllistArray赋值
        self.alllistArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioWithString:@"alllist"];
        
        //  解析的是hotlist     :收听最热门的电台数据
        
        NSArray *arrayHotlist = [[dic objectForKey:@"data"] objectForKey:@"hotlist"];
        for(NSDictionary *dictionary in arrayHotlist){
            Radio *radio = [[Radio alloc] init];
            [radio setValuesForKeysWithDictionary:dictionary];
            radio.uname = [[dictionary objectForKey:@"userinfo"] objectForKey:@"uname"];
            [[DataBaseSingleton shareDataBaseSingleton] insertRadioTable:radio AndKind:@"hotlist"];
            [radio release];
        }
        //  给hotlistArray赋值
        self.hotlistArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioWithString:@"hotlist"];
        
        //  解析的是carousel    :轮播图的数据
        NSArray *arrayCarousel = [[dic objectForKey:@"data"] objectForKey:@"carousel"];
        for(NSDictionary *dictionary in arrayCarousel){
            Carousel *carousel = [[Carousel alloc] init];
            carousel.img = [dictionary objectForKey:@"img"];
            carousel.url = [dictionary objectForKey:@"url"];
            [[DataBaseSingleton shareDataBaseSingleton] insertCarouselTable:carousel AndKind:@"radio"];
            [carousel release];
        }
        //  给carouselArray赋值
        self.carouselArray = [[DataBaseSingleton shareDataBaseSingleton] selectCarouselWithKind:@"radio"];
        
        /**
         *  请求的新的数据之后,刷新myTableView,同时停止头部和尾部的fresh
         */
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];

        
    } failure:^(NSError *error) {
        self.carouselArray = [[DataBaseSingleton shareDataBaseSingleton] selectCarouselWithKind:@"radio"];
        self.hotlistArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioWithString:@"hotlist"];
        self.alllistArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioWithString:@"alllist"];
        
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
        
    }];
    
}

/**
 *  下拉加载更多,具体实现步骤跟上拉刷新一毛一样,但是只有普通电台的数据
 */
-(void)getDataFromAFN{
    
    NSString *url_string = @"http://api2.pianke.me/ting/radio_list";
    NSDictionary *para = @{@"client":@"1",@"auth":@"C807FCuwm36lDC8l3HMTslDJxQMKpNLeNoj1vCGMzcWP22NZLTRhY4fI",@"deviceid":@"63900960-1ED5-47D0-B561-86C09F41ED08",@"limit":@"9",@"start":[NSString stringWithFormat:@"%ld",self.dataIndex],@"version":@"3.0.6"};
    NSString *cookie = @"PHPSESSID=dlbvjmr0e59672q3lseu1fomu5";
    
    [AppTools postDataFromAFN:url_string WithParameters:para AndCookie:cookie AndBlock:^(id data) {
        
        NSDictionary *dic = data;
        
        //  解析的是 alllist
        NSArray *arrayAlllist = [[dic objectForKey:@"data"] objectForKey:@"list"];
        for(NSDictionary *dictionary in arrayAlllist){
            Radio *radio = [[Radio alloc] init];
            [radio setValuesForKeysWithDictionary:dictionary];
            radio.uname = [[dictionary objectForKey:@"userinfo"] objectForKey:@"uname"];
            [[DataBaseSingleton shareDataBaseSingleton] insertRadioTable:radio AndKind:@"alllist"];
            [radio release];
        }
        self.alllistArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioWithString:@"alllist"];
        
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];

        
    } failure:^(NSError *error) {
        
        self.alllistArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioWithString:@"alllist"];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
        
    }];
    
    
}

/**
 *  整个界面分两个区
        1.第一个区的头部
            1.1 轮播图
            1.2 tableViewCell,里面嵌套了一个CollectionViewCell
        2.第二个区的头部是一行字符串
            2.1 tableViewCell
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if(section == 0){
        self.myScrollView = [[CarouselScrollView alloc] initWithFrame:CGRectMake(0, 0, 375 * WIDTH, 150 * WIDTH)];
        self.myScrollView.carouselArray = self.carouselArray;
        return self.myScrollView;
    }
    else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 150 * WIDTH;
    }
    else{
        return 15 * WIDTH;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 120 * WIDTH;
    }
    else{
        return 90 * WIDTH;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }
    else{
        return self.alllistArray.count;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        return @"全部电台·All stations";
    }
    return nil;
    
}

/**
 *  自定义协议方法:
        当点击第一个区里面的Item时,跳转到Radio_DetailViewController,并且传过去相应的参数
 *
 */
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Radio *radio = [self.hotlistArray objectAtIndex:indexPath.row];
    
    Radio_DetailViewController *radio_Detail = [[Radio_DetailViewController alloc] init];
    radio_Detail.radioid = radio.radioid;
    radio_Detail.navigationItem.title = radio.title;
    [self.navigationController pushViewController:radio_Detail animated:YES];
    
    [radio_Detail release];

    
}

/**
 *  设置tableViewCell内容,包含两个部分
 *
 *
 *  @return 根据不同的区返回不同的Cell
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString *ID = @"radio_top";
        Radio_topTableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(topCell == nil){
            topCell = [[Radio_topTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        topCell.delegate = self;
        topCell.radio_topArray = self.hotlistArray;
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return topCell;
    }
    else{
        static NSString *ID = @"radio";
        Radio_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if(cell == nil){
            cell = [[Radio_TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.radio = [self.alllistArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
}

/**
 *  系统协议方法
        只有点击第二个区里面的Cell的时候才会触发
 *
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1){
        Radio *radio = [self.alllistArray objectAtIndex:indexPath.row];
        Radio_DetailViewController *radio_Detail = [[Radio_DetailViewController alloc] init];
        radio_Detail.radioid = radio.radioid;
        radio_Detail.navigationItem.title = radio.title;
        [self.navigationController pushViewController:radio_Detail animated:YES];

        [radio_Detail release];
    }
}


@end

//
//  Radio_DetailViewController.m
//  EyeWink
//
//  Created by dllo on 15/9/29.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "Radio_DetailViewController.h"
#import "RadioDetailTableViewCell.h"
#import "RadioPlayerViewController.h"
#import "AppTools.h"

#import "DataBaseSingleton.h"
#import "Radio.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#define HEADER_HEIGHT WIDTH * 250

@interface Radio_DetailViewController ()

@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,retain) NSMutableArray *listArray;
@property (nonatomic,retain) NSMutableArray *radioInfoArray;
@property (nonatomic,assign) NSInteger dataIndex;

@end

@implementation Radio_DetailViewController

- (void)dealloc
{
    [_radioid release];
    [_myTableView release];
    [_listArray release];
    [_radioInfoArray release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,  WIDTH * 375, WIDTH * 667 - WIDTH * 30) style:UITableViewStyleGrouped];
    [self.view addSubview:self.myTableView];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.myTableView release];

    [[DataBaseSingleton shareDataBaseSingleton] creatRadioDetailTable];
    self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioDetailWithString:@"list" AndRadioid:self.radioid];
    self.radioInfoArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioDetailWithString:@"radioInfo" AndRadioid:self.radioid];
    
    [self headerFresh];
    [self footerFresh];

}

-(void)headerFresh{
    [self.myTableView addHeaderWithCallback:^{
        [self reloadDataWithAFN];
        self.dataIndex = 0;
    }];
    [self.myTableView headerBeginRefreshing];
}

-(void)footerFresh{
    [self.myTableView addFooterWithCallback:^{
        self.dataIndex += 10;
        [self getDataWithAFN];
    }];
}


-(void)reloadDataWithAFN{
    NSString *url_string = @"http://api2.pianke.me/ting/radio_detail";
    
    NSDictionary *para = @{@"radioid":self.radioid,@"client":@"1",@"auth":@"C807FCuwm36lDC8l3HMTslDJxQMKpNLeNoj1vCGMzcWP22NZLTRhY4fI",@"version":@"3.0.6",@"deviceid":@"63900960-1ED5-47D0-B561-86C09F41ED08"};
    
    NSString *cookie = @"PHPSESSID=dlbvjmr0e59672q3lseu1fomu5";
    
    [AppTools postDataFromAFN:url_string WithParameters:para AndCookie:cookie AndBlock:^(id data) {
        
        [[DataBaseSingleton shareDataBaseSingleton] deleteRadioDetailWithRadioid:self.radioid];
        [self.listArray removeAllObjects];
        [self.radioInfoArray removeAllObjects];
        
        NSMutableDictionary *dic = data;
        NSArray *listArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
        for(NSMutableDictionary *dictionary in listArray){
            Radio *radio = [[Radio alloc] init];
            [radio setValuesForKeysWithDictionary:dictionary];
            radio.sharetext = [[dictionary objectForKey:@"playInfo"] objectForKey:@"sharetext"];
            radio.shareurl = [[dictionary objectForKey:@"playInfo"] objectForKey:@"shareurl"];
            radio.musicUrl = [[dictionary objectForKey:@"playInfo"] objectForKey:@"musicUrl"];
            [[DataBaseSingleton shareDataBaseSingleton] insertRadioDetailTable:radio AndKind:@"list" AndRadioid:self.radioid];
            [radio release];
        }
        self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioDetailWithString:@"list" AndRadioid:self.radioid];
        
        NSDictionary *radioInfoDic = [[dic objectForKey:@"data"] objectForKey:@"radioInfo"];
        Radio *radio = [[Radio alloc] init];
        [radio setValuesForKeysWithDictionary:radioInfoDic];
        radio.uname = [[radioInfoDic objectForKey:@"userinfo"] objectForKey:@"uname"];
        radio.icon = [[radioInfoDic objectForKey:@"userinfo"] objectForKey:@"icon"];
        [[DataBaseSingleton shareDataBaseSingleton] insertRadioDetailTable:radio AndKind:@"radioInfo" AndRadioid:self.radioid];
        self.radioInfoArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioDetailWithString:@"radioInfo" AndRadioid:self.radioid];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];

        
    } failure:^(NSError *error) {
        
        self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioDetailWithString:@"list" AndRadioid:self.radioid];
        self.radioInfoArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioDetailWithString:@"radioInfo" AndRadioid:self.radioid];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
    }];
    
}


-(void)getDataWithAFN{
    
    NSString *url_string = @"http://api2.pianke.me/ting/radio_detail_list";
    
    NSDictionary *para = @{@"radioid":self.radioid,@"start":[NSString stringWithFormat:@"%ld",self.dataIndex],@"client":@"1",@"auth":@"C807FCuwm36lDC8l3HMTslDJxQMKpNLeNoj1vCGMzcWP22NZLTRhY4fI",@"limit":@"10",@"version":@"3.0.6",@"deviceid":@"63900960-1ED5-47D0-B561-86C09F41ED08"};
    
    NSString *cookie = @"PHPSESSID=dlbvjmr0e59672q3lseu1fomu5";
    
    [AppTools postDataFromAFN:url_string WithParameters:para AndCookie:cookie AndBlock:^(id data) {
        
        NSMutableDictionary *dic = data;
        NSArray *listArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
        for(NSMutableDictionary *dictionary in listArray){
            Radio *radio = [[Radio alloc] init];
            [radio setValuesForKeysWithDictionary:dictionary];
            radio.sharetext = [[dictionary objectForKey:@"playInfo"] objectForKey:@"sharetext"];
            radio.shareurl = [[dictionary objectForKey:@"playInfo"] objectForKey:@"shareurl"];
            radio.musicUrl = [[dictionary objectForKey:@"playInfo"] objectForKey:@"musicUrl"];
            [[DataBaseSingleton shareDataBaseSingleton] insertRadioDetailTable:radio AndKind:@"list" AndRadioid:self.radioid];
            [radio release];
        }
        self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioDetailWithString:@"list" AndRadioid:self.radioid];
        
        NSDictionary *radioInfoDic = [[dic objectForKey:@"data"] objectForKey:@"radioInfo"];
        Radio *radio = [[Radio alloc] init];
        [radio setValuesForKeysWithDictionary:radioInfoDic];
        radio.uname = [[radioInfoDic objectForKey:@"userinfo"] objectForKey:@"uname"];
        radio.icon = [[radioInfoDic objectForKey:@"userinfo"] objectForKey:@"icon"];
        [[DataBaseSingleton shareDataBaseSingleton] insertRadioDetailTable:radio AndKind:@"radioInfo" AndRadioid:self.radioid];
        self.radioInfoArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioDetailWithString:@"radioInfo" AndRadioid:self.radioid];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];

        
    } failure:^(NSError *error) {
        self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioDetailWithString:@"list" AndRadioid:self.radioid];
        self.radioInfoArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioDetailWithString:@"radioInfo" AndRadioid:self.radioid];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];

    }];
    
}

#pragma mark-  设置cell

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RadioPlayerViewController *radioplayVC = [RadioPlayerViewController shareRadio_PlayerViewController];
    radioplayVC.allMusicArray = [[DataBaseSingleton shareDataBaseSingleton] selectRadioDetailWithString:@"list" AndRadioid:self.radioid];
    radioplayVC.indexPath = indexPath.row;
    radioplayVC.radio = [radioplayVC.allMusicArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:radioplayVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return WIDTH * 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"radio_Detail";
    
    RadioDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[RadioDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.radio = [self.listArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    return cell;
}

/**
 *  设置tableView的区的头部的高度
 *  注:只有一个区
 *
 *  @return 返回区的头部高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEADER_HEIGHT;
}

/**
 *  设置tableView的区的头部的内容
 *  注:只有一个区
 *
 *  @return 返回区的头部的内容
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.radioInfoArray.count != 0){
        Radio *radio = [self.radioInfoArray objectAtIndex:0];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, HEADER_HEIGHT)];
        UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 140)];
        [headView addSubview:coverImageView];
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:radio.coverimg]];
        [coverImageView release];
        
        UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, WIDTH * 140 , WIDTH * 375, WIDTH * 110 )];
        userView.backgroundColor = [UIColor whiteColor];
        UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 10, WIDTH * 15, WIDTH * 26, WIDTH * 26)];
        [userView addSubview:userIcon];
        [userIcon sd_setImageWithURL:[NSURL URLWithString:radio.icon] placeholderImage:[UIImage imageNamed:@"eyeWink"]];
        userIcon.layer.masksToBounds = YES;
        userIcon.layer.cornerRadius = WIDTH * 13;
        [userIcon release];
        
        UIImageView *visitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 275, WIDTH * 20, WIDTH * 12, WIDTH * 12)];
        [userView addSubview:visitImageView];
        
        
        [visitImageView release];
        
        UILabel *musicVisitLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 290, WIDTH * 15, WIDTH * 70, WIDTH * 26)];
        [userView addSubview:musicVisitLabel];
        musicVisitLabel.font = [UIFont systemFontOfSize:WIDTH * 14];
        musicVisitLabel.textColor = [UIColor grayColor];
        musicVisitLabel.text = [NSString stringWithFormat:@"%ld",radio.musicvisitnum];
        [musicVisitLabel release];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH * 10, WIDTH * 40, WIDTH * 345, WIDTH * 70)];
        desc.numberOfLines = 0;
        desc.textColor = [UIColor grayColor];
        [userView addSubview:desc];
        desc.text = radio.desc;
        [desc release];
        
        
        [headView addSubview:userView];
        [userView release];
        
        return headView;
    }
    else    return nil;
}


@end

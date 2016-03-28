//
//  ReadViewController.m
//  EyeWink
//
//  Created by dllo on 15/9/29.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "ReadViewController.h"
#import "DataBaseSingleton.h"
#import "CarouselScrollView.h"
#import "Read_DetailViewController.h"
#import "AppTools.h"

#import "Carousel.h"
#import "Read.h"

#import "MJRefresh.h"
#import "AFNetworking.h"

@interface ReadViewController ()

@property (nonatomic,retain) CarouselScrollView *myScrollView;
@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,assign) BOOL isUploading;

@property (nonatomic,retain) NSMutableArray *listArray;
@property (nonatomic,retain) NSMutableArray *carouselArray;


@end

@implementation ReadViewController

- (void)dealloc
{
    [_read release];
    [_myScrollView release];
    [_myTableView release];
    [_listArray release];
    [_carouselArray release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isUploading = NO;

    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 667) style:UITableViewStyleGrouped];
    [self.view addSubview:self.myTableView];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.myTableView release];
    
    [[DataBaseSingleton shareDataBaseSingleton] openDB];
    [[DataBaseSingleton shareDataBaseSingleton ] creatReadTable];
    [[DataBaseSingleton shareDataBaseSingleton] creatCarouselTable];
    self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllRead];
    self.carouselArray = [[DataBaseSingleton shareDataBaseSingleton] selectCarouselWithKind:@"read"];
    
    [self headerFresh];
    [self footerFresh];
    
}

-(void)headerFresh{
    [self.myTableView addHeaderWithCallback:^{
        self.isUploading = YES;
        
        [self getDataFromAFN];
    }];
    [self.myTableView headerBeginRefreshing];
}

-(void)footerFresh{
    [self.myTableView addFooterWithCallback:^{
        self.isUploading = NO;
        
        [self getDataFromAFN];
    }];
}

-(void)getDataFromAFN{

    NSString *url_string = @"http://api2.pianke.me/read/columns";
    NSDictionary *para = @{@"client":@"2",@"auth":@"B8Y4En3h8f1DC8Z8GcHulTJxQMOuNLCNojtsUT0xcWP22NVFSh9U6fo"};
    NSString *cookie = @"PHPSESSID=58ts41v1nohdn89damknm0vdt5";
    
    [AppTools postDataFromAFN:url_string WithParameters:para AndCookie:cookie AndBlock:^(id data) {
        
        if(self.isUploading){
            [[DataBaseSingleton shareDataBaseSingleton] dropReadTable];
            [[DataBaseSingleton shareDataBaseSingleton] creatReadTable];
            [[DataBaseSingleton shareDataBaseSingleton] deleteCarouselWithKind:@"read"];
            [[DataBaseSingleton shareDataBaseSingleton] creatCarouselTable];
            [self.listArray removeAllObjects];
            [self.carouselArray removeAllObjects];
        }
        
        NSDictionary *dic = data;
        
        //  list解析
        NSArray *listArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
        for(NSDictionary *dictionary in listArray){
            Read *read = [[Read alloc] init];
            [read setValuesForKeysWithDictionary:dictionary];
            [[DataBaseSingleton shareDataBaseSingleton] insertReadTable:read];
            [read release];
        }
        self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllRead];
        
        //  carousel解析
        NSArray *carouselArray = [[dic objectForKey:@"data"] objectForKey:@"carousel"];
        for(NSDictionary *dictionary in carouselArray){
            Carousel *carousel = [[Carousel alloc] init];
            carousel.img = [dictionary objectForKey:@"img"];
            carousel.url = [dictionary objectForKey:@"url"];
            [[DataBaseSingleton shareDataBaseSingleton] insertCarouselTable:carousel AndKind:@"read"];
            [carousel release];
        }
        self.carouselArray = [[DataBaseSingleton shareDataBaseSingleton] selectCarouselWithKind:@"read"];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];

        
    } failure:^(NSError *error) {
        
        self.listArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllRead];
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
        
    }];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.myScrollView = [[CarouselScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 150)];
    self.myScrollView.carouselArray = self.carouselArray;
    return self.myScrollView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"read";
    ReadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil){
        cell = [[ReadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.readArray = [NSMutableArray array];
    cell.delegate = self;
    if(self.listArray.count != 0){
        for(int i = 0 ; i < 3 ; i++){
            [cell.readArray addObject:[self.listArray objectAtIndex:(indexPath.row * 3 + i)]];
        }
    }
    return cell;

}

/**
 *  自定义协议方法
        作用是当点击不同的Item,跳转到不同的controller
 *
 *  @param typeID Item的唯一标识
 */
-(void)selectReadWithTypeID:(NSInteger)typeID{
    Read_DetailViewController *read_DetailVC = [[Read_DetailViewController alloc] init];
    read_DetailVC.typeID = typeID;
    [self.navigationController pushViewController:read_DetailVC animated:YES];
    
    [read_DetailVC release];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH * 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return WIDTH * 160;
    }
    else{
        return 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

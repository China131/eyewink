//
//  VideoViewController.m
//  EyeWink
//
//  Created by dllo on 15/10/7.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoTableViewCell.h"
#import "DataBaseSingleton.h"

#import "Video.h"

#import "AFNetworking.h"
#import "MJRefresh.h"


@interface VideoViewController () < UITableViewDataSource , UITableViewDelegate , getHeightProtocol >

@property (nonatomic,retain) UITableView *myTableView;
@property (nonatomic,assign) CGFloat height;

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) BOOL isUploading;

@end

@implementation VideoViewController

- (void)dealloc
{
    [_myTableView release];
    [_dataArray release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.height = 300;
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -40 * WIDTH, WIDTH * 375, WIDTH * 667 + WIDTH * 5) style:UITableViewStyleGrouped];
    [self.view addSubview:self.myTableView];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.myTableView release];
    
    
    [[DataBaseSingleton shareDataBaseSingleton] creatVideoTable];
    self.dataArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllVideo];
    
    [self headerFresh];
    [self footerFresh];

}

-(void)headerFresh{
    [self.myTableView addHeaderWithCallback:^{
        self.isUploading = YES;
        self.count = 30;
        
        [self getDataFromAFN];
    }];
    [self.myTableView headerBeginRefreshing];
}

-(void)footerFresh{
    [self.myTableView addFooterWithCallback:^{
        self.isUploading = NO;
        self.count += 30;
        
        [self getDataFromAFN];
    }];
}


-(void)getDataFromAFN{
    NSString *url_string = [NSString stringWithFormat:@"http://ic.snssdk.com/neihan/stream/mix/v1/?content_type=-104&iid=3116205395&min_time=1444198156&message_cursor=0&count=%ld&latitude=38.88259758462358&mpic=1&essence=1&content_type=-104&ac=WIFI&app_name=joke_essay&aid=7&version_code=4.3.5&device_platform=iphone&os_version=9.0&device_type=iPhone8,1&device_id=6717139371&vid=FAB8E59B-6E8C-4BDA-8D30-E9E7DBB53D16&openudid=7180192250c6112714fd4461d51a8b13cf03302c&os_api=18&idfa=CB9E1D9F-3B84-4BCE-9CC1-20FA8EF975F3&screen_width=750",self.count];
    
    
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"install_id=3116205395" forHTTPHeaderField:@"Cookie"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager GET:url_string parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(self.isUploading){
            [[DataBaseSingleton shareDataBaseSingleton] dropVideoTable];
            [[DataBaseSingleton shareDataBaseSingleton] creatVideoTable];
            [self.dataArray removeAllObjects];
        }
        
        NSDictionary *dic = responseObject;
        NSArray *dataArray = [[dic objectForKey:@"data"] objectForKey:@"data"];
        for(NSDictionary *dictionary in dataArray){
            NSDictionary *groupDic = [dictionary objectForKey:@"group"];
            Video *video = [[Video alloc] init];
            [video setValuesForKeysWithDictionary:groupDic];
            video.user_avatar_url = [[groupDic objectForKey:@"user"] objectForKey:@"avatar_url"];
            video.user_name = [[groupDic objectForKey:@"user"] objectForKey:@"name"];
            video.url = [[[[groupDic objectForKey:@"large_cover"] objectForKey:@"url_list"] objectAtIndex:1] objectForKey:@"url"];
            [[DataBaseSingleton shareDataBaseSingleton] insertVideoTable:video];
            [video release];
        }
        self.dataArray = [[DataBaseSingleton shareDataBaseSingleton] selectAllVideo];
        
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.myTableView headerEndRefreshing];
        [self.myTableView footerEndRefreshing];
        [self.myTableView reloadData];
    }];

    
}

-(void)play:(NSString *)url{
    MPMoviePlayerViewController *moviePlayerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url]];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerVC];
}

-(void)getHeight:(CGFloat)height{
    self.height = height;
}

#pragma mark-  设置cell

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"video";
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    Video *video = [self.dataArray objectAtIndex:indexPath.row];
    cell.video = video;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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

//
//  SearchViewController.m
//  EyeWink
//
//  Created by dllo on 15/10/8.
//  Copyright (c) 2015年 袁涛. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "Read_ArticleViewController.h"
#import "RadioPlayerViewController.h"

#import "Search.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface SearchViewController () < UITableViewDataSource , UITableViewDelegate , UISearchResultsUpdating >

@property (nonatomic,retain) UISearchController *mySearchC;
@property (nonatomic,retain) UITableView *myTableView;

@property (nonatomic,retain) NSMutableArray *allArray;
@property (nonatomic,retain) NSMutableArray *searchArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.allArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];

    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 667) style:UITableViewStylePlain];
    [self.view addSubview:self.myTableView];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.showsHorizontalScrollIndicator = NO;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.myTableView release];
    
    UIImage *leftImage = [UIImage imageNamed:@"ButtonEntryToolClose@2x~iphone"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonAction)];
    /**
     设置这个bgView 的作用是  防止self.mySearchC.searchBar 第一次偏移
     
     */
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375 * WIDTH, 40 * WIDTH)];
    
    self.mySearchC = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.myTableView.tableHeaderView = bgView;
    self.mySearchC.dimsBackgroundDuringPresentation = NO;
    self.mySearchC.hidesNavigationBarDuringPresentation = NO;
    self.mySearchC.searchBar.backgroundColor = [UIColor whiteColor];
    self.mySearchC.searchResultsUpdater = self;
    [self.mySearchC.searchBar sizeToFit];
    [self.mySearchC release];
    [bgView addSubview:self.mySearchC.searchBar];
    
    [self getDataFromAFN];

}

-(void)leftBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)getDataFromAFN{

    NSString *url_string = @"http://api2.pianke.me/search/hotlist";
    NSDictionary *para = @{@"client":@"2",@"auth":@"B8Y4En3h8f1DC8Z8GcHulTJxQMOuNLCNojtsUT0xcWP22NVFSh9U6fo"};
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"PHPSESSID=58ts41v1nohdn89damknm0vdt5" forHTTPHeaderField:@"Cookie"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",@"application/x-javascript",nil];
    [manager POST:url_string parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = responseObject;
        NSArray *searchArray = [dic objectForKey:@"data"];
        for(NSDictionary *dictionary in searchArray){
            Search *search = [[Search alloc] init];
            [search setValuesForKeysWithDictionary:dictionary];
            search.playInfo = [dictionary objectForKey:@"playInfo"];
            search.musicUrl = [[dictionary objectForKey:@"playInfo"] objectForKey:@"musicUrl"];
            search.imgUrl = [[dictionary objectForKey:@"playInfo"] objectForKey:@"imgUrl"];
            [self.allArray addObject:search];
            [search release];
        }
        
        [self.myTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];

}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{

    NSString *searchStr = searchController.searchBar.text;
    [self.searchArray removeAllObjects];
    for(Search *search in self.allArray){
        if([search.title rangeOfString:searchStr].location != NSNotFound){
            [self.searchArray addObject:search];
        }
        
    }
    [self.myTableView reloadData];
    
}

#pragma mark-  设置cell

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Search *search = [[Search alloc] init];
    if(self.searchArray.count == 0){
        search = [self.allArray objectAtIndex:indexPath.row];
    }
    else{
        search = [self.searchArray objectAtIndex:indexPath.row];
    }
    
    if(![search.playInfo objectForKey:@"title"]){
        Read_ArticleViewController *controller = [[Read_ArticleViewController alloc] init];
        controller.contentid = search.contentid;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        RadioPlayerViewController *controller = [RadioPlayerViewController shareRadio_PlayerViewController];
        controller.musicUrl = search.musicUrl;
        controller.imgUrl = search.imgUrl;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.mySearchC.active){
        return self.searchArray.count;
    }
    return self.allArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search"];
    if(cell == nil){
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search"];
    }
    Search *search = [[Search alloc] init];
    if(self.mySearchC.active){
        cell.indexPath = indexPath;
        cell.searchArray = self.searchArray;
        cell.text = self.mySearchC.searchBar.text;
        search = [self.searchArray objectAtIndex:indexPath.row];
    }
    else{
        search = [self.allArray objectAtIndex:indexPath.row];
    }
    
    cell.search = search;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH * 80;
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WIDTH * 80;
}
 
 
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH * 375, WIDTH * 80)];
    
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40 * WIDTH, WIDTH * 150, WIDTH * 40)];
    [headView addSubview:headLabel];
    headLabel.text = @"   他们都推荐";
    headLabel.font = [UIFont systemFontOfSize:WIDTH * 20];
    headLabel.textColor = [UIColor grayColor];
    [headLabel release];
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [headView addSubview:headButton];
    headButton.frame = CGRectMake(WIDTH * 290, 40 * WIDTH, WIDTH * 70, WIDTH * 40);
    UIImage *image = [UIImage imageNamed:@"ButtonEntryToolClose@2x~iphone"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [headButton setImage:image forState:UIControlStateNormal];
    [headButton addTarget:self action:@selector(headButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    return headView;
}

*/


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

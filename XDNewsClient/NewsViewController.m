//
//  NewsViewController.m
//  XDNewsClient
//
//  Created by xlhu on 14-3-22.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import "NewsViewController.h"
#import "AFHTTPRequestOperation.h"
#import "NewsViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworkReachabilityManager.h"

@interface NewsViewController (){

    int newsPage;
    
}
@property(nonatomic,strong)NSMutableArray *newsListData;

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.newsListData = [NSMutableArray arrayWithCapacity:20];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = YES;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:self.tableView.frame];
    self.refreshHeaderView.delegate = self;
    [self.view insertSubview:self.refreshHeaderView belowSubview:self.tableView];
    
    //  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    //加载0 page 列表
    [self loadNewsList:0];
    
}


-(void)loadNewsList:(int)page{

    //加载新闻列表
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ipad.jiadeapp.com/ajax/news.news.php?id_max=0&type=123&p=%d&l=ch",page+1]];
    NSURLRequest *request;
    if([[AFNetworkReachabilityManager sharedManager] isReachable]){
        NSLog(@"reach");
        request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3.0];
    }else{
        NSLog(@"not reache");
        request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:3.0];
    }
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"bock success");
        NSArray *newsList = [responseObject objectForKey:@"news"];
        //返回没有数据
        if(newsList==nil||[newsList count]==0){
            _reloading = NO;
            [self doneLoadingTableViewData];
            return;
        }
        //返回有数据
        if(page==0){
            newsPage = 0;
            self.newsListData = [responseObject objectForKey:@"news"];
            //下拉刷新，提示没有网络
            if(![[AFNetworkReachabilityManager sharedManager] isReachable]){
                //在现实UIAlertView之前，恢复contentInset
//                _reloading = NO;  //不再reloading
//                [self doneLoadingTableViewData];
                [self showConnectInternetFail];
            }
            
        }else{
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            [tempArray addObjectsFromArray:self.newsListData];
            [tempArray addObjectsFromArray:newsList];
            self.newsListData = tempArray;
            newsPage++;
        }
        [self.tableView reloadData];
        _reloading = NO;  //不再reloading
        [self doneLoadingTableViewData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"block failure");
        [self showConnectInternetFail];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}


-(void)showConnectInternetFail{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您暂时无法访问网络!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma tableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.newsListData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"NewsViewCell";
    NewsViewCell *newsCell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (newsCell == nil) {
        NSArray *cellNib = [[NSBundle mainBundle] loadNibNamed:@"NewsViewCell" owner:self options:nil];
        newsCell = [cellNib objectAtIndex:0];
        newsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *tempDic = [self.newsListData objectAtIndex:indexPath.row];
    [newsCell.thumbImgView setImageWithURL:[NSURL URLWithString:[tempDic objectForKey:@"img"]] placeholderImage:nil];
    newsCell.titleLabel.text = [tempDic objectForKey:@"title"];
    newsCell.descLabel.text = [tempDic objectForKey:@"subContent"];
    
    return newsCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    DetailViewController *detailController = [[DetailViewController alloc] init];
    detailController.newsId = [[self.newsListData objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:detailController animated:YES];
    
    
}


#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
    [self loadNewsList:0];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    float offset = [self.newsListData count]*100-scrollView.contentOffset.y;
    if(!_reloading && offset<800 && [[AFNetworkReachabilityManager sharedManager] isReachable]){
        _reloading = YES; //_reloading为yes的时候，不再执行加载数据
        [self loadNewsList:newsPage+1];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

-(IBAction)newsDetailClick:(id)sender{

    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(IBAction)backButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

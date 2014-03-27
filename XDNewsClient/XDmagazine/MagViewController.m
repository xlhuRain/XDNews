//
//  MagViewController.m
//  XDNewsClient
//
//  Created by xlhu_mac on 14-3-27.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import "MagViewController.h"
#import "ConnectAPI.h"
#import "Utils.h"
#import "ContentScrollView.h"
#import "AboutViewController.h"
#import "JSONKit.h"

@interface MagViewController ()

@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UIScrollView *homeScroll;
@property(nonatomic,strong)NSDictionary *homeDic;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIPageControl *pageControl;

@property(nonatomic,strong)UIImageView *guideImageView;

@property(nonatomic,strong)ContentScrollView *contentScrView;

@end

@implementation MagViewController

@synthesize contentView = _contentView;
@synthesize homeScroll = _homeScroll;
@synthesize homeDic = _homeDic;
@synthesize tableView = _tableView;
@synthesize headView = _headView;
@synthesize pageControl = _pageControl;

@synthesize guideImageView = _guideImageView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        self.navigationItem.title = @"现代车尚";
        _homeDic = [[ConnectAPI sharedInstance] getLocalData];
//        [self getShareContent];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 175)];
    
    _homeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 175)];
    _homeScroll.delegate = self;
    _homeScroll.pagingEnabled = YES;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 160, 320, 10)];
    _pageControl.currentPage = 0;
    
    [self reloadScrollView];
    
    [_contentView addSubview:_homeScroll];
    [_contentView addSubview:_pageControl];
    
    
    //加载HeadView
    [self loadHeadView];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, 320, self.view.frame.size.height-41) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:35.0/255.0 blue:36.0/255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.clipsToBounds = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.decelerationRate = 0.1;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView setTableHeaderView:_contentView];
    
    UIImageView *headImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    headImageView.image = [UIImage imageNamed:@"bar.png"];
    headImageView.userInteractionEnabled = YES;
    
    UIImageView *titleHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 45)];
    titleHeader.center = CGPointMake(160, 23);
    titleHeader.image = [UIImage imageNamed:@"title.png"];
    [headImageView addSubview:titleHeader];
    //关于
    
    UIButton *aboutBtn = [[UIButton alloc] initWithFrame:CGRectMake(275, 0, 41, 41)];
    [aboutBtn setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [aboutBtn addTarget:self action:@selector(aboutClick:) forControlEvents:UIControlEventTouchUpInside];
    [headImageView addSubview:aboutBtn];
    
    [self.view addSubview:headImageView];
    
    //有数据，显示ScrollView和list
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        NSDictionary *serverData = [[ConnectAPI sharedInstance] getServerData];
    //        if(serverData!=NULL){
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                _homeDic = serverData;
    //                [self reloadScrollView];
    //                [_tableView reloadData];
    //
    //                [self getShareContent];  //分享json
    //            });
    //        }
    //    });
    _guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,320,548)];
    _guideImageView.image = [UIImage imageNamed:@"welcome.jpg"];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeWelcome:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    _guideImageView.userInteractionEnabled = YES;
    [_guideImageView addGestureRecognizer:swipe];
    
    [self.view addSubview:_guideImageView];
    
    NSString *url = @"http://club.beijing-hyundai.com.cn/survey2013/phone/data.php?d=2";
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)swipeWelcome:(UISwipeGestureRecognizer *)swipe{
    //    [UIView beginAnimations:@"animationID" context:nil];http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx/getMobileCodeInfo?mobileCode=string&userID=string
    //	[UIView setAnimationDuration:0.5f];
    //	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //	[UIView setAnimationRepeatAutoreverses:NO];
    //
    //    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    //    [_guideImageView removeFromSuperview];
    //    _guideImageView = nil;
    ////    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    //	[UIView commitAnimations];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _guideImageView.frame = CGRectMake(-320, 0, 320, 548);
        
    } completion:^(BOOL finished){
        
        [_guideImageView removeFromSuperview];
        _guideImageView = nil;
    }];
}

//获得分享的数据
-(void)getShareContent{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *tempImg = [Utils getImgWithUrl:[[_homeDic objectForKey:@"share"] objectForKey:@"shareImg"]];
        [Utils saveCachesData:tempImg to:[Utils applicationCachesDirectory:@"shareapp.jpg"]];
    });
}

-(void)aboutClick:(id)sender{
    
    AboutViewController *aboutControllerView = [[AboutViewController alloc] init];
    aboutControllerView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    [self.navigationController presentModalViewController:aboutControllerView animated:YES];
    [self.navigationController presentViewController:aboutControllerView animated:YES completion:nil];
}


//加载Scrollview;
-(void)reloadScrollView{
    
    for(UIView *subView in _homeScroll.subviews){
        [subView removeFromSuperview];
    }
    
    NSArray *homeList = [_homeDic objectForKey:@"carousel"];
    
    for (int i =0; i<[homeList count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_homeScroll.frame.size.width*i, 0, 320, _homeScroll.frame.size.height)];
        NSString *fileName = [Utils GetImgNameFromUrl:[[homeList objectAtIndex:i]objectForKey:@"img" ]];
        //本地存在加载本地，否则请求服务器端
        
        if([Utils fileIsExists:[Utils applicationCachesDirectory:fileName]]){
            imageView.image = [[UIImage alloc] initWithContentsOfFile:[Utils applicationCachesDirectory:fileName]];
        }else{
            imageView.image = [UIImage imageNamed:@"banner_loading.png"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *tempImg = [Utils getImgWithUrl:[[homeList objectAtIndex:i]objectForKey:@"img" ]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils saveCachesData:tempImg to:[Utils applicationCachesDirectory:fileName]];
                    imageView.image = tempImg;
                    [self.tableView setTableHeaderView:_contentView];
                    [self.tableView reloadData];
                });
            });
        }
        
        imageView.tag = 88+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ScrollImageClick:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        [_homeScroll addSubview:imageView];
    }
    _homeScroll.contentSize = CGSizeMake(320*[homeList count], _homeScroll.frame.size.height);
    [_pageControl setNumberOfPages:[homeList count]];
    
}


-(void)ScrollImageClick:(UITapGestureRecognizer *)tap{
    int index = tap.view.tag-88;
    NSString *urlStr = [[[_homeDic objectForKey:@"carousel"] objectAtIndex:index] objectForKey:@"url"];
    NSLog(@"url %@",urlStr);
    
    NSURL *url = [NSURL URLWithString:[[[_homeDic objectForKey:@"carousel"] objectAtIndex:index] objectForKey:@"url"]];
    [[UIApplication sharedApplication] openURL:url];
    
}



-(void)loadHeadView{
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 24)];
    UILabel *magLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0 , 200, 24)];
    magLabel.backgroundColor = [UIColor clearColor];
    magLabel.font = [UIFont systemFontOfSize:14];
    magLabel.text = @"现代车尚";
    magLabel.textAlignment = NSTextAlignmentLeft;
    magLabel.textColor = [UIColor whiteColor];
    
    [_headView addSubview:magLabel];
    _headView.backgroundColor = [UIColor blackColor];
}

#pragma mark -scrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = scrollView.contentOffset.x/320;
    _pageControl.currentPage = page;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[_homeDic objectForKey:@"journal"] count]%2 + [[_homeDic objectForKey:@"journal"] count]/2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 262;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return  _headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%d",[indexPath row]]];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"cell%d",[indexPath row]]];
        
        //期刊列表
        NSArray *list = [_homeDic objectForKey:@"journal"];
        MagView *leftMagView = [[MagView alloc] initWithFrame:CGRectMake(33.3,40, 110, 191)];
        leftMagView.delegate = self;
        [leftMagView loadMagView:[list objectAtIndex:[indexPath row]*2]];
        [cell.contentView addSubview:leftMagView];
        
        if([indexPath row]*2+1!=[list count]){
            
            MagView *rightMagView = [[MagView alloc] initWithFrame:CGRectMake(176.6, 40, 110, 191)];
            rightMagView.delegate =self;
            [rightMagView loadMagView:[list objectAtIndex:[indexPath row]*2+1]];
            [cell.contentView addSubview:rightMagView];
            
        }
        cell.contentView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:35.0/255.0 blue:36.0/255.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        return cell;
    }
    
}

-(void)magImgClicked:(NSString *)magId{
    
    NSLog(@"magId is %@",magId);

    self.contentScrView = [[ContentScrollView alloc] init];
    self.contentScrView.magId = magId;
    self.contentScrView.shareContent = [[_homeDic objectForKey:@"share"] objectForKey:@"shareContent"];
    self.contentScrView.shareUrl = [[_homeDic objectForKey:@"share"] objectForKey:@"shareURL"];
    self.contentScrView.shareTitle = [[_homeDic objectForKey:@"share"] objectForKey:@"shareTitle"];
    self.contentScrView.view.backgroundColor = [UIColor clearColor];
    [self.navigationController pushViewController:self.contentScrView animated:YES ];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}

-(void)requestFinished:(ASIHTTPRequest *)request{

    NSData *response = [request responseData];
    NSString *fileName = @"list.json";
    NSString *filePath = [Utils applicationDocumentsDirectory:fileName];
    NSDictionary *result = [response objectFromJSONData];
    
    if(result != NULL){
        if([Utils fileIsExists:filePath])
            [Utils removeDocumentFile:filePath];
        [Utils saveDocumentData:response to:filePath];
    }
    
    _homeDic = [[ConnectAPI sharedInstance] getLocalData];
    [self getShareContent];
    
    [self.tableView reloadData];
    [self reloadScrollView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

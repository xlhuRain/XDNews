//
//  ContentScrollView.m
//  XDmagazine
//
//  Created by tagux-mac-04 on 13-5-20.
//  Copyright (c) 2013年 tagux-mac-04. All rights reserved.
//

#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)] 

#import "ContentScrollView.h"
#import "Utils.h"
#import "Define.h"
#import "ConnectAPI.h"
#import "AboutViewController.h"

#define scrollTag 333

@interface ContentScrollView ()

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,strong)NSDictionary *dataSource;
@property(nonatomic,strong)UITableView *tableView;  //目录列表
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,strong)UILabel *titleLable;

@end

@implementation ContentScrollView

@synthesize magId = _magId;
@synthesize scrollView = _scrollView;
@synthesize filePath = _filePath;
@synthesize dataSource = _dataSource;
@synthesize tableView  = _tableView;
@synthesize headView = _headView;
@synthesize bottomView = _bottomView;

@synthesize titleLable = _titleLable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        // Custom initialization
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight-20)];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches =YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        //默认第一屏
        indexLocation = 0;
        isShowBar = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTopbar:)];
        [_scrollView addGestureRecognizer:tap];
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _filePath = [Utils applicationCachesDirectory:[NSString stringWithFormat:@"/%@",_magId]];
    
    _dataSource = [[ConnectAPI sharedInstance] readMagStatusDic:[NSString stringWithFormat:@"%@/%@.config",_filePath,_magId]];
    
//    NSLog(@"dataSource %@",_dataSource);
    NSArray *array= [_dataSource objectForKey:@"page"];
    
    totalPage = [array count];
    
    for (int i = 0; i<[array count]; i++) {
        SingleScrollView *singleView = [[SingleScrollView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight-20) withBtnArray:[[array objectAtIndex:i] objectForKey:@"btn" ]];
        singleView.btnDelegate = self;
        singleView.delegate = self;
        singleView.imageName = [[array objectAtIndex:i] objectForKey:@"img"];
        if(i==0||i==1||i==2){
            UIImage *addImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",_filePath,singleView.imageName]];
            singleView.imageView.frame = CGRectMake(0, 0, 320, addImage.size.height*320/addImage.size.width);
            singleView.contentSize = CGSizeMake(320, singleView.imageView.frame.size.height);
            singleView.imageView.image = addImage;
        }
            
        singleView.tag = scrollTag + i;
        [_scrollView addSubview:singleView];
        
    }
    _scrollView.frame = CGRectMake(0, 20, ScreenWidth, self.view.frame.size.height-20);
    _scrollView.contentSize = CGSizeMake(ScreenWidth*[array count], _scrollView.frame.size.height);
    
    [self.view addSubview:_scrollView];
    
    
    //目录列表
    _tableView = [[UITableView alloc] init];
    _tableView.transform = CGAffineTransformMakeRotation(M_PI_2);
    _tableView.frame = CGRectMake(0, self.view.frame.size.height-217, 320, 170);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:35.0/255.0 blue:36.0/255.0 alpha:1];
    _tableView.hidden = YES;
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[_dataSource objectForKey:@"pageSmall"]count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self.view addSubview:_tableView];
    
    
    //headview
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, -45, 320, 45)];
    //返回按钮
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    backImageView.image = [UIImage imageNamed:@"bar.png"];
    [_headView addSubview:backImageView];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 41, 41)];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:backBtn];
    //titile
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 45)];
    _titleLable.center = CGPointMake(160, 22.5);
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    _titleLable.font = [UIFont systemFontOfSize:15];
    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.text = [[[_dataSource objectForKey:@"page"] objectAtIndex:0] objectForKey:@"title"];
    [_headView addSubview:_titleLable];
    //关于按钮
    UIButton *aboutBtn = [[UIButton alloc] initWithFrame:CGRectMake(275, 0, 41, 41)];
    [aboutBtn setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [aboutBtn addTarget:self action:@selector(aboutClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:aboutBtn];
    
    [self.view addSubview:_headView];
    
    
    // bottomView
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 49)];
    _bottomView.backgroundColor = HexRGBAlpha(0,.5);
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 49, 49)];
    [menuBtn setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:menuBtn];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 49)];
    bottomLabel.center = CGPointMake(160, 25);
    bottomLabel.text = @"现代车尚";
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.font = [UIFont systemFontOfSize:15];
    bottomLabel.backgroundColor = [UIColor clearColor];
    
    [_bottomView addSubview:bottomLabel];
    
    //share 分享
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(268, 2, 49, 49)];
    [shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:shareBtn];
    
    [self.view addSubview:_bottomView];
    
}
-(void)backClick:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)aboutClick:(id)sender{

    AboutViewController *aboutControllerView = [[AboutViewController alloc] init];
    aboutControllerView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self.navigationController presentModalViewController:aboutControllerView animated:YES];
    [self.navigationController presentViewController:aboutControllerView animated:YES completion:nil];
}

-(void)menuBtnClick:(id)sender{
    if(_tableView.hidden)
        _tableView.hidden = NO;
    else
        _tableView.hidden = YES;
}

-(void)shareBtnClick:(id)sender{

    //email
    [UMSocialData defaultData].extConfig.emailData.title = @"主题是神马啊?";
    UMSocialSnsPlatform *emailPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToEmail];
    emailPlatform.bigImageName = @"email.png";
    emailPlatform.displayName = @"投诉建议";
    
    //url to 现代俱乐部
    UMSocialSnsPlatform *urlPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    urlPlatform.bigImageName = @"link.png";
    urlPlatform.displayName = @"现代俱乐部";
    urlPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
        //跳转
        NSURL *url = [ NSURL URLWithString:@"cn.com.beijing-hyundai.hclub://open"];
        if(![[UIApplication  sharedApplication] openURL:url]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id652757799"]];
        }
        
    };
    
    //设置微信好友分享url图片
    [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.baidu.com/img/bdlogo.gif"];
    
    //    //设置微信朋友圈分享视频
    //    [[UMSocialData defaultData].extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeVideo url:@"http://v.youku.com/v_show/id_XNjQ1NjczNzEy.html?f=21207816&ev=2"];
    
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010" shareText:@"安妮阿噻呦" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToEmail,UMShareToQQ,nil] delegate:nil];

}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  92;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[_dataSource objectForKey:@"pageSmall"] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Celltest";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Celltest"];
        cell.transform = CGAffineTransformMakeRotation(-M_PI_2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 7, 88, 151)];
        imageView.tag = 888;
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell addSubview:imageView];
    }
    
    NSArray *smallArray = [_dataSource objectForKey:@"pageSmall"];
    
    UIImageView *tmpImageView = (UIImageView*)[cell viewWithTag:888];
    tmpImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",_filePath,[smallArray objectAtIndex:[smallArray count]-[indexPath row]-1]]];
    
    return cell;
}

-(void)scrollToRowAtIndexPath:(NSIndexPath *)custIndex{
    
    //    [self.tableView scrollToRowAtIndexPath:custIndex atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [self.tableView selectRowAtIndexPath:custIndex animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self BtnClicked:[NSString stringWithFormat:@"%d",[[_dataSource objectForKey:@"pageSmall"] count]-[indexPath row]-1]];
}



#pragma mark  scrollView Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{

    if([scrollView isKindOfClass:[SingleScrollView class]]){
        _tableView.hidden = YES;
    }

}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

//    _scrollView.userInteractionEnabled = YES;
    if([scrollView isKindOfClass:[UITableView class]])return;
    if([scrollView isKindOfClass:[SingleScrollView class]])return;
    int index = scrollView.contentOffset.x/ScreenWidth;
    if(index>0&&index<totalPage){
        SingleScrollView *addSingleView = (SingleScrollView*)[_scrollView viewWithTag:scrollTag+index];
        if(addSingleView.imageView.image!=nil){
            return;
        }else{
            _titleLable.text = [[[_dataSource objectForKey:@"page"] objectAtIndex:index] objectForKey:@"title"];
            if(![Utils fileIsExists:[NSString stringWithFormat:@"%@/%@",_filePath,addSingleView.imageName]])return;
            UIImage *addImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",_filePath,addSingleView.imageName]];
            addSingleView.imageView.frame = CGRectMake(0, 0, 320, addImage.size.height*320/addImage.size.width);
            addSingleView.contentSize = CGSizeMake(320, addSingleView.imageView.frame.size.height);
            addSingleView.imageView.image = addImage;
        }
        
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if((UITableView*)scrollView==_tableView)return;
    if([scrollView isKindOfClass:[UITableView class]])return;
    if([scrollView isKindOfClass:[SingleScrollView class]])return;

    int index = scrollView.contentOffset.x/ScreenWidth;
    int oldIndexLocation = indexLocation;
    indexLocation = index;
    if(index!=oldIndexLocation){
//        _scrollView.userInteractionEnabled = NO;
        _titleLable.text = [[[_dataSource objectForKey:@"page"] objectAtIndex:index] objectForKey:@"title"];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[_dataSource objectForKey:@"pageSmall"]count]-1-index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }

    if(index!=oldIndexLocation&&index!=0&&index!=totalPage-1){ //滑动屏幕
        if (index>oldIndexLocation) {
            SingleScrollView *addSingleView = (SingleScrollView*)[_scrollView viewWithTag:scrollTag+index+1];
            if(![Utils fileIsExists:[NSString stringWithFormat:@"%@/%@",_filePath,addSingleView.imageName]])return;
            UIImage *addImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",_filePath,addSingleView.imageName]];
            addSingleView.imageView.frame = CGRectMake(0, 0, 320, addImage.size.height*320/addImage.size.width);
            addSingleView.contentSize = CGSizeMake(320, addSingleView.imageView.frame.size.height);
            addSingleView.imageView.image = addImage;
            
            SingleScrollView *removeSingleView = (SingleScrollView*)[_scrollView viewWithTag:scrollTag+index-2];
            removeSingleView.imageView.image = nil;
            
            NSLog(@"right add %d  plus %d indexLoacation %d",index+1,index-2,indexLocation);
            
        }else{
        
            SingleScrollView *addSingleView = (SingleScrollView*)[_scrollView viewWithTag:scrollTag+index-1];
            if(![Utils fileIsExists:[NSString stringWithFormat:@"%@/%@",_filePath,addSingleView.imageName]])return;
            UIImage *addImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",_filePath,addSingleView.imageName]];
            addSingleView.imageView.frame = CGRectMake(0, 0, 320, addImage.size.height*320/addImage.size.width);
            addSingleView.contentSize = CGSizeMake(320, addSingleView.imageView.frame.size.height);
            addSingleView.imageView.image = addImage;
            
            SingleScrollView *removeSingleView = (SingleScrollView*)[_scrollView viewWithTag:scrollTag+index+2];
            removeSingleView.imageView.image = nil;
            
            NSLog(@"left add %d  plus %d  indexLoacation %d",index-1,index+2,indexLocation);
        }
//        indexLocation = index;
    }

}

-(void)showTopbar:(UITapGestureRecognizer *)tap{

    if(!isShowBar){
        [UIView animateWithDuration:0.3 animations:^{
            [_headView setFrame:CGRectMake(0, 20, 320, 50)];
            [_bottomView setFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
        } completion:^(BOOL finished){
            isShowBar = YES;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.hidden= YES;
            [_headView setFrame:CGRectMake(0, -50, 320, 50)];
            [_bottomView setFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
        } completion:^(BOOL finished){
            isShowBar = NO;
        }];
    }

}


-(void)BtnClicked:(NSString *)pageId{

    indexLocation = [pageId intValue];
    //页面跳转
    [_scrollView setContentOffset:CGPointMake(ScreenWidth*indexLocation, 0)];
//    [_scrollView scrollRectToVisible:CGRectMake(ScreenWidth*indexLocation, 0, ScreenWidth, self.view.frame.size.height) animated:YES];
    //加载图片
    _titleLable.text = [[[_dataSource objectForKey:@"page"] objectAtIndex:indexLocation] objectForKey:@"title"];
    
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[_dataSource objectForKey:@"pageSmall"]count]-1-indexLocation inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//    
    
    for(int i=indexLocation-1;i<indexLocation+2;i++){
    
        if(i<0||i>totalPage)continue;
        SingleScrollView *singleView = (SingleScrollView*)[_scrollView viewWithTag:scrollTag+i];
        [singleView setContentOffset:CGPointMake(0, 0)];
        if([Utils fileIsExists:[NSString stringWithFormat:@"%@/%@",_filePath,singleView.imageName]]){
            UIImage *addImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",_filePath,singleView.imageName]];
            singleView.imageView.frame = CGRectMake(0, 0, 320, addImage.size.height*320/addImage.size.width);
            singleView.contentSize = CGSizeMake(320, singleView.imageView.frame.size.height);
            singleView.imageView.image = addImage;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

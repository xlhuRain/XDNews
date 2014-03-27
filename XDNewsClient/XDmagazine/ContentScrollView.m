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
@synthesize shareContent = _shareContent;
@synthesize shareUrl = _shareUrl;
@synthesize shareTitle = _shareTitle;
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
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches =YES;
        
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
        SingleScrollView *singleView = [[SingleScrollView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, self.view.frame.size.height) withBtnArray:[[array objectAtIndex:i] objectForKey:@"btn" ]];
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
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height);
    _scrollView.contentSize = CGSizeMake(ScreenWidth*[array count], self.view.frame.size.height);
    
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
    NSString *imagePath = [Utils applicationCachesDirectory:@"shareapp.jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:_shareContent
                                       defaultContent:@"现代车尚"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:_shareTitle
                                                  url:_shareUrl
                                          description:@"分享内容"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //自定义菜单项
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"现代俱乐部" icon:[UIImage imageNamed:@"link.png"]  clickHandler:^{
    
        NSURL *url = [ NSURL URLWithString:@"cn.com.beijing-hyundai.hclub://open"];
        if(![[UIApplication  sharedApplication] openURL:url]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id652757799"]];
        }
        
    }];
    
    id<ISSShareActionSheetItem> item2 = [ShareSDK shareActionSheetItemWithTitle:@"投诉建议" icon:[UIImage imageNamed:@"email.png"]  clickHandler:^{
        
        [self sendEmail];
        
    }];
    
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    
//    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, ShareTypeTencentWeibo,ShareTypeWeixiSession, nil];
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeRenren),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          item2,
                          item1,
                          nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享" shareViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
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
            [_headView setFrame:CGRectMake(0, 0, 320, 50)];
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


#pragma send email 

-(void)sendEmail{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

//可以发送邮件的话
-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"联系我们"];
    [mailPicker setToRecipients:[NSArray arrayWithObjects:@"H-club@bhmc.com.cn", nil]];
    
    NSString *emailBody = @"您好，欢迎您的参与！";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    
//    [self presentModalViewController: mailPicker animated:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];
}

-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:H-club@bhmc.com.cn&subject=my email!";
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
//            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

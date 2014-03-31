//
//  DetailViewController.m
//  XDNewsClient
//
//  Created by xlhu on 14-3-27.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import "UIActivityIndicatorView+AFNetworking.h"
#import "DetailViewController.h"
#import "Define.h"
#import "AFHTTPRequestOperationManager.h"

@interface DetailViewController ()

@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIActivityIndicatorView *indicatorView;

@end

@implementation DetailViewController

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view from its nib.
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 20)];
    [self.view addSubview:self.webView];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.indicatorView];
    
    
//    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
//    requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    NSDictionary *parameters = @{@"id":@"11"};
//    [requestManager POST:@"http://www.baidu.com" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    
//    }];
    
//    AFHTTPRequestOperation *operation = [AFHTTPRequestOperation alloc]  initWithRequest:(NSURLRequest *)
    
}

-(IBAction)shareBtnClick:(id)sender{
    
    UMSocialSnsPlatform *sinaPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    sinaPlatform.bigImageName = @"icon";
    sinaPlatform.displayName = @"微博";
    sinaPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
        NSLog(@"点击新浪微博的响应");
    };
    
    UMSocialSnsPlatform *urlPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:@"urlPlatform"];
    urlPlatform.bigImageName = @"icon";
    urlPlatform.displayName = @"现代科技";
    urlPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController){
    
        //跳转
    };
    
    [UMSocialData defaultData].extConfig.emailData.title = @"给谁发邮件啊";
    
    //设置微信好友分享url图片
    [[UMSocialData defaultData].extConfig.wechatSessionData.urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://www.baidu.com/img/bdlogo.gif"];
    
    //设置微信朋友圈分享视频
    [[UMSocialData defaultData].extConfig.wechatTimelineData.urlResource setResourceType:UMSocialUrlResourceTypeVideo url:@"http://v.youku.com/v_show/id_XNjQ1NjczNzEy.html?f=21207816&ev=2"];
    

    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010" shareText:@"安妮阿噻呦" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToEmail,urlPlatform,nil] delegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

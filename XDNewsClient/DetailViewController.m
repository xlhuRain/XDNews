//
//  DetailViewController.m
//  XDNewsClient
//
//  Created by xlhu on 14-3-27.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

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
    // Do any additional setup after loading the view from its nib.
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

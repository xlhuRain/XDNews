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
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.indicatorView];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    [self.webView loadRequest:request];

}

-(void)webViewDidStartLoad:(UIWebView *)webView{

    [self.indicatorView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    
    //js与oc交互
    [self loadNewsWebView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"网络连接失败" message:@"数据加载失败,请检查网络!" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alertview show];
}

-(void)loadNewsWebView{

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewTap:)];
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.delegate = self;
    [self.webView addGestureRecognizer:tapGesture];
}

-(void)webViewTap:(UITapGestureRecognizer*)sender{

    int scrollPositionX = [[self.webView stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] intValue];
    
    int displayWidth = [[self.webView stringByEvaluatingJavaScriptFromString:@"window.outerWidth"] intValue];
    CGFloat scale = self.webView.frame.size.width / displayWidth;
    
    CGPoint pt = [sender locationInView:self.webView];
    pt.x *= scale;
    pt.y *= scale;
    pt.x += scrollPositionX;
    
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", pt.x, pt.y];
    NSString * tagName = [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    if ([tagName isEqualToString:@"IMG"]) {
        NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
        NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
        
        //得到高清图片的地址
        NSString *newPath = [urlToSave stringByReplacingOccurrencesOfString:@"cache" withString:@"uploads"];
        NSString *tem1 = [newPath substringFromIndex:7];
        NSArray *tem2 = [tem1 componentsSeparatedByString:@"/"];
        NSArray *tem3= [[tem2 lastObject] componentsSeparatedByString:@"."];
        
        NSString *realPath = [newPath stringByReplacingOccurrencesOfString:[tem2 lastObject] withString:[NSString stringWithFormat:@"%@.%@",[tem3 objectAtIndex:0],[tem3 lastObject]]];
        
//        [_imageView setImageWithURL:[NSURL URLWithString:realPath]  placeholderImage:nil options:SDWebImageCacheMemoryOnly  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//

//            if(image.size.height/image.size.width<1.33 && image.size.width>768){
//                _imageView.frame = CGRectMake(0, 0, kScreenHeight, kScreenHeight*image.size.height/image.size.width);
//            }else if(image.size.height/image.size.width>1.33 && image.size.height>1024){
//                
//                _imageView.frame = CGRectMake(0, 0, image.size.width*kScreenWidth/image.size.height,kScreenWidth);
//                
//            }else if(image.size.width==image.size.height && image.size.width>768){
//                _imageView.frame = CGRectMake(0, 0, kScreenHeight, kScreenHeight);
//            }else{
//                _imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//            }

//        }];
    }

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

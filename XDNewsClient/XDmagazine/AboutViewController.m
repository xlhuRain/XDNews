//
//  AboutViewController.m
//  XDmagazine
//
//  Created by tagux-mac-04 on 13-5-13.
//  Copyright (c) 2013年 tagux-mac-04. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor =[UIColor colorWithRed:37.0/255.0 green:35.0/255.0 blue:36.0/255.0 alpha:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 548)];
    imageView.image = [UIImage imageNamed:@"about.jpg"];
    [scrollView addSubview:imageView];
    scrollView.contentSize = CGSizeMake(320, 549);
    
    UIButton *webBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 280, 45)];
	webBtn.backgroundColor = [UIColor clearColor];
    [webBtn addTarget:self action:@selector(openWebClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:webBtn];

    
    [self.view addSubview:scrollView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    backImageView.image = [UIImage imageNamed:@"bar.png"];
    //titile
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
    titleLabel.center = CGPointMake(160, 22.5);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"关于";
    [backImageView addSubview:titleLabel];
    
    [self.view addSubview:backImageView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 41, 41)];
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

}

-(void)backBtnClick:(id)sender{
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)openWebClick:(id)sender{

    NSURL *url = [NSURL URLWithString:@"http://weibo.com/bjhyundai"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  NewsViewController.m
//  XDNewsClient
//
//  Created by xlhu on 14-3-22.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import "NewsViewController.h"
#import "AFHTTPRequestOperation.h"

@interface NewsViewController ()

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
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
//    self.navigationController.navigationItem.leftBarButtonItem = backButton;
    // Do any additional setup after loading the view from its nib.
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    //加载新闻列表
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [[NSOperationQueue mainQueue ] addOperation:operation];
    [operation start];

}

-(IBAction)newsDetailClick:(id)sender{

    DetailViewController *detailViewController = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(IBAction)backButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

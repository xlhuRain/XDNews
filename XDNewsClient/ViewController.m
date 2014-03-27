//
//  ViewController.m
//  XDNewsClient
//
//  Created by xlhu on 14-3-22.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import "ViewController.h"
#import "NewsViewController.h"
#import "MagViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)buttonClick:(UIButton *)sender{


    NewsViewController *newsViewController = [[NewsViewController alloc] init];
    newsViewController.typeId = sender.tag;
    [self.navigationController pushViewController:newsViewController animated:YES];
}


-(IBAction)MagazineButtonClick:(id)sender{
   
    MagViewController *magViewController = [[MagViewController alloc] init];
    [self.navigationController pushViewController:magViewController animated:YES];
    
}

@end

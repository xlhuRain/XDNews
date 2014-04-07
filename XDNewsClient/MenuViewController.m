//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "MenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"

#import "MagViewController.h"
#import "NewsViewController.h"

@implementation MenuViewController


-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor colorWithRed:37.0/255.0 green:35.0/255.0 blue:36.0/255.0 alpha:1];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 320, 568)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCellIdentifier"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCellIdentifier"];
    }
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"行业要闻";
            break;
        case 1:
            cell.textLabel.text = @"科技未来";
            break;
        case 2:
            cell.textLabel.text = @"对比评测";
            break;
        case 3:
            cell.textLabel.text = @"车型鉴赏";
            break;
        case 4:
            cell.textLabel.text = @"美景如画";
            break;
        case 5:
            cell.textLabel.text = @"往期回顾";
            break;
        case 6:
            cell.textLabel.text = @"电子报";
            break;
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.row==0){
    
        MagViewController *magViewController = [[MagViewController alloc] init];
        [[SlideNavigationController sharedInstance] switchToViewController:magViewController withCompletion:nil];
        return;
    }
    
    NewsViewController *newsViewController = [[NewsViewController alloc] init];
		
    [[SlideNavigationController sharedInstance] switchToViewController:newsViewController withCompletion:nil];
		
//  [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
	

}

@end

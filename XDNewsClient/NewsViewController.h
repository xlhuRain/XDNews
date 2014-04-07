//
//  NewsViewController.h
//  XDNewsClient
//
//  Created by xlhu on 14-3-22.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "SlideNavigationController.h"

@interface NewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,SlideNavigationControllerDelegate>{
    
    BOOL _reloading;
}
@property(nonatomic)NSInteger typeId;   //新闻类型id
@property(strong,nonatomic)UITableView *tableView;
@property(nonatomic,strong)EGORefreshTableHeaderView *refreshHeaderView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end

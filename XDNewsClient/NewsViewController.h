//
//  NewsViewController.h
//  XDNewsClient
//
//  Created by xlhu on 14-3-22.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface NewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)NSInteger typeId;
@property(strong,nonatomic)UITableView *tableView;

@end

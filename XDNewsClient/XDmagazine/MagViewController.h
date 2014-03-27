//
//  MagViewController.h
//  XDNewsClient
//
//  Created by xlhu_mac on 14-3-27.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MagView.h"

@interface MagViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MagViewDelegate,ASIHTTPRequestDelegate>


@end

//
//  DetailViewController.h
//  XDNewsClient
//
//  Created by xlhu on 14-3-27.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface DetailViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)NSString *newsId;

@end

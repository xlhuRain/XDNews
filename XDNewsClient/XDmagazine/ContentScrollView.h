//
//  ContentScrollView.h
//  XDmagazine
//
//  Created by tagux-mac-04 on 13-5-20.
//  Copyright (c) 2013年 tagux-mac-04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import "SingleScrollView.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface ContentScrollView : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,SingleScrollViewDelegate,MFMailComposeViewControllerDelegate>{

    int indexLocation;  //记录当前屏幕 动态加载
    int totalPage;      //总页数
    BOOL isShowBar;
    AppDelegate *_appDelegate;

}

@property(nonatomic,strong)NSString *magId;
@property(nonatomic,strong)NSString *shareContent;
@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,strong)NSString *shareTitle;

@end

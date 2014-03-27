//
//  MagView.h
//  XDmagazine
//
//  Created by tagux-mac-04 on 13-5-14.
//  Copyright (c) 2013年 tagux-mac-04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@protocol MagViewDelegate <NSObject>

-(void)magImgClicked:(NSString *)magId;

@end


@interface MagView : UIView<ASIHTTPRequestDelegate>{

    BOOL  isDownload;
    float fileLength;  //下载文件的大小
    float downLength;  //已经下载的大小
}


@property(nonatomic,strong)UILabel *title;

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)UIImageView *cornerImgView;

@property(nonatomic,strong)UILabel *progressLabel;

@property(nonatomic,strong)NSString *magId;

@property(nonatomic,strong)NSString *magYear;

@property(nonatomic,strong)NSString *zipUrl;

@property(nonatomic,assign)id<MagViewDelegate>delegate;

@property(nonatomic,strong)ASINetworkQueue *queue;


-(void)loadMagView:(NSDictionary*)dic;


@end

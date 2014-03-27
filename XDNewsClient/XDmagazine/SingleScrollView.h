//
//  SingleScrollView.h
//  XDmagazine
//
//  Created by tagux-mac-04 on 13-5-20.
//  Copyright (c) 2013年 tagux-mac-04. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingleScrollViewDelegate <NSObject>

-(void)BtnClicked:(NSString *)pageId;

@end


@interface SingleScrollView : UIScrollView

@property(nonatomic,weak)id superView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)NSString *imageName;  //图片名
@property(nonatomic,strong)NSArray *btnArray;

@property(nonatomic,assign)id<SingleScrollViewDelegate>btnDelegate;

- (id)initWithFrame:(CGRect)frame withBtnArray:(NSArray*)array;

@end

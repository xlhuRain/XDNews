//
//  NewsViewCell.h
//  XDNewsClient
//
//  Created by xlhu_mac on 14-4-3.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewCell : UITableViewCell


@property(nonatomic,strong)IBOutlet UIImageView *thumbImgView;
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *descLabel;


@end

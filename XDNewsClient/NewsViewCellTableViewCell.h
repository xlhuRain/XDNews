//
//  NewsViewCellTableViewCell.h
//  XDNewsClient
//
//  Created by xlhu on 14-4-1.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewCellTableViewCell : UITableViewCell


@property(nonatomic,strong)IBOutlet UIImageView *thumbImgView;
@property(nonatomic,strong)IBOutlet UILabel *titleLabel;
@property(nonatomic,strong)IBOutlet UILabel *descLabel;

@end

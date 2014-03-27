//
//  SingleScrollView.m
//  XDmagazine
//
//  Created by tagux-mac-04 on 13-5-20.
//  Copyright (c) 2013年 tagux-mac-04. All rights reserved.
//

#import "SingleScrollView.h"

@implementation SingleScrollView

@synthesize superView;
@synthesize imageView = _imageView; 
@synthesize imageName = _imageName;
@synthesize btnArray = _btnArray;
@synthesize btnDelegate = _btnDelegate;

- (id)initWithFrame:(CGRect)frame withBtnArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        _btnArray = array;
        NSLog(@"array %@",array);
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_imageView];
        if(array!=NULL){
            for(int i=0;i<[array count];i++){
                NSArray *tempArray = [[array objectAtIndex:i] objectForKey:@"area"];
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake([[tempArray objectAtIndex:0]intValue], [[tempArray objectAtIndex:1] intValue], [[tempArray objectAtIndex:2]intValue], [[tempArray objectAtIndex:3] intValue])];
                [btn setBackgroundColor:[UIColor clearColor]];
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateHighlighted];
                btn.clipsToBounds = YES;
                btn.tag = 100 +i;
                
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
        }
    }
    return self;
}

//-(void)btnViewClick:(UITapGestureRecognizer *)tap{
//
//    if([_btnDelegate respondsToSelector:@selector(BtnClicked:)])
//        [_btnDelegate performSelector:@selector(BtnClicked:) withObject:[_btnArray objectAtIndex:tap.view.tag-100]];
//    
//}

-(void)btnClick:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    int index = button.tag - 100;

    NSArray *array = [[_btnArray objectAtIndex:index] objectForKey:@"area"];
    if([[array objectAtIndex:4] intValue]==0){
    
        if([_btnDelegate respondsToSelector:@selector(BtnClicked:)])
            [_btnDelegate performSelector:@selector(BtnClicked:) withObject:[array objectAtIndex:5]];
        
    }else{
    
        NSURL *url = [NSURL URLWithString:[array objectAtIndex:5]];
        [[UIApplication sharedApplication] openURL:url];
    
    }
    
    

}




-(CGRect)getBtnRect:(int)index{
    CGRect rect;
    switch (index) {
        case 0:
            rect = CGRectMake(0, 40, 320, 175);
            break;
        case 1:
            rect = CGRectMake(0,215, 162, 87);
            break;
        case 2:
            rect = CGRectMake(165, 215, 162, 87);
            break;
        case 3:
            rect = CGRectMake(0, 304, 162, 93);
            break;
        case 4:
            rect = CGRectMake(165,304, 162, 93);
            break;
        case 5:
            rect = CGRectMake(0, 399, 320, 60);
            break;
    }
    return  rect;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

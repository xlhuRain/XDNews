//
//  ViewController.m
//  XDNewsClient
//
//  Created by xlhu on 14-3-22.
//  Copyright (c) 2014年 xlhu. All rights reserved.
//

#import "ViewController.h"
#import "NewsViewController.h"


@interface ViewController (){

    float offsetY;
    BOOL isCoverShow;
}


@property(nonatomic,strong)UIDynamicAnimator *animator;
@property(nonatomic,weak)IBOutlet UIView *coverView;
@property(nonatomic,weak)IBOutlet UIImageView *coverImgView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanCoverFrom:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    isCoverShow = YES;
    self.coverView.frame = CGRectMake(0, -568, 320, 548);
    self.coverImgView.image = [UIImage imageNamed:@"cover.jpg"];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void)handlePanCoverFrom:(UIPanGestureRecognizer*)panGesture{
    
    CGPoint point = [panGesture translationInView:self.view];
    if(!isCoverShow&&point.y>20){
        [self.animator removeAllBehaviors];
        [self addBehaviorToCoverImgView];
        return;
    }
    
    if (panGesture.state==UIGestureRecognizerStateBegan) {
        [self.animator removeAllBehaviors];
        offsetY = self.coverView.frame.origin.y;
    }else if (panGesture.state == UIGestureRecognizerStateChanged){
        self.coverView.frame = CGRectMake(self.coverView.frame.origin.x,offsetY+point.y,self.coverView.frame.size.width,self.coverView.frame.size.height);
        if(self.coverView.frame.origin.y>=20)
            self.coverView.frame = CGRectMake(0, 20, 320, 548);
    }else if (panGesture.state == UIGestureRecognizerStateEnded){
        if (self.coverView.frame.origin.y<-150) {
            [UIView animateWithDuration:0.3 animations:^{
                self.coverView.frame = CGRectMake(0, -568, 320, 548);
            }completion:^(BOOL finished) {
                isCoverShow = NO;
            }];
        }else{
            [self addBehaviorToCoverImgView];
        }
    }
   
}

-(void)addBehaviorToCoverImgView{

    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.coverView]];
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.coverView]];
    [collisionBehavior addBoundaryWithIdentifier:@"collision"
                                       fromPoint:CGPointMake(0,568)
                                         toPoint:CGPointMake(320, 568)];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.coverView]];
    itemBehavior.elasticity = 0.5;
    [self.animator addBehavior:itemBehavior];
    [self.animator addBehavior:gravityBehavior];
    [self.animator addBehavior:collisionBehavior];
    
}


-(IBAction)buttonClick:(UIButton *)sender{

    NewsViewController *newsViewController = [[NewsViewController alloc] init];
    newsViewController.typeId = sender.tag;
    [self.navigationController pushViewController:newsViewController animated:YES];
}


-(IBAction)MagazineButtonClick:(id)sender{
   
    if (!self.magViewController) {
        self.magViewController = [[MagViewController alloc] init];
    }
    [self.navigationController pushViewController:self.magViewController animated:YES];
}


@end

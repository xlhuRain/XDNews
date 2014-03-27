//
//  MagView.m
//  XDmagazine
//
//  Created by tagux-mac-04 on 13-5-14.
//  Copyright (c) 2013年 tagux-mac-04. All rights reserved.
//

#import "MagView.h"
#import "ZipArchive.h"
#import "Utils.h"
#import "ConnectAPI.h"

@implementation MagView

@synthesize title = _title;
@synthesize imageView = _imageView;
@synthesize cornerImgView = _cornerImgView;
@synthesize progressLabel = _progressLabel;
@synthesize magId = _magId;
@synthesize magYear = _magYear;
@synthesize zipUrl = _zipUrl;
@synthesize queue = _queue;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backImageView.image = [UIImage imageNamed:@"cover_bottom.png"];
        [self addSubview:backImageView];
        //标题1
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, self.frame.size.width, 20)];
        _title.font =[UIFont boldSystemFontOfSize:14];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        _title.textColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1];
        _title.backgroundColor = [UIColor clearColor];
        [self addSubview:_title];
        
            
        //期刊图片1
        _imageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 36, 108, 155)];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
        [_imageView addGestureRecognizer:tap];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        
        //进度条1
        _cornerImgView= [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-68, self.frame.size.height-68, 68, 68)];
        _cornerImgView.image = [UIImage imageNamed:@"cover_top.png"];
        _cornerImgView.backgroundColor = [UIColor clearColor];
        
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
        _progressLabel.center = CGPointMake(42, 42);
        _progressLabel.font =[UIFont boldSystemFontOfSize:14];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
        [_cornerImgView addSubview:_progressLabel];
        [self addSubview:_cornerImgView];
        
        
        isDownload = NO;
        _queue = [[ASINetworkQueue alloc] init];
        [_queue setShowAccurateProgress:YES];//高精度进度
        [_queue go];//启动
    }
    return self;
}

-(void)loadMagView:(NSDictionary *)dic{

    NSString *fileName = [Utils GetImgNameFromUrl:[dic objectForKey:@"img"]];
    //本地存在加载本地，否则请求服务器端
    if([Utils fileIsExists:[Utils applicationCachesDirectory:fileName]]){
        _imageView.image = [[UIImage alloc] initWithContentsOfFile:[Utils applicationCachesDirectory:fileName]];
    }else{
        _imageView.image = [UIImage imageNamed:@"cover_loading.png"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *tempImg = [Utils getImgWithUrl:[dic objectForKey:@"img"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utils saveCachesData:tempImg to:[Utils applicationCachesDirectory:fileName]];
                _imageView.image = tempImg;
            });
        });
    }
    _title.text = [dic objectForKey:@"title"];
    _magId = [dic objectForKey:@"id"];
    _zipUrl = [dic objectForKey:@"url"];
    _magYear = [dic objectForKey:@"year"];
    
    //期刊下载状态
    NSUserDefaults *status = [NSUserDefaults standardUserDefaults];
    NSString *value = [NSString stringWithFormat:@"mag%@",_magId];
    
    //判断进度条是否显示
    if([status objectForKey:value]!=NULL){
        if([[status objectForKey:value] isEqual:@"yes"]){
//            _cornerImgView.hidden = YES;
            _progressLabel.text = @"观看";
            
        }else{
            _progressLabel.text = [NSString stringWithFormat:@"%@%%",[status objectForKey:value]];
        }
    }else{
        _progressLabel.text = @"未下载";
    }

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void)clickImageView:(UITapGestureRecognizer *)tap{

    NSLog(@"click %@ %@",_magId,_zipUrl);
    NSUserDefaults *status = [NSUserDefaults standardUserDefaults];
    
    if(![[status objectForKey:[NSString stringWithFormat:@"mag%@",_magId]] isEqual:@"yes"]){
        
        //记录杂志下载状态
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://club.beijing-hyundai.com.cn/survey2013/phone/down.php?y=%@&id=%@&d=1",_magYear,_magId]];
        ASIHTTPRequest *asiRequest = [ASIHTTPRequest requestWithURL:url];
        [asiRequest startAsynchronous];
        
        
        if(!isDownload){  //暂停状态
           [self startDownload];
        }else{
           [self pauseDownload];
        }
    }else{ //下载完的杂志，可以打开
    
        NSLog(@"open magazine");
        if([_delegate respondsToSelector:@selector(magImgClicked:)])
            [_delegate performSelector:@selector(magImgClicked:) withObject:_magId];
    
    }
    
    //    NSDictionary *tempDic;
    //    if(value==0){
    //        tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:_magId_one,@"id",_url_one,@"url", nil];
    //    }else{
    //        tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:_magId_two,@"id",_url_two,@"url", nil];
    //    }
    //
    //    if ([self.delegate respondsToSelector: @selector(newsContentClicked:)])
    //        [self.delegate performSelector: @selector(newsContentClicked:) withObject:tempDic];
}


- (void)startDownload
{
    NSLog(@"创建请求");
    
    isDownload = YES; 
    
    NSString *downloadPath = [Utils applicationCachesDirectory:[NSString stringWithFormat:@"%@.zip",_magId]];
    NSString *tempPath = [Utils applicationCachesDirectory:[NSString stringWithFormat:@"%@.temp",_magId]];
    NSURL *url = [NSURL URLWithString:_zipUrl];
    //创建请求
    NSLog(@"zip url %@",_zipUrl);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;//代理
    [request setDownloadDestinationPath:downloadPath];//下载路径
    [request setTemporaryFileDownloadPath:tempPath];//缓存路径
    [request setAllowResumeForFileDownloads:YES];//断点续传
    request.downloadProgressDelegate = self;//下载进度代理
    [_queue addOperation:request];//添加到队列，队列启动后不需重新启动
    if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
        NSLog(@"有了");
    }
    else {
        NSLog(@"没有");
    }
}

- (void)pauseDownload
{
    //暂停
    NSLog(@"parseDownLoad");
    isDownload = NO;
    ASIHTTPRequest *request = [[_queue operations] objectAtIndex:0];
    [request clearDelegatesAndCancel];//取消请求
}

- (void)unzipFile{
    //解压
    
    NSString *downloadPath = [Utils applicationCachesDirectory:[NSString stringWithFormat:@"%@.zip",_magId]];
    NSString *unzipPath = [Utils getCachesPath];
    ZipArchive *unzip = [[ZipArchive alloc] init];
    if ([unzip UnzipOpenFile:downloadPath]) {
        BOOL result = [unzip UnzipFileTo:unzipPath overWrite:YES];
        if (result) {
            NSLog(@"解压成功！");
            //删除下载的压缩文件
            [self deleteFile];
            //保存下载状态
            NSUserDefaults *SaveDefaults = [NSUserDefaults standardUserDefaults];
            [SaveDefaults setObject:@"yes" forKey:[NSString stringWithFormat:@"mag%@",_magId]];
        }
        else {
            NSLog(@"解压失败1");
        
        }
        [unzip UnzipCloseFile];
    }else {
        NSLog(@"解压失败2");
    }
}


- (void)deleteFile
{
    BOOL clear = YES;
    NSString *downloadPath = [Utils applicationCachesDirectory:[NSString stringWithFormat:@"%@.zip",_magId]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:downloadPath error:nil]) {
            NSLog(@"删除压缩文件");
        }
        else {
            NSLog(@"删除压缩文件失败");
            clear = NO;
        }
    }
//    if ([[NSFileManager defaultManager] fileExistsAtPath:unzipPath]) {
//        if ([[NSFileManager defaultManager] removeItemAtPath:unzipPath error:nil]) {
//            NSLog(@"删除解压文件");
//        }
//        else {
//            NSLog(@"删除解压文件失败");
//            clear = NO;
//        }
//    }
    if (clear) {
        fileLength = 0;
        isDownload = NO;
//        _cornerImgView.hidden = YES;
        _progressLabel.text = @"观看";
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"收到头部！");
    NSLog(@"%f",request.contentLength/1024.0/1024.0);
    NSLog(@"%@",responseHeaders);
    if (fileLength == 0) {
        fileLength = request.contentLength/1024.0/1024.0;
//        _progressLabel.text = [NSString stringWithFormat:@"%.2fM",fileLength];
    }
}

- (void)setProgress:(float)newProgress
{
//    _progressLabel.text = [NSString stringWithFormat:@"%.2fM",fileLength*newProgress];
    NSLog(@"newProress %f,fileLength %f",newProgress,fileLength);
    NSUserDefaults *updateDefaults = [NSUserDefaults standardUserDefaults];
    NSString *percent = [NSString stringWithFormat:@"%d",(int)floorf(newProgress*100)];
    [updateDefaults setObject:percent forKey:[NSString stringWithFormat:@"mag%@",_magId]];
//    NSLog(@"persent %@",[updateDefaults objectForKey:[NSString stringWithFormat:@"mag%@",_magId]]);
    _progressLabel.text = [NSString stringWithFormat:@"%@%%",percent];
    
}

- (void)requestStarted:(ASIHTTPRequest *)request{
    fileLength = request.contentLength/1024.0/1024.0;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"下载成功！");
    //解压下载的文件
    [self unzipFile];

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载失败！");
     
    [self deleteFile];
    _progressLabel.text = @"下载失败!";
}



@end

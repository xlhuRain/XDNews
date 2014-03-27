#import "Utils.h"


@implementation Utils

+ (NSString *) getAPIUrl{
	return @"http://ipad.jiadeapp.com/ajax/";
	
}

//+(NSData *)GetUrlData:(NSString *)requestUrl{
//	NSData *response;
//	NSURL *url = [NSURL URLWithString:requestUrl];
//	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
//	[request startSynchronous];
//	NSError *error = [request error];
//	if (!error) {
//		response = [request responseData];
//	}
//	else {
//		response = NULL;
//	}
//    
//	return response;
//}


+(NSString *)getCurrentLanguage{
    
   if([[[NSUserDefaults standardUserDefaults] objectForKey:@"CustomLanguage"] isEqualToString:@"Chinese"])
       return @"cn";
    else
        return @"en";
}

+ (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}


/** 弹出框 */
+(void)alertWithTitle:(NSString *)title message:(NSString *)message {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil
										  cancelButtonTitle:@"确定"
										  otherButtonTitles:nil
						  ];
	[alert show];
}


+(NSString *)GetImgNameFromUrl:(NSString*)url{
    
    NSArray *array = [url componentsSeparatedByString:@"/"];
    return [array lastObject];
    
    
}

// 根据网络图片得地址获取图片
+ (UIImage *) getImgWithUrl: (NSString *)url{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *img = [UIImage imageWithData:imageData];
    return img;
}

//获得缓存目录
+(NSString *)getCachesPath{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
														 NSUserDomainMask,
														 YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


/** 加载缓存目录的路径 */
+ (NSString *) applicationCachesDirectory: (NSString *) filename {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
														 NSUserDomainMask,
														 YES);

	
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return [basePath stringByAppendingPathComponent: filename];
}

/**判断某个文件是否存在*/
+(BOOL)fileIsExists:(NSString *)filename {
	
	if ([[NSFileManager defaultManager] fileExistsAtPath: filename]) {
        return YES;
	}else{
		return NO;
	}
}

/** 保存图片到缓存目录 */
+ (void)saveCachesData: (UIImage *) image to: (NSString *) filename {
	
    NSData *imageData = nil;
    NSString *ext = [filename pathExtension];
    if ([ext isEqualToString:@"png"])
    {
        imageData = UIImagePNGRepresentation(image);
    }else{
        imageData = UIImageJPEGRepresentation(image, 0);
    }
    
    [imageData writeToFile:filename atomically:YES];
}

/** 删除缓存目录对应的文件 */
+ (BOOL)removeCachesFile:(NSString *)filename {
	
    NSString *filePath = [Utils applicationCachesDirectory: filename];
    NSError *error = nil;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isSuccess = [fileMgr removeItemAtPath:filePath error:&error] ;
    return isSuccess;
}

//删除caches文件夹下所有的文件
+(void)removeCachesAllFile{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachesDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[cachesDirectory stringByAppendingPathComponent:filename] error:NULL];
    }
}

/** 获取document目录 */
+ (NSString *)applicationDocumentsDirectory:(NSString *)filename{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask,
														 YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *appendPath = filename;
    return [basePath stringByAppendingPathComponent:appendPath];
}

//加载document目录对应的文件内容
+(NSData *)loadDocumentDataFrom:(NSString *)filename{
	
    NSData *data = [NSData dataWithContentsOfFile:filename];
    return  data;
}

//保存文件内容到document目录
+(void)saveDocumentData:(NSData *)dataToSave to:(NSString *)filename{
    
    [dataToSave writeToFile:filename atomically:YES];
    
}

//删除doucment目录对应的文件
+(BOOL)removeDocumentFile:(NSString *)filename{
    
    NSError *error = nil;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isSuccess = [fileMgr removeItemAtPath:filename error:&error] ;
    return isSuccess;
}

@end

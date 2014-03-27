#import <Foundation/Foundation.h>
//#import "ASIHTTPRequest.h"

@interface Utils : NSObject



//api地址
+ (NSString *) getAPIUrl;

//获取数据
+(NSData *)GetUrlData:(NSString *)requestUrl;

/**
 *得到本机现在用的语言
 * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ......
 */
+ (NSString*)getPreferredLanguage;

+(NSString*)getCurrentLanguage;

/** 弹出框 */
+(void)alertWithTitle:(NSString *)title message:(NSString *)message;


//从url中获得image Name
+(NSString*)GetImgNameFromUrl:(NSString*)url;

/** 根据网络图片得地址获取图片*/
+ (UIImage *) getImgWithUrl: (NSString *)url;

+(NSString *)getCachesPath;

/** 加载缓存目录的路径 */
+ (NSString *) applicationCachesDirectory: (NSString *) filename;

/**判断路径下某个文件是否存在*/
+ (BOOL)fileIsExists:(NSString *)filename;

/** 保存图片到缓存目录, */
+ (void)saveCachesData: (UIImage *) image to: (NSString *) filename;

/** 删除缓存目录对应的文件 */
+ (BOOL)removeCachesFile:(NSString *)filename;

//删除caches文件夹下所有的文件
+(void)removeCachesAllFile;



/** 获取document目录 */
+ (NSString *)applicationDocumentsDirectory:(NSString *)filename;

//加载document目录对应的文件内容
+(NSData *)loadDocumentDataFrom:(NSString *)filename;

//保存文件内容到document目录
+(void)saveDocumentData:(NSData *)dataToSave to:(NSString *)filename;

//删除doucment目录对应的文件
+(BOOL)removeDocumentFile:(NSString *)filename;




@end

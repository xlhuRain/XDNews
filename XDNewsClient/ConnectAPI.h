#import <Foundation/Foundation.h>

@interface ConnectAPI : NSObject

+(ConnectAPI*)sharedInstance;

-(NSDictionary *)getServerData;

//返回预告字典
-(NSDictionary *)getLocalData;

//返回下载状态字典
-(NSMutableDictionary*)readMagStatusDic:(NSString*)filePath;

-(void)writeMagStatusDic:(NSData*)data;
@end

#import "ConnectAPI.h"
#import "Utils.h"
#import "JSONKit.h"
#import "Define.h"

static ConnectAPI *connectApi = nil;

@implementation ConnectAPI

+(ConnectAPI*)sharedInstance{

    @synchronized (self)
    {
        if (connectApi == nil)
        {
            connectApi = [[self  alloc] init];
        }
    }
    return connectApi;
}

-(NSDictionary*)getServerData{

    NSString *url = @"http://movingshop.org/bx/data.php?d=2";
    NSData  *response = [Utils GetUrlData:url];
    NSString *fileName = @"list.json";
    NSString *filePath = [Utils applicationDocumentsDirectory:fileName];
    NSDictionary *result = [response objectFromJSONData];
    
    if(result == NULL){
        if([Utils fileIsExists:filePath]){
            response = [Utils loadDocumentDataFrom:filePath];
            result = [response objectFromJSONData];
        }else{
            return  NULL;
        }
    }else{
        if([Utils fileIsExists:filePath])
            [Utils removeDocumentFile:filePath];
        [Utils saveDocumentData:response to:filePath];
    }

    return result;
}

-(NSDictionary*)getLocalData{

    NSData *response;
    NSString *fileName = @"list.json";
    NSString *filePath = [Utils applicationDocumentsDirectory:fileName];

    if([Utils fileIsExists:filePath]){
        response = [Utils loadDocumentDataFrom:filePath];
        NSDictionary *result = [response objectFromJSONData];
        return result;
    }else{
        return  NULL;
    }
}

-(NSMutableDictionary*)readMagStatusDic:(NSString *)filePath{
    NSData *response;
    if([Utils fileIsExists:filePath]){
        response = [Utils loadDocumentDataFrom:filePath];
        NSMutableDictionary *result = [response objectFromJSONData];
        return result;
    }else{
        return  NULL;
    }

}

-(void)writeMagStatusDic:(NSData *)data{
    NSString *fileName = @"magStatus.json";
    NSString *filePath = [Utils applicationDocumentsDirectory:fileName];
    [Utils saveDocumentData:data to:filePath];
}

@end

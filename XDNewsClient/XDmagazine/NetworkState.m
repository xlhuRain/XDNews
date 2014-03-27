//
//  NetworkStatus.m

//  嘉德
//
//  Created by tagux imac04 on 13-1-22.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "NetworkState.h"

@implementation NetworkState

+ (BOOL)isEnableNetwork
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    if ([reachability currentReachabilityStatus] == NotReachable) 
    {
        return NO;
    }
    else {
        return YES;
    }
}

+ (BOOL)isEnable3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable); 
}

+ (BOOL)isEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable); 
} 

@end

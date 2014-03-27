//
//  NetworkStatus.h
//  嘉德
//
//  Created by tagux imac04 on 13-1-22.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkState : NSObject

+ (BOOL)isEnableNetwork;
+ (BOOL)isEnable3G;
+ (BOOL)isEnableWIFI;

@end
